module LifeInsuranceProduct

using Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä     # pull the shortform notation into scope
export calculate, get_tariff_interface

function get_tariff_interface(::Val{1})
    """
      {"calculation_target":
        {"selected": "none",
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
        }
      }, "result": {"value": 0}
      }
    """
end

function get_tariff_interface(::Val{2})
    """
      {"calculation_target":
        {"selected": "none",
        "label": "calculation target",
        "options": ["premium","sum insured"],
        "sum insured": 
        {"p":{"type":"Int", "default":0, "value":null},
        "n":{"type":"Int", "default":0, "value":null},
        "begin":{"type":"Date", "default":"2020-01-01", "value":null}
        },
        "premium": 
        {"n":{"type":"Int", "default":0, "value":null},
        "C":{"type":"Int", "default":0, "value":null},
        "begin":{"type":"Date", "default":"2020-01-01", "value":null}
        }
      }, "result": {"value": 0}
      }
    """
end
# load mortality rates from MortalityTables.jl
vbt2001 = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

function insurance_age(dob, begindate)::Integer
    if ((Date(Dates.year(begindate), Dates.month(dob), Dates.day(dob)) - begindate).value > 183)
        Dates.year(begindate) - Dates.year(dob) - 1
    else
        Dates.year(begindate) - Dates.year(dob)
    end
end

function calculate(ti, params::Dict{String,Any})
    dob = ti.partner_refs[1].ref.revision.date_of_birth
    begindate = Date(Dates.year(today()) + (month(today()) == 12 ? 1 : 0), Dates.mod(month(today()) + 1, 12), 1)
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

    ai = AnnuityImmediate(lc)
    if (ti.tariff_ref.rev.deferment == 0.0)
        ti.tariff_ref.rev.annuity_due = 0.0
        ti.tariff_ref.rev.annuity_immediate = present_value(AnnuityImmediate(lc))
    else
        ti.tariff_ref.rev.annuity_immediate = 0.0
        ti.tariff_ref.rev.annuity_due = present_value(AnnuityDue(lc, start_time=ti.tariff_ref.rev.deferment))
    end
    ti
end

end # module
