import Base:  +, -, ==, hash
#Position on a 2D space wiht continuouns coordinate system
struct Real2D{T<:Real} <: Position
    x::T
    y::T
end

function +(p1::Real2D{T}, p2::Real2D{T}) where {T<:Real}
    Real2D(p1.x+p2.x, p1.y+p2.y)
end
function -(p1::Real2D{T}, p2::Real2D{T}) where {T<:Real}
    Real2D(p1.x-p2.x, p1.y-p2.y)
end
function ==(p1::Real2D{T}, p2::Real2D{T}) where {T<:Real}
    p1.x ≈ p2.x && p1.y ≈ p2.y
end

function hash(p::Real2D{T}, h::UInt) where {T<:Real}
    hash((p.x,p.y), h)
end


"""
Utility function for toroidal transformation of euclidian coordinate.
"""
function toroidal(p::Real2D{T}, dim1::T, dim2::T) where {T<:Real}
    return Real2D(toroidalTransform(p.x,dim1),toroidalTransform(p.y,dim2))
end

"""
Utility function for toroidal distance.
"""
function distance(p1::Real2D{T}, p2::Real2D{T},  dim1::T, dim2::T, toroidal::Bool) where {T<:Real}
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
function toroidalTransform(val::T, dim::T) where {T<:Real}
    if (val >= 0 && val < dim)  return val end
    val = val % dim
    if (val < 0) val = val + dim end
    return val
end

"""
Utility function for toroidal distance on euclidian field.
"""
function toroidalDistance(val1::T, val2::T, dim::T) where {T<:Real}
    if (abs(val1-val2) <= dim / 2) return val1 - val2 end
    d = toroidalTransform(val1,dim) - toroidalTransform(val2,dim)
    if (d * 2 > dim) return d - dim end
    if (d * 2 < -dim) return d + dim end
    return d
end
