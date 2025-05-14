include("discrete.jl") 
using .DiscreteDistribution: Discrete, ℙ, *, /, logsumexp, DiscreteFromNonLog

include("distributionbag.jl")
using .DistributionCollections: DistributionBag, add!, reset!

using Distributions

N = 10
mu1 = 9
mu2 = 4
v1 = 1
v2 = 1
bq = 1

values = 1:N
dvalues = -N+1:N-1

f1(s1) = pdf(Normal(mu1, v1), s1)
f2(s1, p1) = pdf(Normal(s1, bq), p1)
f3(s2) = pdf(Normal(mu2, v2), s2)
f4(s2, p2) = pdf(Normal(s2, bq), p2)
f5(p1, p2, d) = d == p1 - p2
f6(d) = if d > 0 return 1.0 else 0.0 end

# Aufgabe 3 a)

function joint_proba(s1, s2, p1, p2, d)
    f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
end

function p_s1(s1)
    local sum = 0
    for s2 in values
        for p1 in values
            for p2 in values
                for d in dvalues
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d)
                end
            end
        end
    end
    sum
end

function p_s2(s2)
    local sum = 0
    for s1 in values
        for p1 in values
            for p2 in values
                for d in dvalues
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d)
                end
            end
        end
    end
    sum
end

function p_p1(p1)
    local sum = 0
    for s1 in values
        for s2 in values
            for p2 in values
                for d in dvalues
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d)
                end
            end
        end
    end
    sum
end

function p_p2(p2)
    local sum = 0
    for s1 in values
        for s2 in values
            for p1 in values
                for d in dvalues
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d)
                end
            end
        end
    end
    sum
end

function p_d(d)
    local sum = 0
    for s1 in values
        for s2 in values
            for p1 in values
                for p2 in values
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d)
                end
            end
        end
    end
    sum
end

println()
println("All Marginals without data by summing out:")
marginal_s1 = p_s1.(values)
marginal_s2 = p_s2.(values)
marginal_p1 = p_p1.(values)
marginal_p2 = p_p2.(values)
marginal_d = p_d.(dvalues)

println("s1: $(DiscreteFromNonLog(marginal_s1))")
println("s2: $(DiscreteFromNonLog(marginal_s2))")
println("p1: $(DiscreteFromNonLog(marginal_p1))")
println("p2: $(DiscreteFromNonLog(marginal_p2))")
println("d: $(DiscreteFromNonLog(marginal_d))")

# Aufgabe 3 b)

marginals = DistributionBag(Discrete(N))
for i in 1:4
    add!(marginals)
end

marginal_d = Discrete(2*N-1)

m_f1_S1 = Discrete(N)
m_S1_f1 = Discrete(N)
m_S1_f2 = Discrete(N)
m_f2_S1 = Discrete(N)
m_f2_P1 = Discrete(N)
m_P1_f2 = Discrete(N)
m_P1_f5 = Discrete(N)
m_f5_P1 = Discrete(N)

m_f3_S2 = Discrete(N)
m_S2_f3 = Discrete(N)
m_S2_f4 = Discrete(N)
m_f4_S2 = Discrete(N)
m_f4_P2 = Discrete(N)
m_P2_f4 = Discrete(N)
m_P2_f5 = Discrete(N)
m_f5_P2 = Discrete(N)

m_f5_D = Discrete(2*N-1)
m_D_f5 = Discrete(2*N-1)
m_D_f6 = Discrete(2*N-1)
m_f6_D = Discrete(2*N-1)


# 1
m_f1_S1 = DiscreteFromNonLog(f1.(values))


# 2
m_f3_S2 = DiscreteFromNonLog(f3.(values))

# 3
marginals[1] = m_f1_S1

# 4
marginals[2] = m_f3_S2

# 5
res = zeros(N)
for p1 in 1:N
    for s1 in 1:N
        res[p1] += f2(s1, p1) * ℙ(marginals[1])[s1]
    end
end

m_f2_P1 = DiscreteFromNonLog(res)

# 6
res = zeros(N)
for p2 in 1:N
    for s2 in 1:N
        res[p2] += f4(s2, p2) * ℙ(marginals[2])[s2]
    end
end

m_f4_P2 = DiscreteFromNonLog(res)

# 7
marginals[3] = m_f2_P1 * m_f5_P1

# 8
marginals[4] = m_f4_P2 * m_f5_P2

# 9
m_P1_f5 = marginals[3] / m_f5_P1

# 10
m_P2_f5 = marginals[4] / m_f5_P2

# 11
res = zeros(2*N-1)

for (i, d) in enumerate(dvalues)
    for p1 in 1:N
        for p2 in 1:N
            res[i] += f5(p1, p2, d) * ℙ(m_P1_f5)[p1] * ℙ(m_P2_f5)[p2]
        end
    end
end

m_f5_D = DiscreteFromNonLog(res)


# 12
marginal_d = m_f5_D * m_f6_D

println()
println("All Marginals without data with Sum-Product:")
println("S1: $(marginals[1])")
println("S2: $(marginals[2])")
println("P1: $(marginals[3])")
println("P2: $(marginals[4])")
println("D: $(marginal_d)")

println()


# 13
@show m_f6_D = DiscreteFromNonLog(f6.(dvalues))

# 14
@show marginal_d = m_f5_D * m_f6_D

# 15
println(marginal_d)
println(m_f5_D)
m_D_f5 = marginal_d / m_f5_D