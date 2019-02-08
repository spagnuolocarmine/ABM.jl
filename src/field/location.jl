import Base:  ==, hash
"""
    Location()
The agent location lying on a Field.
"""
mutable struct Location
    pos::Position
    agent::Agent
end


function ==(x::Location, y::Location)
    x.pos==y.pos && x.agent==y.agent
end

function hash(x::Location, h::UInt)
    hash((x.pos, x.agent), h)
end
