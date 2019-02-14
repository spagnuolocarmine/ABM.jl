struct Memory
    name::String
end

function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.state.name," ",agent.id,"\n"))
    #println(state.fields)
end

a1 = Agent(fstep,Memory("Bob"))
a2 = Agent(fstep,Memory("Alice"))
a3 = Agent(fstep,Memory("Kraken"))

schedule = Schedule(SimState())

scheduleOnce!(schedule,a1)

scheduleRepeating!(schedule,a2;ordering=1)

scheduleRepeating!(schedule,a3,4.0)


for i = 1:4
    #println("step ",i)
    step!(schedule)
end
