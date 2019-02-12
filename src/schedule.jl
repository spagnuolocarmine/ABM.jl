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
    simstate::SimState
    events::PriorityQueue{Agent,Priority}
    endevents::Dict{Agent,Agent}
    steps::Int64
    time::Float64

end

"""
    Schedule()

Construct `Schedule` with empty events list and initial time 0.0.

"""
Schedule(simstate::SimState) = Schedule(simstate,PriorityQueue{Agent,Priority}(),Dict{Agent,Agent}(),0,0.0)

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent)
    push!(schedule.endevents,agent=>agent)
    enqueue!(schedule.events, agent, Priority(schedule.time+1.0,0))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, ordering::Int)
    push!(schedule.endevents,agent=>agent)
    enqueue!(schedule.events, agent, Priority(schedule.time+1.0,ordering))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, time::Float64)
    push!(schedule.endevents,agent=>agent)
    enqueue!(schedule.events, agent, Priority(time,0))
end

"""
"""
function scheduleOnce!(schedule::Schedule,agent::Agent, time::Float64, ordering::Int)
    push!(schedule.endevents,agent=>agent)
    enqueue!(schedule.events, agent, Priority(time,ordering))
end

function stop!(schedule::Schedule,agent::Agent)
    push!(schedule.endevents,agent=>agent)
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
function step!(schedule::Schedule)
    schedule.steps+=1
    schedule.time = peek(schedule.events).second.time
    ctime = schedule.time #current simulation time given by the event with small time
    cevents = Vector{Pair{Agent,Priority}}() #current events to be scheduled for this time
    while true
        if(isempty(schedule.events)) break end # no other events in the scheduling queue
        @inbounds event = peek(schedule.events)
        if(event.second.time > schedule.time) break end #no other events for currenttime
        ctime = event.second.time
        @inbounds dequeue!(schedule.events)
        push!(cevents,event)
    end #while loop


    #@sync @distributed
    for e in cevents
        #Double buffering on the event memory
        ce = deepcopy(e.first)
        ce.step(schedule.simstate,e.first)
        if(!haskey(schedule.endevents,e.first))
            enqueue!(schedule.events, ce, Priority(ctime+1.0, e.second.priority))
        end
    end
    #Reset the stopped events
    schedule.endevents = Dict{Agent,Agent}()
end
