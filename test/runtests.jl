using ABM
struct memory
    a
end
f = Float2D(2.0,2.0)
f2 = Float2D(2.6,2.6)
f3 = Float2D(2.6,3.2)
m = memory(2)
a1 = @agent m 2x
a2 = @agent m 2x
a3 = @agent m 2x
field = @field2d 100 100
field.place(f,a1)
field.place(f2,a2)
field.place(f3,a3)
field.getNeighbors(f)
