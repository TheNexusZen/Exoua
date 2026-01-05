local Prefab = {}
Prefab.__index = Prefab

local Read = require("exoua.read")
local Write = require("exoua.write")
local Image = require("exoua.types.image")
local Object = require("exoua.types.object")

function Prefab.new(prefab_id, prefab_image_data, items)
    return setmetatable({
        prefab_id = prefab_id or 0,
        prefab_image_data = prefab_image_data,
        items = items or {},
    }, Prefab)
end

function Prefab.read(reader)
    local prefab_id = Read.i32(reader)
    local prefab_image_data = Image.read(reader)
    local items = Read.array(reader, Object.read)
    return Prefab.new(prefab_id, prefab_image_data, items)
end

function Prefab:write(writer)
    Write.i32(writer, self.prefab_id)
    self.prefab_image_data:write(writer)
    Write.array(writer, self.items, function(w, obj)
        obj:write(w)
    end)
end

return Prefab
