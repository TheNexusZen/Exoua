local M = {}

function M.read_ctx(reader, tag)
    return tag:read_ctx(reader)
end

function M.write_ctx(writer, value)
    return value:write(writer)
end

return M
