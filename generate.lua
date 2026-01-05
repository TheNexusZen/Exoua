package.path = "src/?.lua;src/?/init.lua;" .. package.path

local Writer = require("exoua.writer")
local Sections = require("exoua.sections")

local Level = require("exoua.types.level")
local LocalLevel = require("exoua.types.local_level")
local Metadata = require("exoua.types.metadata")
local Theme = require("exoua.types.theme")

local NovaAction = require("exoua.types.novascript.nova_action")
local Action = require("exoua.types.novascript.action")
local ActionType = require("exoua.types.novascript.action_type")
local NovaValue = require("exoua.types.novascript.nova_value")
local DynamicType = require("exoua.types.dynamic_type")

local level = Level({
    metadata = Metadata({
        name = "Generated Level",
        author = "Exoua",
        description = "Generated via Lua",
    }),
    theme = Theme.Mountains,
    local_level = LocalLevel({
        actions = {
            NovaAction({
                trigger = 0,
                actions = {
                    Action({
                        closed = false,
                        wait = false,
                        action_type = ActionType.Wait({
                            duration = NovaValue.new_float(DynamicType.Float, 1.0)
                        })
                    })
                }
            })
        }
    })
})

local file = assert(io.open("test.exolvl", "wb"))
local writer = Writer(file)

Sections.write_all(writer, level)

file:close()
