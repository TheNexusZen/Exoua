local api = require("lua.api")

local objects = {}

function objects.platform(x, y, w, h)
  api.add({
    kind = "platform",
    x = x,
    y = y,
    w = w,
    h = h
  })
end

function objects.spike(x, y)
  api.add({
    kind = "spike",
    x = x,
    y = y
  })
end

function objects.player(x, y)
  api.add({
    kind = "player",
    x = x,
    y = y
  })
end

return objects
