local Read = require("exoua.read")
local Write = require("exoua.write")

local Color = require("exoua.types.color")
local Enums = require("exoua.types.enums")
local DynamicType = Enums.DynamicType
local Vec2 = require("exoua.types.vec2")

local NovaValue = {}
NovaValue.__index = NovaValue

function NovaValue.new(dynamic_type, inner)
    return setmetatable({
        dynamic_type = dynamic_type,
        inner = inner,
    }, NovaValue)
end

-- Constructors (match Rust exactly)

function NovaValue.new_bool(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = value,
        int_value = 0,
        float_value = 0.0,
        string_value = nil,
        color_value = Color.default(),
        vector_value = Vec2.default(),
        int_list_value = nil,
        sub_values = nil,
    })
end

function NovaValue.new_int(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = value,
        float_value = 0.0,
        string_value = nil,
        color_value = Color.default(),
        vector_value = Vec2.default(),
        int_list_value = nil,
        sub_values = nil,
    })
end

function NovaValue.new_float(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = 0,
        float_value = value,
        string_value = nil,
        color_value = Color.default(),
        vector_value = Vec2.default(),
        int_list_value = nil,
        sub_values = nil,
    })
end

function NovaValue.new_string(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = 0,
        float_value = 0.0,
        string_value = value,
        color_value = Color.default(),
        vector_value = Vec2.default(),
        int_list_value = nil,
        sub_values = nil,
    })
end

function NovaValue.new_color(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = 0,
        float_value = 0.0,
        string_value = nil,
        color_value = value,
        vector_value = Vec2.default(),
        int_list_value = nil,
        sub_values = nil,
    })
end

function NovaValue.new_vector(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = 0,
        float_value = 0.0,
        string_value = nil,
        color_value = Color.default(),
        vector_value = value,
        int_list_value = nil,
        sub_values = nil,
    })
end

function NovaValue.new_int_list(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = 0,
        float_value = 0.0,
        string_value = nil,
        color_value = Color.default(),
        vector_value = Vec2.default(),
        int_list_value = value,
        sub_values = nil,
    })
end

function NovaValue.new_sub_values(dynamic_type, value)
    return NovaValue.new(dynamic_type, {
        bool_value = false,
        int_value = 0,
        float_value = 0.0,
        string_value = nil,
        color_value = Color.default(),
        vector_value = Vec2.default(),
        int_list_value = nil,
        sub_values = value,
    })
end

-- Binary IO

function NovaValue.read(input)
    local dynamic_type = Read.read(input)

    local inner = {
        bool_value = Read.read(input),
        int_value = Read.read(input),
        float_value = Read.read(input),
        string_value = Read.read(input),
        color_value = Read.read(input),
        vector_value = Read.read(input),
        int_list_value = Read.read(input),
        sub_values = Read.read(input),
    }

    return NovaValue.new(dynamic_type, inner)
end

function NovaValue:write(output)
    Write.write(output, self.dynamic_type)
    Write.write(output, self.inner.bool_value)
    Write.write(output, self.inner.int_value)
    Write.write(output, self.inner.float_value)
    Write.write(output, self.inner.string_value)
    Write.write(output, self.inner.color_value)
    Write.write(output, self.inner.vector_value)
    Write.write(output, self.inner.int_list_value)
    Write.write(output, self.inner.sub_values)
end

return NovaValue
