using ABM
using Random
using Distributions
mutable struct BoidData
    name::String
    pos::Real2D
    orientation::Real2D
end
function fstep(state::SimState, agent::Agent)
end
pos = Real2D(rand(Uniform(0, 100)), rand(Uniform(0, 100)))
d = BoidData("Boid", pos, Real2D(rand(Uniform(0, 100)),rand(Uniform(0, 100))))
a = Agent(fstep,d)


dict1 = Dict{Int64,Int64}()
array1 = Array{Int64,1}()

dict2 = Dict{Agent,Int64}()
array2 = Array{Agent,1}()

set1 = Set{Int64}()
set2 = Set{Agent}()


println("------------------------------")

@time for i in 1:1000000
    pos = Real2D(rand(Uniform(0, 100)), rand(Uniform(0, 100)))
    d = BoidData("Boid", pos, Real2D(rand(Uniform(0, 100)),rand(Uniform(0, 100))))
    a = Agent(fstep,d)
    push!(array2, a)
end

@time for i in 1:1000000
    pos = Real2D(rand(Uniform(0, 100)), rand(Uniform(0, 100)))
    d = BoidData("Boid", pos, Real2D(rand(Uniform(0, 100)),rand(Uniform(0, 100))))
    a = Agent(fstep,d)
    push!(dict2, a=>i)
end


@time for i in 1:1000000
    pos = Real2D(rand(Uniform(0, 100)), rand(Uniform(0, 100)))
    d = BoidData("Boid", pos, Real2D(rand(Uniform(0, 100)),rand(Uniform(0, 100))))
    a = Agent(fstep,d)
    push!(set2, a)
end

@time for x in values(dict2)
end

@time for x in values(set2)
end

@time for x in array2
end
