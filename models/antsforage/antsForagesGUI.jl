using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("ants.jl")

using Pkg
Pkg.add("Plots")
using Plots
Pkg.add("PyPlot") # Install a different backend
pyplot() # Switch to using the PyPlot.jl backend

mutable struct AntsForageData
    HOME::Int8
    FOOD::Int8
    updateCutDown::Float64
    diagonalCutDown::Float64
    evaporationConstant::Float64
    momentumProbability::Float64
    randomActionProbability::Float64
    afReward::Float64

    IMPOSSIBLY_BAD_PHEROMONE::Int8
    LIKELY_MAX_PHEROMONE::Int8

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

#values PHEROMONE
"""global const IMPOSSIBLY_BAD_PHEROMONE = -1
global const LIKELY_MAX_PHEROMONE = 3"""

#POINT HOME AND FOOD
posHome = Real2D(HOME_X, HOME_Y)
posFood = Real2D(FOOD_X, FOOD_Y)

#MATRICES
"""toFoodGrid = zeros(Int64, height, width)
   toHomeGrid = zeros(Int64, height, width)"""

#values SITES
"""global const HOME = 1
global const FOOD = 2"""

patchHome = Patch(afd.HOME)
patchFood = Patch(afd.FOOD)

setObjectLocation!(field, patchHome, posHome)
setObjectLocation!(field, patchFood, posFood)

numAnts = 10
"""evaporationConstant = 0.999
afReward = 1.0
updateCutDown = 0.9
diagonalCutDown = updateCutDown^√2"""

#PROBABILITYS
"""momentumProbability = 0.8
randomActionProbability = 0.1"""

addfield!(simstate,field)

pos = Real2D(HOME_X, HOME_Y)
initialReward = 0.0



    #gr(show = true) # in IJulia this would be: gr(show = :ijulia)       ROBA GRAFICA



for i in 1:numAnts
    a = AntData("Ant", pos, initialReward, false, posHome)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)



        #v = getAllObjects(field)

        #x = 1; y = 10;

        #display(plot(x,y))


end

function simulateGraphics!(schedule::Schedule, nsteps::Int64)
    @gif for i = 1:nsteps
        println("[",schedule.steps,"] time: ",schedule.time)

        field = schedule.simstate.fields[length(schedule.simstate.fields)]
        points = collect(getAllObjects(field))
        println("fino a qua ci arrivo")
        x = []
        println("pure qua ci arrivo")
        y = []
        println("sono quasi al for")
        for j = 1:length(points)
            push!(x, points[j].x)
            push!(y, points[j].y)
        end

        println("sono uscito: $x e $y")

        scatter!(x, y, shape = :star5, color = :black,
     markersize = 10)

        println("ho anche stampato jee")

        step!(schedule)

        println("step complet")
    end every 1
end


@time  simulateGraphics!(myschedule,10);