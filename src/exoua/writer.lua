local binary = require("exoua.binary")

local writer = {}

function writer.bool(f, v)
    binary.write_bool(f, v)
end

function writer.i32(f, v)
    binary.write_i32(f, v)
end

function writer.u32(f, v)
    binary.write_u32(f, v)
end

function writer.string(f, v)
    binary.write_string(f, v)
end

function writer.list(f, l, fn)
    binary.write_list(f, l, fn)
end

function writer.uuid(f, uuid)
    -- already raw 16-byte binary
    if type(uuid) == "string" and #uuid == 16 then
        f:write(uuid)
        return
    end

    -- dashed UUID → hex
    if type(uuid) == "string" then
        local hex = uuid:gsub("-", "")
        assert(#hex == 32, "uuid string must be 32 hex chars")

        local bytes = {}
        for i = 1, 32, 2 do
            bytes[#bytes + 1] = string.char(tonumber(hex:sub(i, i + 1), 16))
        end

        f:write(table.concat(bytes))
        return
    end

    error("invalid uuid format")
end
return writer
