local Read = require("exoua.read")
local ReadContext = require("exoua.read_context")
local Write = require("exoua.write")
local ActionType = require("exoua.types.novascript.action_type")

local Action = {}
Action.__index = Action

function Action.new(closed, wait, action_type)
    return setmetatable({
        closed = closed,
        wait = wait,
        action_type = action_type,
    }, Action)
end

function Action.read(input)
    local action_type_id = Read.read(input)

    local closed = Read.read(input)
    local wait = Read.read(input)
    local action_type = ReadContext.read_ctx(input, action_type_id, ActionType)

    return Action.new(closed, wait, action_type)
end

function Action:write(output)
    local action_type_id = self.action_type:to_id()

    Write.write(output, action_type_id)
    Write.write(output, self.closed)
    Write.write(output, self.wait)
    self.action_type:write(output)
end

return Action
