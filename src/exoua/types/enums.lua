local Enums = {}

Enums.PhysicsType = {
    None = 0,
    Static = 1,
    Dynamic = 2,
    Kinematic = 3,
}

Enums.FillMode = {
    Solid = 0,
    Outline = 1,
}

Enums.Blending = {
    Normal = 0,
    Additive = 1,
    Multiply = 2,
}

Enums.SimulationSpace = {
    Local = 0,
    World = 1,
}

Enums.EmitterShape = {
    Point = 0,
    Box = 1,
    Circle = 2,
}

return Enums
