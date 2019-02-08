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


export Position
export Location
export Priority
export Agent
export Field, tx, ty
export Float2D, Int2D, toroidal, distance
export Field2D, setObjectLocation!, getObjectLocation, getObjectsAtLocation, getAllObjects, numObjectsAtLocation, remove!, clear!, swapState!
export Schedule, scheduleOnce!, scheduleRepeating!, step!, simtime
export SimState, simulate!, update!, random


include("priority.jl")
include("agent.jl")
include("field/position.jl")
include("field/location.jl")
include("field/int2d.jl")
include("field/float2d.jl")
include("field/field.jl")
include("field/field2d.jl")
include("schedule.jl")
include("simstate.jl")

#TODO Dev the schedule
#TODO Agent function is bad to pass in the method also the agent other methods?
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
