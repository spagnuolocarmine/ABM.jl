using ABM

struct memory
    a::Int32
end

simulation = SimState()
f = Float2D(2.0,2.0)
f2 = Float2D(2.6,2.6)
f3 = Float2D(2.6,3.2)
m1 = memory(2)

function b(state::SimState, agent::Agent)
    print(string("Hello from agent:",agent.id))
end
a1 = Agent(b,m1)
a2 = Agent(b,m1)
a3 = Agent(b,m1)

field = @field2d 100 100
field.place(f,a1)
field.place(f2,a2)
field.place(f3,a3)
field.getNeighbors(f)

field.update(f3,a2)
field.swap()
field.getNeighbors(f3)

behavior!(simulation,a1)
a2.behavior(simulation,a2)
a3.behavior(simulation,a3)
