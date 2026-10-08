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

return UI
