export Agent

#Agent structure definition use Base.Random.uuid4() to generate unique ID
mutable struct Agent
    behavior::Function
    data::Any
    id::String
    function Agent(b::Function,data::Any)
        instance = new(b, data)
        instance.id= string(UUIDs.uuid4(random()))
        return instance
    end
end
