module SingleLifeRiskProduct
using LifeInsuranceDataModel
include("ProductUtilities.jl")
using .ProductUtilities

function validate(pi::ProductItemSection)::Dict{Int,Any}
    @info("validating SingleLifeRiskProduct")
    Dict()
end

end