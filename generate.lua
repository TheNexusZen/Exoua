package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local binary   = require("exoua.binary")
local writer   = require("exoua.writer")
local sections = require("exoua.sections")

local f = assert(io.open("test.exolvl", "wb"))

-- =========================
-- LOCAL_LEVEL SECTION
-- =========================
sections.write(f, sections.LOCAL_LEVEL, function()

    writer.string(f, "00000000-0000-0000-0000-000000000001")
    writer.i32(f, os.time())
    writer.i32(f, os.time())

end)

-- =========================
-- LEVEL SECTION
-- =========================
sections.write(f, sections.LEVEL, function()

    writer.i32(f, 1024) -- width
    writer.i32(f, 1024) -- height

    writer.i32(f, 0) -- origin x
    writer.i32(f, 0) -- origin y

    writer.i32(f, 0) -- active layer index

    -- layers
    writer.list(f, {
        {
            id = 0,
            name = "Layer 1",
            visible = true,
            locked = false,
        }
    }, function(layer)

        writer.i32(f, layer.id)
        writer.string(f, layer.name)
        writer.bool(f, layer.visible)
        writer.bool(f, layer.locked)

    end)

    -- objects (empty but REQUIRED)
    writer.list(f, {}, function() end)

    -- scripts (empty)
    writer.list(f, {}, function() end)

end)

f:close()

print("Generated test.exolvl")
