export Schedule
include("agent.jl")
mutable struct Schedule
    this::Schedule

    function Schedule()
        instance=new()
        instance.this=instance
        return this
    end
end
