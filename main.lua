local exoua = require("exoua")

-- Create a new level with metadata
local lvl = exoua.level{
  name = "Test Level",
  author = "Nexus",
  version = 1
}

-- Add terrain object
lvl:terrain{
  pos = { x = 0, y = 0 }
}

-- Add killer object
lvl:killer{
  pos = { x = 3, y = 1 }
}

-- Export the level data
local level_data = lvl:export()

-- Print as JSON for Rust to consume
local json = require("json")
print(json.encode(level_data))

return level_data
