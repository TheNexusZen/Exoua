package.path = "./src/?.lua;./src/?/init.lua;" .. package.path

local binary = require("exoua.binary")
local writer = require("exoua.writer")

local SECTION_LOCAL_LEVEL = 2
local SECTION_LEVEL       = 3

local function write_section(f, id, fn)
    local buf = {}
    local mf = {
        write = function(_, s) buf[#buf + 1] = s end
    }

    fn(mf)

    local data = table.concat(buf)

    binary.write_i32(f, id)
    binary.write_i32(f, #data)
    f:write(data)
end

local f = assert(io.open("test.exolvl", "wb"))

write_section(f, SECTION_LOCAL_LEVEL, function(w)
    writer.string(w, "00000000-0000-0000-0000-000000000001")
    writer.i32(w, os.time())
    writer.i32(w, os.time())
end)

write_section(f, SECTION_LEVEL, function(w)
    writer.i32(w, 1024)
    writer.i32(w, 1024)

    writer.i32(w, 0)
    writer.i32(w, 0)

    writer.i32(w, 0)

    writer.list(w, {
        { id = 0, name = "Layer 1", visible = true, locked = false }
    }, function(layer)
        writer.i32(w, layer.id)
        writer.string(w, layer.name)
        writer.bool(w, layer.visible)
        writer.bool(w, layer.locked)
    end)

    writer.list(w, {}, function() end)
    writer.list(w, {}, function() end)
end)

f:close()
print("Generated test.exolvl")
