

local ui = _G.AstraUI or _G.Kirin
if type(ui) ~= "table" or ui.Version ~= "4.0.0" or not ui._alive then
    warn("Load Astra UI 4.0.0 first")
    return
end
local host = task or {}
local spawnTask, waitTask = host.spawn or spawn, host.wait or wait
if type(spawnTask) ~= "function" or type(waitTask) ~= "function" then return end

if type(_G.MyAstraProjectCleanup) == "function" then
    pcall(_G.MyAstraProjectCleanup)
end
local alive, enabled, runningAction = true, false, false
local connections = {}
local window = ui:CreateWindow({Title="My project",ToggleKey="h"})
local tab = window:AddTab("General")
local status = tab:AddLabel("Status: stopped")
local toggle

local function isActive()
    return alive and enabled and window:IsAlive()
end

local function myStep()



    if not isActive() then return end
end

local function cleanup()
    if not alive then return end
    alive, enabled = false, false
    for _,connection in ipairs(connections) do
        pcall(function() connection:Disconnect() end)
    end
    connections = {}
    window:Destroy()
    if _G.MyAstraProjectCleanup == cleanup then _G.MyAstraProjectCleanup = nil end
end
_G.MyAstraProjectCleanup = cleanup

toggle = tab:AddToggle({Title="Enable",Flag="MyAstraProject.enabled",Callback=function(value)
    if not alive then return end
    enabled = value
    status:SetText(value and "Status: active" or "Status: stopped")
end})

tab:AddButton({Title="Single action",Callback=function()

    if not alive or runningAction then return end
    runningAction = true
    local ok, err = pcall(function()

    end)
    runningAction = false
    if not ok then warn("[MyAstraProject] "..tostring(err)) end
end})
tab:AddButton({Title="Close",Style="danger",Callback=cleanup})
tab:Select()


spawnTask(function()
    while alive and window:IsAlive() do
        waitTask(0.2)
        if isActive() then
            local ok, err = pcall(myStep)
            if not ok then
                enabled = false
                if alive and window:IsAlive() then
                    toggle:Set(false,true)
                    status:SetText("Your code failed; check the console")
                end
                warn("[MyAstraProject] "..tostring(err))
            end
        end
    end
    cleanup()
end)
