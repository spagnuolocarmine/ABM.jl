export SimState, Schedule, behavior!

#Simulation Schedule
mutable struct Schedule
    this::Schedule

    function Schedule()
        instance=new()
        instance.this=instance
        return this
    end
end

#Simulation State Definition
mutable struct SimState
    schedule::Schedule
    fields::Vector{Field}
    this::SimState
    function SimState()
        instance=new()
        instance.this = instance
        return instance
    end
end

#Agent step function
#TODO this function should not be exported outside this 
function behavior!(simstate::SimState,agent::Agent)
    return agent.behavior(simstate,agent)
end
