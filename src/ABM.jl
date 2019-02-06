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


include("agent.jl")
include("field.jl")
include("schedule.jl")
include("simstate.jl")
include("field2d.jl")

#TODO Impelmente the schedule
#TODO Agent function is bad to pass in the method also the agent other methods?
#TODO Field2D remove matrix and use hash
#TODO Field2D include discretization
#TODO Field2D include width and height definition
#TODO FIeld2D include toroidal
#TODO Field2D implement get getNeighbors distances using square and circle
#TODO Schedule include EventSimulation.jl

end # module
