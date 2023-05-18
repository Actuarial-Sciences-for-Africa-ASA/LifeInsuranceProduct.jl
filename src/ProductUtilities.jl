module ProductUtilities
using JSON, LifeInsuranceDataModel
export validate

function validate(interface_id::Val{T}, pis::ProductItemSection) where {T<:Integer}
end

function validate(pis::ProductItemSection)
    validate(Val(pis.product_ref.revision.interface_id), pis)
end

end
