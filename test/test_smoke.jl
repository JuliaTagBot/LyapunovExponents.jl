using Base.Test
using Plots
using OnlineStats: CovMatrix
using LyapunovExponents
using LyapunovExponents: VecVariance, CLVSolver
using LyapunovExponents: CovariantVectors
using LyapunovExponents.Test: @test_nothrow

@time @testset "Smoke test CLV" begin
    @test_nothrow begin
        prob = LyapunovExponents.lorenz_63(num_attr=3).prob :: LEProblem
        solver = CovariantVectors.CLVSolver(prob)
        solve!(solver)
    end
    @test_nothrow begin
        demo = LyapunovExponents.lorenz_63(num_attr=3)
        solver = CLVSolver(demo)
        solve!(solver)
    end
end

@time @testset "Smoke test demo" begin
    @test begin
        demo = solve!(LyapunovExponents.lorenz_63(num_attr=3))
        plot(demo, show = false)
        true
    end
    @test begin
        demo = solve!(LyapunovExponents.lorenz_63(num_attr=3, dim_lyap=1))
        plot(demo, show = false)
        true
    end
    @testset "main_stat = $ST" for ST in [VecVariance, CovMatrix]
        demo = LyapunovExponents.lorenz_63(num_attr=3)
        @test_nothrow solve!(demo; main_stat = ST)
        @test isa(demo.solver.solver.main_stat, ST)
        @test_nothrow plot(demo, show = false)
    end
end
