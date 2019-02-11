import Base:   ==
"""
    Bounds(Real2D,Real2D,Real2D,Real2D)

    ....
"""
struct Bounds
    nw::Position
    ne::Position
    sw::Position
    se::Position
    function Bounds(f::Field2D, bagID::Int2D)
        nw = Real2D(bagID.x * f.discretization, bagID.y * f.discretization)
        ne = Real2D(nw.x, min(nw.y + f.discretization, f.height))
        sw = Real2D(min(nw.x+f.discretization, f.width), nw.y)
        se = Real2D(sw.x, ne.y)
        bounds = new(nw, ne, sw, se)
        return bounds
    end
end


function ==(b1::Bounds, b2::Bounds)
        b1.nw == b2.nw &&
            b1.ne == b2.ne &&
                 b1.sw == b2.sw &&
                    b1.sw == b2.sw
end

function checkBoundCircle(b::Bounds, center::Position, radius::Real)
    if distance(b.nw, center) <= radius &&
            distance(b.ne, center) <= radius &&
                distance(b.sw, center) <= radius &&
                    distance(b.se, center) <= radius
                return 1
    elseif distance(b.nw, center) > radius &&
            distance(b.ne, center) > radius &&
                distance(b.sw, center) > radius &&
                    distance(b.se, center) > radius
                        return -1

    end
    return 0

end
