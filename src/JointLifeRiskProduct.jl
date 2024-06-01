module JointLifeRiskProduct
using LifeInsuranceDataModel

function LifeInsuranceDataModel.get_product_interface(::Val{3})::ProductInterface
    @info "get_product_interface in JointLifeRiskProduct"
    ProductInterface("JointLifeRiskProduct", Dict(), identity, validator, Dict(), Dict(),
        [get_tariff_interface(Val(4)), get_tariff_interface(1)])
end

function validator(pi::ProductItemSection)::Dict{Int,Any}
    @info("validating JointLifeRiskProduct")
    Dict()
end

end