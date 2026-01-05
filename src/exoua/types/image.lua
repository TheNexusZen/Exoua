local Image = {}
Image.__index = Image

function Image.new(data)
    return setmetatable({
        data = data or ""
    }, Image)
end

function Image:write(writer)
    writer:write_string(self.data)
end

function Image.read(reader)
    return Image.new(reader:read_string())
end

return Image
