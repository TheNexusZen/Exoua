local exoua = {}

local Level = {}
Level.__index = Level

function exoua.level(meta)
  return setmetatable({
    metadata = {
      name = meta.name or "unnamed",
      author = meta.author or "unknown",
      version = meta.version or 1
    },
    objects = {}
  }, Level)
end

function Level:add(object_type, data)
  local obj = {
    type = object_type
  }

  if data.position then
    obj.x = data.position.x or 0
    obj.y = data.position.y or 0
  end

  if data.size then
    for k, v in pairs(data.size) do
      obj[k] = v
    end
  end

  if data.scale then
    obj.scaleX = data.scale.x or 1
    obj.scaleY = data.scale.y or 1
  end

  for k, v in pairs(data) do
    if k ~= "position" and k ~= "size" and k ~= "scale" then
      obj[k] = v
    end
  end

  table.insert(self.objects, obj)
end

function Level:terrain(data)
  self:add("terrain", data)
end

function Level:killer(data)
  self:add("killer", data)
end

function Level:object(object_type, data)
  self:add(object_type, data)
end

function Level:export()
  return {
    metadata = self.metadata,
    objects = self.objects
  }
end

return exoua
