export  Schedule

#Simulation Schedule
mutable struct Schedule
    events::Vector{Agent}
    scheduleRepeating::Function
    _step::UInt64
    nextTime::Function
    function Schedule()
        instance=new()
        instance.events = Vector{Agent}()
        instance._step=0
        instance.scheduleRepeating = function(agent::Agent)
            push!(instance.events,agent)
        end
        instance.nextTime = function ()
            instance._step+=1
            return instance.events
        end
        return instance
    end
end
