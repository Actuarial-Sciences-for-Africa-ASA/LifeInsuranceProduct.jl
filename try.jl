using LifeContingencies, MortalityTables, Yields
import LifeContingencies: A, ä, a, C, D, N, premium_net

mortality = MortalityTables.table("2001 VBT Residual Standard Select and Ultimate - Male Nonsmoker, ANB")

l1 = SingleLife(
    mortality=mortality.select[30],
    issue_age=30
)

l2 = SingleLife(
    mortality=mortality.select[30],
    issue_age=30
)

jl = JointLife(
    lives=(l1, l2),
    contingency=LastSurvivor(),
    joint_assumption=Frasier()
)
A(jl, Yields.Constant(0.05))

A(l1, Yields.Constant(0.05))

m = 20
n = 30

a_omega = a(l1, Yields.Constant(0.05))
# sofortrente m jahre
a_m = a(l1, Yields.Constant(0.05), m)
# um m aufgeschobene rente n jahre 
a_nm = a(l1, Yields.Constant(0.05), n, start_time=m)
# um m+n aufgeschobene rente lebenslänglich
a_mplusn = a(l1, Yields.Constant(0.05), start_time=m + n)

a_omega == a_m + a_nm + a_mplusn

a_omega - (a_m + a_nm + a_mplusn)
#function wommasehn(::Val{1}, bubu::String)
#    println(bubu * "hurra 1")
#end
#
#function wommasehn(::Val{2}, bubu::String)
#    println(bubu * "hurra 2")
#end
#
#wommasehn(Val(1), "schnaps")
#wommasehn(Val(2), "päeng")


lc = LifeContingency(l1, Yields.Constant(0.05))
D(lc, 10)