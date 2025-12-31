print("Exoua booting")

local physics = {}

function physics.step(pos, vel, dt)
    return {
        x = pos.x + vel.x * dt,
        y = pos.y + vel.y * dt
    }
end

local position = { x = 0, y = 0 }
local velocity = { x = 5, y = 0 }
local dt = 1 / 60

for i = 1, 60 do
    position = physics.step(position, velocity, dt)
end

print("Final position:")
print(position.x, position.y)
