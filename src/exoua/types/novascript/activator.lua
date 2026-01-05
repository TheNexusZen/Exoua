local Read = require("exoua.read")
local Write = require("exoua.write")
local NovaValue = require("exoua.types.novascript.nova_value")

local Activator = {}
Activator.__index = Activator

function Activator.new(activator_type, parameters)
    return setmetatable({
        activator_type = activator_type,
        parameters = parameters,
    }, Activator)
end

function Activator.read(input)
    local activator_type = Read.read(input)
    local parameters = Read.read(input) -- Vec<NovaValue>

    return Activator.new(activator_type, parameters)
end

function Activator:write(output)
    Write.write(output, self.activator_type)
    Write.write(output, self.parameters)
end

return Activator
