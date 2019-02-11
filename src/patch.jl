import Base:  ==, hash
"""
    Patch()
"""
mutable struct Patch
    state::Any
    id::String
    function Patch(data::Any)
        patch = new(data)
        patch.id = string(UUIDs.uuid4(random()))
        return patch
    end
end

function ==(patch1::Patch, patch2::Patch)
    patch1.id==patch2.id
end

function hash(patch::Patch, h::UInt)
    hash(patch.id, h)
end
