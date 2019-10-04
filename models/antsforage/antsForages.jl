using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("ants.jl")

mutable struct AntsForageData
    HOME::Int8
    FOOD::Int8
    updateCutDown::Float64
    diagonalCutDown::Float64
    evaporationConstant::Float64
    momentumProbability::Float64
    randomActionProbability::Float64
    afReward::Float64

    IMPOSSIBLY_BAD_PHEROMONE::Float16
    LIKELY_MAX_PHEROMONE::Float16

    toFoodGrid
    toHomeGrid

    AntsForageData() = new(1, 2, 0.9, 0.9^√2, 0.999, 0.8, 0.1, 1.0, -1, 3, zeros(Int64, convert(Int, height), convert(Int, width)), zeros(Int64, convert(Int, height), convert(Int, width)))

end


simstate = SimState()
myschedule = Schedule(simstate)
width = 150
height = 150
neighborhood_distance = 10

global field = Field2D(width,height,neighborhood_distance/1.5,false)

global afd = AntsForageData()

#coordinates HOME
global const HOME_X = 15
global const HOME_Y = 15

#coordinates FOOD
global const FOOD_X = width - 15
global const FOOD_Y = height - 15

#POINT HOME AND FOOD
posHome = Real2D(HOME_X, HOME_Y)
posFood = Real2D(FOOD_X, FOOD_Y)

patchHome = Patch(afd.HOME)
patchFood = Patch(afd.FOOD)

setObjectLocation!(field, patchHome, posHome)
setObjectLocation!(field, patchFood, posFood)

numAnts = 10000
step = 10
addfield!(simstate,field)

pos = Real2D(HOME_X, HOME_Y)


for i in 1:numAnts
    a = AntData("Ant", pos, afd.afReward, false, posHome)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)
end

output = @timed  simulate!(myschedule,step);
time = output[2];

println("time: $time, step/s: $(step/time)");
9
