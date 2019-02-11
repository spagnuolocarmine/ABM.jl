function fstep(state::Union{SimState, Nothing}, agent::Agent) end
struct Data
    pos::Real2D
end

d1 = Data(Real2D(1.0,1.0))
d2 = Data(Real2D(2.0,2.0))

a1 = Agent(fstep,d1)
a2 = Agent(fstep,d2)

@test a1 != a2

a3 = deepcopy(a2)

@test pointer_from_objref(a2) != pointer_from_objref(a3)

@test a1.state.pos != a3.state.pos
@test a2.state.pos == a3.state.pos

@test a1 != a2
@test a2 == a3

@test a1.id != a2.id
@test a1.id != a3.id
@test a2.id == a3.id
