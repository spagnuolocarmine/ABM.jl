"""
    Schedule

Represents a scheduling queue in which events can be scheduled to occur at future time.
The schedule time is the time of the most recent scheduled event.
The schedule time starts from 0.0. The time -1.0 is the time before simulation.
The time after simulation is the time maxiumum Float64.
You can schedule your events at time greater then 0.0, such as 0.0 + eps().

The events are cloned before each simulation step, when an agent is scheduled,
there are no changing in its memory, until the  next simulation step.
This ensures that the agent memory remains unchanged during the simulation step,
and the agents can see the status of the other agents consistent with the current simulation time.

**Constructors**

Schedule()

"""

mutable struct Schedule
    events::PriorityQueue{Agent,Priority}
    steps::Int64
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
function scheduleOnce!(schedule::Schedule,agent::Agent, ordering::Int)
    agent.stop = true
    enqueue!(schedule.events, agent, Priority(schedule.time+1.0,ordering))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, time::Float64)
    agent.stop = true
    enqueue!(schedule.events, agent, Priority(time,0))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, time::Float64, ordering::Int)
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
function scheduleRepeating!(schedule::Schedule,agent::Agent,ordering::Int)
    enqueue!(schedule.events, agent, Priority(schedule.time+1.0,ordering))
end

"""
"""
function scheduleRepeating!(schedule::Schedule,agent::Agent, time::Float64)
    enqueue!(schedule.events, agent, Priority(time,0))
end

"""
"""
function scheduleRepeating!(schedule::Schedule,agent::Agent, time::Float64, ordering::Int)
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
        if(event.second.time > schedule.time) break end #no other events for currenttime
        ctime = event.second.time
        dequeue!(schedule.events)
        push!(cevents,event)
    end #while loop
    for e in cevents
        ce = deepcopy(e.first)
        ce.step(simstate,e.first)
        if(!ce.stop) enqueue!(schedule.events, ce, Priority(ctime+1.0, e.second.priority))
        end
    end

end
