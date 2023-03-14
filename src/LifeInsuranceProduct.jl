module LifeInsuranceProduct

using LifeInsuranceDataModel, JSON, Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä     # pull the shortform notation into scope
export calculate!, get_tariff_interface, TariffInterface

mutable struct TariffInterface
  description::String
  calls::Dict{String,Any}
  calculator::Function
  parameters::Dict{String,Any}
  contract_attributes::Dict{String,Any}
  partnerroles::Vector{Int}
  mortality_table::String
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

TerminalIllnessTariff = create_tariff(
  "Terminal Illness", 2,
  "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB", tariffparameters
)
OccupationalDisabilityTariff = create_tariff(
  "Occupational Disability", 2,
  "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB", tariffparameters
)
ProfitParticipationTariff = create_tariff(
  "Profit participation", 2,
  "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB", tariffparameters
)
LifeRiskTariff2 = create_tariff(
  "Two Life Risk Insurance", 2,
  "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB", tariffparameters, [1, 2])

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
          "options": ["premium","sum insured","ä"],
          "sum insured": 
          {"p":{"type":"Int", "default":0, "value":null},
          "n":{"type":"Int", "default":0, "value":null},
          "m":{"type":"Int", "default":0, "value":null},
          "begin":{"type":"Date", "default":"2020-01-01", "value":null}
          },
          "premium": 
          {"n":{"type":"Int", "default":0, "value":null},
          "m":{"type":"Int", "default":0, "value":null},
          "C":{"type":"Int", "default":0, "value":null},
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
    attributes = JSON.parse("{}")
    tariffitem_attributes = JSON.parse("{}")
    TariffInterface("Life Risk Insurance",
      calls, calculate!, attributes, tariffitem_attributes, [1], "1980 CET - Male Nonsmoker, ANB")
  end
end

"""
  get_tariff_interface(::Val{2})
  Terminal Illness
"""
function get_tariff_interface(::Val{2})
  let
    calls = JSON.parse("""
       {"calculation_target":
         {"selected": "none",
         "options": []
       
       }, "result": {"value": 0}
       }
      """)
    attributes = JSON.parse("{}")
    tariffitem_attributes = JSON.parse("{}")
    TariffInterface("Terminal Illness",
      calls, calculate!, attributes, tariffitem_attributes, [1], "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")
  end
end

"""
  get_tariff_interface(::Val{3})
  Profit Participation
"""
function get_tariff_interface(::Val{3})
  let
    calls = JSON.parse("""
       {"calculation_target":
         {"selected": "none",
         "options": []
       
       }, "result": {"value": 0}
       }
      """)
    attributes = JSON.parse("{}")
    tariffitem_attributes = JSON.parse("{}")
    TariffInterface("Profit Participation",
      calls, calculate!, attributes, tariffitem_attributes, [1], "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")
  end
end

"""
  get_tariff_interface(::Val{4})
  Two Life Risk
"""
function get_tariff_interface(::Val{4})
  let
    calls = JSON.parse("""
       {"calculation_target":
         {"selected": "none",
         "options": []
       
       }, "result": {"value": 0}
       }
      """)
    attributes = JSON.parse("{}")
    tariffitem_attributes = JSON.parse("{}")
    TariffInterface("Two Life Risk",
      calls, calculate!, attributes, tariffitem_attributes, [1, 2], "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")
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
