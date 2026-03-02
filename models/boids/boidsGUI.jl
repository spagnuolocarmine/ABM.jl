using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("boid.jl")

using Pkg
Pkg.add("Plots")
using Plots
Pkg.add("PyPlot") # Install a different backend
pyplot() # Switch to using the PyPlot.jl backend




mutable struct BoidsData
    cohesion::Float16
    avoidance::Float16
    randomness::Float16
    consistency::Float16
    momentum::Float16
    deadFlockerProbability::Float16
    neighborhood_distance:: Real
    jump::Float64

    BoidsData() = new(1.0, 1.0, 1.0, 1.0, 1.0,0.1, 10, 0.7)
end

simstate = SimState()
myschedule = Schedule(simstate)
width = 200.0
height = 200.0

global boids = BoidsData()
global field = Field2D(width,height,boids.neighborhood_distance/10,true)


addfield!(simstate,field)

numBoids = 130

for i in 1:numBoids
    pos = Real2D(rand(Uniform(0, width)), rand(Uniform(0, height)))
    d = BoidData(pos)

    if rand() <= boids.deadFlockerProbability
        d.isDead = true
    end

    boid = Agent(fstep,d)
    setObjectLocation!(field, boid, pos)
    #if i == 1
        scheduleRepeating!(myschedule,boid)
    #end
end



using Profile

using Juno
Profile.init(delay=0.0005, n = 10^7)

Profile.clear()

function simulateGraphics!(schedule::Schedule, nsteps::Int64)
    mp4(@animate(for i = 1:nsteps
        println("[",schedule.steps,"] time: ",schedule.time)

        field = schedule.simstate.fields[length(schedule.simstate.fields)]
        points = collect(getAllObjects(field))

        x = []
        y = []

        deadx = []
        deady = []
        for j = 1:length(points)

            push!(x, points[j].x)
            push!(y, points[j].y)

            dict = field.f[points[j]]
            agent = collect(keys(dict))

            if agent[1].state.isDead == true
                push!(deadx, points[j].x)
                push!(deady, points[j].y)
            end
        end

        scatter(x, y, color = :red,
         markersize = 6, legend = false,
         xlims = (0, width), ylim = (0, height), size = (800, 800))

         scatter!(deadx, deady, color = :black,
          markersize = 6, legend = false,
          xlims = (0, width), ylim = (0, height), size = (800, 800))

        step!(schedule)

    end), "boids.mp4", fps = 30)
end

@time  simulateGraphics!(myschedule,900);
