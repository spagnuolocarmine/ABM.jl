using ABM
using Revise
using Base

global const N = 625
global const M = 397

global const UPPER_MASK = 0x80000000
global const LOWER_MASK = 0x7fffffff
global const MATRIX_A = 0x9908b0df

global const TEMPERING_MASK_B = 0x9d2c5680
global const TEMPERING_MASK_C = 0xefc60000



global mt = []

global mag01 = []

seed = trunc(Int, rand()*2135454343)


function setSeed(seed::Int64)

    push!(mag01, 0x0)
    push!(mag01, MATRIX_A)
    push!(mt, (seed & 0xffffffff))

    mtiLocal = 0
    mti = 2

    while mti <= N
        push!(mt, (1812433253 * (mt[mti-1] ⊻ (mt[mti-1] >>> 30)) + mti))
         mtiLocal = mti
         mti += 1
    end
    return mtiLocal-1
end

global mtiGlobal = setSeed(seed)



function nextBoolean(probability::Float64)
    y::Int64 = 0
    z::Int64 = 0
    mtiLocal = mtiGlobal

    if probability < 0.0 || probability > 1.0
        return
    end

    if probability == 0.0
        return false
    elseif probability == 1.0
        return true
    end

    if mtiLocal > N
        kk = 1
        mtLocal = mt
        mag01Local = mag01

        while kk < (N-M)+1
            y = (mtLocal[kk] & UPPER_MASK) | (mtLocal[kk+1] & LOWER_MASK)
            mtLocal[kk] = mtLocal[kk+M] ⊻ (y >>> 1) ⊻ mag01Local[y & 0x1]
            kk += 1
        end
        kk2 = kk
        while kk2 < N
            y = (mtLocal[kk2] & UPPER_MASK) | (mtLocal[kk2+1] & LOWER_MASK)
            mtLocal[kk2] = mtLocal[kk2+(M-N)] ⊻ (y >>> 1) ⊻ mag01Local[y & 0x1]
            kk2 += 1
        end

        y = (mtLocal[N-1] & UPPER_MASK) | (mtLocal[0] & LOWER_MASK)
        mtLocal[N-1] = mtLocal[M-1] ⊻ (y >>> 1) ⊻ mag01Local[y & 0x1]

        mtiLocal = 0
    end

    y = mt[mtiLocal]
    mtiLocal+=1
    y ⊻= y >>> 11
    y ⊻= (y << 7) & TEMPERING_MASK_B
    y ⊻= (y << 15) & TEMPERING_MASK_C
    y ⊻= (y >>> 18)

    if mtiLocal > N
        kk = 0
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

        mtiLocal = 0
    end

    z = mt[mtiLocal]
    mtiLocal+=1
    z ⊻= z >>> 11
    z ⊻= (z << 7) & TEMPERING_MASK_B
    z ⊻= (z << 15) & TEMPERING_MASK_C
    z ⊻= (z >>> 18)

    return (((y >>> 6) << 27) + (z >>> 5)) / (1 << 53) < probability
end
