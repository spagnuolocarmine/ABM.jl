using Plots

pyplot(leg = false)

mp4(@animate(for i=1:100
    x = rand(i)
    y = rand(i)

    scatter!(x, y, marker_z=((x, y)->begin
                        x + y
                    end), color=:bluesreds, legend=false)

end), "prova.mp4", fps = 30)
