import Base:  ==, hash
"""
    Location()
The Agent or Patch location lying on a Field.
"""
mutable struct Location{P<:Position}
    pos::P
    object::Union{Agent,Patch}
end


function ==(x::Location{P}, y::Location{P}) where {P<:Position}
    x.pos==y.pos && x.object==y.object
end

function hash(x::Location{P}, h::UInt) where {P<:Position}
    hash((x.pos, x.object), h)
end
