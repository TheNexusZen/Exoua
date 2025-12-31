-- Simple JSON encoder for Lua
local json = {}

local function escape_str(s)
    s = string.gsub(s, "\\", "\\\\")
    s = string.gsub(s, '"', '\\"')
    s = string.gsub(s, "\n", "\\n")
    s = string.gsub(s, "\r", "\\r")
    s = string.gsub(s, "\t", "\\t")
    return s
end

local function encode_value(val, indent, depth)
    local t = type(val)
    
    if t == "nil" then
        return "null"
    elseif t == "boolean" then
        return val and "true" or "false"
    elseif t == "number" then
        return tostring(val)
    elseif t == "string" then
        return '"' .. escape_str(val) .. '"'
    elseif t == "table" then
        -- Check if it's an array or object
        local is_array = true
        local count = 0
        
        for k, v in pairs(val) do
            count = count + 1
            if type(k) ~= "number" or k ~= count then
                is_array = false
                break
            end
        end
        
        if count == 0 then
            return "{}"
        end
        
        local new_depth = depth + 1
        local spacing = indent and ("\n" .. string.rep("  ", new_depth)) or ""
        local end_spacing = indent and ("\n" .. string.rep("  ", depth)) or ""
        
        if is_array then
            local parts = {}
            for i = 1, count do
                table.insert(parts, spacing .. encode_value(val[i], indent, new_depth))
            end
            return "[" .. table.concat(parts, ",") .. end_spacing .. "]"
        else
            local parts = {}
            for k, v in pairs(val) do
                local key = '"' .. escape_str(tostring(k)) .. '"'
                table.insert(parts, spacing .. key .. ": " .. encode_value(v, indent, new_depth))
            end
            return "{" .. table.concat(parts, ",") .. end_spacing .. "}"
        end
    else
        error("Cannot encode type: " .. t)
    end
end

function json.encode(value, indent)
    return encode_value(value, indent, 0)
end

function json.decode(str)
    -- Basic JSON decoder (simplified)
    -- For production, use a proper JSON library like dkjson or cjson
    error("JSON decode not implemented - use a proper JSON library")
end

return json
