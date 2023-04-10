using BitemporalPostgres, LifeInsuranceDataModel, LifeInsuranceProduct
using MortalityTables, LifeContingencies, Yields
using JSON, SearchLight, SearchLightPostgreSQL, TimeZones
import LifeContingencies: ä, A
ENV["SEARCHLIGHT_USERNAME"] = "postgres"
ENV["SEARCHLIGHT_PASSWORD"] = "postgres"
SearchLight.Configuration.load() |> SearchLight.connect
cid = 2
h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1];
txntime = vi.tsdb_validfrom
reftime = vi.tsworld_validfrom

cs = csection(cid, txntime, reftime)

ti = cs.product_items[1].tariff_items[1]

tariffparms = JSON.parse(ti.tariff_ref.ref.revision.parameters)
println(tariffparms)
mts = tariffparms["mortality_tables"]
interface_id = ti.tariff_ref.ref.revision.interface_id
tif = get_tariff_interface(Val(interface_id))
tgt = tif.calls["calculation_target"]
tgt["selected"] = "net premium"
parms = tgt[tgt["selected"]]
parms["m"] = 10
parms["n"] = 20
parms["frequency"] = 2
parms["begin"] = string(Date("2023-04-01"))
parms["sum insured"] = 20000

tif.calculator(interface_id, ti, tif.calls)
println(tif.calls)
# accessiong partner LifeInsuranceDataModel
# dob1 = ti.partner_refs[1].ref.revision.date_of_birth
# smoker1 = ti.partner_refs[1].ref.revision.smoker ? "smoker" : "nonsmoker"
# sex1 = ti.partner_refs[1].ref.revision.sex
# issue_age1 = TariffUtilities.insurance_age(dob1, Date(parms["begin"]))
# 
# dob2 = ti.partner_refs[2].ref.revision.date_of_birth
# smoker2 = ti.partner_refs[2].ref.revision.smoker ? "smoker" : "nonsmoker"
# sex2 = ti.partner_refs[2].ref.revision.sex
# issue_age2 = TariffUtilities.insurance_age(dob2, Date(parms["begin"]))
# 
# # accessing tariff data
# i = ti.tariff_ref.ref.revision.interest_rate
# 
# life1 = SingleLife(
#     mortality=MortalityTables.table(mts[sex1][smoker1]).select[issue_age1])
# life2 = SingleLife(
#     mortality=MortalityTables.table(mts[sex2][smoker2]).select[issue_age2])
# jl = JointLife(lives=(life1, life2))
# 
# yield = Yields.Constant(i)      # Using a flat
# 
# lc = LifeContingency(jl, yield)  # LifeContingenc
# 
# n = 30
# c = 5000
# r1 = A(lc, 42)
# r2 = ä(lc, n)
# 5000 * A(lc, 42) / ä(lc, 42, frequency=12)
# A(lc, 30)#
# #/ ä(lc, 30,frequency=1n)
# i
# 
# r3 = A(LifeContingency(life1, yield), 42)
# r4 = A(LifeContingency(life2, yield), 42)