local binary = {}

function binary.read_bool(f)
    return string.byte(f:read(1)) ~= 0
end

function binary.write_bool(f, v)
    f:write(string.char(v and 1 or 0))
end

function binary.read_i32(f)
    local b1, b2, b3, b4 = string.byte(f:read(4), 1, 4)
    local n = b1 | (b2 << 8) | (b3 << 16) | (b4 << 24)
    if n >= 0x80000000 then n = n - 0x100000000 end
    return n
end

function binary.write_i32(f, v)
    v = v or 0
    if v < 0 then v = v + 0x100000000 end
    binary.write_u32(f, v)
end

function binary.read_string(f)
    local len = binary.read_i32(f)
    if len < 0 then return nil end
    return f:read(len)
end

function binary.write_string(f, s)
    if not s then
        binary.write_i32(f, -1)
        return
    end
    binary.write_i32(f, #s)
    f:write(s)
end

function binary.read_list(f, read_fn)
    local len = binary.read_i32(f)
    if len < 0 then return nil end
    local t = {}
    for i = 1, len do
        t[i] = read_fn(f)
    end
    return t
end

function binary.write_list(f, list, write_fn)
    if not list then
        binary.write_i32(f, -1)
        return
    end
    binary.write_i32(f, #list)
    for i = 1, #list do
        write_fn(f, list[i])
    end
end

return binary
