module SingleLifeRiskProduct
using LifeInsuranceDataModel

import LifeInsuranceDataModel.get_tariff_interface

function LifeInsuranceDataModel.get_product_interface(::Val{2})::ProductInterface
    @info "get_product_interface in SingleLifeRiskProduct"
    ProductInterface("SingleLifeRiskProduct", Dict(), identity, validator, Dict(), Dict(),
        [get_tariff_interface(Val(2)), get_tariff_interface(1)])
end

function validator(pi::ProductItemSection)::Dict{Int,Any}
    @info("validating SingleLifeRiskProduct")
    Dict()
end

end