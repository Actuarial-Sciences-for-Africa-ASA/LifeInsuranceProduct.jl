using BitemporalPostgres, LifeInsuranceDataModel, LifeInsuranceProduct
using JSON, SearchLight, TimeZones
ENV["SEARCHLIGHT_USERNAME"] = "postgres"
ENV["SEARCHLIGHT_PASSWORD"] = "postgres"
SearchLight.Configuration.load() |> SearchLight.connect
cid = 3
h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1];
txntime = vi.tsdb_validfrom
reftime = vi.tsworld_validfrom

cs = csection(cid, txntime, reftime)

ti = cs.product_items[1].tariff_items[1]

tariffparms = JSON.parse(ti.tariff_ref.ref.revision.parameters)
tif = get_tariff_interface(ti)
tgt = tif.calls["calculation_target"]
tgt["selected"] = "net premium"
parms = tgt[tgt["selected"]]
parms["n"]["value"] = "20"
parms["frequency"]["value"] = "2"
parms["begin"]["value"] = "2023-04-01"
parms["sum insured"]["value"] = "20000"

tif.calculator(ti, tif.calls)
