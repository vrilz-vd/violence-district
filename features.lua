--=============================================================
-- 🎲 VRILZHUB FEATURES — ANIME DICE
-- Logic game (kosong dulu, nanti diisi)
--=============================================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

--========== AMBIL REMOTE ==========
local Network = RS:WaitForChild("Network", 10)

local function getRemote(path)
    local cur = RS
    for _, part in ipairs(string.split(path, ".")) do
        cur = cur:FindFirstChild(part)
        if not cur then return nil end
    end
    return cur
end

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

local SellingZone = workspace:FindFirstChild("Zones")
if SellingZone then SellingZone = SellingZone:FindFirstChild("Selling") end

--========== UTIL ==========
local function fire(remote, ...)
    if not remote then return end
    local args = {...}
    task.spawn(function()
        pcall(function() remote:FireServer(table.unpack(args)) end)
    end)
end

local function invoke(remote, ...)
    if not remote then return nil end
    local args = {...}
    local result
    task.spawn(function()
        pcall(function() result = remote:InvokeServer(table.unpack(args)) end)
    end)
    return result
end

--========== FEATURES ==========
local Features = {}

-- Placeholder — nanti diisi logic
Features.Remotes = Remotes
Features.SellingZone = SellingZone
Features.fire = fire
Features.invoke = invoke

_G.VRILZ_Features = Features
print("[Features] ✅ Anime Dice features loaded")
