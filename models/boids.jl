using ABM
using Revise
using Distributions
using BenchmarkTools

simstate = SimState()
myschedule = Schedule(simstate)
width = 150
height = 150
neighborhood_distance = 10.0
jump = 0.7

global field = Field2D(width,height,neighborhood_distance/1.5,true)

addfield!(simstate,field)

function fstep(state::SimState, agent::Agent)
    mypos = agent.state.pos #getObjectLocation(field, agent)
    neighborhood = getNeighborsWithinDistance(field, mypos, neighborhood_distance)
    for neighboring in neighborhood
        #println(agent.state.name," ",agent.id," ",neighboring.id)
    end
    agent.state.orientation = mypos
    newpos =  Real2D(rand(Uniform(0, width)),rand(Uniform(0, height)))
    setObjectLocation!(field, agent, newpos)
end

mutable struct BoidData
    name::String
    pos::Real2D
    orientation::Real2D
end

for i in 1:10000
    pos = Real2D(rand(Uniform(0, width)),rand(Uniform(0, height)))
    d = BoidData("Boid", pos, Real2D(rand(Uniform(0, width)),rand(Uniform(0, height))))
    boid = Agent(fstep,d)
    setObjectLocation!(field, boid, pos)
    scheduleRepeating!(myschedule,boid)
end

@time simulate!(myschedule,3)

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
