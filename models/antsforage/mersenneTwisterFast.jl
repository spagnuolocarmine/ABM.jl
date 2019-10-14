using ABM
using Revise
using Base

global const N = 624
global const M = 397

global const UPPER_MASK = 0x80000000
global const LOWER_MASK = 0x7fffffff

global const TEMPERING_MASK_B = 0x9d2c5680
global const TEMPERING_MASK_B = 0x9d2c5680

mt = []
mti
mag01 = []

function nextBoolean(probability::Float64)
    y::Int32 = 0
    z::Int32 = 0

    if probability < 0.0 || probability > 1.0
        return
    end

    if probability == 0.0
        return false
    elseif probability == 1.0
        return true
    end

    if mti >= N
        kk::Int32 = 0
        mtLocal = mt
        mag01Local = mag01

        for kk = 0:(N-M)
            y = (mtLocal[kk] & UPPER_MASK) | (mtLocal[kk+1] & LOWER_MASK)
            mtLocal[kk] = mtLocal[kk+M] ⊻ (y >>> 1) ⊻ mag01Local[y & 0x1]
        end

        for kk2 = kk:(N-1)
            y = (mtLocal[kk2] & UPPER_MASK) | (mtLocal[kk2+1] & LOWER_MASK)
            mtLocal[kk2] = mtLocal[kk2+(M-N)] ⊻ (y >>> 1) ⊻ mag01Local[y & 0x1]
        end

        y = (mtLocal[N-1] & UPPER_MASK) | (mtLocal[0] & LOWER_MASK)
        mtLocal[N-1] = mtLocal[M-1] ⊻ (y >>> 1) ⊻ mag01Local[y & 0x1]

        mti = 0
    end

    y = mt[mti+=1];
    y ⊻= y >>> 11
    y ⊻= (y << 7) & TEMPERING_MASK_B
    y ⊻= (y << 15) & TEMPERING_MASK_C
    y ⊻= (y >>> 18)

    if mti >= N
        kk::Int32 = 0
        mtLocal = mt
        mag01Local = mag01

        for kk = 0:(N-M)
            z = (mtLocal[kk] & UPPER_MASK) | (mtLocal[kk+1] & LOWER_MASK)
            mtLocal[kk] = mtLocal[kk+M] ⊻ (z >>> 1) ⊻ mag01Local[z & 0x1]
        end

        for kk2 = kk:(N-1)
            z = (mtLocal[kk2] & UPPER_MASK) | (mtLocal[kk2+1] & LOWER_MASK)
            mtLocal[kk2] = mtLocal[kk2+(M-N)] ⊻ (z >>> 1) ⊻ mag01Local[z & 0x1]
        end

        z = (mtLocal[N-1] & UPPER_MASK) | (mtLocal[0] & LOWER_MASK)
        mtLocal[N-1] = mtLocal[M-1] ⊻ (z >>> 1) ⊻ mag01Local[z & 0x1]

        mti = 0
    end

    z = mt[mti+=1];
    z ⊻= z >>> 11
    z ⊻= (z << 7) & TEMPERING_MASK_B
    z ⊻= (z << 15) & TEMPERING_MASK_C
    z ⊻= (z >>> 18)

    return (((y >>> 6) << 27) + (z >>> 5)) / (1 << 53) < probability
end
