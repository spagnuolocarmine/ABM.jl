import Base:  ==, hash

mutable struct Agent
    step::Function
    data::Any
    id::String
    stop::Bool
    function Agent(step::Function,data::Any)
        A = new(step, data)
        A.id = string(UUIDs.uuid4(random()))
        A.stop = false
        return A
    end
end

function ==(x::Agent, y::Agent)
    x.id==y.id
end

function hash(x::Agent, h::UInt)
    hash(x.id, h)
end
