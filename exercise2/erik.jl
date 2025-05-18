using Plots

main() = begin
    mult(v1,v2,n) = begin
        v = Vector{Float64}(undef, n)
        for i in 1:n
            v[i] = v1[i]*v2[i]
        end
        v
    end

    multNorm(v1,v2,n) = begin
        v = Vector{Float64}(undef, n)
        sum = 0
        for i in 1:n
            v[i] = v1[i]*v2[i]
            sum += v[i]
        end
        for i in 1:n
            v[i] /= sum
        end
        v
    end

    divNorm(v1,v2,n) = begin
        v = Vector{Float64}(undef, n)
        sum = 0
        for i in 1:n
            v[i] = v1[i]/v2[i]
            sum += v[i]
        end
        for i in 1:n
            v[i] /= sum
        end
        v
    end

    N = 20
    μ_1 = 8
    μ_2 = 12
    σ2_1 = 2
    σ2_2 = 2
    β2 = 3

    f1(s1) = (2*pi*σ2_1)^(-1/2)*exp(-1/(2*σ2_1)*(s1-μ_1)^2)
    f2(s1,p1) = (2*pi*β2)^(-1/2)*exp(-1/(2*β2)*(p1-s1)^2)
    f3(s2) = (2*pi*σ2_2)^(-1/2)*exp(-1/(2*σ2_2)*(s2-μ_2)^2)
    f4(s2,p2) = (2*pi*β2)^(-1/2)*exp(-1/(2*β2)*(p2-s2)^2)
    f5(p1,p2,d) = d==p1-p2
    f6(d) = d>0

    discrete_f1 = begin
        v = Vector{Float64}(undef, N)
        for i in 1:N
            v[i] = f1(i)
        end
        v
    end
    discrete_f3 = begin
        v = Vector{Float64}(undef, N)
        for i in 1:N
            v[i] = f3(i)
        end
        v
    end
    discrete_f6 = begin
        v = Vector{Float64}(undef, N)
        for i in 1:N
            v[i] = 1/N
        end
        v
    end
    discrete_uniform = begin
        v = Vector{Float64}(undef, N)
        for i in 1:N
            v[i] = 1/N
        end
        v
    end

    p(s1,s2,p1,p2,d) = f1(s1) * f2(s1,p1) * f3(s2) * f4(s2,p2) * f5(p1,p2,d) * f6(d)

    t1 = time()
    pa_s1 = begin
        v = Vector{Float64}(undef, N)
        for s1 in 1:N
            sum = 0.0
            for s2 in 1:N
                for p1 in 1:N
                    for p2 in 1:N
                        for d in -N:N
                            sum += p(s1,s2,p1,p2,d)
                        end
                    end
                end
            end
            v[s1] = sum
        end
        multNorm(v, discrete_uniform, N)
    end

    pa_s2 = begin
        v = Vector{Float64}(undef, N)
        for s2 in 1:N
            sum = 0.0
            for s1 in 1:N
                for p1 in 1:N
                    for p2 in 1:N
                        for d in -N:N
                            sum += p(s1,s2,p1,p2,d)
                        end
                    end
                end
            end
            v[s2] = sum
        end
        multNorm(v, discrete_uniform, N)
    end

    pa_p1 = begin
        v = Vector{Float64}(undef, N)
        for p1 in 1:N
            sum = 0.0
            for s1 in 1:N
                for s2 in 1:N
                    for p2 in 1:N
                        for d in -N:N
                            sum += p(s1,s2,p1,p2,d)
                        end
                    end
                end
            end
            v[p1] = sum
        end
        multNorm(v, discrete_uniform, N)
    end

    pa_p2 = begin
        v = Vector{Float64}(undef, N)
        for p2 in 1:N
            sum = 0.0
            for s1 in 1:N
                for s2 in 1:N
                    for p1 in 1:N
                        for d in -N:N
                            sum += p(s1,s2,p1,p2,d)
                        end
                    end
                end
            end
            v[p2] = sum
        end
        multNorm(v, discrete_uniform, N)
    end

    pa_d = begin
        v = Vector{Float64}(undef, N)
        for d in 1:N
            sum = 0.0
            for s1 in 1:N
                for s2 in 1:N
                    for p1 in 1:N
                        for p2 in 1:N
                            sum += p(s1,s2,p1,p2,d)
                        end
                    end
                end
            end
            v[d] = sum
        end
        multNorm(v, discrete_uniform, N)
    end

    p1_wins() = begin
        sum_won = 0.0
        sum_lost = 0.0
        for i in 1:N
            sum_won += p_d(i)
        end
        for i in -N:0
            sum_lost += p_d(i)
        end
        sum_won
    end
    t2 = time()

    t3 = time()
    m_f1_S1 = discrete_f1
    m_f3_S2 = discrete_f3

    pb_s1 = multNorm(m_f1_S1, discrete_uniform, N)
    pb_s2 = multNorm(m_f3_S2, discrete_uniform, N)
    # m_f2_P1 = begin
    #     v = Vector{Float64}(undef, N)
    #     for p1 in 1:N
    #         sum = 0.0
    #         for s1 in 1:N
    #             sum += f2(s1, p1)
    #         end
    #         v[p1] = sum
    #     end
    #     multNorm(v, pb_s1, N)
    # end
    m_f2_P1 = begin
        v = Vector{Float64}(undef, N)
        for p1 in 1:N
            sum = 0.0
            for s1 in 1:N
                sum += f2(s1, p1) * pb_s1[s1]
            end
            v[p1] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    # m_f4_P2 = begin
    #     v = Vector{Float64}(undef, N)
    #     for p2 in 1:N
    #         sum = 0.0
    #         for s2 in 1:N
    #             sum += f4(s2, p2)
    #         end
    #         v[p2] = sum
    #     end
    #     multNorm(v, pb_s2, N)
    # end
    m_f4_P2 = begin
        v = Vector{Float64}(undef, N)
        for p2 in 1:N
            sum = 0.0
            for s2 in 1:N
                sum += f4(s2, p2) * pb_s2[s2]
            end
            v[p2] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    pb_p1 = m_f2_P1
    pb_p2 = m_f4_P2
    m_P1_f5 = pb_p1
    m_P2_f5 = pb_p2
    # m_f5_d = begin
    #     v = Vector{Float64}(undef, N)
    #     for d in 1:N
    #         sum = 0.0
    #         for p1 in 1:N
    #             for p2 in 1:N
    #                 sum += f5(p1,p2, d)
    #             end
    #         end
    #         v[d] = sum
    #     end
    #     multNorm(v, multNorm(m_P1_f5, m_P2_f5, N), N)
    # end
    m_f5_d = begin
        v = Vector{Float64}(undef, N)
        for d in 1:N
            sum = 0.0
            for p1 in 1:N
                for p2 in 1:N
                    sum += f5(p1,p2, d) * m_P1_f5[p1] * m_P2_f5[p2]
                end
            end
            v[d] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    pb_d = m_f5_d
    m_f6_d = begin
        v = Vector{Float64}(undef, N)
        for d in 1:N
            v[d] = f6(d)
        end
        multNorm(v, discrete_uniform, N)
    end
    pb_d = multNorm(m_f5_d, m_f6_d, N)
    m_d_f5 = discrete_uniform # ????
    # m_f5_P1 = begin
    #     v = Vector{Float64}(undef, N)
    #     for p1 in 1:N
    #         sum = 0.0
    #         for d in 1:N
    #             for p2 in 1:N
    #                 sum += f5(p1, p2, d)
    #             end
    #         end
    #         v[p1] = sum
    #     end
    #     multNorm(v, multNorm(m_d_f5, m_P2_f5, N), N)
    # end
    m_f5_P1 = begin
        v = Vector{Float64}(undef, N)
        for p1 in 1:N
            sum = 0.0
            for d in 1:N
                for p2 in 1:N
                    sum += f5(p1, p2, d) * m_d_f5[d] * m_P2_f5[p2]
                end
            end
            v[p1] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    # m_f5_P2 = begin
    #     v = Vector{Float64}(undef, N)
    #     for p2 in 1:N
    #         sum = 0.0
    #         for d in 1:N
    #             for p1 in 1:N
    #                 sum += f5(p1, p2, d)
    #             end
    #         end
    #         v[p2] = sum
    #     end
    #     multNorm(v, multNorm(m_d_f5, m_P1_f5, N), N)
    # end
    m_f5_P2 = begin
        v = Vector{Float64}(undef, N)
        for p2 in 1:N
            sum = 0.0
            for d in 1:N
                for p1 in 1:N
                    sum += f5(p1, p2, d) * m_d_f5[d] * m_P1_f5[p1]
                end
            end
            v[p2] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    pb_p1 = multNorm(m_f2_P1, m_f5_P1, N)
    pb_p2 = multNorm(m_f4_P2, m_f5_P2, N)
    m_f2_S1 = begin
        v = Vector{Float64}(undef, N)
        for s1 in 1:N
            sum = 0.0
            for p1 in 1:N
                sum += f2(s1,p1) * pb_p1[p1] / m_f2_P1[p1]
            end
            v[s1] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    m_f4_S2 = begin
        v = Vector{Float64}(undef, N)
        for s2 in 1:N
            sum = 0.0
            for p2 in 1:N
                sum += f4(s2,p2) * pb_p2[p2] / m_f4_P2[p2]
            end
            v[s2] = sum
        end
        multNorm(v, discrete_uniform, N)
    end
    # bar(pb_s1, alpha=0.5)
    # plot!(pb_s1)
    pb_s1 = multNorm(m_f1_S1, m_f2_S1, N)
    pb_s2 = multNorm(m_f3_S2, m_f4_S2, N)
    t4 = time()
    # bar!(pb_s1, alpha=0.5)
    # plot!(pb_s1)
    println(t2-t1)
    println(t4-t3)
    println((t2-t1)/(t4-t3))
end

main()