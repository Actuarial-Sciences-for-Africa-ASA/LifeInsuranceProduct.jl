module LifeInsuranceProduct

using LifeInsuranceDataModel
include("TariffUtilities.jl")
using .TariffUtilities
include("ProfitParticipationTariff.jl")
using .ProfitParticipationTariff
include("PensionTariff.jl")
using .PensionTariff
include("SingleLifeRiskTariff.jl")
using .SingleLifeRiskTariff
include("JointLifeRiskTariff.jl")
using .JointLifeRiskTariff
export TariffInterface, get_tariff_interface, calculate!

"""
  TariffUtilities.get_tariff_interface(::Val{1})
  ProfitParticipationTariff 
"""
function TariffUtilities.get_tariff_interface(::Val{1})
  ProfitParticipationTariff.get_tariff_interface()
end
"""
  TariffUtilities.calculate!(interface_id::Val{1}, ti::TariffItemSection, params::Dict{String,Any})
  ProfitParticipationTariff 
"""

function TariffUtilities.calculate!(interface_id::Val{1}, ti::TariffItemSection, params::Dict{String,Any})
  ProfitParticipationTariff.calculate!(1, ti, params)
end


"""
  TariffUtilities.get_tariff_interface(::Val{2})
  PensionTariff 
"""
function TariffUtilities.get_tariff_interface(::Val{2})
  PensionTariff.get_tariff_interface()
end
"""
  TariffUtilities.calculate!(interface_id::Val{2}, ti::TariffItemSection, params::Dict{String,Any})
  PensionTariff 
"""
function TariffUtilities.calculate!(interface_id::Val{2}, ti::TariffItemSection, params::Dict{String,Any})
  PensionTariff.calculate!(2, ti, params)
end

"""
  TariffUtilities.get_tariff_interface(::Val{3})
  SingleLifeRisk 
"""
function TariffUtilities.get_tariff_interface(::Val{3})
  SingleLifeRiskTariff.get_tariff_interface()
end

"""
  TariffUtilities.calculate!(interface_id::Val{3}, ti::TariffItemSection, params::Dict{String,Any})
  SingleLifeRisk 
"""
function TariffUtilities.calculate!(interface_id::Val{3}, ti::TariffItemSection, params::Dict{String,Any})
  SingleLifeRiskTariff.calculate!(3, ti, params)
end

"""
  TariffUtilities.get_tariff_interface(::Val{4})
  JointLifeRiskTariff 
"""
function TariffUtilities.get_tariff_interface(::Val{4})
  JointLifeRiskTariff.get_tariff_interface()
end

"""
  TariffUtilities.calculate!(interface_id::Val{4}, ti::TariffItemSection, params::Dict{String,Any})
  JointLifeRisk 
"""
function TariffUtilities.calculate!(interface_id::Val{4}, ti::TariffItemSection, params::Dict{String,Any})
  JointLifeRiskTariff.calculate!(4, ti, params)
end
end # module
