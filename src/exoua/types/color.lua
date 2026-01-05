local Color = {}
Color.__index = Color

function Color.new(r, g, b, a)
    return setmetatable({
        r = r or 0.0,
        g = g or 0.0,
        b = b or 0.0,
        a = a or 0.0,
    }, Color)
end

function Color.from_rgba(r, g, b, a)
    return Color.new(r, g, b, a)
end

function Color:to_rgba()
    return self.r, self.g, self.b, self.a
end

return Color
