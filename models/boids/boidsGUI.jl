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


#@time simulate!(myschedule,10)

using Profile
#using ProfileView
using Juno
Profile.init(delay=0.0005, n = 10^7)

Profile.clear()
# @time Profile.@profile simulate!(myschedule,10);
# Juno.profiler()

# @time step!(myschedule)
# println("size ",length(field.fO))
# @time step!(myschedule)
# println("size ",length(field.fO))
# @time step!(myschedule)
# println("size ",length(field.fO))
#

function simulateGraphics!(schedule::Schedule, nsteps::Int64)
    for i = 1:nsteps
        println("[",schedule.steps,"] time: ",schedule.time)

        field = schedule.simstate.fields[length(schedule.simstate.fields)]
        points = collect(getAllObjects(field))
        #println("fino a qua ci arrivo")
        x = []
        #println("pure qua ci arrivo")
        y = []
        #println("sono quasi al for")
        for j = 1:length(points)
            push!(x, points[j].x)
            push!(y, points[j].y)
        end

        for k = 1:length(x)
            # println("sono uscito: $(x[k]) e $(y[k])")
        end


        scatter(x, y, shape = :rtriangle, color = :black,
         xlims = (0, width), ylim = (0, height), size = (800, 800))

         gui()

        #println("ho anche stampato")

        step!(schedule)

        #println("step complet")
    end
end

@time  simulateGraphics!(myschedule,400);













"""@time while myschedule.steps < 3
    println("[",myschedule.steps,"] time: ",myschedule.time)
    @time step!(myschedule)
    #Swap the fields status to the new one A = B
    @time for field in myschedule.simstate.fields
        swapState!(field)
    end
end"""


"""
function consistency(neighborhood::Vector{Union{Agent,Patch}})
    if length(neighborhood) == 0 return Real2D(0,0) end
    x = 0
    y = 0
    count = 0
    for neighboring in neighborhood
        count++
        x += neighboring.state.orientation.x
        y += neighboring.state.orientation.y
    end
    if count > 0
        x /= count
        y /= count
    end
    return Real2D(x,y)
end

function cohesion(boid::Agent, neighborhood::Vector{Union{Agent,Patch}})
    if length(neighborhood) == 0 return Real2D(0,0) end
    x = 0
    y = 0
    count = 0
    for neighboring in neighborhood
        count++
        tpos = toroidal(boid.state.pos, field.width, field.height)
        ntpos = toroidal(neighboring.state.pos, field.width, field.height)
        x += dx;
                y += dy;
    end
    if count > 0
        x /= count
        y /= count
    end
    return Real2D(-x/10.0,-y/10.0)
end"""
