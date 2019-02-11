using ABM
using Test
using DataStructures
using Distributed

const testdir = dirname(@__FILE__)

#addprocs(4);

tests = [
    "priority",
    "schedule",
    "field2d",
    "agent",
    "real2d"
]

@testset "ABM" begin
    for t in tests
        tp = joinpath(testdir, "test-$(t).jl")
        include(tp)
    end
end

"""
simulation = SimState()

struct memory
    pos::Float2D
end
f = Float2D(2.0,2.0)
f2 = Float2D(2.6,2.6)
f3 = Float2D(2.6,3.2)
m1 = memory(f)
m2 = memory(f2)
m3 = memory(f3)
field = @field2d 100 100

function b(state::SimState, agent::Agent)
    ##sleep(rand(1:2))
    n = ndims(field.getNeighbors(agent.data.pos))
    print(string("Hello from agent:",agent.id," ",n,"\n"))
end
a1 = Agent(b,m1)
a2 = Agent(b,m2)
a3 = Agent(b,m3)


field.place(f,a1)
field.place(f2,a2)
field.place(f3,a3)
field.getNeighbors(f)

field.update(f3,a2)
field.swap()
field.getNeighbors(f3)

simulation.addField(field)

simulation.schedule.scheduleRepeating(a1)
simulation.schedule.scheduleRepeating(a2)
simulation.schedule.scheduleRepeating(a3)

simulate!(simulation,10)
"""
