local Pattern = {}
Pattern.__index = Pattern

function Pattern.new(pattern_id, pattern_frames)
    return setmetatable({
        pattern_id = pattern_id or 0,
        pattern_frames = pattern_frames or {},
    }, Pattern)
end

function Pattern.add_frame(self, image)
    self.pattern_frames[#self.pattern_frames + 1] = image
end

function Pattern.get_frames(self)
    return self.pattern_frames
end

return Pattern
