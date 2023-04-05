using JSON, BitemporalPostgres, LifeInsuranceProduct, LifeInsuranceDataModel,
    Dates, MortalityTables, LifeContingencies, Yields, SearchLight
import LifeContingencies: ä, A
ENV["SEARCHLIGHT_USERNAME"] = "postgres"
ENV["SEARCHLIGHT_PASSWORD"] = "postgres"
LifeInsuranceDataModel.connect()
cid = 1
h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1];
txntime = vi.tsdb_validfrom
reftime = vi.tsworld_validfrom

cs = csection(cid, txntime, reftime)

ti = cs.product_items[1].tariff_items[1]

tariffparms = JSON.parse(ti.tariff_ref.ref.revision.parameters)
mts = tariffparms["mortality_tables"]
interface_id = ti.tariff_ref.ref.revision.interface_id
parms = get_tariff_interface(Val(interface_id)).calls
args = parms["calculation_target"]
args["selected"] = "net premium"
args["net premium"]["pension rate"]["value"] = "500"
args["net premium"]["m"]["value"] = "10"
args["net premium"]["n"]["value"] = "20"
args["net premium"]["frequency"]["value"] = "2"
args["net premium"]["begin"]["value"] = string(Date("2023-04-01"))
parms
parms["calculation_target"]
calculate!(Val(interface_id), ti, parms)
println(parms["result"])
