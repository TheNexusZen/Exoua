local exoua = {}

local Level = {}
Level.__index = Level

function exoua.level(meta)
  local self = setmetatable({}, Level)
  self.metadata = meta or {}
  self.objects = {}
  return self
end

local function push(self, kind, props)
  local obj = { type = kind }
  if props then
    for k, v in pairs(props) do
      obj[k] = v
    end
  end
  table.insert(self.objects, obj)
end

function Level:terrain(props)
  push(self, "terrain", props)
end

function Level:killer(props)
  push(self, "killer", props)
end

function Level:object(kind, props)
  push(self, kind, props)
end

function Level:export()
  return {
    metadata = self.metadata,
    objects = self.objects
  }
end

return exoua
