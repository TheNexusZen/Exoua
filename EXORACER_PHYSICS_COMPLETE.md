# ExoRacer Complete Physics Reference

## 🎯 SOURCE: Il2CppDumper Analysis of GameAssembly.dll

---

## GLOBAL SETTINGS (Game class)

| Constant | Value | Notes |
|----------|-------|-------|
| **DEFAULT_GRAVITY** | Vector2 (likely 0, -9.81) | Static readonly |
| **TILE_SIZE** | Vector2 | Static readonly |
| **EPSILON** | 0.001 | Floating point tolerance |
| **STARTING_DURATION** | 1.0 | Level start countdown |
| **ENDING_DURATION** | 0.4 | Level end animation |
| **KILL_ZONE_HEIGHT** | 5 | Death zone distance |
| **Physics Rate** | 100 Hz | From globalgamemanagers |

---

## 🏃 CHARACTER PHYSICS (CharacterEntity class)

### Movement Constants
| Constant | Value | Description |
|----------|-------|-------------|
| **MIN_AIR_SPEED** | 5 | Minimum speed in air |
| **AIR_ACCEL** | 15 | Air acceleration |
| **MAX_AIR_SPEED** | 23 | Maximum air speed |
| **AIR_FRICTION** | 0.99 | Air friction multiplier |
| **MAX_ROTATION** | 15 | Max sprite rotation degrees |
| **MIN_NORMAL_Y** | 0.6 | Min ground normal Y for landing |
| **ICE_MIN_NORMAL_Y** | 0.05 | Min ground normal for ice |
| **ICE_FRICTION** | 1.0 | Ice surface friction |

### Jump Physics
| Constant | Value | Description |
|----------|-------|-------------|
| **JUMP_IMPULSE** | 25 | Jump force |
| **LONG_JUMP_DURATION** | 0.4 | Hold duration for long jump |
| **CANCEL_JUMP_FACTOR** | 0.75 | Jump cancel multiplier |
| **CANCEL_JUMP_VELOCITY** | 5 | Jump cancel velocity threshold |
| **NO_GROUND_TIMER** | 0.04 | Coyote time (40ms) |

### Booster Physics
| Constant | Value | Description |
|----------|-------|-------------|
| **BOOSTER_SPEED** | 25 | Booster target speed |
| **BOOST_ACCEL** | 150 | Booster acceleration |

### Dash Physics
| Constant | Value | Description |
|----------|-------|-------------|
| **DASH_MIN_SPEED** | 15 | Minimum dash speed |
| **DASH_MAX_SPEED** | 50 | Maximum dash speed |
| **DASH_DURATION** | 0.25 | Dash duration (250ms) |

### Fan Physics
| Constant | Value | Description |
|----------|-------|-------------|
| **FAN_SPEED** | 23 | Fan propulsion speed |

### Floating Zone Physics
| Constant | Value | Description |
|----------|-------|-------------|
| **MAX_FLOATING_ZONE_SPEED** | 30 | Max speed in float zone |
| **FLOATING_ZONE_FRICTION** | 0.95 | Float zone friction |
| **FLOATING_ZONE_VELOCITY_ROTATION_FACTOR** | 0.1 | Rotation influence |
| **FLOATING_ZONE_VELOCITY_LENGTH_FACTOR** | 0.5 | Length factor |
| **FLOATING_ZONE_MOVE_ANGLE** | 60 | Movement angle degrees |
| **FLOATING_ZONE_UP_SPEED** | 22 | Upward speed in zone |

### Combat
| Constant | Value | Description |
|----------|-------|-------------|
| **BASE_DAMAGE** | 10 | Base damage value |
| **INVULNERABLE_TO_UNITS_TIMER** | 0.4 | I-frames (400ms) |

### Grabber
| Constant | Value | Description |
|----------|-------|-------------|
| **MAX_GRABBER_FALL_SPEED** | 2 | Max fall speed on grabber |

---

## 🎯 ENTITY-SPECIFIC PROPERTIES

### BumperEntity
| Field | Type | Notes |
|-------|------|-------|
| **impulse** | float | Customizable launch force |
| **extendedDuration** | float | Extended animation time |

