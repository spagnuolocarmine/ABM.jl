using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("boid.jl")

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
global field = Field2D(width,height,boids.neighborhood_distance/1.5,true)


addfield!(simstate,field)

numBoids = 100
step = 1000

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


#@time simulate!(myschedule,10)

using Profile

Profile.init(delay=0.0005, n = 10^7)

Profile.clear()

@profile  simulate!(myschedule,step);
output1 = @timed  simulate!(myschedule,step);
output2 = @timed  simulate!(myschedule,step);
time1 = output1[2];
time2 = output2[2];

println("time1: $time1, step/s: $(step/time1)");
println("time2: $time2, step/s: $(step/time2)");
