--=============================================================
-- VRILZHUB FEATURES - ANIME DICE v4 (FAST ROLL)
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

--========== GET REMOTE ==========
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

local Remotes = {
    SetAutoRoll   = getRemote("Network.RollService.RE.SetAutoRoll"),
    RollDice      = getRemote("Network.RollService.RF.RollDice"),
    RollMessage   = getRemote("Network.RollService.RE.RollMessage"),
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

local function getHum()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

--========== RARITY CHANCE MAPPING ==========
local RARITY_CHANCE = {
    Common = 10, Uncommon = 100, Rare = 1000, Epic = 10000,
    Legendary = 100000, Mythical = 1000000, Divine = 10000000,
    Celestial = 100000000, Exotic = 1000000000,
    ["Secret I"] = 10000000000, ["Secret II"] = 100000000000,
    Exclusive = 999999999999999,
}

--========== SHARED ==========
local function S()
    return _G.VRILZ_UI_Shared or {}
end

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
    if not lowest then return 999999999999999 end
    return math.floor(lowest / 2)
end

--========== FEATURES ==========
local Features = {}

--========== AUTO ROLL: LISTEN ROLL MESSAGE ==========
-- Ini yang bikin kita dapet hasil roll tanpa nunggu animasi
if Remotes.RollMessage then
    Remotes.RollMessage.OnClientEvent:Connect(function(data)
        if type(data) == "table" and data.message then
            local msg = data.message
            -- extract unit name dari message
            -- contoh: "zcfdb1234 has rolled a <b>Diamond Meliadus</b> with a <b>1 in 14sx</b> chance!"
            local unitName = msg:match("<b>(.-)</b>") -- ambil unit pertama
            local chance = msg:match("<b>(.-)</b>%s*chance") -- ambil chance
            if chance == unitName then chance = nil end
            
            print("[ROLL RESULT] " .. tostring(unitName) .. " | " .. tostring(chance))
            
            -- simpan ke shared state (buat UI log)
            if Shared then
                Shared.LastRoll = unitName
                Shared.LastRollChance = chance
                if Shared.RollLog then
                    table.insert(Shared.RollLog, 1, {unit = unitName, chance = chance})
                    if #Shared.RollLog > 50 then
                        table.remove(Shared.RollLog, 51)
                    end
                end
            end
        end
    end)
    print("[Features] RollMessage listener active")
end

--========== AUTO ROLL (FAST - SKIP ANIMASI) ==========
-- Pakai RollDice:InvokeServer() di dalam task.spawn
-- biar ga nunggu return (return-nya nil, cuma trigger)
task.spawn(function()
    while true do
        local delay = S().RollDelay or 0.15
        task.wait(delay)
        
        if S().AutoRoll_Enabled and Remotes.RollDice then
            -- FIRE-AND-FORGET: task.spawn biar ga block
            task.spawn(function()
                pcall(function()
                    Remotes.RollDice:InvokeServer()
                end)
            end)
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

--========== EXPOSE ==========
Features.Remotes = Remotes
Features.SellingZone = SellingZone
Features.fire = fire
Features.getHum = getHum
Features.getRoot = getRoot
Features.getThreshold = calculateThreshold

_G.VRILZ_Features = Features
print("[Features] Anime Dice features loaded v4 (FAST ROLL)")
