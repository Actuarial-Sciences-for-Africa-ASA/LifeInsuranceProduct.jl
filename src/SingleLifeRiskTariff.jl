module SingleLifeRiskTariff
using LifeInsuranceDataModel, JSON, Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä, A    # pull the shortform notation into scope
include("TariffUtilities.jl")
using .TariffUtilities


"""
  get_tariff_interface()
  Life Risk Insurance 
"""
function get_tariff_interface()
  let
    calls = JSON.parse("""
        {"calculation_target":
          {"selected": "none",
          "label": "calculation target",
          "options": ["net premium"],
         "net premium": 
          {"n":{"type":"Int", "default":0, "value":null},
          "sum insured":{"type":"Int", "default":0, "value":null},
          "begin":{"type":"Date", "default":"2020-01-01", "value":null}
          }
        }, "result": {"value": 0}
        }
      """)
    attributes = JSON.parse("""
      { "interest rate": 0.02,
        "mortality_tables":
        { "f": {"nonsmoker": "1986-92 CIA – Female Nonsmoker, ANB",
              "smoker": "1986-92 CIA – Female Smoker, ANB" },
        "m":{"nonsmoker": "1986-92 CIA – Male Nonsmoker, ANB",
            "smoker": "1986-92 CIA – Male Smoker, ANB"}
        }
      }
      """)
    tariffitem_attributes = JSON.parse("""
    {"sum insured":{"type":"Int", "default":0, "value":null},
      "n":{"type":"Int", "default":0, "value":null},
      "frequency":{"type":"Int", "default":0, "value":null},
      "begin":{"type":"Date", "default":"2020-01-01", "value":null}
    }""")
    partnerroles = [1]
    TariffInterface("Life Risk Insurance",
      calls, calculate!, attributes, tariffitem_attributes, partnerroles)
  end
end

function calculate!(interface_id::Integer, ti::TariffItemSection, params::Dict{String,Any})
  try

    # accessiong partner data
    pr = ti.partner_refs[1].ref.revision
    dob = pr.date_of_birth
    sex = pr.sex
    smoker = pr.smoker

    #accessing tariff data
    tariffparameters = get_tariff_interface().parameters
    mts = tariffparameters["mortality_tables"]
    i = tariffparameters["interest rate"]

    fn = params["calculation_target"]["selected"]
    args = params["calculation_target"][fn]
    if fn == "ä"

      begindate = Date(args["begin"]["value"])
      n = parse(Int, args["n"]["value"])
      m = parse(Int, args["m"]["value"])
      frq = parse(Int, args["frequency"]["value"])
      issue_age = insurance_age(dob, begindate)

      life = SingleLife(
        mortality=MortalityTables.table(mts[sex][smoker ? "smoker" : "nonsmoker"]).select[issue_age])

      yield = Yields.Constant(i)      # Using a flat 1,25% interest rate

      lc = LifeContingency(life, yield)  # LifeContingency joins the risk with interest


      ins = Insurance(lc)                # Whole Life insurance
      ins = Insurance(life, yield)       # alternate way to construct

      premium_net(lc)

      params["result"]["value"] = ä(lc, n, start_time=m, frequency=frq)
    end
  catch err
    println("wassis shief gegangen ")
    @error "ERROR: " exception = (err, catch_backtrace())
  end
end


end # module