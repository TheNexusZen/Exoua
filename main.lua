local level = {
  metadata = {
    name = "test",
    author = "exoua",
    version = 1
  },
  objects = {}
}

local function add(obj)
  level.objects[#level.objects + 1] = obj
end

add({
  type = "terrain",
  pos = { x = 0, y = 0 },
  scale = { x = 5, y = 1 },
  color = "FFFFFF00"
})

add({
  type = "killer",
  pos = { x = 3, y = 1 }
})

return level
