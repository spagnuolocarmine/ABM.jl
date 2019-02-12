import Base:  ==, hash
"""
    Agent()
"""
struct Agent
    step::Function
    state::Any
    id::String
end
Agent(step::Function,data::Any) = Agent(step,data,string(UUIDs.uuid4(random())))

function ==(agent1::Agent, agent2::Agent)
    agent1.id==agent2.id
end

function hash(agent::Agent, h::UInt)
    hash(agent.id, h)
end
