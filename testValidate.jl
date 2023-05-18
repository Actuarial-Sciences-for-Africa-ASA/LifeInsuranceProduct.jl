using BitemporalPostgres, LifeInsuranceDataModel, LifeInsuranceProduct
using SearchLight, TimeZones, Revise
ENV["SEARCHLIGHT_USERNAME"] = "postgres"
ENV["SEARCHLIGHT_PASSWORD"] = "postgres"
SearchLight.Configuration.load() |> SearchLight.connect
cid = 1
h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1];
txntime = vi.tsdb_validfrom
reftime = vi.tsworld_validfrom

cs = csection(cid, txntime, reftime)

pi = cs.product_items[1]

validate(pi)
get_tariff_interface(pi.tariff_items[1])