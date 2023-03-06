using Dates, JSON, LifeInsuranceDataModel, MortalityTables, Yields, ToStruct, Revise, LifeContingencies
import LifeContingencies: V, ä

tij = Dict{String,Any}("tariff_ref" => Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 11), "ref_invalidfrom" => Dict{String,Any}("value" => 15), "parameters" => "{\"n\": {\"type\": \"Int\", \"default\": 0,\"value\":null},\n \"m\": {\"type\": \"Int\", \"default\": 0,\"value\":null},\n \"C\": {\"type\": \"Int\", \"default\": 0,\"value\":null},\n \"begin\": {\"type\": \"Date\", \"default\": \"2020-01-01\",\"value\":null}\n}\n  ", "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => "Main Coverage - Two Life", "ref_tariff" => Dict{String,Any}("value" => 5)), "ref" => Dict{String,Any}("tsdb_validfrom" => "2023-03-05T18:22:55.928+00:00", "ref_history" => Dict{String,Any}("value" => 9007199254740991), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 7), "ref_invalidfrom" => Dict{String,Any}("value" => 9007199254740991), "parameters" => "{\"n\": {\"type\": \"Int\", \"default\": 0,\"value\":null},\n \"m\": {\"type\": \"Int\", \"default\": 0,\"value\":null},\n \"C\": {\"type\": \"Int\", \"default\": 0,\"value\":null},\n \"begin\": {\"type\": \"Date\", \"default\": \"2020-01-01\",\"value\":null}\n}\n  ", "mortality_table" => "2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB", "ref_component" => Dict{String,Any}("value" => 5), "id" => Dict{String,Any}("value" => 5), "description" => "Two Life Risk Insurance"), "ref_version" => Dict{String,Any}("value" => 9007199254740991), "tsw_validfrom" => "2023-03-05T18:22:55.928+00:00", "partner_roles" => Any[Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 7), "ref_invalidfrom" => Dict{String,Any}("value" => 9007199254740991), "ref_component" => Dict{String,Any}("value" => 5), "id" => Dict{String,Any}("value" => 5), "ref_role" => Dict{String,Any}("value" => 1)), Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 7), "ref_invalidfrom" => Dict{String,Any}("value" => 9007199254740991), "ref_component" => Dict{String,Any}("value" => 6), "id" => Dict{String,Any}("value" => 6), "ref_role" => Dict{String,Any}("value" => 2))])), "partner_refs" => Any[Dict{String,Any}("rev" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 11), "ref_invalidfrom" => Dict{String,Any}("value" => 9007199254740991), "ref_partner" => Dict{String,Any}("value" => 1), "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "ref_role" => Dict{String,Any}("value" => 1), "description" => ""), "ref" => Dict{String,Any}("tsdb_validfrom" => "2023-03-05T18:22:55.939+00:00", "ref_history" => Dict{String,Any}("value" => 9007199254740991), "revision" => Dict{String,Any}("ref_validfrom" => Dict{String,Any}("value" => 1), "ref_invalidfrom" => Dict{String,Any}("value" => 9007199254740991), "date_of_birth" => "2000-01-01", "ref_component" => Dict{String,Any}("value" => 1), "id" => Dict{String,Any}("value" => 1), "description" => "Partner 1"), "ref_version" => Dict{String,Any}("value" => 9007199254740991), "tsw_validfrom" => "2023-03-05T18:22:55.939+00:00"))], "contract_attributes" => Dict{String,Any}("begin" => Dict{String,Any}("default" => "2020-01-01", "value" => nothing, "type" => "Date"), "m" => Dict{String,Any}("default" => 0, "value" => nothing, "type" => "Int"), "C" => Dict{String,Any}("default" => 0, "value" => nothing, "type" => "Int"), "n" => Dict{String,Any}("default" => 0, "value" => nothing, "type" => "Int")))
ti = ToStruct.tostruct(TariffItemSection, tij)

mutable struct TariffInterface
    calls::Dict{String,Any}
    calculator::Function
end

function get_tariff_interface(::Val{1})
    calls = """
        {"calculation_target":
          {"selected": "ä",
          "label": "calculation target",
          "options": ["premium","sum insured"],
          "sum insured": 
          {"p":{"type":"Int", "default":0, "value":null},
          "n":{"type":"Int", "default":0, "value":null},
          "m":{"type":"Int", "default":0, "value":null},
          "begin":{"type":"Date", "default":"2020-01-01", "value":null}
          },
          "premium": 
          {"n":{"type":"Int", "default":0, "value":null},
          "m":{"type":"Int", "default":0, "value":null},
          "C":{"type":"Int", "default":0, "value":null},
          "begin":{"type":"Date", "default":"2020-01-01", "value":null}
          },
          "ä": 
          {"n":{"type":"Int", "default":0, "value":5},
          "m":{"type":"Int", "default":0, "value":5},
          "frequency":{"type":"Int", "default":0, "value":4},
          "begin":{"type":"Date", "default":"2020-01-01", "value":"2020-01-01"}
          }
        }, "result": {"value": 0}
        }
      """
    TariffInterface(JSON.parse(calls), calculate!)
end
vbt2001 = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

function insurance_age(dob, begindate)::Integer
    if ((Date(Dates.year(begindate), Dates.month(dob), Dates.day(dob)) - begindate).value > 183)
        Dates.year(begindate) - Dates.year(dob) - 1
    else
        Dates.year(begindate) - Dates.year(dob)
    end
end

function calculate!(ti, params::Dict{String,Any})
    dob = ti.partner_refs[1].ref.revision.date_of_birth
    fn = params["calculation_target"]["selected"]
    args = params["calculation_target"][fn]
    if fn == "ä"

        begindate = Date(args["begin"]["value"])
        n = args["n"]["value"]
        m = args["m"]["value"]
        frq = args["frequency"]["value"]

        """
        issue_age

        Age of insured person as of insurance begin date
        """
        issue_age = insurance_age(dob, begindate)

        life = SingleLife(                 # The life underlying the risk
            mortality=vbt2001.select[issue_age],    # -- Mortality rates
        )

        yield = Yields.Constant(0.0125)      # Using a flat 1,25% interest rate

        lc = LifeContingency(life, yield)  # LifeContingency joins the risk with interest


        ins = Insurance(lc)                # Whole Life insurance
        ins = Insurance(life, yield)       # alternate way to construct

        premium_net(lc)

        params["result"]["value"] = ä(lc, n, certain=m, frequency=frq)
    end
end

tif = get_tariff_interface(Val(1))
tif.calculator(ti, tif.calls)