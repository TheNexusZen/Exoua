local exoua = require("exoua")

local lvl = exoua.level{
  name = "test",
  author = "me",
  version = 1
}

lvl:terrain{
  pos = { x = 0, y = 0 }
}

lvl:killer{
  pos = { x = 3, y = 1 }
}

return lvl:export()
