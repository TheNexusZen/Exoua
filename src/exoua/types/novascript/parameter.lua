local Read = require("exoua.read")
local Write = require("exoua.write")

local NovaValue = require("exoua.types.novascript.nova_value")
local StaticType = require("exoua.types.novascript.static_type")

local Parameter = {}
Parameter.__index = Parameter

function Parameter.new(parameter_id, name, static_type, default_value)
    return setmetatable({
        parameter_id = parameter_id,
        name = name,
        static_type = static_type,
        default_value = default_value,
    }, Parameter)
end

function Parameter.read(input)
    local parameter_id = Read.read(input)
    local name = Read.read(input)
    local static_type = Read.read(input)
    local default_value = Read.read(input)

    return Parameter.new(
        parameter_id,
        name,
        static_type,
        default_value
    )
end

function Parameter:write(output)
    Write.write(output, self.parameter_id)
    Write.write(output, self.name)
    Write.write(output, self.static_type)
    Write.write(output, self.default_value)
end

return Parameter
