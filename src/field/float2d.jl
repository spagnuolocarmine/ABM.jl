#Position on a 2D space wiht continuouns coordinate system
mutable struct Float2D <: Position
    x::Float64
    y::Float64
    getArrayPos::Function
    function Float2D(x::Float64,y::Float64)
        this = new(x,y)
        this.getArrayPos = function ()
            return Int2D(convert(UInt64, floor(x)),convert(UInt64, floor(y)))
        end
        return this
    end
end
