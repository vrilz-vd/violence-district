--=============================================================
-- 🎲 VRILZHUB LOADER — ANIME DICE (FINAL)
--=============================================================

local GITHUB_RAW = "https://raw.githubusercontent.com/vrilz-vd/violence-district/main"

local function loadScript(path)
    local url = GITHUB_RAW .. "/" .. path
    print("[Loader] Fetching: " .. url)
    local ok, code = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not code or #code < 10 then
        warn("[Loader] ❌ Gagal fetch: " .. path)
        return nil
    end
    return code
end

print("========================================")
print("🎲 VRILZHUB ANIME DICE LOADER")
print("========================================")

-- TUNGGU GAME READY
local RS = game:GetService("ReplicatedStorage")
local Network = RS:WaitForChild("Network", 30)
if not Network then return warn("[Loader] ❌ Network ga ketemu") end
print("[Loader] ✅ Network ready")

local LP = game:GetService("Players").LocalPlayer
local char = LP.Character or LP.CharacterAdded:Wait()
print("[Loader] ✅ Character ready")
task.wait(2)

-- LOAD FEATURES
print("[Loader] === LOADING FEATURES ===")
local featCode = loadScript("features.lua")
if not featCode then return end

local featFn, featErr = loadstring(featCode)
if not featFn then
    return warn("[Loader] ❌ Features syntax error: " .. tostring(featErr))
end

local featOk, featErr2 = pcall(featFn)
if not featOk then
    return warn("[Loader] ❌ Features runtime error: " .. tostring(featErr2))
end
print("[Loader] ✅ Features loaded")

-- LOAD UI
print("[Loader] === LOADING UI ===")
local uiCode = loadScript("ui.lua")
if not uiCode then return end

local uiFn, uiErr = loadstring(uiCode)
if not uiFn then
    return warn("[Loader] ❌ UI syntax error: " .. tostring(uiErr))
end

print("[Loader] Executing ui.lua...")
local uiOk, uiResult = pcall(uiFn)
if not uiOk then
    warn("[Loader] ❌ UI runtime error: " .. tostring(uiResult))
    return
end

print("[Loader] ✅ ui.lua executed")

-- ══════════════════════════════════════════════════════
-- CARI UI MODULE (dari return uiFn)
-- ══════════════════════════════════════════════════════
local UI = uiResult
if type(UI) ~= "table" then
    UI = _G.VRILZ_UI
end

if type(UI) ~= "table" or type(UI.Init) ~= "function" then
    warn("[Loader] ❌ UI module ga ketemu atau ga punya .Init")
    warn("  Type UI     = " .. type(UI))
    warn("  Type Init   = " .. type(UI and UI.Init))
    warn("  _G.VRILZ_UI = " .. type(_G.VRILZ_UI))
    warn("")
    warn("  💡 FIX: Pastikan ui.lua lu ada baris:")
    warn("     return UI")
    warn("     atau _G.VRILZ_UI = UI")
    return
end

-- ══════════════════════════════════════════════════════
-- PANGGIL UI.INIT()
-- ══════════════════════════════════════════════════════
print("[Loader] === INIT UI ===")
print("[Loader] Calling UI.Init()...")

local initOk, initErr = pcall(function()
    UI.Init({})
end)

if not initOk then
    warn("[Loader] ❌ UI.Init error:")
    warn(tostring(initErr))
    return
end

print("[Loader] ✅ UI.Init done")

print("========================================")
print("✅ VRILZHUB ANIME DICE READY")
print("========================================")
