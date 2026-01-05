local uuid = {}


function uuid.random()
    local bytes = {}

    for i = 1, 16 do
        bytes[i] = string.char(math.random(0, 255))
    end

    
    bytes[7]  = string.char((bytes[7]:byte() & 0x0F) | 0x40) 
    bytes[9]  = string.char((bytes[9]:byte() & 0x3F) | 0x80) 

    return table.concat(bytes)
end

return uuid
