# Compatibility and troubleshooting

## Required APIs

Astra requires Drawing.new, Vector2, Color3, a clock (os.clock or tick), and a scheduler (task.spawn/task.wait or global spawn/wait). Drawing must implement Square, Line, Circle and Text with their basic geometry properties.

Interaction requires pointer coordinates and a mouse-state source: ismouse1pressed, iskeypressed or a compatible input service. Keyboard handling requires polling or supported events. API names alone do not prove complete support in a particular Matcha version.

GetCapabilities reports API presence without performing game actions. Touch and ProximityPrompt report whether their functions exist; Astra does not implement or invoke them on your behalf.

## Fallbacks

| Missing feature | Behavior |
|---|---|
| task | Uses global spawn/wait |
| RenderStepped | Tries Heartbeat |
| Both frame events | Updates through a loop with waits |
| Fonts/TextBounds | Numeric font defaults and estimated text width |
| Corner/FontSize/Transparency | Probes compatible properties and skips rejected optional ones |
| Internet/image files | Default design does not download or read images |
| File functions/JSON | Menu works; configuration functions return failure |
| Required startup APIs | Returns nil and reports an unsupported-runtime message |

The window is constrained to the viewport and cards wrap when needed. A 640×360 viewport was simulated. Below 340×280, enough space is not assured. Mobile support and every display scaling configuration have not been verified.

## Verification

Local Python/Lupa tests with simulated Drawing, services, mouse input and scheduling passed for:

- Library initialization, documented controls and simulated rendering.
- Styles, widths, columns and hidden controls.
- Silent Set, callbacks/observers and repeated-value handling.
- Consecutive toggle clicks and cooldown expiry.
- Slider step rounding.
- JSON export/import, silent restoration and invalid configuration rejection.
- Missing filesystem functions, frame events, fonts and optional Drawing properties.
- Viewport changes and removal of all created Drawing objects.
- Missing required Drawing support.
- Example execution, reload and cleanup.

The preview was produced from simulated drawings and visually reviewed. These tests do not verify native Matcha behavior, GPU load or performance across PCs. See REVIEW_STATUS.md for the current evidence.

## Before distribution

Test the standalone demo in each Matcha version you intend to support. Check controls, scrolling, dragging, resolution changes, closing and reloading. Add your callbacks one at a time. Use waits in loops and stop your resources when closing. Publish the exact version/commit you tested.

Avoid absolute personal paths, assets present only on your PC and expiring image URLs.

## Troubleshooting

- **No menu:** check `[Astra]` messages, Drawing, scheduling, pointer coordinates and the loaded version.
- **A toggle changes twice:** close duplicate instances and use silent Set when synchronizing external state. Default click cooldown is 0.35 seconds per button/toggle.
- **`{} 0`:** this library does not emit that message. An older hub task may still be running; test the demo alone in a clean session.
- **Game actions fail while the menu works:** verify that script's APIs and object paths separately. Astra does not add missing game or server functions.
- **Configuration does not save:** check file functions, JSON support and Matcha's working directory.
- **The game process exits:** record Matcha version, display settings, the active action, final console output and reproduction steps. Lua pcall cannot catch a native process failure.

## References

- [Original repository](https://github.com/Leox385/ima)
- [Jdui layout reference](https://github.com/jdev-studio/jdui#sizes-and-layout)
- [Matcha Drawing documentation](https://matcha-latte.gitbook.io/matcha/luau-environment/drawing)
