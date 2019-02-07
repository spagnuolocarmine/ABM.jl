


#Position on a 2D space with integer coordinate system
mutable struct Int2D <: Position
    x::Int32
    y::Int32
end
#Position on a 2D space wiht continuouns coordinate system, with discretized 1
#TODO add generic discretization
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

#A 2D continuonus space
#It is discretized by 1, that means the position 1,2-1,2 it is the same of 1,3-1,3
mutable struct Field2D <: Field
    fielda:: DistributedArrays.DArray
    fieldb:: DistributedArrays.DArray
    getNeighbors::Function
    place::Function
    update::Function
    swap::Function
    function Field2D(FA::DistributedArrays.DArray, FB::DistributedArrays.DArray)
        this = new(FA,FB)
        this.getNeighbors = function (pos::Float2D)
            return this.fielda[pos.getArrayPos().x,pos.getArrayPos().y]
        end
        this.place = function (pos::Float2D, agent::Agent)
            return push!(this.fielda[pos.getArrayPos().x,pos.getArrayPos().y], Location(pos,agent))
        end
        this.update = function (pos::Float2D,agent::Agent)
            return push!(this.fieldb[pos.getArrayPos().x,pos.getArrayPos().y], Location(pos,agent))
        end
        #TODO copy agents that are not moved usign update from the fielda
        this.swap = function ()
            this.fielda = this.fieldb
        end
        return this
    end
end

macro field2d(width,height)
    fa=@DArray [Vector{Location}() for i = 1:width, j = 1:height]
    fb=@DArray [Vector{Location}() for i = 1:width, j = 1:height]
    return Field2D(fa,fb)
end
