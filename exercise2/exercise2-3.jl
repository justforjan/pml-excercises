include("discrete.jl") 
using .DiscreteDistribution: Discrete, ℙ, *, /, logsumexp, DiscreteFromNonLog

include("distributionbag.jl")
using .DistributionCollections: DistributionBag, add!, reset!

using Distributions

N = 5
mu1 = 8
mu2 = 12
v1 = 2
v2 = 2
bq = 3

values = 1:N

f1(s1) = pdf(Normal(mu1, v1), s1)
f2(s1, p1) = pdf(Normal(s1, bq), p1)
f3(s2) = pdf(Normal(mu2, v2), s2)
f4(s2, p2) = pdf(Normal(s2, bq), p2)
f5(p1, p2, d) = d == p1 - p2
f6(d) = d >= 0

# Aufgabe 3 a)

function joint_proba(s1, s2, p1, p2, d)
    f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
end

function p_s1(s1)
    local sum = 0
    for s2 in values
        for p1 in values
            for p2 in values
                for d in -N:N
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
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
                for d in -N:N
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
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
                for d in -N:N
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
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
                for d in -N:N
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
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
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d) * f6(d)
                end
            end
        end
    end
    sum
end

marginal_s1 = p_s1.(values)
marginal_s2 = p_s2.(values)
marginal_p1 = p_p1.(values)
marginal_p2 = p_p2.(values)
marginal_d = p_d.(-N:N)

println(DiscreteFromNonLog(marginal_s1))
println(DiscreteFromNonLog(marginal_s2))
println(DiscreteFromNonLog(marginal_p1))
println(DiscreteFromNonLog(marginal_p2))
println(DiscreteFromNonLog(marginal_d))

# Aufgabe 3 b)

marginals = DistributionBag(Discrete(N))
for i in 1:5
    add!(marginals)
end

# messages = DistributionBag(Discrete(N))

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

m_f5_D = Discrete(N)
m_D_f5 = Discrete(N)
m_D_f6 = Discrete(N)
m_f6_D = Discrete(N)


# 1
m_f1_S1 = m_f1_S1 * DiscreteFromNonLog(f1(values))

# 2
m_f3_S2 *= DiscreteFromNonLog(f3(values))

# 3
marginals[1] = m_f1_S1 * m_f2_S1

# 4
marginals[2] = m_f3_S2 * m_f4_S2

# 5
m_f2_P1 = begin
    local sum = zeros(N)
    for s1 in values
        sum += f2(s1, values)
    end
    DiscreteFromNonLog(sum) * marginals[1]
end

# 6
m_f4_P2 = begin
    local sum = zeros(N)
    for s2 in values
        sum += f2(s2, values)
    end
    DiscreteFromNonLog(sum) * marginals[2]
end

# 7
marginals[3] = m_f2_P1 * m_f5_P1

# 8
marginals[4] = m_f4_P2 * m_f5_P2

# 9
m_P1_f5 = marginals[5] / m_f5_P1

# 10
m_P2_f5 = marginals[5] / m_f5_P2

# 11
# m_f5_D = begin
#     local values2N = -N:N
#     local sum = zeros(2)

#     for p1 in values
#         for p2 in values
#            f5(p1, p2, values2N)
#         end
#     end
# end
