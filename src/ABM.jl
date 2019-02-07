__precompile__()

"""
ABM is a multi agent based simulation engine.
"""
module ABM
using DistributedArrays
using BenchmarkTools
using Compat
using Random
using UUIDs
using DataStructures

export Agent
export Position
export Priority
export Schedule, scheduleOnce!, scheduleRepeating!, step!, simtime
export SimState, simulate!, update!, random
export Float2D, Int2D, Field2D, @field2d


include("priority.jl")
include("agent.jl")
include("field.jl")
include("schedule.jl")
include("simstate.jl")
include("field2d.jl")

#TODO Dev the schedule
#TODO Agent function is bad to pass in the method also the agent other methods?
#TODO Field2D remove matrix and use hash remvoing double buffering
#TODO Field2D include discretization
#TODO Field2D include width and height definition
#TODO FIeld2D include toroidal
#TODO Field2D implement et getNeighbors distances using square and circle


function simulate!(simstate::SimState, nsteps)
    i = 1
    while i <= nsteps
        print(string("[",simstate.schedule.steps,"] "))
        @time step!(simstate.schedule)
        i+=1
    end
end

end # module
