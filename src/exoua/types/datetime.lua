local Read = require("exoua.read")
local Write = require("exoua.write")

local DateTime = {}
DateTime.__index = DateTime

function DateTime.new(value)
    return setmetatable({ value = value }, DateTime)
end

function DateTime.read(r)
    return DateTime.new(Read.i64(r))
end

function DateTime:write(w)
    Write.i64(w, self.value)
end

return DateTime
