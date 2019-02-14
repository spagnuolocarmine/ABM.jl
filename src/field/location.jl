import Base:  ==, hash
"""
    Location()
The Agent or Patch location lying on a Field.
"""
mutable struct Location{P<:Position, A}
    pos::P
    object::Union{Agent{A},Patch{A}}
end


function ==(x::Location{P,A1}, y::Location{P,A2}) where {P<:Position,A1,A2}
    x.pos==y.pos && x.object==y.object
end

function hash(x::Location{P,A}, h::UInt) where {P<:Position,A}
    hash((x.pos, x.object), h)
end
