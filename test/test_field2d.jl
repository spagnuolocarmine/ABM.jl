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

@test length(getAllObjects(f)) == 2

remove!(f,a1)

@test length(getAllObjects(f)) == 1

clear!(f)

@test length(getAllObjects(f)) == 0

setObjectLocation!(f,a1,Float2D(1.0,1.0))
setObjectLocation!(f,a2,Float2D(1.0,1.399999))

@test length(getObjectsAtLocation(f,Float2D(1.0,1.0))) == 2
#swapState!(f)
