--=============================================================
-- VRILZHUB FEATURES - ANIME DICE
--=============================================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Network = RS:WaitForChild("Network", 30)
if not Network then
    warn("[Features] Network ga ketemu")
    return
end

print("[Features] Network found")

--========== GET REMOTE (SAFE) ==========
local function getRemote(path)
    if not path or path == "" then return nil end
    local cur = RS
    for _, part in ipairs(string.split(path, ".")) do
        if not cur then return nil end
        cur = cur:FindFirstChild(part)
        if not cur then return nil end
    end
    return cur
end

--========== AMBIL REMOTE ==========
local Remotes = {
    SetAutoRoll   = getRemote("Network.RollService.RE.SetAutoRoll"),
    RollDice      = getRemote("Network.RollService.RF.RollDice"),
    SellInventory = getRemote("Network.SellService.RF.SellInventory"),
    SellEquipped  = getRemote("Network.SellService.RF.SellEquipped"),
    UpdateAutoSell= getRemote("Network.SellService.RE.UpdateAutoSell"),
    EquipBest     = getRemote("Network.PlotService.RE.EquipBest"),
    DailyClaim    = getRemote("Network.DailyRewardService.RE.Claim"),
    QuestClaim    = getRemote("Network.QuestService.RE.Claim"),
    OfflineClaim  = getRemote("Network.OfflineEarningsService.RE.Claim"),
    GroupClaim    = getRemote("Network.GroupRewardService.RE.Claim"),
}

print("[Features] Remote status:")
for name, remote in pairs(Remotes) do
    print(string.format("  %-15s : %s", name, remote and "OK" or "FAIL"))
end

--========== ZONA SELLING ==========
local SellingZone = nil
local Zones = workspace:FindFirstChild("Zones")
if Zones then
    SellingZone = Zones:FindFirstChild("Selling")
end
print("[Features] SellingZone: " .. (SellingZone and "OK" or "FAIL"))

--========== UTIL ==========
local function fire(remote, ...)
    if not remote then return false end
    local args = {...}
    task.spawn(function()
        pcall(function()
            remote:FireServer(table.unpack(args))
        end)
    end)
    return true
end

local function invoke(remote, ...)
    if not remote then return nil end
    local args = {...}
    local result
    task.spawn(function()
        pcall(function()
            result = remote:InvokeServer(table.unpack(args))
        end)
    end)
    return result
end

local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

--========== SHARED STATE ==========
local function S()
    return _G.VRILZ_UI_Shared or {}
end

--========== FEATURES ==========
local Features = {}

--========== AUTO ROLL (server-side) ==========
task.spawn(function()
    local lastState = nil
    while task.wait(1) do
        local state = S().AutoRoll_Enabled
        if state ~= nil and state ~= lastState then
            lastState = state
            if Remotes.SetAutoRoll then
                fire(Remotes.SetAutoRoll, state)
                print("[Features] Auto Roll: " .. tostring(state))
            end
        end
    end
end)

--========== AUTO EQUIP BEST ==========
task.spawn(function()
    while task.wait(3) do
        if S().AutoEquipBest_Enabled and Remotes.EquipBest then
            fire(Remotes.EquipBest)
        end
    end
end)

--========== AUTO CLAIM ==========
task.spawn(function()
    while task.wait(120) do
        if S().AutoClaim_Enabled then
            fire(Remotes.DailyClaim)
            task.wait(3)
            fire(Remotes.QuestClaim)
            task.wait(3)
            fire(Remotes.OfflineClaim)
            task.wait(3)
            fire(Remotes.GroupClaim)
            print("[Features] Auto Claim done")
        end
    end
end)

--========== AUTO TELEPORT KE ZONA SELL ==========
task.spawn(function()
    while task.wait(5) do
        if S().AutoTeleportSell_Enabled and SellingZone then
            local root = getRoot()
            if root then
                pcall(function()
                    root.CFrame = CFrame.new(SellingZone.Position + Vector3.new(0, 5, 0))
                end)
            end
        end
    end
end)

--========== EXPOSE ==========
Features.Remotes = Remotes
Features.SellingZone = SellingZone
Features.fire = fire
Features.invoke = invoke
Features.getHum = getHum
Features.getRoot = getRoot

_G.VRILZ_Features = Features
print("[Features] Anime Dice features loaded")
