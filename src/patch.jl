import Base:  ==, hash
"""
    Patch()
"""
mutable struct Patch{T}
    state::T
    id::UUID
    Patch(data::T, rng::AbstractRNG=Random.GLOBAL_RNG) where T = new{T}(data,UUIDs.uuid4(rng))
end

function ==(patch1::Patch, patch2::Patch)
    patch1.id==patch2.id
end

function hash(patch::Patch, h::UInt)
    hash(patch.id, h)
end
