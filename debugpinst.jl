using BitemporalPostgres
using LifeInsuranceDataModel
using SearchLight
using SearchLightPostgreSQL
using TimeZones
ENV["SEARCHLIGHT_USERNAME"] = "postgres"
ENV["SEARCHLIGHT_PASSWORD"] = "postgres"
SearchLight.Configuration.load() |> SearchLight.connect
cpRole = Dict{String,Int64}()
map(find(LifeInsuranceDataModel.ContractPartnerRole)) do entry
    cpRole[entry.value] = entry.id.value
end
tiprRole = Dict{String,Int64}()
map(find(LifeInsuranceDataModel.TariffItemPartnerRole)) do entry
    tiprRole[entry.value] = entry.id.value
end
woman1 = find(Partner, SQLWhereExpression("id=?", 1))[1]
man2 = find(Partner, SQLWhereExpression("id=?", 4))[1]
jointlifeRiskInsurance = find(Product, SQLWhereExpression("id=?", 3))[1]

w1 = Workflow(
    type_of_entity="Contract",
    tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"UTC"),
)

create_entity!(w1)
c = Contract()
cr = ContractRevision(description="contract creation properties")
create_component!(c, cr, w1)

cpr = ContractPartnerRef(ref_super=c.id)
cprr = ContractPartnerRefRevision(
    ref_partner=woman1.id,
    ref_role=cpRole["Policy Holder"],
    description="policyholder ref properties",
)

create_subcomponent!(c, cpr, cprr, w1)
# pi 1
PartnerroleMap = Dict{Integer,PartnerSection}()
PartnerRole = tiprRole["Insured Person"]
PartnerroleMap[PartnerRole] = psection(woman1.id.value, now(tz"UTC"), w1.tsw_validfrom, 0)
PartnerRole = tiprRole["2nd Insured Person"]
PartnerroleMap[PartnerRole] = psection(man2.id.value, now(tz"UTC"), w1.tsw_validfrom, 0)


cpi = ProductItem(ref_super=c.id)
cpir = ProductItemRevision(
    ref_product=jointlifeRiskInsurance.id.value,
    description="from contract creation",
)
create_subcomponent!(c, cpi, cpir, w1)

LifeInsuranceDataModel.create_product_instance(
    w1,
    cpi,
    jointlifeRiskInsurance.id.value,
    PartnerroleMap,
)
commit_workflow!(w1)
cs = csection(c.id.value, now(tz"UTC"), w1.tsw_validfrom)

prs = cs.product_items[1].tariff_items[1].partner_refs
println(prs)

