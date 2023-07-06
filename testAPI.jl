using BitemporalPostgres
using LifeInsuranceDataModel, LifeInsuranceProduct
using SearchLight
using TimeZones
ENV["SEARCHLIGHT_USERNAME"] = ENV["USER"]
ENV["SEARCHLIGHT_PASSWORD"] = ENV["USER"]
SearchLight.Configuration.load() |> SearchLight.connect

SearchLight.query("DROP SCHEMA public CASCADE")
SearchLight.query("CREATE SCHEMA public")
LifeInsuranceDataModel.load_model()

#   Creating Tariffs

using LifeInsuranceDataModel, LifeInsuranceProduct, SearchLight
import SearchLight: Serializer.serialize

tif = get_tariff_interface(1)
ProfitParticipationTariff = create_tariff("Profit participation", 1, serialize(tif.parameters), serialize(tif.contract_attributes))
tif = get_tariff_interface(2)
PensionTariff = create_tariff("Pension Insurance", 2, serialize(tif.parameters), serialize(tif.contract_attributes))
tif = get_tariff_interface(3)
SingleLifeRiskTariff = create_tariff("Single Life Risk Insurance", 3, serialize(tif.parameters), serialize(tif.contract_attributes))
tif = get_tariff_interface(4)
JointLifeRiskTariff = create_tariff("Joint Life Risk Insurance", 4, serialize(tif.parameters), serialize(tif.contract_attributes), [1, 2])


cpRole = Dict{String,Int64}()
map(find(LifeInsuranceDataModel.ContractPartnerRole)) do entry
    cpRole[entry.value] = entry.id.value
end
tiprRole = Dict{String,Int64}()
map(find(LifeInsuranceDataModel.TariffItemPartnerRole)) do entry
    tiprRole[entry.value] = entry.id.value
end
titrRole = Dict{String,Int64}()
map(find(LifeInsuranceDataModel.TariffItemRole)) do entry
    titrRole[entry.value] = entry.id.value
end

ppRole = Dict{String,Int64}()
map(find(LifeInsuranceDataModel.ProductPartRole)) do entry
    ppRole[entry.value] = entry.id.value
end


#   Pension Insurance Product


pensionInsurance = Product()
pr = ProductRevision(description="Pension", interface_id=1)

pp = ProductPart()
ppr = ProductPartRevision(
    ref_tariff=PensionTariff,
    ref_role=ppRole["Main Coverage - Life"],
    description="Main Coverage - Life",
)

pp2 = ProductPart()
ppr2 = ProductPartRevision(
    ref_tariff=ProfitParticipationTariff,
    ref_role=ppRole["Profit participation"],
    description="Profit participation Life Risk",
)

w0 = Workflow(
    type_of_entity="Product",
    tsw_validfrom=ZonedDateTime(2000, 1, 1, 0, 0, 0, 0, tz"UTC"),
)
create_entity!(w0)
create_component!(pensionInsurance, pr, w0)
create_subcomponent!(pensionInsurance, pp, ppr, w0)
create_subcomponent!(pensionInsurance, pp2, ppr2, w0)
commit_workflow!(w0)

#   Single Life Risk Insurance Product


singlelifeRiskInsurance = Product()
pr = ProductRevision(description="Single Life Risk", interface_id=2)

pp = ProductPart()
ppr = ProductPartRevision(
    ref_tariff=SingleLifeRiskTariff,
    ref_role=ppRole["Main Coverage - Life"],
    description="Main Coverage - Life",
)

pp2 = ProductPart()
ppr2 = ProductPartRevision(
    ref_tariff=ProfitParticipationTariff,
    ref_role=ppRole["Profit participation"],
    description="Profit participation Life Risk",
)

w0 = Workflow(
    type_of_entity="Product",
    tsw_validfrom=ZonedDateTime(2000, 1, 1, 0, 0, 0, 0, tz"UTC"),
)
create_entity!(w0)
create_component!(singlelifeRiskInsurance, pr, w0)
create_subcomponent!(singlelifeRiskInsurance, pp, ppr, w0)
create_subcomponent!(singlelifeRiskInsurance, pp2, ppr2, w0)
commit_workflow!(w0)

#   A Joint Life Risk Insurance Product


jointlifeRiskInsurance = Product()
pr = ProductRevision(description="Joint Life Risk", interface_id=3)

pp = ProductPart()
ppr = ProductPartRevision(
    ref_tariff=JointLifeRiskTariff,
    ref_role=ppRole["Main Coverage - Life"],
    description="Main Coverage - Life",
)

pp2 = ProductPart()
ppr2 = ProductPartRevision(
    ref_tariff=ProfitParticipationTariff,
    ref_role=ppRole["Profit participation"],
    description="Profit participation Life Risk",
)

