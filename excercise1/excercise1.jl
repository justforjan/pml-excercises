using StatsPlots, Distributions

numberOfSimulations = 50
alpha = 1
beta = 1

dir = @__DIR__

prior = Beta(alpha, beta)
bernoulli = Bernoulli(0.7)

data = rand(Binomial(1, 0.7), numberOfSimulations)

sample1 = data[1]
posterior1 = Beta(alpha + sample1, beta + 1 - sample1)

sample5 = sum(data[1:5])
posterior5 = Beta(alpha + sample5, beta + 5 - sample5)

sample50 = sum(data)
posterior50 = Beta(alpha + sample50, beta + 50 - sample50)


plot(prior, label="prior", legend=:topleft)
plot!(posterior50, label="50 ($(data[1:5]))")
plot!(posterior5, label="5 ($(data[1:5]))")
plot!(posterior1, label="1 ($(data[1]))")

vspan!([0.69, 0.71]; alpha = 0.5, label = "true θ", color="green")

savefig(joinpath(dir, "4c.png"))

alpha = 2
beta = 2

prior = Beta(alpha, beta)

sample1 = data[1]
posterior1 = Beta(alpha + sample1, beta + 1 - sample1)

sample5 = sum(data[1:5])
posterior5 = Beta(alpha + sample5, beta + 5 - sample5)

sample50 = sum(data)
posterior50 = Beta(alpha + sample50, beta + 50 - sample50)

plot(prior, label="prior", legend=:topleft)
plot!(posterior50, label="50 ($(data[1:5]))")
plot!(posterior5, label="5 ($(data[1:5]))")
plot!(posterior1, label="1 ($(data[1]))")

vspan!([0.69, 0.71]; alpha = 0.5, label = "true θ", color="green")

savefig(joinpath(dir, "4d.png"))















