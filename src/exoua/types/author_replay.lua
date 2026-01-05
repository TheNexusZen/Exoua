local AuthorReplay = {}
AuthorReplay.__index = AuthorReplay

function AuthorReplay.new(bytes)
    return setmetatable({
        bytes = bytes or "",
    }, AuthorReplay)
end

function AuthorReplay.from_bytes(bytes)
    return AuthorReplay.new(bytes)
end

function AuthorReplay:to_bytes()
    return self.bytes
end

return AuthorReplay