w0 = Workflow(
    type_of_entity="Product",
    tsw_validfrom=ZonedDateTime(2000, 1, 1, 0, 0, 0, 0, tz"UTC"),
)
create_entity!(w0)
create_component!(jointlifeRiskInsurance, pr, w0)
create_subcomponent!(jointlifeRiskInsurance, pp, ppr, w0)
create_subcomponent!(jointlifeRiskInsurance, pp2, ppr2, w0)
commit_workflow!(w0)

prs = prsection(1, now(tz"UTC"), ZonedDateTime(2023, 4, 1, 21, 0, 1, 1, tz"UTC"), 0)
rolesTariffItemPartner = load_role(TariffItemPartnerRole)

#   create partner woman1 nonsmoker

woman1 = LifeInsuranceDataModel.Partner()
pr = LifeInsuranceDataModel.PartnerRevision(description="woman 1", sex="f", smoker=false)
w = Workflow(type_of_entity="Partner",
    tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"UTC"),
)
create_entity!(w)
create_component!(woman1, pr, w)
commit_workflow!(w)

#   create partner woman2 smoker

woman2 = LifeInsuranceDataModel.Partner()
pr = LifeInsuranceDataModel.PartnerRevision(description="woman 2", sex="f", smoker=true)
w = Workflow(type_of_entity="Partner",
    tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"UTC"),
)
create_entity!(w)
create_component!(woman2, pr, w)
commit_workflow!(w)

#   create partner man1 nonsmoker

man1 = LifeInsuranceDataModel.Partner()
pr = LifeInsuranceDataModel.PartnerRevision(description="man 1", sex="m", smoker=false)
w = Workflow(type_of_entity="Partner",
    tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"UTC"),
)
create_entity!(w)
create_component!(man1, pr, w)
commit_workflow!(w)
man1

#   create partner man2 smoker

man2 = LifeInsuranceDataModel.Partner()
pr = LifeInsuranceDataModel.PartnerRevision(description="man 2", sex="m", smoker=true)
w = Workflow(type_of_entity="Partner",
    tsw_validfrom=ZonedDateTime(2014, 5, 30, 21, 0, 1, 1, tz"UTC"),
)
create_entity!(w)
create_component!(man2, pr, w)
commit_workflow!(w)

#   Contract woman nonsmoker pension

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
    description="policiyholder ref properties",
)
create_subcomponent!(c, cpr, cprr, w1)
# pi 1

PartnerRole = tiprRole["Insured Person"]
PartnerroleMap = Dict{Integer,PartnerSection}()
PartnerroleMap[PartnerRole] = psection(woman1.id.value, now(tz"UTC"), w1.tsw_validfrom, 0)

cpi = ProductItem(ref_super=c.id)
cpir = ProductItemRevision(
    ref_product=pensionInsurance.id,
    description="from contract creation",
)
create_subcomponent!(c, cpi, cpir, w1)

LifeInsuranceDataModel.create_product_instance(
    w1,
    cpi,
    pensionInsurance.id.value,
    PartnerroleMap
)
commit_workflow!(w1)

#   Contract man smoker woman nonsmoker joint life

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
    ref_partner=woman2.id,
    ref_role=cpRole["Policy Holder"],
    description="policyholder ref properties",
)

create_subcomponent!(c, cpr, cprr, w1)
# pi 1
PartnerroleMap = Dict{Integer,PartnerSection}()
PartnerRole = tiprRole["Insured Person"]
PartnerroleMap[PartnerRole] = psection(woman1.id.value, now(tz"UTC"), w1.tsw_validfrom, 0)
PartnerRole = tiprRole["2nd Insured Person"]
PartnerroleMap[PartnerRole] = psection(man1.id.value, now(tz"UTC"), w1.tsw_validfrom, 0)


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

#   contract man smoker single life risk

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
    ref_partner=man2.id,
    ref_role=cpRole["Policy Holder"],
    description="policiyholder ref properties",
)
create_subcomponent!(c, cpr, cprr, w1)
# pi 1

PartnerRole = tiprRole["Insured Person"]
PartnerroleMap = Dict{Integer,PartnerSection}()
PartnerroleMap[PartnerRole] = psection(man2.id.value, now(tz"UTC"), w1.tsw_validfrom, 0)

cpi = ProductItem(ref_super=c.id)
cpir = ProductItemRevision(
    ref_product=singlelifeRiskInsurance.id,
    description="from contract creation",
)
create_subcomponent!(c, cpi, cpir, w1)

LifeInsuranceDataModel.create_product_instance(
    w1,
    cpi,
    singlelifeRiskInsurance.id.value,
    PartnerroleMap
)
commit_workflow!(w1)

include("testCalcPEN.jl")
include("testCalcSLR.jl")
include("testCalcJLR.jl")
include("testValidate.jl")