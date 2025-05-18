using Distributions, Plots

μ1 = -3
μ2 = 7
σ1 = 2
σ2 = 2

x = -25:0.01:25

N1 = Normal(μ1, σ1^2)
N2 = Normal(μ2, σ2^2)
Nmult = Normal((μ1 * σ2^2 + μ2 * σ1^2)/(σ1^2 + σ2^2), σ1^2 * σ2^2 / (σ1^2 + σ2^2))


v1 = pdf(N1, x)
v2 = pdf(N2, x)
vmult = pdf(Nmult, x)



nrOfSamples = 10000

s1 = rand(N1, nrOfSamples)
s2 = rand(N2, nrOfSamples)
smult = rand(Nmult, nrOfSamples)

histogram(s1, normalize=:pdf, color=:red, alpha=0.3)
histogram!(s2, normalize=:pdf, color=:blue, alpha=0.3)
histogram!(smult, normalize=:pdf, color=:green, alpha=0.3)

plot!(x, v1, color=:red)
plot!(x, v2, color=:blue)
plot!(x, vmult, color=:green)

savefig("./exercise2/1a.png")

