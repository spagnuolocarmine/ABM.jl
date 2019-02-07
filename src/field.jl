
#Abstract type of a position in the space
abstract type Position
end

abstract type Field
end

#Location on a space of an agent
struct Location
    pos::Position
    agent::Agent
end
