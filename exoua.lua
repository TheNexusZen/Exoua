local exoua = {}

-- Create a new level with metadata
function exoua.level(meta)
  local self = {
    metadata = meta or {},
    objects = {}
  }

  -- Internal function to add objects
  local function add_object(type_name, props)
    if not props then
      error("Props cannot be nil for object type: " .. type_name)
    end
    
    props.type = type_name
    table.insert(self.objects, props)
    return self  -- Enable method chaining
  end

  -- Add terrain object
  function self:terrain(props)
    return add_object("terrain", props)
  end

  -- Add killer object (spikes, hazards, etc.)
  function self:killer(props)
    return add_object("killer", props)
  end

  -- Add platform object
  function self:platform(props)
    return add_object("platform", props)
  end

  -- Add checkpoint
  function self:checkpoint(props)
    return add_object("checkpoint", props)
  end

  -- Add finish line
  function self:finish(props)
    return add_object("finish", props)
  end

  -- Add start position
  function self:start(props)
    return add_object("start", props)
  end

  -- Generic object adder
  function self:object(type_name, props)
    return add_object(type_name, props)
  end

  -- Export level data in a format Rust can consume
  function self:export()
    return {
      metadata = self.metadata,
      objects = self.objects
    }
  end

  -- Export as JSON string (if json library is available)
  function self:to_json()
    local json = require("json")
    return json.encode(self:export())
  end

  return self
end

-- Helper function to create position table
function exoua.pos(x, y, z)
  return {
    x = x or 0,
    y = y or 0,
    z = z or 0
  }
end

-- Helper function to create size table
function exoua.size(width, height, depth)
  return {
    width = width or 1,
    height = height or 1,
    depth = depth or 1
  }
end

-- Helper function to create color table
function exoua.color(r, g, b, a)
  return {
    r = r or 255,
    g = g or 255,
    b = b or 255,
    a = a or 255
  }
end

return exoua
