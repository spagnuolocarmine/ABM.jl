pos1 = Float2D(1.0,1.0)
pos2 = Float2D(1.0,1.0)
pos3 = Float2D(10.0,10.0)

@test (pos1 - pos2) == Float2D(0.0,0.0)
@test (pos1 + pos2) == Float2D(2.0,2.0)
@test pos1 == pos2

@test toroidal(Float2D(11.2,11.2),10.0,10.0) == Float2D(1.2,1.2)

@test toroidal(Float2D(11.2,11.2),10.0,10.0) != Float2D(1.3,1.3)

@test toroidal(Float2D(11.2,11.2),3.0,3.0) == Float2D(2.2,2.2)

@test distance(Float2D(1.0,1.0), Float2D(1.0,5.0), 10.0, 10.0, false) == 4.0

@test distance(Float2D(1.0,1.0), Float2D(1.0,5.0), 10.0, 10.0, true) == 4.0

@test distance(Float2D(1.0,1.0), Float2D(1.0,5.0), 4.0, 4.0, true) == 0.0
