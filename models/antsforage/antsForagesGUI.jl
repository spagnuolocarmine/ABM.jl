using ABM
using Revise
using Distributions
using BenchmarkTools
using Base
include("ants.jl")

using Pkg
Pkg.add("Plots")
using Plots
Pkg.add("PyPlot") # Install a different backend # Switch to using the PyPlot.jl backend

using PyPlot
pyplot()


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
width = 10
height = 10
neighborhood_distance = 10

global field = Field2D(width,height,neighborhood_distance/10,false)

global afd = AntsForageData()

#coordinates HOME
global const HOME_X = 2
global const HOME_Y = 2

#coordinates FOOD
global const FOOD_X = 8
global const FOOD_Y = 8


#POINT HOME AND FOOD
posHome = Real2D(HOME_X, HOME_Y)
posFood = Real2D(FOOD_X, FOOD_Y)

afd.locationGrid[posHome.x, posHome.y] = afd.HOME
afd.locationGrid[posFood.x, posFood.y] = afd.FOOD

# for x = 40:80
#     for y = 70:80
#         afd.obstacleGrid[x, y] = 1
#     end
#
# end

# patchHome = Patch(afd.HOME)
# patchFood = Patch(afd.FOOD)

# setObjectLocation!(field, patchHome, posHome)
# setObjectLocation!(field, patchFood, posFood)



numAnts = 3

addfield!(simstate,field)

pos = Real2D(HOME_X, HOME_Y)

for i in 1:numAnts
    a = AntData("Ant", pos, afd.afReward, false, posHome)
    ant = Agent(fstep,a)
    setObjectLocation!(field, ant, pos)
    scheduleRepeating!(myschedule,ant)
end

function simulateGraphics!(schedule::Schedule, nsteps::Int64)
    f(x, y) = afd.toHomeGrid[x, y]
    mp4(@animate(for i = 1:nsteps
        # println("[",schedule.steps,"] time: ",schedule.time)

        field = schedule.simstate.fields[length(schedule.simstate.fields)]
        points = collect(getAllObjects(field))
        #println("fino a qua ci arrivo")
        x = []
        #println("pure qua ci arrivo")
        y = []
        #println("sono quasi al for")
        foodx = []
        foody = []

        obstaclex = []
        obstacley = []

        homex = []
        homey = []

        locationx = []
        locationy = []

        for j = 1:length(points)
            push!(x, points[j].x)
            push!(y, points[j].y)
        end

        for v = 1:width
            for w = 1:height
                if afd.toFoodGrid[v, w] != 0
                    push!(foodx, v)
                    push!(foody, w)
                end

                if afd.toHomeGrid[v, w] != 0
                    push!(homex, v)
                    push!(homey, w)
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

        # for k = 1:length(x)
        #     println("sono uscito: $(x[k]) e $(y[k])")
        # end

        # f(x, y) = afd.toHomeGrid[x, y]
        # if length(homex) != 0 && length(homey) != 0
        #     histogram2d(homex, homey, weights = map(f, homex, homey),xlims = (0, width), ylim = (0, height), size = (800, 800), legend =false)
        # end

        scatter!(homex, homey, marker_z=((x, y)->begin
                            x + y
                        end),
            xlims = (0, width), ylim = (0, height), size = (800, 800), legend =false)
            println("prova")

        scatter!(foodx, foody, shape = :square, color = :yellow, markersize = 3,
            xlims = (0, width), ylim = (0, height), size = (800, 800), legend =false)

        scatter!(obstaclex, obstacley, shape = :square, color = :orange, markersize = 3,
            xlims = (0, width), ylim = (0, height), size = (800, 800), legend =false)

        scatter!(locationx, locationy, shape = :square, color = :pink, markersize = 10,
            xlims = (0, width), ylim = (0, height), size = (800, 800), legend =false)

        scatter!(x, y, shape = :circle, color = :red, markersize = 5,
            xlims = (0, width), ylim = (0, height), size = (800, 800), legend =false)

         # gui()

        #println("ho anche stampato")

        step!(schedule)

        #println("step complet")
    end), "ants18.mp4", fps = 30)
end

@time  simulateGraphics!(myschedule,10);
