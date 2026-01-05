local binary = require("exoua.binary")

local reader = {}

function reader.bool(f) return binary.read_bool(f) end
function reader.i32(f) return binary.read_i32(f) end
function reader.string(f) return binary.read_string(f) end
function reader.list(f, fn) return binary.read_list(f, fn) end

return reader
