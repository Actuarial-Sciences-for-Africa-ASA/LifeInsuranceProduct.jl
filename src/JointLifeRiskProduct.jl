module JointLifeRiskProduct
using LifeInsuranceDataModel

include("ProductUtilities.jl")
using .ProductUtilities

function validate(pi::ProductItemSection)::Dict{Int,Any}
    @info("validating JointLifeRiskProduct")
    Dict()
end

end