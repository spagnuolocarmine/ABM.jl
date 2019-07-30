using ABM
using Revise
using Distributions
using BenchmarkTools
using Base

mutable struct BoidData
    pos::Real2D
    isDead::Bool
    lastPos::Real2D

    BoidData(location::Real2D) = new(location, false, Real2D(0, 0))
end

function getNeighbors(field::Field2D, boid::BoidData)
    boids = BoidsData()
    return getNeighborsWithinDistance(field, boid.pos, boids.neighborhood_distance)
end

function getOrientation(boid::BoidData)
    if boid.lastPos.x == 0 && boid.lastPos.y == 0
        return 0
    end

    return atan(lastPos.y, lastPos.x)
end

function setOrientation(boid::BoidData, val)
    boids.lastPos = Real2D(cos(val), sin(val))
end

function consistency(neighbors, field::Field2D)
    if neighbors == nothing || length(neighbors) == 0
        return Real2D(0, 0)
    end

    x = 0
    y = 0
    i = 0
    count = 0

    for i = 1:length(neighbors)
        otherBoid = neighbors[i].state

        if !otherBoid.isDead
            m = otherBoid.lastPos
            count += 1
            x += m.x
            y += m.y
        end
    end

    if count > 0
        x /= count
        y /= count
    end
    return Real2D(x, y)
end

function cohesion(neighbors, field::Field2D, thisBoid::BoidData)
    if neighbors == nothing || length(neighbors) == 0
        return Real2D(0, 0)
    end

    x = 0
    y = 0
    i = 0
    count = 0

    for i = 1:length(neighbors)
        otherBoid = neighbors[i].state

        if !otherBoid.isDead
            dx = abs(thisBoid.pos.x - otherBoid.pos.x)      #TODO MANCA TOROIDAL
            dy = abs(thisBoid.pos.y - otherBoid.pos.y)
            count += 1
            x += dx
            y += dy
        end
    end

    if count > 0
        x /= count
        y /= count
    end
    return Real2D(-x/10, -y/10)
end

function avoidance(neighbors, field::Field2D, thisBoid:: BoidData)
    if neighbors == nothing || length(neighbors) == 0
        return Real2D(0, 0)
    end

    x = 0
    y = 0
    i = 0
    count = 0

    for i = 1:length(neighbors)
        otherBoid = neighbors[i].state

        if otherBoid != thisBoid
            dx = abs(thisBoid.pos.x - otherBoid.pos.x)      #TODO MANCA TOROIDAL
            dy = abs(thisBoid.pos.y - otherBoid.pos.y)
            lensquared = dx*dx+dy*dy
            count += 1
            x += dx/(lensquared*lensquared + 1)
            y += dy/(lensquared*lensquared + 1)
        end
    end

    if count > 0
        x /= count
        y /= count
    end
    return Real2D(400*x, 400*y)
end

function randomness()
    x = rand() * 2 - 1.0
    y = rand() * 2 - 1.0

    l = √(x*x + y*y)

    return Real2D(0.05*x / l, 0.05*y / l)
end

function fstep(state::SimState, agent::Agent)

    boids = BoidsData()
    thisBoid = agent.state
    field = state.fields[length(state.fields)]

    if thisBoid.isDead
        return
    end

    neighbors = getNeighbors(field, thisBoid)

    avoid = avoidance(neighbors, field, thisBoid)
    cohe = cohesion(neighbors, field, thisBoid)
    rand = randomness()
    cons = consistency(neighbors, field)
    mome = thisBoid.lastPos

    dx = boids.cohesion * cohe.x + boids.avoidance * avoid.x + boids.consistency * cons.x + boids.randomness * rand.x + boids.momentum * mome.x
    dy = boids.cohesion * cohe.y + boids.avoidance * avoid.y + boids.consistency * cons.y + boids.randomness * rand.y + boids.momentum * mome.y

    dis = √(dx*dx + dy*dy)
    if dis > 0
        dx = dx / dis * boids.jump
        dy = dy / dis * boids.jump
    end

    thisBoid.lastPos = Real2D(dx, dy)
    thisBoid.pos = Real2D(tTransform(thisBoid.pos.x + dx, field.width), tTransform(thisBoid.pos.y + dy, field.height))                          #TODO COMPLETARE
    setObjectLocation!(field, agent, thisBoid.pos)
end
