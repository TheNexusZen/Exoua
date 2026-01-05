local Read = require("exoua.read")
local Write = require("exoua.write")

local UUID = {}
UUID.__index = UUID

function UUID.new(bytes)
    return setmetatable({ bytes = bytes }, UUID)
end

function UUID.read(r)
    local b = {}
    for i = 1, 16 do
        b[i] = Read.u8(r)
    end
    return UUID.new(b)
end

function UUID:write(w)
    for i = 1, 16 do
        Write.u8(w, self.bytes[i])
    end
end

return UUID
