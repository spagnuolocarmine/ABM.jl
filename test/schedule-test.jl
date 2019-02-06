function b(state::Union{SimState, Nothing}, agent::Agent)
    print(string(agent.id,"\n"))
end


a1 = Agent(b,nothing)
a2 = Agent(b,nothing)
a3 = Agent(b,nothing)

schedule = Schedule()
