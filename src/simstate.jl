


struct SimState{T<:Field}
    fields::Vector{T}
end
SimState{T}() where {T<:Field} = SimState(Vector{T}())


function addfield!(simstate::SimState{T},field::T) where {T<:Field}
    push!(simstate.fields,field)
end
