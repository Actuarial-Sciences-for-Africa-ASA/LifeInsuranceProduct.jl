module LifeInsuranceProduct

using LifeInsuranceDataModel, JSON, Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä     # pull the shortform notation into scope
export calculate!, get_tariff_interface, TariffInterface

"""
mutable struct TariffInterface
  calls: signatures of functions in JSON format usable in HTML-code
  calculator: function name of the calculator implementing those calls
  contract_attributes: definition of persistent attributes - in JSON format - of tariffitems,
    which are not part of the data base model
  parameters: definition of persistent attributes - in JSON format - of tariffs,
    which are not part of the data base model
  partnerroles: roles of partner relations from tariffitems
  mortality_table: id

  
"""

mutable struct TariffInterface
  description::String
  calls::Dict{String,Any}
  calculator::Function
  parameters::Dict{String,Any}
  contract_attributes::Dict{String,Any}
  partnerroles::Vector{Int}
end

"""
dummy used to init calculator interface gui
"""
function get_tariff_interface(::Val{0})
  calls = JSON.parse("""
       {"calculation_target":
         {"selected": "none",
         "options": []
       
       }, "result": {"value": 0}
       }
     """)
  attributes = JSON.parse("{}")
  tariffitem_attributes = JSON.parse("{}")
  TariffInterface("",
    calls, calculate!, attributes, tariffitem_attributes, [1], "")
end

"""
"1986-92 CIA – Female Nonsmoker, ANB"
"1986-92 CIA – Female Smoker, ANB"
"1986-92 CIA – Male Nonsmoker, ANB"
"1986-92 CIA – Male Smoker, ANB"

"""

"""
  get_tariff_interface(::Val{1})
  Life Risk Insurance 
"""
function get_tariff_interface(::Val{1})
  let
    calls = JSON.parse("""
        {"calculation_target":
          {"selected": "none",
          "label": "calculation target",
          "options": ["net premium","A"],
          "sex": {"type":"enum", "options": ["female","male"],"selected": "none"},
          "smoker": {"type":"enum", "options": ["smoker","nonsmoker"],"selected": "none"},
          "net premium": 
          {"n":{"type":"Int", "default":0, "value":null},
          "begin":{"type":"Date", "default":"2020-01-01", "value":null}
          },
          "ä": 
          {"n":{"type":"Int", "default":0, "value":null},
          "m":{"type":"Int", "default":0, "value":null},
          "frequency":{"type":"Int", "default":0, "value":null},
          "begin":{"type":"Date", "default":"2020-01-01", "value":null}
          }
        }, "result": {"value": 0}
        }
      """)
    attributes = JSON.parse("""{"mortality_tables":
        { "f": {"nonsmoker": "1986-92 CIA – Female Nonsmoker, ANB",
              "smoker": "1986-92 CIA – Female Smoker, ANB" },
        "m":{"nonsmoker": "1986-92 CIA – Male Nonsmoker, ANB",
            "smoker": "1986-92 CIA – Male Smoker, ANB"}
        }
      }
      """)
    tariffitem_attributes = JSON.parse("{}")
    partnerroles = [1]
    TariffInterface("Life Risk Insurance",
      calls, calculate!, attributes, tariffitem_attributes, partnerroles)
  end
end

# load mortality rates from MortalityTables.jl
vbt2001 = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

function insurance_age(dob, begindate)::Integer
  if ((Date(Dates.year(begindate), Dates.month(dob), Dates.day(dob)) - begindate).value > 183)
    Dates.year(begindate) - Dates.year(dob) - 1
  else
    Dates.year(begindate) - Dates.year(dob)
  end
end

function calculate!(ti::TariffItemSection, params::Dict{String,Any})
  dob = ti.partner_refs[1].ref.revision.date_of_birth
  fn = params["calculation_target"]["selected"]
  args = params["calculation_target"][fn]
  if fn == "ä"

    begindate = Date(args["begin"]["value"])
    n = parse(Int, args["n"]["value"])
    m = parse(Int, args["m"]["value"])
    frq = parse(Int, args["frequency"]["value"])

    """
    issue_age

    Age of insured person as of insurance begin date
    """
    issue_age = insurance_age(dob, begindate)

    life = SingleLife(                 # The life underlying the risk
      mortality=vbt2001.select[issue_age],    # -- Mortality rates
    )

    yield = Yields.Constant(0.0125)      # Using a flat 1,25% interest rate

    lc = LifeContingency(life, yield)  # LifeContingency joins the risk with interest


    ins = Insurance(lc)                # Whole Life insurance
    ins = Insurance(life, yield)       # alternate way to construct

    premium_net(lc)

    params["result"]["value"] = ä(lc, n, certain=m, frequency=frq)
  end
end

end # module
