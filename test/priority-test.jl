
queue = PriorityQueue{String,Priority}()


enqueue!(queue, "1"=>Priority(2.0))
enqueue!(queue, "2"=>Priority(2.0))
enqueue!(queue, "3"=>Priority(4.0))

x = dequeue!(queue)

@test (x== "1" || x == "2")
y = dequeue!(queue)

@test (y== "1" || y == "2")
@test dequeue!(queue) == "3"

enqueue!(queue, "4", Priority(5,1))
enqueue!(queue, "5", Priority(5,0))

@test dequeue!(queue) == "5"
@test dequeue!(queue) == "4"
