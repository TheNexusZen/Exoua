local Read = require("exoua.read")
local Write = require("exoua.write")

local NovaValue = require("exoua.types.novascript.nova_value")
local StaticType = require("exoua.types.novascript.static_type")

local Variable = {}
Variable.__index = Variable

function Variable.new(variable_id, name, static_type, initial_value)
    return setmetatable({
        variable_id = variable_id,
        name = name,
        static_type = static_type,
        initial_value = initial_value,
    }, Variable)
end

function Variable.read(input)
    return Variable.new(
        Read.read(input),          -- variable_id (i32)
        Read.read(input),          -- name (string)
        StaticType.read(input),    -- static_type
        NovaValue.read(input)      -- initial_value
    )
end

function Variable.write(output, self)
    Write.write(output, self.variable_id)
    Write.write(output, self.name)
    StaticType.write(output, self.static_type)
    NovaValue.write(output, self.initial_value)
end

return Variable
