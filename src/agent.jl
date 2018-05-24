export Agent

#Agent structure definition use Base.Random.uuid4() to generate unique ID
mutable struct Agent
    behavior::Function
    data::Any
    this::Agent
    id::String
    function Agent(b::Function,data::Any)
        instance = new(b, data)
        instance.id= string(Base.Random.uuid4())
        instance.this = instance
        return instance
    end
end
