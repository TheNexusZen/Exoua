local varint = {}

function varint.read(f)
    local shift = 0
    local result = 0

    while true do
        local b = string.byte(f:read(1))
        result = result | ((b & 0x7F) << shift)
        if (b & 0x80) == 0 then break end
        shift = shift + 7
    end

    if result & 1 ~= 0 then
        result = -(result >> 1) - 1
    else
        result = result >> 1
    end

    return result
end

function varint.write(f, n)
    local v
    if n < 0 then
        v = ((-n - 1) << 1) | 1
    else
        v = n << 1
    end

    while true do
        local b = v & 0x7F
        v = v >> 7
        if v ~= 0 then
            f:write(string.char(b | 0x80))
        else
            f:write(string.char(b))
            break
        end
    end
end

return varint
