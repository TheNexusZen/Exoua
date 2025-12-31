local exoua = {}

function exoua.level(meta)
  local self = {
    metadata = meta or {},
    objects = {}
  }

  local function add_object(type_name, props)
    props.type = type_name
    table.insert(self.objects, props)
  end

  function self:terrain(props)
    add_object("terrain", props)
  end

  function self:killer(props)
    add_object("killer", props)
  end

  function self:object(type_name, props)
    add_object(type_name, props)
  end

  function self:export()
    return {
      metadata = self.metadata,
      objects = self.objects
    }
  end

  return self
end

return exoua
