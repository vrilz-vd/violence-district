--=============================================================
-- 🎲 VRILZHUB LOADER — ANIME DICE
-- Load features.lua + ui.lua dari GitHub
--=============================================================

local GITHUB_RAW = "https://raw.githubusercontent.com/USERNAME/anime-dice-auto/main"

local function loadScript(path)
    local url = GITHUB_RAW .. "/" .. path
    local ok, code = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not code or #code < 10 then
        warn("[Loader] Gagal load: " .. path)
        return nil
    end
    return code
end

print("========================================")
print("🎲 VRILZHUB ANIME DICE LOADER")
print("========================================")

-- 1. Load FEATURES dulu (biar _G.VRILZ_Features ada)
print("[Loader] Loading features.lua...")
local featCode = loadScript("features.lua")
if not featCode then
    return warn("[Loader] Features ga bisa di-load")
end

local featOk, featErr = pcall(function()
    loadstring(featCode)()
end)
if not featOk then
    return warn("[Loader] Features error: " .. tostring(featErr))
end
print("[Loader] ✅ Features loaded")

-- 2. Load UI
print("[Loader] Loading ui.lua...")
local uiCode = loadScript("ui.lua")
if not uiCode then
    return warn("[Loader] UI ga bisa di-load")
end

local uiOk, uiErr = pcall(function()
    loadstring(uiCode)()
end)
if not uiOk then
    return warn("[Loader] UI error: " .. tostring(uiErr))
end
print("[Loader] ✅ UI loaded")

print("========================================")
print("✅ VRILZHUB ANIME DICE READY")
print("========================================")
