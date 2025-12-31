local exoua = require("exoua")

local lvl = exoua.level{
  name = "test",
  author = "me",
  version = 1
}

lvl:terrain{
  pos = { x = 0, y = 0 },
  scale = { x = 5, y = 1 },
  color = "FFFFFF00"
}

lvl:killer{
  pos = { x = 3, y = 1 }
}

local f = io.open("level.json", "w")
f:write(json.encode(lvl:export()))
f:close()
