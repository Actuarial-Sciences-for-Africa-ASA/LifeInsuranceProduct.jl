module LifeInsuranceProduct

using Dates, LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä     # pull the shortform notation into scope
export calculate

# load mortality rates from MortalityTables.jl
vbt2001 = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

function insurance_age(dob, beginn)::Integer
    if ((Date(Dates.year(beginn), Dates.month(dob), Dates.day(dob)) - beginn).value > 183)
        Dates.year(beginn) - Dates.year(dob) - 1
    else
        Dates.year(beginn) - Dates.year(dob)
    end
end

function calculate(ti)
    dob = ti.partner_refs[1].ref.revision.date_of_birth
    beginn = Date(Dates.year(today()), Dates.month(today()) + 1, 1)
    """
    issue_age

    Age of insured person as of insurance begin date
    """
    issue_age = insurance_age(dob, beginn)

    life = SingleLife(                 # The life underlying the risk
        mortality=vbt2001.select[issue_age],    # -- Mortality rates
    )

    yield = Yields.Constant(0.05)      # Using a flat 5% interest rate

    lc = LifeContingency(life, yield)  # LifeContingency joins the risk with interest


    ins = Insurance(lc)                # Whole Life insurance
    ins = Insurance(life, yield)       # alternate way to construct

    premium_net(lc)
end

end # module
