"""
    Field2D(...)
"""

mutable struct Field2D <: Field
    width::Int
    height::Int
    discretization::Float64
    toroidal::Bool
    fA::Dict{Int2D, Dict{Agent,Location}}
    fB::Dict{Int2D, Dict{Agent,Location}}
    fOA::Dict{Agent,Int2D}
    fOB::Dict{Agent,Int2D}

end

Field2D(width::Int,height::Int,discretization::Float64,toroidal::Bool) =
    Field2D(width,height,discretization,toroidal,
        Dict{Int2D,Dict{Agent,Location}}(),Dict{Int2D,Dict{Agent,Location}}(),
                                        Dict{Agent,Int2D}(),Dict{Agent,Int2D}())

function setObjectLocation!(f::Field2D,a::Agent,pos::Position)
    bag = discretize(pos,f.discretization)
    if (haskey(f.fOA,a))

        if (f.fA[f.fOA[a]][a].pos == pos)#the position is not changed
            return true
        end
        if (f.fOA[a] == bag)# if (fO.get(A) == bag) the agent is in the same bag but change the position
            f.fA[f.fOA[a]][a].pos = pos
            return true
        else
            remove!(f,a)
        end
    end
    if (!haskey(f.fA,bag))
        f.fA[bag] = Dict{Agent,Location}()
    end
    add!(f,a,pos)
end

function getObjectsAtLocation(f::Field2D,pos::Position)
    bag = discretize(pos,f.discretization)
    if (!haskey(f.fA,bag)) return nothing end
    values(f.fA[bag])
end

function getObjectLocation(f::Field2D,a::Agent)
    if (!haskey(f.fOA,a)) return nothing end
    bag = f.fOA[a]
    f.fA[bag][a].pos
end

function getAllObjects(f::Field2D)
    values(f.fOA)
end

#TODO CHECK DB
function add!(f::Field2D,a::Agent,pos::Position)
    #here we add the agent in the memory B for the next step
    bag = discretize(pos,f.discretization)
    f.fA[bag][a] = Location(pos,a)
    f.fOA[a] = bag
end


#TODO CHECK DB
function remove!(f::Field2D,a::Agent)
    #here we remove the agent from the memory B for the next step
    delete!(f.fA[f.fOA[a]],a)
    delete!(f.fOA,a)
end

function swapState!(f::Field2D)
    f.fB = f.fA
    f.fOB = f.fOA
end

function clear!(f::Field2D)
    f.fA = Dict{Int2D, Dict{Agent,Location}}()
    f.fB = Dict{Int2D, Dict{Agent,Location}}()
    f.fOA = Dict{Agent,Int2D}()
    f.fOB = Dict{Agent,Int2D}()
end


function discretize(p::Float2D,discretization::Float64)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
function discretize(p::Int2D,discretization::Int2D)
    Int2D(convert(Int, floor(p.x/discretization)), convert(Int, floor(p.y/discretization)));
end
