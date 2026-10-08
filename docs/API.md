# Astra UI 4.0.0 API

The library returns a table and registers it as `_G.Kirin` and `_G.AstraUI`. Loading a new instance closes the previous Astra instance. Load one library instance for your interface.

## Library

| Method | Result or effect |
|---|---|
| CreateWindow(options) | Window with Title, Theme, Size={width,height}, ToggleKey, Layout and optional Icon |
| AddTab(options) | Creates a default window if needed and returns a tab |
| SetLayout(value) | Default, Compact or a style table; existing and future windows |
| GetThemes() / SetTheme(name) | Cosmos, Nebula, Supernova, Aurora |
| SetTransparency(value) | Additional transparency from 0 to 0.6 |
| Notify(options) | Title, Content, Type, Duration in seconds |
| GetCapabilities() | API presence detection; not proof that a host implementation works |
| Get(flag) / Set(flag,value,silent) | Access a flagged control |
| Watch(flag,callback) | Observer with a Disconnect method |
| ExportConfig() | JSON string or nil,message |
| ImportConfig(json,silent) | true,count or false,message; silent by default |
| SaveConfig(path) / LoadConfig(path,silent) | Optional file persistence; does not create folders |
| Destroy() / Unload() | Remove the library's drawings and disconnect its events |

Flags must be unique strings within a library instance. Buttons and labels do not store values. Imports apply only to existing controls with matching Flags and types. Update external state after a silent import, or import with callbacks enabled.

## Windows and tabs

| Method | Behavior |
|---|---|
| window:Section(options) → section:Tab(options) | Original section/tab API |
| window:AddTab(options) | Tab under the Pages section; Title, Icon, Style, Columns |
| window:SetLayout(value) | Window layout overrides |
| window:SetSize(width,height) | Requested size, constrained by renderer and viewport |
| window:SetToggleKey(key) | Letter/key name or numeric VK code |
| window:Toggle() / Minimize() / Restore() | Visibility state |
| window:IsPointerOver(x,y) | Test whether a pointer overlaps the menu |
| window:SetVisualFX(enabled) | Toggle the animated garden; other decorations remain |
| window:SetIcon(urlOrPath) | Explicit optional image dependency |
| window:IsAlive() / Destroy() | Window lifecycle |
| tab:Select() | Select the tab |
| tab:SetColumns(count) | 1–4 requested columns, with automatic wrapping |
| tab:SetStyle(table) | Tab style overrides |
| tab:GetLayoutBounds() | Content-relative X/Y/Width/Height entries and total height |

Destroy only manages UI resources. Your code must stop its own tasks, disconnect its connections and remove its drawings.

## Controls

Original names and aliases are equivalent. Common options include Title, Default, Flag, Callback and Style where supported.

| Original | Alias | Specific options |
|---|---|---|
| Toggle | AddToggle | Default=false; Type="Checkbox" optional |
| Slider | AddSlider | Min, Max, Step, Default, Suffix; values snap to Step |
| Button | AddButton | Callback; legacy Style="primary" or "danger" |
| Dropdown | AddDropdown | String Options, Default, optional Multi=true |
| Keybind | AddKeybind | Default key/VK, Mode, OnTriggered; hold/toggle/click/always |
| Colorpicker | AddColorPicker | Default Color3; preset color palette |
| Input | AddInput | Default, Placeholder, Callback |
| Progressbar | AddProgressBar | Default between 0 and 1 |
| Paragraph | AddLabel | String or Text option; wraps to available width |
| Divider | AddDivider | Decorative separator |
| Space(pixels) | — | Vertical space |
| Section(text) | — | In-tab heading |

A Style table controls sizing. For a legacy primary/danger button, create it with the string style, then use SetStyle for sizing. Description, SearchBarEnabled, AddIsland and other libraries' options are not implemented. Colorpicker uses presets rather than a complete HSV editor.

## Control handles

Value controls provide Get/GetValue and Set/SetValue. The second Set argument is silent. Repeated values do not schedule duplicate callbacks. A multiple-selection dropdown returns a map of selected options to true; pass a new table to Set instead of mutating that returned map.

Returned handles from Toggle, Slider, Button, Dropdown, Keybind, Colorpicker, Input, Progressbar and Paragraph provide:

```lua
control:SetTitle("Title")
control:SetText("Title")
control:SetStyle({Width=1,Height=48})
control:SetVisible(false)
control:OnChanged(function(value) end)
control:Destroy()
```

Hidden controls take no layout space. Buttons provide Fire for programmatic invocation without click cooldown. Progress bars provide SetProgress/GetProgress. Keybind provides IsEnabled and OnTriggered.

Callbacks run in separate scheduled tasks. Lua callback failures are reported with `[Astra] Callback`. Keep your own cancellation and concurrency checks for long-running actions.
