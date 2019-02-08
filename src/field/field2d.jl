
"""
#A 2D continuonus space
#It is discretized by 1, that means the position 1,2-1,2 it is the same of 1,3-1,3
mutable struct Field2D <: Field
    toroidal::Bool
    fielda:: DistributedArrays.DArray
    fieldb:: DistributedArrays.DArray
    getNeighbors::Function
    place::Function
    update::Function
    swap::Function
    function Field2D(FA::DistributedArrays.DArray, FB::DistributedArrays.DArray)
        this = new(FA,FB)
        this.toroidal = true#???
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
"""

mutable struct Field2D <: Field
    width::Int
    height::Int
    discretization::Float64
    toroidal::Bool
    fA::Dict{Int2D, Dict{Agent,Location}}
    fB::Dict{Int2D, Dict{Agent,Location}}
    fO::Dict{Agent,Int2D}

end

Field2D(width::Int,height::Int,discretization::Float64,toroidal::Bool) =
    Field2D(width,height,discretization,toroidal,Dict{Int2D,Dict{Agent,Location}}(),Dict{Int2D,Dict{Agent,Location}}(),Dict{Agent,Int2D}())

function setObjectLocation!(f::Field2D,a::Agent,pos::Position)
    bag = discretize(pos,f.discretization)
    if (haskey(f.fO,a))

        if (f.fA[f.fO[a]][a].pos == pos)#the position is not changed
            return true
        end

        if (f.fO[a] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            f.fA[f.fO[a]][a].pos = pos
            return true
        else
            delete!(f.fA[f.fO[a]],a)
            delete!(f.fO,a)
        end
    end
    if (!haskey(f.fA,bag))
        f.fA[bag] = Dict{Agent,Location}()
    end
    f.fA[bag][a] = Location(pos,a)
    f.fO[a] = bag
end

#function setObjectLocation!(f::Field2D,a::Agent,pos::Int2D)
#end

#getObjectsAtLocations

function getObjectLocation(f::Field2D,a::Agent)
    if (!haskey(f.fO,a)) return nothing end
    bag = f.fO[a]
    f.fA[bag][a].pos
end

function discretize(p::Float2D,discretization::Float64)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
function discretize(p::Int2D,discretization::Int2D)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end


"""
macro field2d(width,height)
    fa=@DArray [Vector{Location}() for i = 1:width, j = 1:height]
    fb=@DArray [Vector{Location}() for i = 1:width, j = 1:height]
    return Field2D(fa,fb)
end
"""
