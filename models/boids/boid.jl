using ABM
using Revise
using Distributions
using BenchmarkTools
using Parameters

mutable struct BoidData
    pos::Real2D
    isDead::Bool
    lastPos::Real2D

    BoidData(location::Real2D) = new(location, false, Real2D(0, 0))
end

function getNeighbors(field::Field2D, boids::BoidsData)
    return field.getNeighborsWithinDistance()
end

function getOrientation()
    if lastPos.x == 0 && lastPos.y == 0
        return 0
    end

    return atan(lastPos.y, lastPos.x)
end

function setOrientation(boid::BoidData, val)
    boids.lastPos = Real2D(cos(val), sin(val))
end

function fstep(state::SimState, agent::Agent)

    thisBoid = agent.state
    field = state.fields[length(state.fields)]

    if thisBoid.isDead
        return
    end

    neighbors = getNeighbors()

    avoid = avoidance(neighbors, field)
    cohe = cohesion(neighbors, field)
    rand = randomness()
    
end
