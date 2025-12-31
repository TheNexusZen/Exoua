local objects = require("lua.objects")
local api = require("lua.api")

objects.player(0, 0)

objects.platform(0, -2, 6, 0.5)
objects.platform(8, -1, 4, 0.5)

objects.spike(4, -1.5)

return api.export()
