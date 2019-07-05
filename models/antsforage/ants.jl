using ABM
using Revise
using Distributions
using BenchmarkTools

simstate = SimState()
myschedule = Schedule(simstate)
width = 150.0
height = 150.0
neighborhood_distance = 0

global field = Field2D(width,height,neighborhood_distance/1.5,true)


#coordinates HOME
global const HOME_X = 15.0
global const HOME_Y = 15.0

#coordinates FOOD
global const FOOD_X = 135.0
global const FOOD_Y = 135.0

#POINT HOME AND FOOD
pointHome = Real2D(HOME_X, HOME_Y)
pointFood = Real2D(FOOD_X, FOOD_Y)

#MATRICES
toFoodGrid = zeros(height, width)
toHomeGrid = zeros(height, width)

updateCutDown = 0.9
diagonalCutDown = updateCutDown^√2

addfield!(simstate,field)

function depositPheromone(state::SimState, agent::Agent)

    location :: Real2D = getObjectLocation(field, agent)


    x = location.x
    y = location.y

    if hasFoodItem
        max = tofoodgrid[x, y]
        for dx = -1:1
            for dy = -1:1
                _x = dx + x
                _y = dy + y

                if _x < 0 || _y < 0 || _x >= width || _y >= height
                    continue
                end

                m = toFoodGrid[_x, _y]
                    *(dx * dy != 0 ?         #diagonal corners
                    diagonalCutDown : updateCutDown) +
                    reward

                if m > max
                    max = m
                end
            end
        end
        toFoodGrid[x, y] = max
    else
        max = toHomeGrid[x, y]
        for dx = -1:1
            for dy = -1:1
                _x = dx + x
                _y = dy + y

                if _x < 0 || _y < 0 || _x >= width || _y >= height
                    continue
                end

                m = toHomeGrid[_x, _y]
                    *(dx * dy != 0 ?         #diagonal corners
                    diagonalCutDown : updateCutDown) +
                    reward

                if m > max
                    max = m
                end
            end
        end
        toHomeGrid[x, y] = max
    end

    reward = 0.0
end

function act()
    #body
end


function fstep(state::SimState, agent::Agent)
    depositPheromone(state, agent)
    act(state)
end


mutable struct AntData
    name::String
    pos::Real2D
    reward::Float64
    hasFoodItem::Bool

end


pos = Real2D(HOME_X, HOME_Y)
initialReward = 0.0
for i in 1:10000
    a = AntData("Ant", pos, initialReward, false)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)
end

@time  simulate!(myschedule,10);