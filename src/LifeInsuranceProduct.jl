module LifeInsuranceProduct

using LifeInsuranceDataModel

include("ProductUtilities.jl")
using .ProductUtilities
include("TariffUtilities.jl")
using .TariffUtilities
include("ProfitParticipationTariff.jl")
using .ProfitParticipationTariff
include("PensionProduct.jl")
using .PensionProduct
include("PensionTariff.jl")
using .PensionTariff
include("SingleLifeRiskProduct.jl")
using .SingleLifeRiskProduct
include("SingleLifeRiskTariff.jl")
using .SingleLifeRiskTariff
include("JointLifeRiskProduct.jl")
using .JointLifeRiskProduct
include("JointLifeRiskTariff.jl")
using .JointLifeRiskTariff
export TariffInterface, get_tariff_interface, calculate!, insurance_age, validate


"""
  wrapper for polymorphic calls using interface_id from TariffItemSection
"""
function get_tariff_interface(tis::TariffItemSection)
  interface_id = tis.tariff_ref.ref.revision.interface_id
  TariffUtilities.get_tariff_interface(Val(interface_id))
end

"""
  wrapper for polymorphic calls using interface_id
"""
function get_tariff_interface(interface_id::Integer)
  TariffUtilities.get_tariff_interface(Val(interface_id))
end

"""
  TariffUtilities.get_tariff_interface(::Val{1})
  ProfitParticipationTariff 
"""
function TariffUtilities.get_tariff_interface(::Val{1})
  ProfitParticipationTariff.get_tariff_interface()
end

"""
  TariffUtilities.calculate!(ti::TariffItemSection, params::Dict{String,Any})
  wrapper for polymorphic calls using Val(interface_id)
"""

function TariffUtilities.calculate!(ti::TariffItemSection, params::Dict{String,Any})
  calculate!(Val(ti.tariff_ref.ref.revision.interface_id), ti, params)
end

"""
  TariffUtilities.calculate!(interface_id::Val{1}, ti::TariffItemSection, params::Dict{String,Any})
  ProfitParticipationTariff 
"""

function TariffUtilities.calculate!(interface_id::Val{1}, ti::TariffItemSection, params::Dict{String,Any})
  ProfitParticipationTariff.calculate!(ti, params)
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
  PensionTariff.calculate!(ti, params)
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
  SingleLifeRiskTariff.calculate!(ti, params)
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
  JointLifeRiskTariff.calculate!(ti, params)
end

"""
  ProductUtilities.validate(interface_id::Val{0}, pi::ProductItemSection)
  Pension 
"""
function ProductUtilities.validate(interface_id::Val{0}, pis::ProductItemSection)::Dict{Int,Any}
  Dict()
end

"""
  ProductUtilities.validate(interface_id::Val{1}, pi::ProductItemSection)
  Pension 
"""
function ProductUtilities.validate(interface_id::Val{1}, pis::ProductItemSection)::Dict{Int,Any}
  PensionProduct.validate(pis)
end

"""
  ProductUtilities.validate(interface_id::Val{2}, pi::ProductItemSection)
  SingleLifeRisk 
"""
function ProductUtilities.validate(interface_id::Val{2}, pis::ProductItemSection)::Dict{Int,Any}
  SingleLifeRiskProduct.validate(pis)
end
"""
  ProductUtilities.validate(interface_id::Val{3}, pi::ProductItemSection)
  JointLifeRisk 
"""
function ProductUtilities.validate(interface_id::Val{3}, pis::ProductItemSection)::Dict{Int,Any}
  JointLifeRiskProduct.validate(pis)
end

end # module
