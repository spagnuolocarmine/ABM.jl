import Base:  ==, hash
"""
    Agent()
"""
struct Agent{T}
    step::Function
    state::T
    id::UUID
end
Agent(step::Function, data::T, rng::AbstractRNG=Random.GLOBAL_RNG) where T = Agent{T}(step, data, UUIDs.uuid4(rng))

function ==(agent1::Agent, agent2::Agent)
    agent1.id==agent2.id
end

function hash(agent::Agent, h::UInt)
    hash(agent.id, h)
end
