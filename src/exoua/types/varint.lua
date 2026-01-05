local Varint = {}
Varint.__index = Varint

function Varint.new(value)
    return setmetatable({
        value = value or 0
    }, Varint)
end

function Varint.read(reader)
    local result = 0
    local shift = 0

    while true do
        local byte = reader:read_u8()
        result = result | ((byte & 0x7F) << shift)

        if (byte & 0x80) == 0 then
            break
        end

        shift = shift + 7
    end

    return Varint.new(result)
end

function Varint:write(writer)
    local value = self.value

    while true do
        local byte = value & 0x7F
        value = value >> 7

        if value ~= 0 then
            byte = byte | 0x80
        end

        writer:write_u8(byte)

        if value == 0 then
            break
        end
    end
end

return Varint
