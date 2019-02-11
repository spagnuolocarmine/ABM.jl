"""
    Field2D(...)
"""

mutable struct Field2D <: Field
    width::Int
    height::Int
    discretization::Real
    toroidal::Bool
    fA::Dict{Int2D, Dict{Union{Agent,Patch},Location}}
    fB::Dict{Int2D, Dict{Union{Agent,Patch},Location}}
    fOA::Dict{Union{Agent,Patch},Int2D}
    fOB::Dict{Union{Agent,Patch},Int2D}

end

Field2D(width::Int, height::Int,discretization::Real, toroidal::Bool) =
    Field2D(width, height, discretization,toroidal,
        Dict{Int2D,Dict{Union{Agent,Patch},Location}}(), Dict{Int2D,Dict{Union{Agent,Patch},Location}}(),
                                        Dict{Union{Agent,Patch},Int2D}(), Dict{Union{Agent,Patch},Int2D}())

function setObjectLocation!(f::Field2D, obj::Union{Agent,Patch}, pos::Position)
    if (pos == nothing || obj == nothing || f == nothing) return end
    bag = discretize(pos,f.discretization)
    if (haskey(f.fOA,obj))

        if (@inbounds f.fA[f.fOA[obj]][obj].pos == pos)#the position is not changed
            return true
        end
        if (@inbounds f.fOA[obj] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            @inbounds f.fA[f.fOA[obj]][obj].pos = pos
            return true
        else
            @inbounds remove!(f,obj)
        end
    end
    if (!haskey(f.fA,bag))
        @inbounds f.fA[bag] = Dict{Union{Agent,Patch},Location}()
    end
    add!(f,obj,pos)
end

function getNeighborsExactlyWithinDistance(f::Field2D, pos::Position, distance::Real)

end

function getObjectsAtLocation(f::Field2D, pos::Position)
    if (pos == nothing || f == nothing) return nothing end
    bag = discretize(pos,f.discretization)
    if (!haskey(f.fA,bag)) return nothing end
    result = Vector{Union{Agent,Patch}}()
    for location in values(f.fA[bag])
        if (location.pos == pos)
            push!(result,location.object)
        end
    end
    result
end
function numObjectsAtLocation(f::Field2D, pos::Position)
    if (pos == nothing || f == nothing) return nothing end
    bag = discretize(pos,f.discretization)
    if (!haskey(f.fA,bag)) return nothing end
    result = Vector{Union{Agent,Patch}}()
    for location in values(f.fA[bag])
        if (location.pos == pos)
            push!(result,location.object)
        end
    end
    length(result)
end

function getObjectLocation(f::Field2D, obj::Union{Agent,Patch})
    if (obj == nothing || f == nothing) return nothing end
    if (!haskey(f.fOA,obj)) return nothing end
    @inbounds bag = f.fOA[obj]
    @inbounds f.fA[bag][obj].pos
end

function getAllObjects(f::Field2D)
    values(f.fOA)
end

#TODO CHECK DB
function add!(f::Field2D, obj::Union{Agent,Patch}, pos::Position)
    #here we add the agent in the memory B for the next step
    bag = discretize(pos,f.discretization)
    @inbounds f.fA[bag][obj] = Location(pos,obj)
    @inbounds f.fOA[obj] = bag
end


#TODO CHECK DB
function remove!(f::Field2D, obj::Union{Agent,Patch})
    #here we remove the agent from the memory B for the next step
    @inbounds delete!(f.fA[f.fOA[obj]],obj)
    @inbounds delete!(f.fOA,obj)
end

function swapState!(f::Field2D)
    @inbounds f.fB = f.fA
    @inbounds f.fOB = f.fOA
end

function clear!(f::Field2D)
    f.fA = Dict{Int2D, Dict{Union{Agent,Patch},Location}}()
    f.fB = Dict{Int2D, Dict{Union{Agent,Patch},Location}}()
    f.fOA = Dict{Union{Agent,Patch},Int2D}()
    f.fOB = Dict{Union{Agent,Patch},Int2D}()
end


function discretize(p::Real2D, discretization::Number)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
