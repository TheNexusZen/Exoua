local ReadContext = require("exoua.read_context")

local ActionType = {}
ActionType.__index = ActionType

function ActionType.new(id, value)
    return setmetatable({
        id = id,
        value = value
    }, ActionType)
end

function ActionType.read(reader)
    local id = reader:i32()
    return ReadContext.read_ctx(reader, ActionType.new(id))
end

function ActionType:read_ctx(reader)
    self.value = reader:any()
    return self
end

function ActionType:write(writer)
    writer:i32(self.id)
    self.value:write(writer)
end

return ActionType
