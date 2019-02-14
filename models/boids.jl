using Distributions
using BenchmarkTools
#using Revise #needs to be loaded before the module that needs to be tracked
using ABM


struct BoidData
    name::String
    pos::Real2D{Float64}
    orientation::Real2D{Float64}
end

const simstate = SimState{Field2D{Float64,Float64,BoidData,Nothing}}()
const myschedule = Schedule(simstate)
const width = 150.0
const height = 150.0
const neighborhood_distance = 10.0
const jump = 0.7


const field = Field2D{Float64,Float64,BoidData,Nothing}(width,height,neighborhood_distance/1.5,true)

addfield!(simstate,field)


function fstep(state::SimState{Field2D{Float64,Float64,BoidData,Nothing}}, agent::Agent{BoidData})
    mypos = agent.state.pos #getObjectLocation(field, agent)
    neighborhood = getNeighborsWithinDistance(field, mypos, neighborhood_distance)
    for neighboring in neighborhood
        #println(agent.state.name," ",agent.id," ",neighboring.id)
    end
    agent.state.orientation.x = mypos.x
    agent.state.orientation.y = mypos.y
    newpos =  Real2D(rand(Uniform(0, width)),rand(Uniform(0, height)))
    setObjectLocation!(field, agent, newpos)
end


for i in 1:10000
    pos = Real2D(rand(Uniform(0, width)),rand(Uniform(0, height)))
    d = BoidData("Boid", pos, Real2D(rand(Uniform(0, width)),rand(Uniform(0, height))))
    boid = Agent(fstep,d)
    setObjectLocation!(field, boid, pos)
    scheduleRepeating!(myschedule,boid)
end

simulate!(myschedule,1)

@time simulate!(myschedule,10)

using Profile
using ProfileView
using Juno
Profile.init(delay=0.0005)
Profile.clear()
Profile.@profile simulate!(myschedule,7);
ProfileView.view()
Juno.@profiler simulate!(myschedule,7);

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
