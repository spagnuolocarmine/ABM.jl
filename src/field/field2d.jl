"""
    Field2D(...)
"""

mutable struct Field2D{T<:Real,D<:Real} <: Field
    width::T
    height::T
    discretization::D
    toroidal::Bool
    f::Dict{Real2D{Int}, Dict{Union{Agent,Patch},Location}}
    #f::Dict{Real2D{Int}, Dict{Union{Agent,Patch},Location}}
    fO::Dict{Union{Agent,Patch},Real2D{Int}}
    #fO::Dict{Union{Agent,Patch},Real2D{Int}}
    Field2D(width::T, height::T, discretization::D, toroidal::Bool) where {T<:Real,D<:Real} =
        new{T,D}(width, height, discretization, toroidal, Dict{Real2D{Int},Dict{Union{Agent,Patch},Location}}(), Dict{Union{Agent,Patch},Real2D{Int}}())
end



"""
    Add/Update an object into the state B of the field, looking for the object
    on the state A.
"""
function setObjectLocation!(f::Field2D, obj::Union{Agent,Patch}, pos::Position)
    if (pos == nothing || obj == nothing || f == nothing) return end
    bag = discretize(pos,f.discretization)

    if (haskey(f.fO,obj))

        if (@inbounds f.f[f.fO[obj]][obj].pos == pos)#the position is not changed
            return true
        end
        if (@inbounds f.fO[obj] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            @inbounds f.f[f.fO[obj]][obj].pos = pos
            return true
        else
            @inbounds remove!(f,obj)
        end
    end
    if (!haskey(f.f,bag))
        @inbounds f.f[bag] = Dict{Union{Agent,Patch},Location}()
    end
    add!(f,obj,pos)
end

function add!(f::Field2D, obj::Union{Agent,Patch}, pos::Position)
    #here we add the agent in the memory B for the next step
    bag = discretize(pos,f.discretization)
    @inbounds f.f[bag][obj] = Location(pos,obj)
    @inbounds f.fO[obj] = bag
end


"""
    Remove the object from the state A.
"""
function remove!(f::Field2D{T,D}, obj::Union{Agent,Patch}) where {T<:Real,D<:Real}
    #here we remove the agent from the memory B for the next step
    @inbounds delete!(f.f[f.fO[obj]],obj)
    @inbounds delete!(f.fO,obj)
end

"""
    This method is inclusive, that means returns also objects at exactly the given distance.
    The search is made using a radial searching.
    Look inside the state A.
"""
function getNeighborsWithinDistance(f::Field2D{T,D}, pos::Position, _distance::T) where {T<:Real,D<:Real}

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
            bagID = Real2D{Int}(tTransform(i,maxX),tTransform(j,maxY))
            if (haskey(f.f, bagID))
                @inbounds b = Bounds(f, bagID)
                @inbounds bag = f.f[bagID] #Dict{Union{Agent,Patch},Location}
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



function getObjectsAtLocation(f::Field2D{T,D}, pos::Position) where {T<:Real,D<:Real}
    if (pos == nothing || f == nothing) return nothing end
    bag = discretize(pos,f.discretization)
    if (!haskey(f.f,bag)) return nothing end
    result = Vector{Union{Agent,Patch}}()
    for location in values(f.f[bag])
        if (location.pos == pos)
            push!(result,location.object)
        end
    end
    result
end
function numObjectsAtLocation(f::Field2D{T,D}, pos::Position) where {T<:Real,D<:Real}
    if (pos == nothing || f == nothing) return nothing end
    bag = discretize(pos,f.discretization)
    if (!haskey(f.f,bag)) return nothing end
    result = Vector{Union{Agent,Patch}}()
    for location in values(f.f[bag])
        if (location.pos == pos)
            push!(result,location.object)
        end
    end
    length(result)
end

function getObjectLocation(f::Field2D{T,D}, obj::Union{Agent,Patch}) where {T<:Real,D<:Real}
    if (obj == nothing || f == nothing) return nothing end
    if (!haskey(f.fO,obj)) return nothing end
    @inbounds bag = f.fO[obj]
    @inbounds f.f[bag][obj].pos
end

function getAllObjects(f::Field2D)
    values(f.fO)
end




function clean!(f::Field2D{T,D}) where {T<:Real,D<:Real}
    f.f = Dict{Real2D{Int}, Dict{Union{Agent,Patch},Location}}()
    #f.f = Dict{Real2D{Int}, Dict{Union{Agent,Patch},Location}}()
    f.fO = Dict{Union{Agent,Patch},Real2D{Int}}()
    #f.fO = Dict{Union{Agent,Patch},Real2D{Int}}()
end


function discretize(p::Real2D{T}, discretization::T) where {T<:Real}
    Real2D{Int}(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
