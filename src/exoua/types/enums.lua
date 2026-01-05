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

Enums.StaticType = {
    Bool = 0,
    Int = 1,
    Float = 2,
    String = 3,
    Color = 4,
    Vector = 5,
    Sound = 6,
    Music = 7,
    Object = 8,
    ObjectSet = 9,
    Transition = 10,
    Easing = 11,
    Sprite = 12,
    Script = 13,
    Layer = 14,
}

Enums.DynamicType = {
    BoolConstant = 0,
    BoolVariable = 1,
    BoolNot = 2,
    BoolAnd = 3,
    BoolOr = 4,
    IntConstant = 38,
    IntVariable = 39,
    FloatConstant = 56,
    FloatVariable = 57,
    StringConstant = 94,
    StringVariable = 95,
    ColorConstant = 99,
    VectorConstant = 103,
    ObjectConstant = 123,
}

return Enums
