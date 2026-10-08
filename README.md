# Astra UI

**Astra UI 4.0.0** is a Drawing-based interface library for Matcha. Build your own tabs, connect controls to your script, and keep the Cosmos, Nebula, Supernova or Aurora appearance.

The default design uses drawn icons and needs no downloaded images. Control sizing is configurable, columns wrap to the available width, and buttons and toggles filter repeated clicks.

## Try it

Run `tutorial_standalone.lua` to try the library without a network download. It includes an original showcase with overview, workspace and appearance tabs. Those tabs belong to the example; the library leaves your application's tab structure to you.

Press H to show or hide the showcase. Use Unload interface to destroy it.

## Load Astra

The repository's library file is named `UI`. After it has been published to main, this loader retrieves it and checks the version:

```lua
local previous = _G.AstraUI
local ok, UI = pcall(function()
    local source = game:HttpGet("https://raw.githubusercontent.com/Leox385/ima/refs/heads/main/UI")
    if type(source) ~= "string" or #source == 0 then return nil end
    local chunk = loadstring(source)
    if type(chunk) ~= "function" then return nil end
    return chunk()
end)
if type(UI) ~= "table" and _G.AstraUI ~= previous then UI = _G.AstraUI end
if not ok or type(UI) ~= "table" or UI.Version ~= "4.0.0" or not UI._alive then
    local output = warn or print
    if type(output) == "function" then pcall(output,"[Astra] UI 4.0.0 could not be loaded") end
    return
end

```

The loaded instance is also registered as `_G.AstraUI` and `_G.Kirin`. The global registration accommodates hosts that discard a loaded chunk's return value. `load.lua` contains the library-only loader; `tutorial.lua` loads it and builds the showcase.

## Your first panel

After loading the library:

```lua
local UI = _G.AstraUI
local Window = UI:CreateWindow({Title="My application",Size={790,570},ToggleKey="h"})
local Page = Window:AddTab({Title="Actions",Icon="engine"})
Page:AddButton({Title="Run action",Callback=function()
    print("Action completed")
end})
Page:Select()
```

CreateWindow gives you access to sizing, the menu shortcut and window lifecycle. For a smaller setup, `UI:AddTab(options)` creates a default window when needed.

## Show information

```lua
local Message = Page:AddLabel({Text="Status: idle"})
Message:SetText("Status: ready")
```

Labels display text and wrap with the content width. Their value is not stored in configuration.

## Switch a feature

```lua
local Enabled = Page:AddToggle({
    Title="Enabled",Flag="app.enabled",Default=false,
    Callback=function(value) print("Enabled:",value) end
})
```

The callback receives a boolean. A checkbox presentation is available through `Type="Checkbox"`.

## Choose a number

```lua
local Amount = Page:AddSlider({
    Title="Amount",Flag="app.amount",Min=0,Max=100,Step=5,Default=35,Suffix="%",
    Callback=function(value) print("Amount:",value) end
})
```

Values are clamped and rounded to the configured step. Dragging schedules callbacks only when the value changes.

## Choose an option

```lua
local Profile = Page:AddDropdown({
    Title="Profile",Flag="app.profile",Options={"Light","Standard","Detailed"},Default="Standard",
    Callback=function(value) print("Profile:",value) end
})
```

A simple dropdown returns a string. With Multi=true it uses a table of selected options. A value outside Options falls back to the first option; validate your values if that fallback is unsuitable.

## Read and update controls

```lua
Page:AddButton({Title="Apply",Callback=function()
    print(Enabled:GetValue(),Amount:GetValue(),Profile:GetValue())
end})
Enabled:SetValue(true)
Amount:SetValue(50)
Profile:SetValue("Detailed")
Enabled:SetValue(false,true)
```

SetValue and Set are equivalent. Assigning an unchanged value does not schedule another control callback. A true second argument makes the update silent: it does not call the callback or Watch observers. Synchronize your external script state yourself after silent changes.

## Additional controls

```lua
Page:AddInput({Title="Name",Default="",Callback=function(value) print(value) end})
Page:AddKeybind({Title="Menu key",Default="h",Callback=function(key) Window:SetToggleKey(key) end})
Page:AddColorPicker({Title="Color",Default=Color3.fromRGB(92,214,255)})
local Progress = Page:AddProgressBar({Title="Progress",Default=0.25})
Progress:SetProgress(0.75)
```

Keybind records a key as a numeric VK code. Triggered actions use OnTriggered and a mode, as described in the API reference. ColorPicker provides a preset palette. Progress ranges from zero to one.

## Notifications

```lua
UI:Notify({Title="Astra",Content="Values applied.",Type="success",Duration=3})
```

Supported notification types include info, success, warning and error. Duration is in seconds. Body text wraps automatically; concise messages remain easier to read.

## Appearance and layout

```lua
UI:SetTheme("Aurora")
UI:SetLayout("Compact")
Page:SetColumns(2)
Page:SetStyle({Gap=8,TextSize=14})
Enabled:SetStyle({Width=0.5,Height=40,Cooldown=0.4})
Window:SetToggleKey("h")
Window:SetVisualFX(false)
```

Themes: Cosmos, Nebula, Supernova and Aurora. Style values are inherited from control to tab to window to defaults. Width is a row fraction. Cards wrap when multiple columns will not fit, and long pages use vertical scrolling.

The default cooldown is 0.35 seconds per button/toggle. It filters pointer clicks, not programmatic Fire/Set calls. Sliders and multiline controls preserve minimum heights.

Supported icon names include navigation, planet, engine, settings, toggle, slider, button, dropdown, keybind, colorpicker, input, progressbar, close, expand, dock and reset. Unrecognized names use a fallback icon. Custom line-segment icon tables are not part of this version's API.

## Save preferences

```lua
local saved,message = UI:SaveConfig("my-app.json")
local restored,details = UI:LoadConfig("my-app.json",false)
```

Only supported value controls with unique Flags are included. File access and HttpService JSON support are optional requirements for persistence. Missing support returns failure without stopping the interface. Loading is silent by default; false runs callbacks to restore external state. Configuration folders must already exist.

## Clean shutdown

```lua
UI:Destroy()
```

The library retires its drawings and disconnects its connections. Your code remains responsible for its own workers, connections and drawings. H and the upper close button hide the window; they do not destroy the library.

Use the [integration template](examples/integration.lua) for a feature worker and cleanup function. The [integration guide](docs/INTEGRATION.md) covers state synchronization and long actions.

## Files and further reference

```text
UI
load.lua
tutorial.lua
tutorial_standalone.lua
README.md
docs/
examples/
tests/
.github/workflows/ui-tests.yml
```

- [Complete API](docs/API.md)
- [Compatibility](docs/COMPATIBILITY.md)
- [Integration](docs/INTEGRATION.md)
- [Publishing on GitHub](PUBLISHING.md)
- [Developer tests](TESTING.md)
- [Review status](REVIEW_STATUS.md)

The implementation is checked with local simulations. Real Matcha and hardware compatibility must be tested before advertising support for a particular version. A UI library cannot guarantee compatibility for arbitrary game code. Reuse licensing remains to be selected by the repository owner.
