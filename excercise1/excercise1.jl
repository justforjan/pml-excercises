using StatsPlots, Distributions

numberOfSimulations = 50
alpha = 2
beta = 2

prior = Beta(alpha, beta)
bernoulli = Bernoulli(0.7)
OurBinominal(n) = Binomial(n, 0.7)

sample50 = rand(OurBinominal(50))
posterior50 = Beta(alpha + sample50, beta + 50 - sample50)

sample5 = rand(OurBinominal(5))
posterior5 = Beta(alpha + sample5, beta + 5 - sample5)

sample1 = rand(OurBinominal(1))
posterior1 = Beta(alpha + sample1, beta + 1 - sample1)

println(posterior)

plot(prior, label="prior")
plot!(posterior50, label="50")
plot!(posterior5, label="5")
plot!(posterior1, label="1")

vspan!([0.69, 0.71]; alpha = 0.5, label = "true θ", color="green")

# savefig("Aufgage 4d")













