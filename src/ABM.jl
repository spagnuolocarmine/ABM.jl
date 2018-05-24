__precompile__()

"""
ABM is a multi agent based simulation engine.
"""
module ABM

using DistributedArrays


include("agent.jl")
include("field.jl")
include("simstate.jl")
include("field2d.jl")

end
