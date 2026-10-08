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

UI:SetLayout("Compact")
local Window = UI:CreateWindow({Title="Astra UI",Theme="Cosmos",Size={790,570},ToggleKey="h"})
local Home = Window:AddTab({Title="Overview",Icon="planet"})
Home:AddLabel({Text="Astra UI 4.0.0"})
local Status = Home:AddLabel({Text="Status: ready"})
Home:AddButton({Title="Show notification",Callback=function()
    UI:Notify({Title="Astra",Content="The interface is ready.",Type="success",Duration=3})
end})

local Main = Window:AddTab({Title="Workspace",Icon="engine",Columns=2})
local Enabled = Main:AddToggle({Title="Enabled",Flag="showcase.enabled",Default=false,Callback=function(value)
    Status:SetText(value and "Status: enabled" or "Status: disabled")
end})
local Strength = Main:AddSlider({Title="Strength",Flag="showcase.strength",Min=0,Max=100,Step=5,Default=35,Suffix="%"})
local Profile = Main:AddDropdown({Title="Profile",Flag="showcase.profile",Options={"Light","Standard","Detailed"},Default="Standard"})
Main:AddButton({Title="Apply values",Callback=function()
    UI:Notify({Title="Current values",Content=string.format("%s / %d / %s",tostring(Enabled:GetValue()),Strength:GetValue(),Profile:GetValue()),Duration=4})
end})
Main:AddToggle({Title="Secondary option",Type="Checkbox",Flag="showcase.secondary"})
Main:AddKeybind({Title="Menu shortcut",Default="h",Callback=function(key) Window:SetToggleKey(key) end})
Main:AddInput({Title="Display name",Flag="showcase.name",Default="",Callback=function(value)
    Status:SetText("Name: "..value)
end})
local Progress = Main:AddProgressBar({Title="Progress",Default=0.35})
Strength:OnChanged(function(value) Progress:SetProgress(value/100) end)
Main:AddColorPicker({Title="Accent sample",Flag="showcase.color",Style={Width=1}})

local Settings = Window:AddTab({Title="Appearance",Icon="settings"})
Settings:AddDropdown({Title="Theme",Options=UI:GetThemes(),Default="Cosmos",Callback=function(value) UI:SetTheme(value) end})
Settings:AddDropdown({Title="Layout",Options={"Compact","Default"},Default="Compact",Callback=function(value) Window:SetLayout(value) end})
Settings:AddToggle({Title="Animated background",Default=true,Callback=function(value) Window:SetVisualFX(value) end})
Settings:AddSlider({Title="Transparency",Min=0,Max=60,Step=5,Default=0,Suffix="%",Callback=function(value) UI:SetTransparency(value/100) end})
Settings:AddButton({Title="Save configuration",Callback=function()
    local saved,message = UI:SaveConfig("astra-showcase.json")
    UI:Notify({Title="Configuration",Content=saved and "Saved" or tostring(message),Type=saved and "success" or "warning"})
end})
Settings:AddButton({Title="Restore configuration",Callback=function()
    local loaded,message = UI:LoadConfig("astra-showcase.json",false)
    UI:Notify({Title="Configuration",Content=loaded and "Restored" or tostring(message),Type=loaded and "success" or "warning"})
end})
Settings:AddButton({Title="Unload interface",Style="danger",Callback=function() UI:Destroy() end})
Home:Select()
