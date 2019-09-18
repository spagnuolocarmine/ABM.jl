using ABM
using Revise
using Distributions
using BenchmarkTools
using Parameters

function depositPheromone(state::SimState, agent::Agent)

    currentfield = state.fields[length(state.fields)]
    location :: Real2D = agent.state.pos

    x::Int64 = location.x
    y::Int64 = location.y

    if agent.state.hasFoodItem
        max = afd.toFoodGrid[x, y]
        for dx = -1:1
            for dy = -1:1
                _x = dx + x
                _y = dy + y

                if _x <= 0 || _y <= 0 || _x > currentfield.width || _y > currentfield.height
                    continue
                end

                m = (afd.toHomeGrid[_x, _y]
                    *((dx * dy != 0 ?         #diagonal corners
                    afd.diagonalCutDown : afd.updateCutDown))) +
                    agent.state.reward

                if m > max
                    max = m
                end
            end
        end
        afd.toFoodGrid[x, y] = max
    else
        max = afd.toHomeGrid[x, y]
        for dx = -1:1
            for dy = -1:1
                _x = dx + x
                _y = dy + y

                if _x <= 0 || _y <= 0 || _x > currentfield.width || _y > currentfield.height
                    continue
                end

                m = (afd.toHomeGrid[_x, _y]
                    *((dx * dy != 0 ?         #diagonal corners
                    afd.diagonalCutDown : afd.updateCutDown))) +
                    agent.state.reward

                if m > max
                    max = m
                end
            end
        end
        afd.toHomeGrid[x, y] = max
    end

    agent.state.reward = 0.0
end

function act(state::SimState, agent::Agent)

    currentfield = state.fields[length(state.fields)]
    location :: Real2D = agent.state.pos

    x = location.x
    y = location.y

    if agent.state.hasFoodItem
        max = afd.IMPOSSIBLY_BAD_PHEROMONE
        max_x = x
        max_y = y
        count = 2

        for dx = -1:1
            for dy = -1:1
                _x = dx + x
                _y = dy + y

                if (dx == 0 & dy == 0) ||
                        _x <= 0 || _y <= 0 ||
                        _x > currentfield.width || _y > currentfield.height
                    continue
                end
                m = afd.toHomeGrid[_x, _y]
                if m > max
                    count = 2
                end

                if m > max || (m == max && (rand() < 1.0/(count += 1)))  #RANDOM NON SO SE E' EFFICACE
                    max = m
                    max_x = _x
                    max_y = _y
                end

            end
        end
        if max == 0 && agent.state.lastPos != nothing              #nowhere to go!
            if rand() < afd.momentumProbability                                    #RANDOM NON SO SE E' EFFICACE
                xm = x + (x - agent.state.lastPos.x)
                ym = y + (y - agent.state.lastPos.y)

                if xm > 0 && xm <= currentfield.width && ym > 0 && ym <= currentfield.height     #aggiungere ostacoli in futuro
                    max_x = xm
                    max_y = ym
                end
            end

        elseif rand() < afd.randomActionProbability                        #RANDOM NON SO SE E' EFFICACE
            xd = rand(-1:1)
            yd = rand(-1:1)
            xm = x + xd
            ym = y + yd

            if !(xd == 0 && yd == 0) && xm > 0 && xm <= currentfield.width && ym > 0 && ym <= currentfield.height
                max_x = xm;
                max_y = ym;
            end
        end

        agent.state.pos = Real2D(max_x, max_y)
        setObjectLocation!(currentfield, agent, agent.state.pos)

        objAtLoc = getObjectsAtLocation(currentfield, agent.state.pos)

        for i = 1: length(objAtLoc)
            if objAtLoc[i].state == afd.HOME       #TODO non so se funziona
                println("oggetto: ",objAtLoc[i].state, " HOME: ", afd.HOME)
                agent.state.reward = afd.afReward
                agent.state.hasFoodItem = !agent.state.hasFoodItem
                println("############$(agent.state.hasFoodItem)##########")
            end
        end

    else
        max = afd.IMPOSSIBLY_BAD_PHEROMONE
        max_x = x
        max_y = y
        count = 2

        for dx = -1:1
            for dy = -1:1
                _x::Int64 = dx + x
                _y::Int64 = dy + y

                if (dx == 0 & dy == 0) ||
                        _x <= 0 || _y <= 0 ||
                        _x > currentfield.width || _y > currentfield.height
                    continue
                end
                m = afd.toFoodGrid[_x, _y]
                if m > max
                    count = 2
                end
                if m > max || (m == max && (rand() < 1.0/(count += 1)))
                    max = m
                    max_x = _x
                    max_y = _y
                end

            end
        end
        if max == 0 && agent.state.lastPos != nothing              #nowhere to go!
            if rand() < afd.momentumProbability
                xm = x + (x - agent.state.lastPos.x)
                ym = y + (y - agent.state.lastPos.y)

                if xm > 0 && xm <= currentfield.width && ym > 0 && ym <= currentfield.height     #aggiungere ostacoli in futuro
                    max_x = xm
                    max_y = ym
                end
            end

        elseif rand() < afd.randomActionProbability
            xd = rand(-1:1)
            yd = rand(-1:1)
            xm = x + xd
            ym = y + yd
            if !(xd == 0 && yd == 0) && xm > 0 && xm <= currentfield.width && ym > 0 && ym <= currentfield.height
                max_x = xm;
                max_y = ym;
            end
        end
        agent.state.pos = Real2D(max_x, max_y)
        setObjectLocation!(currentfield, agent, agent.state.pos)

        objAtLoc = getObjectsAtLocation(currentfield, agent.state.pos)

        for i = 1: length(objAtLoc)
            if objAtLoc[i].state == afd.FOOD
                println("oggetto: ",objAtLoc[i].state, " FOOD: ", afd.FOOD)
                agent.state.reward = afd.afReward
                agent.state.hasFoodItem = !agent.state.hasFoodItem
            end
        end
    end
    agent.state.lastPos = location
end


function fstep(state::SimState, agent::Agent)

    #afd = AntsForageData()

    afd.toFoodGrid *= afd.evaporationConstant
    afd.toHomeGrid *= afd.evaporationConstant

    depositPheromone(state::SimState, agent::Agent)
    act(state::SimState, agent::Agent)
end


mutable struct AntData
    name::String
    pos::Real2D
    reward::Float16
    hasFoodItem::Bool
    lastPos::Real2D
    #AntData(name, pos, reward, hasFoodItem) = new(name, pos, reward, hasFoodItem)

end


"""simstate = SimState()
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

#values PHEROMONE
global const IMPOSSIBLY_BAD_PHEROMONE = -1
global const LIKELY_MAX_PHEROMONE = 3

#POINT HOME AND FOOD
pointHome = Real2D(HOME_X, HOME_Y)
pointFood = Real2D(FOOD_X, FOOD_Y)

#MATRICES
toFoodGrid = zeros(height, width)
toHomeGrid = zeros(height, width)

updateCutDown = 0.9
diagonalCutDown = updateCutDown^√2

addfield!(simstate,field)"""


"""pos = Real2D(HOME_X, HOME_Y)
initialReward = 0.0
for i in 1:10000
    a = AntData("Ant", pos, initialReward, false)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)
end

@time  simulate!(myschedule,10);"""
