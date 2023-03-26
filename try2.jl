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



lc = LifeContingency(l1, Yields.Constant(0.05))
lcj = LifeContingency(jl, Yields.Constant(0.05))
D(lc, 10)

#
# immediate annuity lifelong
# 
# present_value
# net premium
a(lc)
# immediate annuity deferred
# 
# present_value
a(lc, start_time=m)

# deferred annuity lifelong
# present_value
a(lc, start_time=m)
# net premium
a(lc, start_time=m) / a(lc, m)
# deferred annuity term
# present_value
ä(lc, n, start_time=m)
# net premium , increasing with frequency as present value of payments decreases with frequency
a(lc, n, start_time=m) / ä(lc, m)
a(lc, n, start_time=m) / ä(lc, m, frequency=2)
a(lc, n, start_time=m) / ä(lc, m, frequency=4)

# life risk life long
# present_value
A(lc)
# net premium ,
A(lc) / ä(lc, m, frequency=1)
# life risk temporary
A(lc, n)
# net premium ,
A(lc, n) / ä(lc, m, frequency=1)
# two life risk
# present_value
A(lcj)
# net premium ,
A(lcj) / ä(lcj, m, frequency=1)
# life risk temporary
A(lcj, n)
# net premium ,
A(lcj, n) / ä(lcj, m, frequency=1)