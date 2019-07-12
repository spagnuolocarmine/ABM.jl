import Base:   ==
"""
    Bounds(Real2D,Real2D,Real2D,Real2D)

    ....
"""
struct Bounds{T<:Real, P<:Position, F<:Field}
    nw::P
    ne::P
    sw::P
    se::P
    f::F
    function Bounds(f::Field2D{T}, bagID::Real2D{Int}) where {T<:Real}
        nw = Real2D{T}(bagID.x * f.discretization, bagID.y * f.discretization)
        ne = Real2D{T}(nw.x, min(nw.y + f.discretization, f.height))
        sw = Real2D{T}(min(nw.x+f.discretization, f.width), nw.y)
        se = Real2D{T}(sw.x, ne.y)
        bounds = new{T,Real2D{T},Field2D{T}}(nw, ne, sw, se, f)
        return bounds
    end
end


function ==(b1::Bounds{T,P,F}, b2::Bounds{T,P,F}) where {T<:Real, P<:Position, F<:Field}
        b1.nw == b2.nw &&
            b1.ne == b2.ne &&
                 b1.sw == b2.sw &&
                    b1.sw == b2.sw      #TODO it may be se?
end

function checkBoundCircle(b::Bounds{T,P,F}, center::P, radius::T, toroidal::Bool) where {T<:Real, P<:Position, F<:Field}
        if distance(b.nw, center, b.f.width, b.f.height,toroidal) <= radius &&
                distance(b.ne, center, b.f.width, b.f.height,toroidal) <= radius &&
                    distance(b.sw, center, b.f.width, b.f.height,toroidal) <= radius &&
                        distance(b.se, center, b.f.width, b.f.height,toroidal) <= radius
                    return 1
        elseif distance(b.nw, center, b.f.width, b.f.height,toroidal) > radius &&
                distance(b.ne, center, b.f.width, b.f.height,toroidal) > radius &&
                    distance(b.sw, center, b.f.width, b.f.height,toroidal) > radius &&
                        distance(b.se, center, b.f.width, b.f.height,toroidal) > radius
                            return -1

        end
        return 0

end
