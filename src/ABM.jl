module ABM

using DistributedArrays
using Parameters

export SimState, Position, Float2D, Agent, @agent, Field2D, @field2d

#Simulation State Definition
struct SimState
    field::DistributedArrays.DArray
end

#Agent structure definition use Base.Random.uuid4() to generate unique ID
mutable struct Agent{F<:Function,D,I}
    behavior::F
    data::D
    id::I
end

#Agent Space definition
#Abstract type of a position in the space
abstract type Position
end
#Position on a 2D space with integer coordinate system
mutable struct Int2D <: Position
    x::Int32
    y::Int32
end
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
#Location on a space of an agent
struct Location
    pos::Position
    agent::Agent
end
#A 2D continuonus space
#It is discretized by 1, that means the position 1,2-1,2 it is the same of 1,3-1,3
mutable struct Field2D
    field::DistributedArrays.DArray
    getNeighbors::Function
    place::Function
    function Field2D(field::DistributedArrays.DArray)
        this = new(field)
        this.getNeighbors = function (pos::Float2D)
            return field[pos.getArrayPos().x,pos.getArrayPos().y]
        end
        this.place = function (pos::Float2D,agent::Agent)
            return push!(field[pos.getArrayPos().x,pos.getArrayPos().y], Location(pos,agent))
        end
        return this
    end
end

macro field2d(width,height)
    return Field2D(@DArray [Vector{Location}() for i = 1:width, j = 1:height])
end
end
