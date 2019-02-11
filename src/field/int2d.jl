import Base:  ==, hash
#Position on a 2D space with integer coordinate system
struct Int2D <: Position
    x::Integer
    y::Integer
end

function ==(p1::Int2D, p2::Int2D)
    p1.x==p2.x && p1.y==p2.y
end

function hash(p::Int2D, h::UInt)
    hash((p.x,p.y), h)
end
