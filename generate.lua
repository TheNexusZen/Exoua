package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local binary  = require("exoua.binary")
local writer  = require("exoua.writer")
local sections = require("exoua.sections")

local function write_section(f, id, fn)
    local buf = {}
    local mf = {
        write = function(_, s) table.insert(buf, s) end
    }

    fn(mf)

    local data = table.concat(buf)

    binary.write_u32(f, id)
    binary.write_u32(f, #data)
    f:write(data)
end

local f = assert(io.open("test.exolvl", "wb"))

-- =====================
-- LOCAL_LEVEL
-- =====================
write_section(f, sections.LOCAL_LEVEL, function(w)

    writer.string(w, "00000000-0000-0000-0000-000000000001")
    writer.i32(w, os.time())
    writer.i32(w, os.time())

end)

-- =====================
-- LEVEL
-- =====================
write_section(f, sections.LEVEL, function(w)

    writer.i32(w, 1024)
    writer.i32(w, 1024)

    writer.i32(w, 0)
    writer.i32(w, 0)

    writer.i32(w, 0)

    -- layers
    writer.list(w, {
        { id = 0, name = "Layer 1", visible = true, locked = false }
    }, function(layer)

        writer.i32(w, layer.id)
        writer.string(w, layer.name)
        writer.bool(w, layer.visible)
        writer.bool(w, layer.locked)

    end)

    -- objects (must exist)
    writer.list(w, {}, function() end)

    -- scripts
    writer.list(w, {}, function() end)

end)

f:close()
print("Generated test.exolvl")
