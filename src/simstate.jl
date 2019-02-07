

rng = MersenneTwister(1234);

function random()
    rng
end

mutable struct SimState
    schedule::Schedule
    fields::Vector{Field}
    addField::Function
end


function addfiled!(simstate::SimState,field::Field)
    push!(simstate.fields,field)
end
