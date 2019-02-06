export SimState, Schedule, behavior!, simulate!, random

rng = MersenneTwister(1234);

function random()
    rng
end

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

#Simulation State Definition
mutable struct SimState
    schedule::Schedule
    fields::Vector{Field}
    next::Function
    addField::Function
    function SimState()
        instance=new()
        instance.schedule = Schedule()
        instance.fields = Vector{Field}()
        instance.addField = function(field::Field)
            push!(instance.fields,field)
        end
        instance.next = function()
            events = instance.schedule.nextTime()
            for agent in events
                behavior!(instance, agent)
            end

            for field in instance.fields
                field.swap()
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


function simulate!(simstate::SimState, _steps)
    i = 1
    while i <= _steps
        print(string("[",simstate.schedule._step,"] "))
        @time simstate.next()
        i+=1
    end
end
