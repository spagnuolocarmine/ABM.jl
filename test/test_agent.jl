function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.id,"\n"))
end

a1 = Agent(fstep,nothing)
a2 = Agent(fstep,nothing)

@test a1 != a2

a3 = deepcopy(a2)

@test pointer_from_objref(a2) != pointer_from_objref(a3)
