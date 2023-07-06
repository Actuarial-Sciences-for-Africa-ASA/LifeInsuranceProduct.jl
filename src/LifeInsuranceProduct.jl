module LifeInsuranceProduct

using LifeInsuranceDataModel

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
export ProductInterface, TariffInterface, calculate!, insurance_age

end # module
