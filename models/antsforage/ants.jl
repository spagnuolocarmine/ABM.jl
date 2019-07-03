using ABM
using Revise
using Distributions
using BenchmarkTools

simstate = SimState()
myschedule = Schedule(simstate)
width = 150.0
height = 150.0
neighborhood_distance = 0

global field = Field2D(width,height,neighborhood_distance/1.5,true)

global const HOME = 1
global const FOOD =2

setObjectLocation!(field, Agent(nothing, nothing), pos)


addfield!(simstate,field)

function depositPheromone(state::SimState)
    if hasFoodItem
        max =
    else
        #body
    end

    reward = 0.0
end

function act()
    #body
end


function fstep(state::SimState, agent::Agent)
    depositPheromone(state)
    act(state)
end


mutable struct AntData
    name::String
    pos::Real2D
    reward::Float64
    hasFoodItem::Bool

end

for i in 1:10000
    initialReward = 0.0
    pos = Real2D(rand(Uniform(0, width)), rand(Uniform(0, height)))
    a = AntData("Ant", pos, initialReward, false)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    #if i == 1
        scheduleRepeating!(myschedule,ant)
    #end
end

@time  simulate!(myschedule,10);
