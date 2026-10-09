--=============================================================
-- 🎲 VRILZHUB LOADER — ANIME DICE
--=============================================================

local GITHUB_RAW = "https://raw.githubusercontent.com/vrilz-vd/violence-district/main"

local function loadScript(path)
    local url = GITHUB_RAW .. "/" .. path
    print("[Loader] Fetching: " .. url)
    local ok, code = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not code or #code < 10 then
        warn("[Loader] Gagal fetch: " .. path)
        return nil
    end
    return code
end

print("========================================")
print("🎲 VRILZHUB ANIME DICE LOADER")
print("========================================")

--========== TUNGGU GAME READY ==========
print("[Loader] Nunggu game ready...")

-- tunggu Network folder
local RS = game:GetService("ReplicatedStorage")
local Network = RS:WaitForChild("Network", 30)
if not Network then
    return warn("[Loader] Network ga ketemu — tunggu 30 detik, game belum ready")
end
print("[Loader] ✅ Network ready")

-- tunggu player + character
local LP = game:GetService("Players").LocalPlayer
local char = LP.Character or LP.CharacterAdded:Wait()
print("[Loader] ✅ Character ready: " .. char.Name)

-- extra delay biar semua module ke-load
task.wait(2)

--========== LOAD FEATURES ==========
print("[Loader] Loading features.lua...")
local featCode = loadScript("features.lua")
if not featCode then
    return warn("[Loader] Features ga bisa di-load")
end

local featFn, featErr = loadstring(featCode)
if not featFn then
    return warn("[Loader] Features syntax error: " .. tostring(featErr))
end

local featOk, featErr2 = pcall(featFn)
if not featOk then
    return warn("[Loader] Features runtime error: " .. tostring(featErr2))
end
print("[Loader] ✅ Features loaded")

--========== LOAD UI ==========
print("[Loader] Loading ui.lua...")
local uiCode = loadScript("ui.lua")
if not uiCode then
    return warn("[Loader] UI ga bisa di-load")
end

local uiFn, uiErr = loadstring(uiCode)
if not uiFn then
    return warn("[Loader] UI syntax error: " .. tostring(uiErr))
end

local uiOk, uiErr2 = pcall(uiFn)
if not uiOk then
    return warn("[Loader] UI runtime error: " .. tostring(uiErr2))
end
print("[Loader] ✅ UI loaded")

print("========================================")
print("✅ VRILZHUB ANIME DICE READY")
print("========================================")
