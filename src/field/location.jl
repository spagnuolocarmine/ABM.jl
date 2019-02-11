import Base:  ==, hash
"""
    Location()
The Agent or Patch location lying on a Field.
"""
mutable struct Location
    pos::Position
    object::Union{Agent,Patch}
end


function ==(x::Location, y::Location)
    x.pos==y.pos && x.object==y.object
end

function hash(x::Location, h::UInt)
    hash((x.pos, x.object), h)
end
