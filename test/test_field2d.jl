function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.id,"\n"))
end

a1 = Agent(fstep,nothing)
a2 = Agent(fstep,nothing)

f = Field2D(100,100,0.7,true)

setObjectLocation!(f,a1,Float2D(10.5,10.0))

@test getObjectLocation(f,a1) == Float2D(10.5,10.0)

setObjectLocation!(f,a1,Float2D(10.0,10.0))

@test getObjectLocation(f,a1) == Float2D(10.0,10.0)

setObjectLocation!(f,a2,Float2D(11.0,11.0))

@test getObjectLocation(f,a2) == Float2D(11.0,11.0)
