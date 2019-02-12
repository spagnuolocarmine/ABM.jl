struct memory
    name::String
end

function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.state.name," ",agent.id,"\n"))
    println(state.fields)
end

a1 = Agent(fstep,memory("Bob"))
a2 = Agent(fstep,memory("Alice"))
a3 = Agent(fstep,memory("Kraken"))

schedule = Schedule(SimState())

scheduleOnce!(schedule,a1)

scheduleRepeating!(schedule,a2,1)

scheduleRepeating!(schedule,a3,4.0)


for i = 1:4
    #println("step ",i)
    step!(schedule)
end
