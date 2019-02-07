

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
    steps::UInt64
    time::Float64

end

"""
    Schedule()

Construct `Schedule` with empty events list and initial time 0.0.
"""
Schedule() = Schedule(PriorityQueue{Agent,Priority}(),0,0.0)

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent)
    agent.stop = true
    enqueue!(schedule.events, agent, Priority(schedule.time+1.0,0))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, time::Float64)
    agent.stop = true
    enqueue!(schedule.events, agent, Priority(time,0))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, time::Float64, ordering::UInt)
    agent.stop = true
    enqueue!(schedule.events, agent, Priority(time,ordering))
end

"""
"""
function scheduleRepeating!(schedule::Schedule,agent::Agent)
    enqueue!(schedule.events, agent, Priority(schedule.time+1.0,0))
end

"""
"""
function scheduleRepeating!(schedule::Schedule,agent::Agent, time::Float64)
    enqueue!(schedule.events, agent, Priority(time,0))
end

"""
"""
function scheduleRepeating!(schedule::Schedule,agent::Agent, time::Float64, ordering::UInt)
    enqueue!(schedule.events, agent, Priority(time,ordering))
end


"""
"""
function simtime(schedule::Schedule)
    schedule.time
end

"""
"""
function step!(simstate::Any,schedule::Schedule)
    schedule.steps+=1
    schedule.time = peek(schedule.events).second.time
    ctime = schedule.time #current simulation time given by the event with small time
    cevents = Vector{Pair{Agent,Priority}}() #current events to be scheduled for this time
    while true
        if(isempty(schedule.events)) break end # no other events in the scheduling queue
        event = peek(schedule.events)
        ctime = event.second.time
        if(ctime > schedule.time) break end #no other events for currenttime
        dequeue!(schedule.events)
        push!(cevents,event)
    end #while loop
    for e in cevents
        e.first.step(simstate,e.first)
        if(!e.first.stop)
            enqueue!(schedule.events, e.first, Priority(ctime+1.0,e.second.priority))
        end
    end

end
