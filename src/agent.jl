export Agent

#Agent structure definition use Base.Random.uuid4() to generate unique ID
mutable struct Agent
    step::Function
    data::Any
    id::String
    stop::Bool
    function Agent(step::Function,data::Any)
        A = new(step, data)
        A.id= string(UUIDs.uuid4(random()))
        A.stop = false
        return A
    end
end
