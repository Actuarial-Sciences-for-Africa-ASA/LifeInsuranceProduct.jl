module PensionProduct
using LifeInsuranceDataModel

include("ProductUtilities.jl")
using .ProductUtilities

function validate(pi::ProductItemSection)::Dict{Int,Any}
    @info("validating PensionProduct ")
    Dict()
end

end