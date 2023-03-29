
using BitemporalPostgres, Dates, JSON, LifeInsuranceDataModel, LifeInsuranceProduct, MortalityTables, LifeContingencies, SearchLight, Yields
import LifeContingencies: ä, A
ENV["SEARCHLIGHT_USERNAME"] = "postgres"
ENV["SEARCHLIGHT_PASSWORD"] = "postgres"
connect()
cid = 1
h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1];
txntime = vi.tsdb_validfrom
reftime = vi.tsworld_validfrom

cs = csection(cid, txntime, reftime)

ti = cs.product_items[1].tariff_items[1]
tariffparms = JSON.parse(ti.tariff_ref.rev.parameters)
interface_id = ti.tariff_ref.ref.revision.interface_id
parms = get_tariff_interface(Val(interface_id)).calls
args = parms["calculation_target"]
args["selected"] = "ä"
args["ä"]["m"]["value"] = "10"
args["ä"]["n"]["value"] = "20"
args["ä"]["frequency"]["value"] = "2"
args["ä"]["begin"]["value"] = string(Date("2023-04-01"))
parms
parms["calculation_target"]
calculate!(Val(1), ti, parms)
parms["result"]