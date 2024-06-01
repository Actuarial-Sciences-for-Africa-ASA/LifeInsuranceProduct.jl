using BitemporalPostgres, LifeInsuranceDataModel, LifeInsuranceProduct
using JSON, SearchLight, TimeZones
SearchLight.Configuration.load() |> SearchLight.connect
cid = 1
h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1];
txntime = vi.tsdb_validfrom
reftime = vi.tsworld_validfrom

cs = csection(cid, txntime, reftime)

ti = cs.product_items[1].tariff_items[1]

tif = get_tariff_interface(ti)
tgt = tif.calls["calculation_target"]
tgt["selected"] = "net premium"
parms = tgt[tgt["selected"]]
parms["n"]["value"] = "20"
parms["m"]["value"] = "20"
parms["frequency"]["value"] = "12"
parms["begin"]["value"] = "2023-04-01"
parms["pension rate"]["value"] = "500"

tif.calculator(ti, tif.calls)

@info "net premium ================================"
@show tif.calls
tgt["selected"] = "pension rate"
parms = tgt[tgt["selected"]]
parms["n"]["value"] = "20"
parms["m"]["value"] = "20"
parms["frequency"]["value"] = "12"
parms["begin"]["value"] = "2023-04-01"
parms["net premium"]["value"] = "20"
tif.calculator(ti, tif.calls)
@info "pension rate ======================="
@show tif.calls

