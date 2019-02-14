"""
    Field2D(...)
"""

mutable struct Field2D{T<:Real,D<:Real,A,P} <: Field
    width::T
    height::T
    discretization::D
    toroidal::Bool
    fA::Dict{Int2D, Dict{Union{Agent{A},Patch{P}},Location{Real2D{T}}}}
    fB::Dict{Int2D, Dict{Union{Agent{A},Patch{P}},Location{Real2D{T}}}}
    fOA::Dict{Union{Agent{A},Patch{P}},Int2D}
    fOB::Dict{Union{Agent{A},Patch{P}},Int2D}
    Field2D{T,D,A,P}(width::T, height::T,discretization::D, toroidal::Bool) where {T<:Real,D<:Real,A,P} =
        new{T,D,A,P}(width, height, discretization,toroidal,
            Dict{Int2D,Dict{Union{Agent{A},Patch{P}},Location{Real2D{T}}}}(), Dict{Int2D,Dict{Union{Agent{A},Patch{P}},Location{Real2D{T}}}}(),
                                            Dict{Union{Agent{A},Patch{P}},Int2D}(), Dict{Union{Agent{A},Patch{P}},Int2D}())

end


"""
    Add/Update an object into the state B of the field, looking for the object
    on the state A.
"""
function setObjectLocation!(f::Field2D{T,D,A,P}, obj::Union{Agent{A},Patch{P}}, pos::Real2D{T}) where {T<:Real,D<:Real,A,P }
    #if (pos == nothing || obj == nothing || f == nothing) return end
    bag = discretize(pos,f.discretization)

"""
    if (haskey(f.fOA,obj)) #Look inside the state A
        if (@inbounds f.fB[f.fOB[obj]][obj].pos == pos)#The position is not changed on the state A
            return true
        end
        if (@inbounds f.fOB[obj] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            @inbounds f.fB[f.fOB[obj]][obj].pos = pos
            return true
        else @inbounds remove!(f,obj)
        end
    end
"""

    if haskey(f.fOB, obj)
        remove!(f,obj)
    end
    if !haskey(f.fB,bag)
        #@inbounds
        f.fB[bag] = Dict{Union{Agent{A},Patch{A}},Location{Real2D{T}}}()
    end
    add!(f,obj,pos)
end


"""
    This method is inclusive, that means returns also objects at exactly the given distance.
    The search is made using a radial searching.
    Look inside the state A.
"""
function getNeighborsWithinDistance(f::Field2D{T,D,A,P}, pos::Real2D{T}, _distance::T) where {T<:Real,D<:Real,A,P}

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
    for (i,j) in Iterators.product(minI:maxI, minJ:maxJ)
            bagID = Int2D(tTransform(i,maxX),tTransform(j,maxY))
            if (haskey(f.fA, bagID))
                #@inbounds
                b = Bounds(f, bagID)
                #@inbounds
                bag = f.fA[bagID] #Dict{Union{Agent,Patch},Location}
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

function tTransform(x::T, width::T) where {T <: Union{Int,Float64}}
    if x >= 0 return (x % width) end
    return (x % width) + width
end



function getObjectsAtLocation(f::Field2D{T,D,A,P}, pos::Real2D{T}) where {T<:Real,D<:Real,A,P}
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
function numObjectsAtLocation(f::Field2D{T,D,A,P}, pos::Real2D{T}) where {T<:Real,D<:Real,A,P}
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

function getObjectLocation(f::Field2D{T,D,A,P}, obj::Union{Agent{A},Patch{P}}) where {T<:Real,D<:Real,A,P}
    #if (obj == nothing || f == nothing) return nothing end
    if (!haskey(f.fOA,obj)) return nothing end
    #@inbounds
    bag = f.fOA[obj]
    #@inbounds
    f.fA[bag][obj].pos
end

function getAllObjects(f::Field2D)
    values(f.fOA)
end

"""
    Add an object to the state B.
"""
function add!(f::Field2D{T,D,A,P}, obj::Union{Agent{A},Patch{P}}, pos::Real2D{T}) where {T<:Real,D<:Real,A,P}
    bag = discretize(pos,f.discretization)
    #here we add the agent in the memory B for the next step
    #@inbounds
    f.fB[bag][obj] = Location(pos,obj)
    #@inbounds
    f.fOB[obj] = bag
end


"""
    Remove the object from the state A.
"""
function remove!(f::Field2D{T,D,A,P}, obj::Union{Agent{A},Patch{P}}) where {T<:Real,D<:Real,A,P}
    #here we remove the agent from the memory B for the next step
    #@inbounds
    delete!(f.fB[f.fOB[obj]],obj)
    #@inbounds
    delete!(f.fOB,obj)
end

function swapState!(f::Field2D{T,D,A,P}) where {T<:Real,D<:Real,A,P}

    for object in f.fOA
        if !haskey(f.fOB, object.first)
            bag = object.second
            if !haskey(f.fB,bag) f.fB[bag] = Dict{Union{Agent,Patch},Location}() end
            #@inbounds
            f.fB[bag][object.first] = Location(f.fA[bag][object.first].pos,object.first)
            #@inbounds
            f.fOB[object.first] = bag
        end
    end

    f.fA = f.fB
    f.fOA = f.fOB

    f.fB = Dict{Int2D, Dict{Union{Agent,Patch},Location}}()
    f.fOB = Dict{Union{Agent,Patch},Int2D}()
    #TODO IF AN AGENT IS NOT MOVED DOES NOT APPEAR IN B AND WE HAVE TO CHECK in A
end

function clean!(f::Field2D{T,D,A,P}) where {T<:Real,D<:Real,A,P}
    f.fA = Dict{Int2D, Dict{Union{Agent{A},Patch{P}},Location{Real2D{T}}}}()
    f.fB = Dict{Int2D, Dict{Union{Agent{A},Patch{P}},Location{Real2D{T}}}}()
    f.fOA = Dict{Union{Agent{A},Patch{P}},Int2D}()
    f.fOB = Dict{Union{Agent{A},Patch{P}},Int2D}()
end


function discretize(p::Real2D{T}, discretization::T) where {T<:Real}
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
