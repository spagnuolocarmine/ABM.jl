using ABM
#create schedule and others stuff
sim1=SimState()

field1 = @field2d 200 200
#net = @network

struct data
    x::Float64
    y::Float64
end

function one1()
    println("hello")
end
function two2()
    println("world")
end

function step_function(sim1)
    list=field1.getNeighbors(10)
    one1()
    two2()
end

for i in 1:10
    a = @agent data(rand(1:100),rand(1:100)) _s
    field1.place(a,a.x,a.y)
    @schedule_repeting sim1 a

@display on
@simulate sim1 100 #parallel
