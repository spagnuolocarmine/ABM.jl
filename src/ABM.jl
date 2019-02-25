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
using Distributions
using UUIDs
using DataStructures
using LightGraphs
using DistributedArrays

export Agent
export Patch

export Position
export Real2D,
        toroidal, distance


export Location
export Field
export Field2D,
        setObjectLocation!,
        getObjectLocation, getObjectsAtLocation, getNeighborsWithinDistance, getAllObjects,
        numObjectsAtLocation,
        remove!, clean!
export Network
export Bounds,
        checkBoundCircle

export Priority
export Schedule,
        scheduleOnce!, scheduleRepeating!,
        stop!,step!

export SimState,
        addfield!, update!, random

export simulate! #, @simulate


include("priority.jl")
include("agent.jl")
include("patch.jl")
include("field/position.jl")
include("field/location.jl")

include("field/real2d.jl")
include("field/field.jl")
include("field/field2d.jl")
include("field/bounds.jl")
include("simstate.jl")
include("schedule.jl")


#TODO Add to schedule the interval for scheduling
#TODO Agent function is bad to pass in the method also the agent other methods?
#TODO More test for schedule and field2d

function simulate!(schedule::Schedule, nsteps::Int64)
    while schedule.steps < nsteps
        println("[",schedule.steps,"] time: ",schedule.time)
        step!(schedule)

    end
end

end # module
