local Theme = {}
Theme.__index = Theme

local Read = require("exoua.read")
local Write = require("exoua.write")

Theme.Mountains = "mountains"
Theme.Halloween = "halloween"
Theme.Christmas = "christmas"
Theme.Custom = "custom"

function Theme.default()
    return Theme.Mountains
end

function Theme.read(reader)
    local value = Read.string(reader)
    if value == Theme.Mountains
        or value == Theme.Halloween
        or value == Theme.Christmas
        or value == Theme.Custom
    then
        return value
    end
    error("InvalidTheme: " .. tostring(value))
end

function Theme.write(writer, value)
    Write.string(writer, value)
end

return Theme
