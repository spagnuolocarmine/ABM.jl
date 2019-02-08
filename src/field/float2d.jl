import Base:  ==, hash
#Position on a 2D space wiht continuouns coordinate system
struct Float2D <: Position
    x::Float64
    y::Float64
end


function ==(p1::Float2D, p2::Float2D)
    p1.x==p2.x && p1.y==p2.y
end

function hash(p::Float2D, h::UInt)
    hash((p.x,p.y), h)
end
