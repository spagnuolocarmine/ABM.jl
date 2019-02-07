export Priority
import Base: +, -, ==, <, <=, hash

struct Priority<:Real
    time::Float64
    priority::UInt
end

"""
    PriorityTime(time)
Construct `PriorityTime` with `priority` randomly generated using `rand()`.
"""

Priority(time::Float64) = Priority(time, rand(UInt))


function +(x::Priority, y::Priority)
    Priority(x.time+y.time, x.priority+y.priority)
end

function -(x::Priority, y::Priority)
    Priority(x.time-y.time, x.priority-y.priority)
end

# we define lexicographic order on PriorityTime
# where both objectives are maximized and time is more important
function ==(x::Priority, y::Priority)
    x.time==y.time && x.priority==y.priority
end

function <(x::Priority, y::Priority)
    x.time < y.time && return true
    x.time == y.time && x.priority < y.priority && return true
    return false
end

function <=(x::Priority, y::Priority)
    x.time < y.time && return true
    x.time == y.time && x.priority <= y.priority && return true
    return false
end

function hash(x::Priority, h::UInt)
    hash((x.time, x.priority), h)
end
