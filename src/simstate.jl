export SimState, Schedule, behavior!

#Simulation Schedule
mutable struct Schedule
    events::Vector{Agent}
    scheduleRepeating::Function
    function Schedule()
        instance=new()
        instance.events = Vector{Agent}()
        instance.scheduleRepeating = function(agent::Agent)
            push!(instance.events,agent)
        end
        return instance
    end
end

#Simulation State Definition
mutable struct SimState
    schedule::Schedule
    fields::Vector{Field}
    next::Function
    function SimState()
        instance=new()
        instance.schedule = Schedule()
        instance.fields = Vector{Field}()
        instance.next = function()
            for agent in instance.schedule.events
                behavior!(instance,agent)
            end
        end
        return instance
    end
end

#Agent step function
#TODO this function should not be exported outside this
function behavior!(simstate::SimState,agent::Agent)
    return agent.behavior(simstate,agent)
end
