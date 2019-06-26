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

addfield!(simstate,field)

mutable struct AntData
    name::String
    pos::Real2D
    reward::Float64
    hasFoodItem::Bool

end


function depositPheromone()
    if hasFoodItem
        max =
    else

    end
end
