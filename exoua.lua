local exoua = {}

function exoua.level(meta)
  local lvl = {
    metadata = meta,
    objects = {}
  }

  function lvl:platform(x, y, w, h)
    table.insert(self.objects, {
      type = "platform",
      x = x, y = y, w = w, h = h
    })
  end

  function lvl:spike(x, y)
    table.insert(self.objects, {
      type = "spike",
      x = x, y = y
    })
  end

  function lvl:export()
    return {
      metadata = self.metadata,
      objects = self.objects
    }
  end

  return lvl
end

return exoua
