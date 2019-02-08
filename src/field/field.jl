"""
Class of fields defined by the abstract concept of Field.
"""
abstract type Field end


"""
Utility function for toroidal euclidian field.
"""
function tx(width::Number, x::Number)
    if (x >= 0 && x < width)  return x end
    x = x % width
    if (x < 0) x = x + width end
    return x
end
"""
Utility function for toroidal euclidian field.
"""
function ty(height::Number, x::Number)
    if (x >= 0 && x < height)  return x end
    x = x % height
    if (x < 0) x = x + height end
    return x
end
