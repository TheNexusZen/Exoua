local Invocation = {}
Invocation.__index = Invocation

local InvocationParam = {}
InvocationParam.__index = InvocationParam

function Invocation.new(id, params)
    return setmetatable({
        id = id,
        params = params or {}
    }, Invocation)
end

function Invocation.read(reader)
    return Invocation.new(
        reader:read_i32(),
        reader:read_array(InvocationParam.read)
    )
end

function Invocation:write(writer)
    writer:write_i32(self.id)
    writer:write_array(self.params, function(p) p:write(writer) end)
end

function InvocationParam.new(id, value)
    return setmetatable({
        id = id,
        value = value
    }, InvocationParam)
end

function InvocationParam.read(reader)
    return InvocationParam.new(
        reader:read_i32(),
        reader:read_nova_value()
    )
end

function InvocationParam:write(writer)
    writer:write_i32(self.id)
    self.value:write(writer)
end

return {
    Invocation = Invocation,
    InvocationParam = InvocationParam
}
