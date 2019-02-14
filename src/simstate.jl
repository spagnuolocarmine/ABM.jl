"""
    SimState
"""
mutable struct SimState
    fields::Vector{Field}
end
SimState() = SimState(Vector{Field}())


function addfield!(simstate::SimState,field::Field)
    push!(simstate.fields,field)
end
