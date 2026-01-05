local OldScript = {}
OldScript.__index = OldScript

local OldAction = {}
OldAction.__index = OldAction

local OldActionProperty = {}
OldActionProperty.__index = OldActionProperty

local OldActionType = {
    RunScript = 0,
    StopScripts = 1,
    Wait = 2,
    WaitFrames = 3,
    Move = 4,
    Jump = 5,
    Slam = 6,
    Charge = 7,
    Scale = 8,
    Rotate = 9,
    RotateAround = 10,
    SetDirection = 11,
    Activate = 12,
    Deactivate = 13,
    PlaySound = 14,
    PlayMusic = 15,
    SetCinematic = 16,
    SetInputEnabled = 17,
    PanCameraToObject = 18,
    CameraFollowPlayer = 19,
    ShowGameText = 20,
    SetVulnerable = 21,
    Color = 22,
    Damage = 23,
    Kill = 24,
    Finish = 25,
    SetGravity = 26,
    SetVelocity = 27
}

local OldActionTypeReverse = {}
for k, v in pairs(OldActionType) do
    OldActionTypeReverse[v] = k
end

function OldScript.new(id, name, creation_date, actions)
    return setmetatable({
        script_id = id,
        name = name,
        creation_date = creation_date,
        actions = actions or {}
    }, OldScript)
end

function OldScript.read(reader)
    return OldScript.new(
        reader:read_uuid(),
        reader:read_string(),
        reader:read_datetime(),
        reader:read_array(OldAction.read)
    )
end

function OldScript:write(writer)
    writer:write_uuid(self.script_id)
    writer:write_string(self.name)
    writer:write_datetime(self.creation_date)
    writer:write_array(self.actions, function(a) a:write(writer) end)
end

function OldAction.new(action_type, wait, properties)
    return setmetatable({
        action_type = action_type,
        wait = wait,
        properties = properties or {}
    }, OldAction)
end

function OldAction.read(reader)
    local t = reader:read_i32()
    if OldActionTypeReverse[t] == nil then
        error("Invalid OldActionType: " .. t)
    end

    return OldAction.new(
        t,
        reader:read_bool(),
        reader:read_array(OldActionProperty.read)
    )
end

function OldAction:write(writer)
    writer:write_i32(self.action_type)
    writer:write_bool(self.wait)
    writer:write_array(self.properties, function(p) p:write(writer) end)
end

function OldActionProperty.new(name, value)
    return setmetatable({
        name = name,
        value = value
    }, OldActionProperty)
end

function OldActionProperty.read(reader)
    return OldActionProperty.new(
        reader:read_string(),
        reader:read_string()
    )
end

function OldActionProperty:write(writer)
    writer:write_string(self.name)
    writer:write_string(self.value)
end

return {
    OldScript = OldScript,
    OldAction = OldAction,
    OldActionType = OldActionType,
    OldActionProperty = OldActionProperty
}