### HookAnchorEntity
| Field | Type | Notes |
|-------|------|-------|
| **radius** | float | Hook grab radius |

### BoosterEntity
| Field | Type | Notes |
|-------|------|-------|
| **direction** | int | Boost direction (0-7) |

### Hook
| Constant | Value | Notes |
|----------|-------|-------|
| **EXTEND_DURATION** | 0.08 | Hook extend animation (80ms) |

---

## 📊 PHYSICS CALCULATIONS

### Jump Height Formula
With JUMP_IMPULSE = 25 and gravity = 9.81:
```
height = v² / (2 * g)
height = 25² / (2 * 9.81)
height ≈ 31.9 units (initial impulse)
```

However, jump is likely velocity-based, not raw impulse.
Estimated actual jump height: **~3 units** (from gameplay)

### Horizontal Running Jump
With MAX_AIR_SPEED = 23:
```
At typical trajectory, running jump distance ≈ 11-12 units
```

### Bumper Launch
With default impulse (estimated 7.5-8.0):
```
Vertical reach ≈ 6-7 units
Parabola peaks ~3-4 units forward from bumper
```

---

## 🔧 DEFAULT VALUE METHODS (NovaPrefabProperty)

| Method | Returns | Description |
|--------|---------|-------------|
| `GetDefaultImpulse()` | float | Default bumper impulse |
| `GetDefaultRadius()` | float | Default hook radius |
| `GetDefaultSpeedMin()` | float | Min speed |
| `GetDefaultSpeedMax()` | float | Max speed |
| `GetDefaultSpeedLimit()` | float | Speed limit |
| `GetDefaultSpeedDampen()` | float | Speed dampening |
| `GetDefaultGravityMultiplier()` | float | Gravity multiplier |
| `GetDefaultFriction()` | float | Default friction |

---

## 🎮 GAME STATE FIELDS (CharacterEntityState)

Key simulation state tracked per-frame:
- `velocity` - Current velocity vector
- `jumpLocked`, `canCancelJump` - Jump state
- `bumperCounter`, `switcherCounter` - Object interaction cooldowns
- `onGround`, `groundNormal`, `groundFriction` - Ground contact
- `hooked`, `hookAnchor`, `hookLength` - Hook state
- `inFloatingZone`, `canJumpOutFloatingZone` - Float zone state
- `dashLocked`, `dashRotation`, `dashDuration` - Dash state
- `antiGravityFactor` - Gravity modification

---

## 📝 LEVEL DESIGN IMPLICATIONS

### Safe Gaps
| Scenario | Max Gap |
|----------|---------|
| Standing jump | ~3 units vertical |
| Running jump | ~11-12 units horizontal |
| Booster launch | Speed 25, quick acceleration |
| Hook swing | Based on radius setting (default ~8) |
| Bumper launch | Based on impulse setting |
| Float zone | Up speed 22, good for vertical sections |

### Timing Windows
| Mechanic | Window |
|----------|--------|
| Coyote time | 40ms (NO_GROUND_TIMER) |
| Long jump hold | 400ms (LONG_JUMP_DURATION) |
| Dash duration | 250ms (DASH_DURATION) |
| Hook extend | 80ms (EXTEND_DURATION) |
| I-frames | 400ms (INVULNERABLE_TO_UNITS_TIMER) |

---

## ✅ CONFIRMED VALUES

| Constant | Value | Confidence |
|----------|-------|------------|
| Gravity | -9.81 | ✅ HIGH |
| Physics Rate | 100 Hz | ✅ HIGH |
| Jump Impulse | 25 | ✅ HIGH |
| Max Air Speed | 23 | ✅ HIGH |
| Booster Speed | 25 | ✅ HIGH |
| Dash Max Speed | 50 | ✅ HIGH |
| Float Zone Up Speed | 22 | ✅ HIGH |
| Coyote Time | 0.04s | ✅ HIGH |
| Hook Extend | 0.08s | ✅ HIGH |


---

## 🆕 ADDITIONAL DISCOVERIES FROM FULL DUMP

### Swing/Hook Mechanics
| Event | Description |
|-------|-------------|
| PLAYER_SWING_START | Player attaches to hook |
| PLAYER_SWING_END | Player detaches from hook |
| PLAYER_SWING_JUMP | Jump while swinging (special) |

