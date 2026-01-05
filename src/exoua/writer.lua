local binary = require("exoua.binary")

local writer = {}

function writer.bool(f, v) binary.write_bool(f, v) end
function writer.i32(f, v) binary.write_i32(f, v) end
function writer.string(f, v) binary.write_string(f, v) end
function writer.list(f, l, fn) binary.write_list(f, l, fn) end

return writer
