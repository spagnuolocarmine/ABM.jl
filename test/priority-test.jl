
queue = PriorityQueue{String,Priority}()
time = 0.0

enqueue!(queue, "1", Priority(time))
enqueue!(queue, "2", Priority(time))
enqueue!(queue, "3", Priority(time+2))

x = dequeue!(queue)
@test (x== "1" || x == "2")
y = dequeue!(queue)
@test (y== "1" || y == "2")
@test dequeue!(queue) == "3"

enqueue!(queue, "4", Priority(time,1))
enqueue!(queue, "5", Priority(time,0))

@test dequeue!(queue) == "5"
@test dequeue!(queue) == "4"
