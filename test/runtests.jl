using ABM

struct memory
    a::Int32
end

f = Float2D(2.0,2.0)
f2 = Float2D(2.6,2.6)
f3 = Float2D(2.6,3.2)
m1 = memory(2)

function b(state::SimState, agent::Agent)
    print("hello from " + agent.id)
end
a1 = Agent(b,m1, Base.Random.uuid4())
a2 = Agent(b,m1, Base.Random.uuid4())
a3 = Agent(b,m1, Base.Random.uuid4())

field = @field2d 100 100
field.place(f,a1)
field.place(f2,a2)
field.place(f3,a3)
field.getNeighbors(f)
