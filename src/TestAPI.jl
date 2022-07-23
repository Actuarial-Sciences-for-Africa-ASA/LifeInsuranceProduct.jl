module TestAPI
using LifeInsuranceDataModel
using ToStruct

pisDict = Dict{String,Any}(
    "tariff_items" => Any[
        Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "Life Risk tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 1)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.294+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 2), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Life Risk Insurance"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.294+00:00")), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.304+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.304+00:00"))]),
        Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 4), "description" => "Profit participation tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 4)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.321+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 4), "id" => Dict{String,Any}("value" => 4), "description" => "Profit participation"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.321+00:00")), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.330+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.330+00:00"))]),
        Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 3), "id" => Dict{String,Any}("value" => 3), "ref_role" => Dict{String,Any}("value" => 3), "description" => "Terminal Illness tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 2)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.346+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 3), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 2), "id" => Dict{String,Any}("value" => 2), "description" => "Terminal Illness"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.346+00:00")), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 3), "id" => Dict{String,Any}("value" => 3), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.362+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.362+00:00"))]),
        Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 4), "id" => Dict{String,Any}("value" => 4), "ref_role" => Dict{String,Any}("value" => 4), "description" => "Profitparticipation tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 4)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.373+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 4), "id" => Dict{String,Any}("value" => 4), "description" => "Profit participation"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.373+00:00")), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 4), "id" => Dict{String,Any}("value" => 4), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.386+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.386+00:00"))]),
        Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 5), "id" => Dict{String,Any}("value" => 5), "ref_role" => Dict{String,Any}("value" => 2), "description" => "Occupational Disablity tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 4)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.395+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 4), "id" => Dict{String,Any}("value" => 4), "description" => "Profit participation"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.395+00:00")), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 5), "id" => Dict{String,Any}("value" => 5), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.407+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.407+00:00"))]),
        Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 6), "id" => Dict{String,Any}("value" => 6), "ref_role" => Dict{String,Any}("value" => 4), "description" => "Profit Participation tariff parameters", "ref_tariff" => Dict{String,Any}("value" => 4)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.416+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 5), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 4), "id" => Dict{String,Any}("value" => 4), "description" => "Profit participation"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.416+00:00")), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 6), "id" => Dict{String,Any}("value" => 6), "ref_role" => Dict{String,Any}("value" => 1), "description" => "partner 1 ref properties"), "ref" => Dict{String,Any}("tsdb_validfrom" => "2022-07-23T09:03:31.431+00:00", "ref_history" => Dict{String,Any}("value" => 9223372036854775807), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9223372036854775807), "tsw_validfrom" => "2022-07-23T09:03:31.431+00:00"))])
    ],
    "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 8), "ref_invalidfrom" => Dict{String,Any}("value" => 9223372036854775807), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "position" => 1, "description" => "from contract creation", "ref_product" => Dict{String,Any}("value" => 2))
)

pis = ToStruct.tostruct(ProductItemSection, pisDict)
tis1 = (pis.tariff_items[1])
println(tis1.tariff_ref.rev.description)
end