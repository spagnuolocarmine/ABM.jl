using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("ants.jl")


simstate = SimState()
myschedule = Schedule(simstate)
width = 150
height = 150
neighborhood_distance = 0.1

global field = Field2D(width,height,neighborhood_distance/1.5,false)

#coordinates HOME
global const HOME_X = 15.0
global const HOME_Y = 15.0

#coordinates FOOD
global const FOOD_X = width - 15.0
global const FOOD_Y = height - 15.0

#values PHEROMONE
global const IMPOSSIBLY_BAD_PHEROMONE = -1
global const LIKELY_MAX_PHEROMONE = 3

#POINT HOME AND FOOD
posHome = Real2D(HOME_X, HOME_Y)
posFood = Real2D(FOOD_X, FOOD_Y)

#MATRICES
toFoodGrid = zeros(Int64, height, width)
toHomeGrid = zeros(Int64, height, width)

#values SITES
global const HOME = 1
global const FOOD = 2

patchHome = Patch(HOME)
patchFood = Patch(FOOD)

setObjectLocation!(field, patchHome, posHome)
setObjectLocation!(field, patchFood, posFood)

numAnts = 10000
evaporationConstant = 0.999
afReward = 1.0
updateCutDown = 0.9
diagonalCutDown = updateCutDown^√2

#PROBABILITY
momentumProbability = 0.8
randomActionProbability = 0.1

addfield!(simstate,field)

pos = Real2D(HOME_X, HOME_Y)
initialReward = 0.0

for i in 1:numAnts
    a = AntData("Ant", pos, initialReward, false)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)
end

@time  simulate!(myschedule,10);
