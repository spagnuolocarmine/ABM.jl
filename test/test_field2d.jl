
function fstep(state::Union{SimState, Nothing}, agent::Agent)
    #print(string(agent.id,"\n"))
end
a1 = Agent(fstep,nothing)

dict = Dict{String,Agent}()

dict["one"] = a1
