module LifeInsuranceProduct

using LifeContingencies
using MortalityTables
using Yields
import LifeContingencies: V, ä     # pull the shortform notation into scope

# load mortality rates from MortalityTables.jl
vbt2001 = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

"""
issue_age

Age of insured person as of insurance begin date
"""
issue_age = 30
life = SingleLife(                 # The life underlying the risk
    mortality=vbt2001.select[issue_age],    # -- Mortality rates
)

yield = Yields.Constant(0.05)      # Using a flat 5% interest rate

lc = LifeContingency(life, yield)  # LifeContingency joins the risk with interest


ins = Insurance(lc)                # Whole Life insurance
ins = Insurance(life, yield)       # alternate way to construct

println(premium_net(lc))
end # module
