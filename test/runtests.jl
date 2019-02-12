using ABM
using Test
using DataStructures
using Distributed
using DistributedArrays

const testdir = dirname(@__FILE__)

#addprocs(4)


tests = [
    "priority",
    "schedule",
    "field2d",
    "agent",
    "real2d"
]

@testset "ABM" begin
    for t in tests
        tp = joinpath(testdir, "test-$(t).jl")
        include(tp)
    end
end
