include("discrete.jl") 
using .DiscreteDistribution: Discrete, ℙ, *, /, logsumexp, DiscreteFromNonLog

include("distributionbag.jl")
using .DistributionCollections: DistributionBag, add!, reset!

using Distributions

N = 20
mu1 = 8
mu2 = 12
v1 = 2
v2 = 2
bq = 3

println("N = $(N)")
println("μ1 = $(mu1)")
println("μ2 = $(mu2)")
println("v1 = $(v1)")
println("v2 = $(v2)")
println("β^2 = $(bq)")

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
marginal_s1_a = DiscreteFromNonLog(p_s1.(values))
marginal_s2_a = DiscreteFromNonLog(p_s2.(values))
marginal_p1_a = DiscreteFromNonLog(p_p1.(values))
marginal_p2_a = DiscreteFromNonLog(p_p2.(values))
marginal_d_a = DiscreteFromNonLog(p_d.(dvalues))

println("s1: $(marginal_s1_a)")
println("s2: $marginal_s2_a)")
println("p1: $(marginal_p1_a)")
println("p2: $(marginal_p2_a)")
println("d: $(marginal_d_a)")



start_sum = time()

function p_s1(s1)
    local sum = 0
    for s2 in values
        for p1 in values
            for p2 in values
                for d in dvalues
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
                for d in dvalues
                    sum += f1(s1) * f2(s1, p1) * f3(s2) * f4(s2, p2) * f5(p1, p2, d)  * f6(d)
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
                for d in dvalues
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

println()
println("All Marginals *with* data by summing out:")
marginal_s1_b = DiscreteFromNonLog(p_s1.(values))
marginal_s2_b = DiscreteFromNonLog(p_s2.(values))
marginal_p1_b = DiscreteFromNonLog(p_p1.(values))
marginal_p2_b = DiscreteFromNonLog(p_p2.(values))
marginal_d_b = DiscreteFromNonLog(p_d.(dvalues))

end_sum = time()

println("s1: $(marginal_s1_b)")
println("s2: $marginal_s2_b)")
println("p1: $(marginal_p1_b)")
println("p2: $(marginal_p2_b)")
println("d: $(marginal_d_b)")

# Plot S1
bar(ℙ(marginal_s1_a), alpha=0.5, title="S1", label="Ohne Daten")
bar!(ℙ(marginal_s1_b), alpha=0.5, color=:red, label="Mit Daten")

savefig("exercise2/s1.png")

bar(ℙ(marginal_s2_a), alpha=0.5, title="S2", label="Ohne Daten")
bar!(ℙ(marginal_s2_b), alpha=0.5, color=:red, label="Mit Daten")

savefig("exercise2/s2.png")

bar(ℙ(marginal_p1_a), alpha=0.5, title="P1", label="Ohne Daten")
bar!(ℙ(marginal_p1_b), alpha=0.5, color=:red, label="Mit Daten")

savefig("exercise2/p1.png")

bar(ℙ(marginal_p2_a), alpha=0.5, title="P2", label="Ohne Daten")
bar!(ℙ(marginal_p2_b), alpha=0.5, color=:red, label="Mit Daten")

savefig("exercise2/p2.png")

bar(ℙ(marginal_d_a), alpha=0.5, title="D", label="Ohne Daten")
bar!(ℙ(marginal_d_b), alpha=0.5, color=:red, label="Mit Daten")

savefig("exercise2/d.png")

println()
println("----------------------------------------------------------------------------------------------------------------------------------------------------------------")

# Aufgabe 3 b)

marginals = DistributionBag(Discrete(N))
for i in 1:4
    add!(marginals)
end

marginal_d = Discrete(length(dvalues))

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

m_f5_D = Discrete(length(dvalues))
m_D_f5 = Discrete(length(dvalues))
m_D_f6 = Discrete(length(dvalues))
m_f6_D = Discrete(length(dvalues))

start_sumprod = time()

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


# 13
m_f6_D = DiscreteFromNonLog(f6.(dvalues))

# 14
marginal_d = m_f5_D * m_f6_D

# 15
m_D_f5 = marginal_d / m_f5_D

# println(m_D_f5)
# println(marginal_d)
# println(m_f5_D)

# 16
res = zeros(N)

for p1 in values
    for (di, d) in enumerate(dvalues)
        for p2 in values
            res[p1] += f5(p1, p2, d) * ℙ(m_D_f5)[di] * ℙ(m_P2_f5)[p2]
        end
    end
end

m_f5_P1 = DiscreteFromNonLog(res)   

# 17
res = zeros(N)
for p2 in values
    for (di, d) in enumerate(dvalues)
        for p1 in values
            res[p2] += f5(p1, p2, d) * ℙ(m_D_f5)[di] * ℙ(m_P1_f5)[p1]
        end
    end
end
m_f5_P2 = DiscreteFromNonLog(res)

# 18
marginals[3] = m_f2_P1 * m_f5_P1

# 19
marginals[4] = m_f4_P2 * m_f5_P2

# 20
res = zeros(N)
for s1 in values
    for p1 in values
        res[s1] += f2(s1, p1) * ℙ(marginals[3] / m_f2_P1)[p1]
    end
end
m_f2_S1 = DiscreteFromNonLog(res)

# 21
res = zeros(N)
for s2 in values
    for p2 in values
        res[s2] += f2(s2, p2) * ℙ(marginals[4] / m_f4_P2)[p2]
    end
end
m_f4_S2 = DiscreteFromNonLog(res)

# 22
marginals[1] = m_f1_S1 * m_f2_S1

# 23
marginals[2] = m_f3_S2 * m_f4_S2

end_sumprod = time()

println()
println("All Marginals *with* data with Sum-Product:")
println("S1: $(marginals[1])")
println("S2: $(marginals[2])")
println("P1: $(marginals[3])")
println("P2: $(marginals[4])")
println("D: $(marginal_d)")

println("------------------------------------------------------------------------------------")

println(end_sum - start_sum)
println(end_sumprod - start_sumprod)
println((end_sum - start_sum) / (end_sumprod - start_sumprod))


