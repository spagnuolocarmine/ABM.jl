function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.id,"\n"))
end

a1 = Agent(fstep,nothing)
a2 = Agent(fstep,nothing)
a3 = Agent(fstep,nothing)

schedule = Schedule()

scheduleOnce!(schedule,a1)
@test a1.stop == true
scheduleRepeating!(schedule,a2)
@test a2.stop == false
scheduleRepeating!(schedule,a3)
@test a3.stop == false

for i = 1:4
    #println("step ",i)
    step!(nothing, schedule)
end
