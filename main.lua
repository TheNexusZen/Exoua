local exoua = require("exoua")

local lvl = {
  metadata = {
    name = "Test Level",
    author = "Exoua",
    version = 1
  },

  objects = {
    {
      type = "terrain",
      pos = { x = 0, y = 0 },
      size = { w = 5, h = 1 },
      color = "FFFFFFFF"
    },
    {
      type = "killer",
      pos = { x = 3, y = 1 }
    }
  }
}

return lvl
