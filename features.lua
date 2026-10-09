--=============================================================
-- 🎲 VRILZHUB FEATURES — ANIME DICE (FIXED)
-- Anti-error, anti-nil, ada guard
--=============================================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

--========== TUNGGU NETWORK ==========
local Network = RS:WaitForChild("Network", 30)
if not Network then
    warn("[Features] ❌ Network ga ketemu setelah 30 detik — abort")
    return
end
print("[Features] ✅ Network found")

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
    -- Roll
    SetAutoRoll   = getRemote("Network.RollService.RE.SetAutoRoll"),
    RollDice      = getRemote("Network.RollService.RF.RollDice"),
    -- Sell
    SellInventory = getRemote("Network.SellService.RF.SellInventory"),
    SellEquipped  = getRemote("Network.SellService.RF.SellEquipped"),
    UpdateAutoSell= getRemote("Network.SellService.RE.UpdateAutoSell"),
    -- Unit
    EquipBest     = getRemote("Network.PlotService.RE.EquipBest"),
    Equip         = getRemote("Network.UnitService.RF.Equip"),
    Unequip       = getRemote("Network.UnitService.RF.Unequip"),
    -- Claim
    DailyClaim    = getRemote("Network.DailyRewardService.RE.Claim"),
    QuestClaim    = getRemote("Network.QuestService.RE.Claim"),
    OfflineClaim  = getRemote("Network.OfflineEarningsService.RE.Claim"),
    GroupClaim    = getRemote("Network.GroupRewardService.RE.Claim"),
}

--========== VALIDASI REMOTE ==========
print("[Features] Remote status:")
for name, remote in pairs(Remotes) do
    print(string.format("  %-15s : %s", name, remote and "✅" or "❌"))
end

--========== ZONA SELLING ==========
local SellingZone = nil
local Zones = workspace:FindFirstChild("Zones")
if Zones then
    SellingZone = Zones:FindFirstChild("Selling")
end
print("[Features] SellingZone: " .. (SellingZone and "✅" or "❌"))

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

--========== RARITY → CHANCE ==========
local RARITY_CHANCE = {
    Common = 10,
    Uncommon = 100,
    Rare = 1000,
    Epic = 10000,
    Legendary = 100000,
    Mythical = 1000000,
    Divine = 10000000,
    Celestial = 100000000,
    Exotic = 1000000000,
    ["Secret I"] = 10000000000,
    ["Secret II"] = 100000000000,
    Exclusive = 999999999999999,
}

--========== SHARED STATE ACCESS ==========
local function S()
    return _G.VRILZ_UI_Shared or {}
end

--========== FEATURES ==========
local Features = {}

--========== AUTO ROLL ==========
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

--========== HITUNG THRESHOLD ==========
local function calculateThreshold()
    local keep = S().KeepRarity or {}
    local lowest = nil
    for rarity, keepFlag in pairs(keep) do
        if keepFlag then
            local chance = RARITY_CHANCE[rarity]
            if chance and (not lowest or chance < lowest) then
                lowest = chance
            end
        end
    end
    if not lowest then
        return 999999999999999
    end
    return math.floor(lowest / 2)
end

--========== AUTO SELL BY RARITY ==========
task.spawn(function()
    while task.wait(15) do
        if S().AutoSell_Enabled and Remotes.UpdateAutoSell then
            local threshold = calculateThreshold()
            fire(Remotes.UpdateAutoSell, threshold)
            print("[Features] AutoSell threshold: 1 in " .. threshold)
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
Features.getThreshold = calculateThreshold

_G.VRILZ_Features = Features
print("[Features] ✅ Anime Dice features loaded")
