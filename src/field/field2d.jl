"""
    Field2D(...)
"""

mutable struct Field2D <: Field
    width::Real
    height::Real
    discretization::Real
    toroidal::Bool
    fA::Dict{Int2D, Dict{Union{Agent,Patch},Location}}
    fB::Dict{Int2D, Dict{Union{Agent,Patch},Location}}
    fOA::Dict{Union{Agent,Patch},Int2D}
    fOB::Dict{Union{Agent,Patch},Int2D}

end

Field2D(width::Real, height::Real,discretization::Real, toroidal::Bool) =
    Field2D(width, height, discretization,toroidal,
        Dict{Int2D,Dict{Union{Agent,Patch},Location}}(), Dict{Int2D,Dict{Union{Agent,Patch},Location}}(),
                                        Dict{Union{Agent,Patch},Int2D}(), Dict{Union{Agent,Patch},Int2D}())

"""
    Add/Update an object into the state B of the field, looking for the object
    on the state A.
"""
function setObjectLocation!(f::Field2D, obj::Union{Agent,Patch}, pos::Position)
    if (pos == nothing || obj == nothing || f == nothing) return end
    internalSetObjectLocation!(f,obj,pos, length(f.fB) == 0)
end

function internalSetObjectLocation!(f::Field2D, obj::Union{Agent,Patch}, pos::Position, isInit::Bool)

    state = isInit ? f.fA :  f.fB
    mapstate = isInit ? f.fOA :  f.fOB

    bag = discretize(pos,f.discretization)

    if (haskey(mapstate,obj)) #Look inside the state A

        if (@inbounds state[mapstate[obj]][obj].pos == pos)#The position is not changed on the state A
            return true
        end
        if (@inbounds mapstate[obj] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            @inbounds state[mapstate[obj]][obj].pos = pos
            return true
        else
            #remove from field
            @inbounds delete!(state[mapstate[obj]],obj)
            @inbounds delete!(mapstate,obj)
        end
    end
    if (!haskey(state,bag))
        @inbounds state[bag] = Dict{Union{Agent,Patch},Location}()
    end

    #add to the field
    @inbounds state[bag][obj] = Location(pos,obj)
    @inbounds mapstate[obj] = bag
end

"""
    This method is inclusive, that means returns also objects at exactly the given distance.
    The search is made using a radial searching.
    Look inside the state A.
"""
function getNeighborsWithinDistance(f::Field2D, pos::Position, _distance::Real)

    if _distance <= 0.0 return nothing end

    discDistance = convert(Int, floor(_distance/f.discretization))
    discPos = discretize(pos,f.discretization)

    maxX = convert(Int, ceil(f.width/f.discretization)) #number of bag
    maxY = convert(Int, ceil(f.height/f.discretization)) #number of bag

    result = Vector{Union{Agent,Patch}}()

    if !f.toroidal
        minI = max(0, discPos.x - discDistance)
        maxI = min(discPos.x + discDistance, maxX - 1) #start from 0 remove the last bag
        minJ = max(0, discPos.y - discDistance)
        maxJ = min(discPos.y + discDistance, maxY - 1)

    else
        minI = discPos.x - discDistance - 1
        maxI = discPos.x + discDistance + 1
        minJ = discPos.y - discDistance -1
        maxJ = discPos.y + discDistance + 1

    end #!isToroidal
    #for i = minI:maxI, j = minJ:maxJ
    #@sync @distributed
    for (i,j) in collect(Iterators.product(minI:maxI, minJ:maxJ))
            bagID = Int2D(tTransform(i,maxX),tTransform(j,maxY))
            if (haskey(f.fA, bagID))
                @inbounds b = Bounds(f, bagID)
                @inbounds bag = f.fA[bagID] #Dict{Union{Agent,Patch},Location}
                check = checkBoundCircle(b, pos, _distance, f.toroidal)
                if check == 1
                    append!(result, keys(bag))
                elseif check == 0
                    for obj in bag
                        if distance(obj.second.pos, pos, f.width, f.height, f.toroidal) <= _distance
                            push!(result, obj.first)
                        end
                    end
                end
            end

    end # for i for j

    return result
end

function tTransform(x::Real, width::Real)
    if x >= 0 return (x % width) end
    return (x % width) + width
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


function swapState!(f::Field2D)
    @inbounds f.fB = f.fA
    @inbounds f.fOB = f.fOA
end

function clean!(f::Field2D)
    f.fA = Dict{Int2D, Dict{Union{Agent,Patch},Location}}()
    f.fB = Dict{Int2D, Dict{Union{Agent,Patch},Location}}()
    f.fOA = Dict{Union{Agent,Patch},Int2D}()
    f.fOB = Dict{Union{Agent,Patch},Int2D}()
end


function discretize(p::Real2D, discretization::Number)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
