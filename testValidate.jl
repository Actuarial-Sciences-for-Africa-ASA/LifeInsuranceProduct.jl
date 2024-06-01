using BitemporalPostgres, LifeInsuranceDataModel, LifeInsuranceProduct
using SearchLight, TimeZones, Revise
SearchLight.Configuration.load() |> SearchLight.connect
piss = map([1, 2, 3]) do cid
    h = find(Contract, SQLWhereExpression("id =?", cid))[1].ref_history
    vi = find(ValidityInterval, SQLWhereExpression("ref_history=?", h), order=["ValidityInterval.id"])[1]
    txntime = vi.tsdb_validfrom
    reftime = vi.tsworld_validfrom

    cs = csection(cid, txntime, reftime)
    cs.product_items[1]
end

map(piss) do pi
    @info pi.product_ref.revision.description
    @info pi.product_ref.revision.interface_id
    @info pi.tariff_items[1].tariff_ref.ref.revision.description
    @info pi.tariff_items[1].tariff_ref.ref.revision.interface_id
    validate(pi)
end

