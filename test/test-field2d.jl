function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.id,"\n"))
end

a1 = Agent(fstep,nothing)
a2 = Agent(fstep,nothing)

f = Field2D(100,100,0.7,true)

setObjectLocation!(f,a1,Real2D(10.5,10.0))
swapState!(f)
@test getObjectLocation(f,a1) == Real2D(10.5,10.0)

setObjectLocation!(f,a1,Real2D(10.0,10.0))
swapState!(f)
@test getObjectLocation(f,a1) == Real2D(10.0,10.0)

setObjectLocation!(f,a2,Real2D(11.0,11.0))
swapState!(f)
@test getObjectLocation(f,a2) == Real2D(11.0,11.0)

@test length(getAllObjects(f)) == 2


clean!(f)

@test length(getAllObjects(f)) == 0

setObjectLocation!(f,a1,Real2D(1.0,1.0))
setObjectLocation!(f,a2,Real2D(1.0,1.399999))
swapState!(f)
@test length(getObjectsAtLocation(f,Real2D(1.0,1.0))) == 1

setObjectLocation!(f,a1, getObjectLocation(f,a2))
swapState!(f)
@test getObjectLocation(f,a1) == Real2D(1.0,1.399999)

@test length(getObjectsAtLocation(f, getObjectLocation(f,a1))) == 2

@test numObjectsAtLocation(f, getObjectLocation(f,a1)) == 2

f2 = Field2D(10.0,10.0,0.5,false)

pos = Real2D(5.2,5.2)
__distance = 3.0

setObjectLocation!(f2,Patch(nothing),Real2D(5.5,5.5))
setObjectLocation!(f2,Patch(nothing),Real2D(4.0,4.0))
setObjectLocation!(f2,Patch(nothing),Real2D(5.2,5.2))
setObjectLocation!(f2,Patch(nothing),Real2D(5.2,2.2))
setObjectLocation!(f2,Patch(nothing),Real2D(5.2,2.1))
swapState!(f2)
@test length(getNeighborsWithinDistance(f2, pos , __distance)) == 4

setObjectLocation!(f2,Patch(nothing),Real2D(0.1,0.1))
__distance = 5.0

@test length(getNeighborsWithinDistance(f2, pos , __distance)) == 5


f3 = Field2D(10.0,10.0,0.5,true)

pos = Real2D(8.1,8.1)
__distance = 3.0

setObjectLocation!(f3,Patch(nothing),Real2D(7.0,8.1))
setObjectLocation!(f3,Patch(nothing),Real2D(8.1,1.0))
setObjectLocation!(f3,Patch(nothing),Real2D(8.1,1.3))
setObjectLocation!(f3,Patch(nothing),Real2D(8.1,9.9))
swapState!(f3)
@test length(getNeighborsWithinDistance(f3, pos , __distance)) == 3

f4 = Field2D(10.0,10.0,0.6,true)

setObjectLocation!(f4,Patch(nothing),Real2D(7.0,8.1))
setObjectLocation!(f4,Patch(nothing),Real2D(8.1,1.0))
setObjectLocation!(f4,Patch(nothing),Real2D(8.1,1.3))
setObjectLocation!(f4,Patch(nothing),Real2D(8.1,9.9))
swapState!(f4)
@test length(getNeighborsWithinDistance(f4, pos , __distance)) == 3

setObjectLocation!(f4,Patch(nothing),Real2D(1.0,9.7))
swapState!(f4)
@test length(getNeighborsWithinDistance(f4, pos , __distance)) == 3

setObjectLocation!(f4,Patch(nothing),Real2D(1.1,8.1))
swapState!(f4)
@test length(getNeighborsWithinDistance(f4, pos , __distance)) == 4

@test length(getNeighborsWithinDistance(f4,  Real2D(0.1,5.0) , __distance)) == 0


setObjectLocation!(f4,Patch(nothing),Real2D(9.9,2.1))
setObjectLocation!(f4,Patch(nothing),Real2D(2.9,4.5))
swapState!(f4)
@test length(getNeighborsWithinDistance(f4,  Real2D(0.1,5.0) , __distance)) == 2

setObjectLocation!(f4,Patch(nothing),Real2D(2.9,8.0))
swapState!(f4)
@test length(getNeighborsWithinDistance(f4,  Real2D(0.1,5.0) , __distance)) == 2

@test length(getNeighborsWithinDistance(f4,  Real2D(0.1,5.0) , 5.0)) == 9


f5 = Field2D(10.0,10.0,0.6,true)
p1 = Patch(nothing)

setObjectLocation!(f5,p1,Real2D(6.0,6.0))#STEP 0 AGENT i
swapState!(f5)#END STEP 0
@test length(getNeighborsWithinDistance(f5,  Real2D(5.0,5.0) , 2.0)) == 1 #STEP 1 AGENT j
setObjectLocation!(f5,p1,Real2D(8.0,8.0))#STEP 1 AGENT i
@test length(getNeighborsWithinDistance(f5,  Real2D(5.0,5.0) , 2.0)) == 1 #STEP 1 AGENT j
swapState!(f5)#END STEP 1
@test length(getNeighborsWithinDistance(f5,  Real2D(5.0,5.0) , 2.0)) == 0 #STEP 2 AGENT j
