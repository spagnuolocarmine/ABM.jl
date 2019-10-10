using Pkg
Pkg.add("Plots")
using Plots
Pkg.add("PyPlot") # Install a different backend # Switch to using the PyPlot.jl backend

using PyPlot
pyplot()

pyplot(leg = false)

    i = 2

    x = rand(i)
    y = rand(i)

    w = rand(i)
    z= rand(i)
    scatter(x, y, shape = :square, markeralpha = 0.1, markerstrokewidth = 0, color= :blue, legend =false)
    scatter!(w, z, shape = :square, markeralpha = 0.5, markerstrokewidth = 0, color= :yellow, legend =false)
