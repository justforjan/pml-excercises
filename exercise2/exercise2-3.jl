include("discrete.jl") 
using .DiscreteDistribution: Discrete, ℙ, *, /, logsumexp

include("distributionbag.jl")
using .DistributionCollections: DistributionBag, add!, reset!

N = 20
mu1 = 8
mu2 = 12
v1 = 2
v2 = 2
bq = 3

# f1(s1) = pdf(Normal(mu1, v1), s1)
# f2(s1, p1) = pdf(Normal(s1, bq), p1)
# f3(s2) = pdf(Normal(mu2, v2), s2)
# f4(s2, p2) = pdf(Normal(s2, bq), p2)

# f5(p1, p2, d) = d == p1 - p2
# f6(d) = d > 0

# m_f1_S1(s1) = f1(s1)
# m_f3_S2(s2) = f3(s2)

# p_s1 = Vector

factors = DistributionBag(Discrete(N))
for i in 1:6
    add!(factors)
end

marginals = DistributionBag(Discrete(N))
for i in 1:5
    add!(marginals)
end

marginals[1]
