module PensionProduct
using LifeInsuranceDataModel

function LifeInsuranceDataModel.get_product_interface(::Val{1})::ProductInterface
    @info "get_product_interface in PensionProduct"
    ProductInterface("Pension Product", Dict(), identity, validator, Dict(), Dict(),
        [get_tariff_interface(Val(2)), get_tariff_interface(1)])
end

function validator(pis::ProductItemSection)
    @info("validating PensionProduct ")
    Dict()
end

end