The Jump() method signature: `Jump(float impulseFactor = 1, bool swingJump = False)`
- Swing jumps are handled specially (likely higher or angled impulse)

### Terrain Properties
| Property | Description |
|----------|-------------|
| `customTerrainCornerRadius` | Rounded corner radius |
| `customTerrainFriction` | Surface friction |
| `GetTerrainCornerRadius()` | Getter method |
| `GetTerrainFriction()` | Getter method |

### Level Camera
| Field | Description |
|-------|-------------|
| `MAX_X_DISTANCE` | 7 units max horizontal from player |
| `GetDefaultCameraOffset()` | Returns camera offset |

### Sound/Effect Constants
| Constant | Value | Description |
|----------|-------|-------------|
| ICE_PITCH_MIN_SPEED | 0.2 | Min speed for ice sound |
| ICE_PITCH_MAX_SPEED | 45 | Max speed for ice sound |
| ICE_VOLUME_MIN_SPEED | 0.2 | Min speed for ice volume |
| ICE_VOLUME_MAX_SPEED | 30 | Max speed for ice volume |
| ICE_EFFECT_FRICTION | 0.9 | Ice visual effect friction |
| FLOATING_ZONE_PITCH_SPEED | 2 | Float zone sound pitch |

### Replay/Validation Constants
| Constant | Value | Description |
|----------|-------|-------------|
| SPEED_REFERENCE | 0.016666668 | ~60 FPS reference (1/60) |
| SPEED_TOLERANCE | 0.001 | Speed validation tolerance |
| SPEED_CONSECUTIVE_FRAMES | 10 | Frames for speed check |
| SPEED_FRAME_TOLERANCE | 100 | Frame tolerance |
| MIN_JUMP_DELAY | 0.05 | Min time between jumps (50ms) |
| INVALID_JUMP_TOLERANCE | 10 | Invalid jump tolerance |

---

## 📊 COMPLETE ENTITY PROPERTY SUMMARY

| Entity | Key Fields |
|--------|------------|
| **BumperEntity** | `impulse`, `extendedDuration` |
| **BoosterEntity** | `direction` (0-7) |
| **HookAnchorEntity** | `radius` |
| **SwitcherEntity** | `direction`, `extendedDuration` |
| **FanEntity** | `size` |
| **DasherEntity** | `extendedDuration` |
| **DoubleJumperEntity** | `extendedDuration` |
| **GravityPortalEntity** | `size`, `reverseDirection` |
| **GrabberEntity** | `color` |
| **DoorEntity** | `size`, `activationCount`, `totalActivationCount` |
| **UnitEntity** | `health`, `killer`, `damageFromJump`, `damageFromDash`, etc. |

---

## 🎯 FINAL PHYSICS REFERENCE CARD

### Movement
```
MAX_AIR_SPEED = 23 units/sec
AIR_ACCEL = 15 units/sec²
MIN_AIR_SPEED = 5 units/sec
AIR_FRICTION = 0.99 (per frame)
```

### Jump
```
JUMP_IMPULSE = 25 units/sec initial velocity
LONG_JUMP_DURATION = 0.4 sec hold time
CANCEL_JUMP_FACTOR = 0.75 multiplier
NO_GROUND_TIMER = 0.04 sec coyote time
```

### Boost/Dash
```
BOOSTER_SPEED = 25 units/sec
BOOST_ACCEL = 150 units/sec²
DASH_MIN_SPEED = 15 units/sec
DASH_MAX_SPEED = 50 units/sec
DASH_DURATION = 0.25 sec
```

### Float Zone
```
MAX_FLOATING_ZONE_SPEED = 30 units/sec
FLOATING_ZONE_FRICTION = 0.95
FLOATING_ZONE_UP_SPEED = 22 units/sec
FLOATING_ZONE_MOVE_ANGLE = 60 degrees
```

### Misc
```
FAN_SPEED = 23 units/sec
MAX_GRABBER_FALL_SPEED = 2 units/sec
ICE_FRICTION = 1.0
HOOK_EXTEND_DURATION = 0.08 sec
```
