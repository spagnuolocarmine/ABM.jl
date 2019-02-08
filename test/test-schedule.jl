struct memory
    name::String
end

function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.data.name," ",agent.id,"\n"))
end

a1 = Agent(fstep,memory("Bob"))
a2 = Agent(fstep,memory("Alice"))
a3 = Agent(fstep,memory("Kraken"))

schedule = Schedule()

scheduleOnce!(schedule,a1)
@test a1.stop == true
scheduleRepeating!(schedule,a2,1)
@test a2.stop == false
scheduleRepeating!(schedule,a3,4.0)
@test a3.stop == false

for i = 1:5
    #println("step ",i)
    step!(nothing, schedule)
end
