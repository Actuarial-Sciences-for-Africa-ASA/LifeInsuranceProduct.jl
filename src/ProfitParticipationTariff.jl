module ProfitParticipationTariff
using LifeInsuranceDataModel, JSON, Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä     # pull the shortform notation into scope
include("TariffUtilities.jl")
using .TariffUtilities


"""
  get_tariff_interface()
  Profit Participation 
"""
function get_tariff_interface()
  let
    calls = JSON.parse("""
        {"result": {"value": 0}}
      """)
    attributes = JSON.parse("""{"mortality_tables":
        { "f": {"nonsmoker": "1986-92 CIA – Female Nonsmoker, ANB",
              "smoker": "1986-92 CIA – Female Smoker, ANB" },
        "m":{"nonsmoker": "1986-92 CIA – Male Nonsmoker, ANB",
            "smoker": "1986-92 CIA – Male Smoker, ANB"}
        }
      }
      """)
    tariffitem_attributes = JSON.parse("""{}""")
    partnerroles = [1]
    TariffInterface("Profit participation",
      calls, calculate!, attributes, tariffitem_attributes, partnerroles)
  end
end

"""
  calculate!(interface_id::Val{2}, ti::TariffItemSection, params::Dict{String,Any})
  Profit Participation 
"""
function calculate!(interface_id::Val{2}, ti::TariffItemSection, params::Dict{String,Any})
  params["result"]["value"] = ""
end


end # module