export  Schedule


#TODO Schedue docs
"""
    Schedule

Represents a scheduling queue in which events can be scheduled to occur at future time.
The schedule time is the time of the most recent scheduled event.

**Constructors**

Schedule()

"""

mutable struct Schedule
    events::PriorityQueue{Agent,Priority}
    scheduleRepeating::Function
    _step::UInt64
    _time::Real
    nextTime::Function
    getTime::Function
    function Schedule()
        instance=new()
        instance.events = PriorityQueue{Agent,Priority}()
        instance._step=0
        instance._time=0.0
        instance.scheduleRepeating = function(agent::Agent)
            enqueue!(instance.events, agent, Priority(_time+1.0,0))
        end
        instance.nextTime = function ()
            instance._step+=1
            return instance.events
        end
        instance.getTime = function ()
            return instance._time
        end
        return instance
    end
end
