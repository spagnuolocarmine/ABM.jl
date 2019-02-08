import Base:  +, -, ==, hash
#Position on a 2D space wiht continuouns coordinate system
struct Float2D <: Position
    x::Float64
    y::Float64
end

function +(p1::Float2D, p2::Float2D)
    Float2D(p1.x+p2.x, p1.y+p2.y)
end
function -(p1::Float2D, p2::Float2D)
    Float2D(p1.x-p2.x, p1.y-p2.y)
end
function ==(p1::Float2D, p2::Float2D)
    p1.x ≈ p2.x && p1.y ≈ p2.y
end

function hash(p::Float2D, h::UInt)
    hash((p.x,p.y), h)
end


"""
Utility function for toroidal transformation of euclidian coordinate.
"""
function toroidal(p::Float2D, dim1::Float64, dim2::Float64)
    return Float2D(toroidalTransform(p.x,dim1),toroidalTransform(p.y,dim2))
end

"""
Utility function for toroidal distance.
"""
function distance(p1::Float2D, p2::Float2D,  dim1::Float64, dim2::Float64, toroidal::Bool)
    if toroidal
        dx = toroidalDistance(p1.x,p2.x,dim1);
        dy = toroidalDistance(p1.y,p2.y,dim2);

    else
        dx = p1.x - p2.x;
        dy = p1.y - p2.y;
    end
    return sqrt(dx * dx + dy * dy)
end

"""
Utility function for toroidal euclidian field.
"""
function toroidalTransform(val::Float64, dim::Float64)
    if (val >= 0 && val < dim)  return val end
    val = val % dim
    if (val < 0) val = val + dim end
    return val
end

"""
Utility function for toroidal distance on euclidian field.
"""
function toroidalDistance(val1::Float64, val2::Float64, dim::Float64)
    if (abs(val1-val2) <= dim / 2) return val1 - val2 end
    d = toroidalTransform(val1,dim) - toroidalTransform(val2,dim)
    if (d * 2 > dim) return d - dim end
    if (d * 2 < -dim) return d + dim end
    return d
end
