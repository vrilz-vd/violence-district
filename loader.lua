-- ============================================================
-- VRILZHUB LOADER — VIOLENCE DISTRICT
-- ============================================================

local CONFIG = {
    GameId = 93978595733734,
    BaseURL = "https://raw.githubusercontent.com/vrilz-vd/violence-district/main/",
    Features = "features.lua",
    UI = "ui.lua",
}

if game.PlaceId ~= CONFIG.GameId then
    warn("[VRILZHUB] Bukan Violence District, abort")
    return
end

print("[VRILZHUB] Loading Violence District...")

local function loadScript(url, name)
    local fullURL = CONFIG.BaseURL .. url
    local ok, source = pcall(function()
        return game:HttpGet(fullURL)
    end)
    if not ok or not source then
        warn("[VRILZHUB] Gagal load " .. name .. " dari " .. fullURL)
        return nil
    end
    local fn, err = loadstring(source)
    if not fn then
        warn("[VRILZHUB] Gagal compile " .. name .. ": " .. tostring(err))
        return nil
    end
    local ok2, result = pcall(fn)
    if not ok2 then
        warn("[VRILZHUB] Gagal execute " .. name .. ": " .. tostring(result))
        return nil
    end
    print("[VRILZHUB] " .. name .. " loaded OK")
    return result
end

local Features = loadScript(CONFIG.Features, "features")
if not Features then return end

local UI = loadScript(CONFIG.UI, "ui")
if not UI then return end

local Shared = {}
Features.Init(Shared)
UI.Init(Shared)

print("[VRILZHUB] Violence District loaded!")
