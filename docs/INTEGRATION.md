# Integrating your code

Load one Astra UI instance, then use `examples/integration.lua` as your starting point. Place one step of your logic in myStep or use an action callback. Keep the state checks, waits and cleanup behavior. Use your own project prefix for Flags and the global cleanup function.

## Callback values

| Control | Value |
|---|---|
| Toggle | Boolean |
| Slider | Number within Min/Max, rounded to Step |
| Simple dropdown | An Options string |
| Multiple dropdown | Map of selected options to true |
| Keybind | Numeric VK code for the selected key |
| Colorpicker | Color3 |
| Input | Confirmed text |
| Button | No argument |

A Keybind callback records a selected key. Use OnTriggered with its mode, or explicit keyboard handling, to respond when that key is pressed.

## Lifecycle and concurrency

- Use `control:Set(value,true)` to synchronize external state without another callback.
- Keep one worker that reads an enabled flag rather than spawning a new loop whenever a toggle turns on.
- Include waits in loops. UI cooldown does not limit requests made by your own code.
- Check state after a wait and before performing the next action. Waiting alone does not cancel an operation.
- H and the upper X hide the menu. Use cleanup/Destroy to stop your instance.
- Store and disconnect your own connections, remove your drawings and release held inputs when applicable.
- Refresh character/object references after respawns and check for nil.
- Protect long actions with your own busy flag. A 0.35-second click cooldown does not prevent another invocation after that interval.
- Detect optional host functions before calling them and provide an alternative or a clear diagnostic.

## Flags and configuration

Flags are shared across windows of one instance. Use unique strings such as project.enabled and project.speed. Value persistence is supported for toggles, sliders, dropdowns, keybinds, colorpickers and inputs.

A silent import changes a control without calling its callback. Read Get to update your external state, or use LoadConfig(path,false) to restore through callbacks. Do not store secrets in shared configuration files.

## Version compatibility

Check Version against 4.0.0 when using the new methods. An older remote library may load but lack SetLayout or AddTab. Similar method names do not make every script written for another library compatible; use the options documented in API.md. Your game code must be compatible with Matcha independently of the UI.
