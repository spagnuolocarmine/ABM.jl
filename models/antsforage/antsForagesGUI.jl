using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("ants.jl")
include("mersenneTwisterFast.jl")
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

    IMPOSSIBLY_BAD_PHEROMONE::Float16
    LIKELY_MAX_PHEROMONE::Float16

    toFoodGrid
    toHomeGrid

    locationGrid
    obstacleGrid

    AntsForageData() = new(1, 2, 0.9, 0.9^√2, 0.999, 0.80, 0.10, 1.0, -1, 3, zeros(Int64, convert(Int, height), convert(Int, width)),
     zeros(Int64, convert(Int, height), convert(Int, width)), zeros(Int64, convert(Int, height), convert(Int, width)), zeros(Int64, convert(Int, height), convert(Int, width)))

end


simstate = SimState()
myschedule = Schedule(simstate)
width = 200
height = 200
neighborhood_distance = 10

global field = Field2D(width,height,neighborhood_distance/10,false)

global afd = AntsForageData()

#coordinates HOME
global const HOME_X = 175
global const HOME_Y = 175

#coordinates FOOD
global const FOOD_X = 25
global const FOOD_Y = 25


#POINT HOME AND FOOD
posHome = Real2D(HOME_X, HOME_Y)
posFood = Real2D(FOOD_X, FOOD_Y)

afd.locationGrid[posHome.x, posHome.y] = afd.HOME
afd.locationGrid[posFood.x, posFood.y] = afd.FOOD

for x = 1:120
    for y = 150:160
        afd.obstacleGrid[x, y] = 1
    end
end

for x = 120:200
    for y = 50:60
        afd.obstacleGrid[x, y] = 1
    end
end

numAnts = 100

addfield!(simstate,field)

pos = Real2D(HOME_X, HOME_Y)

for i in 1:numAnts
    a = AntData("Ant", pos, afd.afReward, false, posHome)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)
end

function simulateGraphics!(schedule::Schedule, nsteps::Int64)
    mp4(@animate(for i = 1:nsteps

        field = schedule.simstate.fields[length(schedule.simstate.fields)]
        points = collect(getAllObjects(field))

        x = []
        y = []

        foodx1 = []
        foody1 = []

        obstaclex = []
        obstacley = []

        homex1 = []
        homey1 = []

        locationx = []
        locationy = []

        for j = 1:length(points)
            push!(x, points[j].x)
            push!(y, points[j].y)
        end

        for v = 1:width
            for w = 1:height
                if  afd.toFoodGrid[v, w] != 0
                    push!(foodx1, v)
                    push!(foody1, w)
                end

                if  afd.toHomeGrid[v, w] != 0
                    push!(homex1, v)
                    push!(homey1, w)
                end

                if afd.locationGrid[v, w] != 0
                    push!(locationx, v)
                    push!(locationy, w)
                end

                if afd.obstacleGrid[v, w] != 0
                    push!(obstaclex, v)
                    push!(obstacley, w)
                end
            end
        end

        scatter(homex1, homey1, shape = :square, markeralpha = 1, markerstrokewidth = 0, color = :blue, markersize = 3,
            xlims = (0, width), ylim = (0, height), size = (800, 450), legend =false)

        scatter!(foodx1, foody1, shape = :square, markeralpha = 1, markerstrokewidth = 0, color = :yellow, markersize = 3,
            xlims = (0, width), ylim = (0, height), size = (800, 450), legend =false)

        scatter!(obstaclex, obstacley, shape = :square, color = :orange, markersize = 3, markerstrokewidth = 0,
            xlims = (0, width), ylim = (0, height), size = (800, 450), legend =false)

        scatter!(locationx, locationy, shape = :square, color = :pink, markersize = 10,
            xlims = (0, width), ylim = (0, height), size = (800, 450), legend =false)

        scatter!(x, y, shape = :circle, color = :red, markersize = 5,
            xlims = (0, width), ylim = (0, height), size = (800, 450), legend =false)

         # gui()

        step!(schedule)

    end), "ants.mp4", fps = 30)
end

@time  simulateGraphics!(myschedule,1800);
