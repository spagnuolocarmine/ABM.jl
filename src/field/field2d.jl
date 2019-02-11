"""
    Field2D(...)
"""

mutable struct Field2D <: Field
    width::Int
    height::Int
    discretization::Real
    toroidal::Bool
    fA::Dict{Int2D, Dict{Agent,Location}}
    fB::Dict{Int2D, Dict{Agent,Location}}
    fOA::Dict{Agent,Int2D}
    fOB::Dict{Agent,Int2D}

end

Field2D(width::Int,height::Int,discretization::Real,toroidal::Bool) =
    Field2D(width,height,discretization,toroidal,
        Dict{Int2D,Dict{Agent,Location}}(),Dict{Int2D,Dict{Agent,Location}}(),
                                        Dict{Agent,Int2D}(),Dict{Agent,Int2D}())

function setObjectLocation!(f::Field2D,a::Agent,pos::Position)
    if (pos == nothing || a == nothing || f == nothing) return end
    bag = discretize(pos,f.discretization)
    if (haskey(f.fOA,a))

        if (@inbounds f.fA[f.fOA[a]][a].pos == pos)#the position is not changed
            return true
        end
        if (@inbounds f.fOA[a] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            @inbounds f.fA[f.fOA[a]][a].pos = pos
            return true
        else
            @inbounds remove!(f,a)
        end
    end
    if (!haskey(f.fA,bag))
        @inbounds f.fA[bag] = Dict{Agent,Location}()
    end
    add!(f,a,pos)
end

function getNeighborsExactlyWithinDistance(f::Field2D,pos::Position,distance::Real)
end

function getObjectsAtLocation(f::Field2D,pos::Position)
    if (pos == nothing || f == nothing) return nothing end
    bag = discretize(pos,f.discretization)
    if (!haskey(f.fA,bag)) return nothing end
    result = Vector{Agent}()
    for location in values(f.fA[bag])
        if (location.pos == pos)
            push!(result,location.agent)
        end
    end
    result
end
function numObjectsAtLocation(f::Field2D,pos::Position)
    if (pos == nothing || f == nothing) return nothing end
    bag = discretize(pos,f.discretization)
    if (!haskey(f.fA,bag)) return nothing end
    result = Vector{Agent}()
    for location in values(f.fA[bag])
        if (location.pos == pos)
            push!(result,location.agent)
        end
    end
    length(result)
end

function getObjectLocation(f::Field2D,a::Agent)
    if (a == nothing || f == nothing) return nothing end
    if (!haskey(f.fOA,a)) return nothing end
    @inbounds bag = f.fOA[a]
    @inbounds f.fA[bag][a].pos
end

function getAllObjects(f::Field2D)
    values(f.fOA)
end

#TODO CHECK DB
function add!(f::Field2D,a::Agent,pos::Position)
    #here we add the agent in the memory B for the next step
    bag = discretize(pos,f.discretization)
    @inbounds f.fA[bag][a] = Location(pos,a)
    @inbounds f.fOA[a] = bag
end


#TODO CHECK DB
function remove!(f::Field2D,a::Agent)
    #here we remove the agent from the memory B for the next step
    @inbounds delete!(f.fA[f.fOA[a]],a)
    @inbounds delete!(f.fOA,a)
end

function swapState!(f::Field2D)
    @inbounds f.fB = f.fA
    @inbounds f.fOB = f.fOA
end

function clear!(f::Field2D)
    f.fA = Dict{Int2D, Dict{Agent,Location}}()
    f.fB = Dict{Int2D, Dict{Agent,Location}}()
    f.fOA = Dict{Agent,Int2D}()
    f.fOB = Dict{Agent,Int2D}()
end


function discretize(p::Real2D,discretization::Float64)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
function discretize(p::Int2D,discretization::Int2D)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
