module abm

@everywhere using DistributedArrays

export Position, Float2D, Agent, @agent, Field2D, @field2d

mutable struct Agent{B,D,I}
    behavior::B
    data::D
    id::I
end

(a::Agent)(x,d,id) = a.s(x,d,id)

function make_function(ex::Expr)
    return :(x -> $ex)
end

function make_model(ex::Expr,data::Symbol)
    return :(Agent($ex,$data, Base.Random.uuid4()))
end

macro agent(data,ex)
    return make_model(make_function(ex),data)
end

abstract type Position
end
mutable struct Int2D <: Position
    x::Int32
    y::Int32
end
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
struct Location
    pos::Position
    agent::Agent
end

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


struct memory
    a
end
f = Float2D(2.0,2.0)
f2 = Float2D(2.6,2.6)
f3 = Float2D(2.6,3.2)
m = memory(2)
a1 = @agent m 2x
a2 = @agent m 2x
a3 = @agent m 2x
field = @field2d 100 100
field.place(f,a1)
field.place(f2,a2)
field.place(f3,a3)
field.getNeighbors(f)
end
