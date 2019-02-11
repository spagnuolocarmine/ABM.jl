__precompile__()

"""
ABM is a multi agent based simulation engine.

Motivations:
- Julia allow easily to parallelize the code also at simulation code.
- MASON does not provide double buffering for agents memories and positions.
- Julia provides lots of libraries for scientific computing.
- Julia data visualization.
"""
module ABM
using Distributed
using BenchmarkTools
using Compat
using Random
using UUIDs
using DataStructures
using LightGraphs

export Agent,
        stop!
export Position
export Location
export Field
export Real2D, Int2D,
        toroidal, distance
export Field2D,
        setObjectLocation!,
        getObjectLocation, getObjectsAtLocation, getNeighborsExactlyWithinDistance, getAllObjects,
        numObjectsAtLocation,
        remove!, clear!, swapState!
export Network
export Priority
export Schedule,
        scheduleOnce!, scheduleRepeating!,
        step!
export SimState,
        simulate!, update!, random


include("priority.jl")
include("agent.jl")
include("field/position.jl")
include("field/location.jl")
include("field/int2d.jl")
include("field/real2d.jl")
include("field/field.jl")
include("field/field2d.jl")
include("schedule.jl")
include("simstate.jl")

#TODO Add to schedule the interval for scheduling
#TODO Agent function is bad to pass in the method also the agent other methods?
#TODO Field2D implement et getNeighbors distances using square and circle
#TODO More test for schedule and field2d


function simulate!(simstate::SimState, nsteps)
    i = 1
    while i <= nsteps
        print(string("[",simstate.schedule.steps,"] "))
        @time step!(simstate.schedule)
        i+=1
    end
end

end # module
