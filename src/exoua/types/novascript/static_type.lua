local Read = require("exoua.read")
local Write = require("exoua.write")

local StaticType = {
    Bool        = 0,
    Int         = 1,
    Float       = 2,
    String      = 3,
    Color       = 4,
    Vector      = 5,
    Sound       = 6,
    Music       = 7,
    Object      = 8,
    ObjectSet   = 9,
    Transition  = 10,
    Easing      = 11,
    Sprite      = 12,
    Script      = 13,
    Layer       = 14,
}

-- Reverse lookup (number → enum key)
local FROM_INT = {}
for k, v in pairs(StaticType) do
    FROM_INT[v] = k
end

function StaticType.read(input)
    local value = Read.read(input)
    if FROM_INT[value] == nil then
        error("InvalidStaticType: " .. tostring(value))
    end
    return value
end

function StaticType.write(output, value)
    Write.write(output, value)
end

return StaticType
