module SingleLifeRiskTariff
using LifeInsuranceDataModel, JSON, Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä, A    # pull the shortform notation into scope
include("TariffUtilities.jl")
using .TariffUtilities


"""
  LifeInsuranceDataModel.get_tariff_interface(::Val{3})
  Life Risk Insurance 
"""
function LifeInsuranceDataModel.get_tariff_interface(::Val{3})
  @info "get_tariff_interface in SingleLifeRiskTariff "
  let
    calls = JSON.parse("""
        {"calculation_target":
          {"selected": "none",
          "label": "calculation target",
          "options": ["net premium"],
         "net premium": 
          {"n":{"type":"Int", "default":0, "value":null},
          "frequency":{"type":"Int", "default":0, "value":null},
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
      "begin":{"type":"Date", "default":"2020-01-01", "value":null},
      "net premium":{"type":"Int", "default":0, "value":null}
    }""")
    partnerroles = [1]
    TariffInterface("Life Risk Insurance",
      calls, calculate!, validator, attributes, tariffitem_attributes, partnerroles)
  end
end

function calculate!(ti::TariffItemSection, params::Dict{String,Any})
  try
    #accessing tariff data
    tariffparameters = get_tariff_interface(Val(2)).parameters
    mts = tariffparameters["mortality_tables"]
    i = tariffparameters["interest rate"]

    fn = params["calculation_target"]["selected"]
    args = params["calculation_target"][fn]
    if fn == "net premium"
      n = parse(Int, args["n"]["value"])
      C = parse(Int, args["sum insured"]["value"])
      frq = parse(Int, args["frequency"]["value"])
      begindate = Date(args["begin"]["value"])
      dob1 = ti.partner_refs[1].ref.revision.date_of_birth
      smoker1 = ti.partner_refs[1].ref.revision.smoker ? "smoker" : "nonsmoker"
      sex1 = ti.partner_refs[1].ref.revision.sex
      issue_age1 = TariffUtilities.insurance_age(dob1, begindate)

      life1 = SingleLife(
        mortality=MortalityTables.table(mts[sex1][smoker1]).select[issue_age1])

      yield = Yields.Constant(i)      # Using a flat

      lc = LifeContingency(life1, yield)  # LifeContingenc
      r0 = A(lc, n)
      r1 = ä(lc, n, frequency=frq)
      result = C * r0 / r1
      params["result"]["value"] = result
    end
  catch err
    println("wassis shief gegangen ")
    @error "ERROR: " exception = (err, catch_backtrace())
  end
end

function validator(tis::TariffItemSection)
  @info "validating SingleLifeRisk Tariff"
end


end # module