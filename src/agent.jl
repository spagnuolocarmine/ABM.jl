import Base:  ==, hash
"""
    Agent()
"""
mutable struct Agent
    step::Function
    state::Any
    id::String
    stop::Bool
    function Agent(step::Function,data::Any)
        agent = new(step, data)
        agent.id = string(UUIDs.uuid4(random()))
        agent.stop = false
        return agent
    end
end

function ==(agent1::Agent, agent2::Agent)
    agent1.id==agent2.id
end

function hash(agent::Agent, h::UInt)
    hash(agent.id, h)
end

function stop!(agent::Agent)
    agent.stop = true
end
