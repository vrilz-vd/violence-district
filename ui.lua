-- ============================================================
-- VRILZHUB UI — ANIME DICE v1.0 (CLEAN)
-- PC: 800x580 | Mobile: 88% x 78% viewport
-- ============================================================

local UI = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Ambil Features dari _G
local function getFeatures()
    return _G.VRILZ_Features
end

-- ====== AUTO-DETECT MOBILE ======
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ====== UI CONFIG ======
local UI_CONFIG = {
    MOBILE = {
        WIN_W_PCT = 0.92, WIN_H_PCT = 0.88,
        SIDEBAR_W = 78, TAB_H = 42, TAB_ICON = 18, TAB_SHOW_LABEL = false,
        CARD_HEADER = 34, CARD_PAD_TOP = 10, CARD_PAD_BOT = 12, CARD_PAD_SIDE = 12,
        CARD_GAP = 8, TOGGLE_H = 38, TOGGLE_W = 50, TOGGLE_KNOB = 20,
        DROPDOWN_H = 42, DROPDOWN_ITEM = 32, DROPDOWN_POPUP_W = 154, ACTION_H = 36,
        FONT_TITLE = 13, FONT_LABEL = 11, FONT_MUTED = 9, FONT_SMALL = 10,
        FONT_MED = 11, FONT_LARGE = 14,
        HEADER_H = 40, SEARCH_H = 30, NOTIF_W = 300, NOTIF_H = 52, OPEN_BTN = 52,
        CHAT_MSG_H = 46, CHAT_AVATAR = 22, CHAT_FONT = 10, CHAT_NAME_FONT = 10,
        CHAT_INPUT_H = 34, CHAT_SEND_W = 46, CHAT_BUBBLE_PAD = 8,
        CHAT_MAX_MSG = 80, CHAT_SHOW_AVATAR = false, CHAT_PANEL_H = 340,
    },
    PC = {
        WIN_W = 800, WIN_H = 580,
        SIDEBAR_W = 152, TAB_H = 46, TAB_ICON = 17, TAB_SHOW_LABEL = true,
        CARD_HEADER = 36, CARD_PAD_TOP = 12, CARD_PAD_BOT = 14, CARD_PAD_SIDE = 16,
        CARD_GAP = 9, TOGGLE_H = 34, TOGGLE_W = 48, TOGGLE_KNOB = 18,
        DROPDOWN_H = 38, DROPDOWN_ITEM = 30, DROPDOWN_POPUP_W = 180, ACTION_H = 34,
        FONT_TITLE = 12, FONT_LABEL = 12, FONT_MUTED = 10, FONT_SMALL = 10,
        FONT_MED = 12, FONT_LARGE = 15,
        HEADER_H = 52, SEARCH_H = 34, NOTIF_W = 380, NOTIF_H = 52, OPEN_BTN = 56,
        CHAT_MSG_H = 54, CHAT_AVATAR = 30, CHAT_FONT = 12, CHAT_NAME_FONT = 11,
        CHAT_INPUT_H = 40, CHAT_SEND_W = 76, CHAT_BUBBLE_PAD = 12,
        CHAT_MAX_MSG = 200, CHAT_SHOW_AVATAR = true, CHAT_PANEL_H = 420,
    },
}

local KEY_SYSTEM_URL = "https://key-system.vrilzwops.workers.dev"
local CFG = IS_MOBILE and UI_CONFIG.MOBILE or UI_CONFIG.PC

-- ====== RARITY (buat auto sell by rarity) ======
local RarityList = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Mythical", "Divine", "Celestial", "Exotic",
    "Secret I", "Secret II", "Exclusive"
}

-- ====== THEME ======
local Themes = {
    Brutal = {
        BG = Color3.fromRGB(7, 8, 11), Surface = Color3.fromRGB(13, 14, 18),
        Surface2 = Color3.fromRGB(20, 20, 24), Surface3 = Color3.fromRGB(28, 28, 33),
        Stroke = Color3.fromRGB(255, 126, 20), Text = Color3.fromRGB(248, 249, 252),
        Muted = Color3.fromRGB(158, 162, 172), Accent = Color3.fromRGB(255, 126, 20),
        Accent2 = Color3.fromRGB(255, 170, 55), Accent3 = Color3.fromRGB(255, 210, 120),
        Success = Color3.fromRGB(70, 230, 140), Error = Color3.fromRGB(255, 75, 85),
    },
    Ice = {
        BG = Color3.fromRGB(5, 10, 20), Surface = Color3.fromRGB(10, 20, 35),
        Surface2 = Color3.fromRGB(15, 30, 50), Surface3 = Color3.fromRGB(20, 40, 65),
        Stroke = Color3.fromRGB(150, 220, 255), Text = Color3.fromRGB(240, 250, 255),
        Muted = Color3.fromRGB(150, 200, 240), Accent = Color3.fromRGB(50, 150, 255),
        Accent2 = Color3.fromRGB(150, 220, 255), Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Fire = {
        BG = Color3.fromRGB(20, 5, 0), Surface = Color3.fromRGB(35, 10, 5),
        Surface2 = Color3.fromRGB(50, 15, 5), Surface3 = Color3.fromRGB(65, 20, 10),
        Stroke = Color3.fromRGB(255, 100, 50), Text = Color3.fromRGB(255, 240, 230),
        Muted = Color3.fromRGB(220, 170, 150), Accent = Color3.fromRGB(255, 100, 50),
        Accent2 = Color3.fromRGB(255, 200, 50), Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Pink = {
        BG = Color3.fromRGB(20, 5, 15), Surface = Color3.fromRGB(35, 10, 25),
        Surface2 = Color3.fromRGB(50, 15, 35), Surface3 = Color3.fromRGB(65, 20, 45),
        Stroke = Color3.fromRGB(255, 105, 180), Text = Color3.fromRGB(255, 240, 250),
        Muted = Color3.fromRGB(230, 170, 210), Accent = Color3.fromRGB(255, 105, 180),
        Accent2 = Color3.fromRGB(255, 182, 220), Accent3 = Color3.fromRGB(255, 220, 245),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Green = {
        BG = Color3.fromRGB(5, 20, 10), Surface = Color3.fromRGB(10, 35, 20),
        Surface2 = Color3.fromRGB(15, 50, 30), Surface3 = Color3.fromRGB(20, 65, 40),
        Stroke = Color3.fromRGB(50, 255, 120), Text = Color3.fromRGB(240, 255, 245),
        Muted = Color3.fromRGB(170, 230, 190), Accent = Color3.fromRGB(50, 255, 120),
        Accent2 = Color3.fromRGB(150, 255, 180), Accent3 = Color3.fromRGB(200, 255, 220),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Blue = {
        BG = Color3.fromRGB(5, 10, 25), Surface = Color3.fromRGB(10, 20, 45),
        Surface2 = Color3.fromRGB(15, 30, 65), Surface3 = Color3.fromRGB(20, 40, 85),
        Stroke = Color3.fromRGB(50, 150, 255), Text = Color3.fromRGB(240, 245, 255),
        Muted = Color3.fromRGB(170, 200, 240), Accent = Color3.fromRGB(50, 150, 255),
        Accent2 = Color3.fromRGB(150, 200, 255), Accent3 = Color3.fromRGB(220, 235, 255),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Mustard = {
        BG = Color3.fromRGB(30, 25, 5), Surface = Color3.fromRGB(45, 38, 10),
        Surface2 = Color3.fromRGB(60, 50, 15), Surface3 = Color3.fromRGB(75, 62, 20),
        Stroke = Color3.fromRGB(230, 190, 50), Text = Color3.fromRGB(255, 250, 230),
        Muted = Color3.fromRGB(200, 180, 130), Accent = Color3.fromRGB(230, 190, 50),
        Accent2 = Color3.fromRGB(255, 220, 90), Accent3 = Color3.fromRGB(255, 240, 150),
        Success = Color3.fromRGB(150, 230, 100), Error = Color3.fromRGB(255, 80, 80),
    },
    Olive = {
        BG = Color3.fromRGB(20, 25, 10), Surface = Color3.fromRGB(35, 45, 20),
        Surface2 = Color3.fromRGB(50, 65, 30), Surface3 = Color3.fromRGB(65, 80, 40),
        Stroke = Color3.fromRGB(140, 170, 60), Text = Color3.fromRGB(245, 250, 235),
        Muted = Color3.fromRGB(180, 200, 140), Accent = Color3.fromRGB(140, 170, 60),
        Accent2 = Color3.fromRGB(180, 210, 90), Accent3 = Color3.fromRGB(210, 235, 140),
        Success = Color3.fromRGB(100, 220, 120), Error = Color3.fromRGB(255, 80, 80),
    },
}

local CurrentTheme = "Brutal"
local C = Themes[CurrentTheme]

local ThemeWidgets = {}
local function registerTheme(widget, key, property)
    table.insert(ThemeWidgets, {widget = widget, key = key, property = property})
end

local function applyTheme(themeName)
    CurrentTheme = themeName
    C = Themes[themeName]
    for _, item in ipairs(ThemeWidgets) do
        pcall(function()
            item.widget[item.property] = C[item.key]
        end)
    end
end

-- ============================================================
-- NOTIFICATION
-- ============================================================
local NotifHolder = nil

local function setupNotifHolder(parent)
    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.AnchorPoint = Vector2.new(0.5, 0)
    NotifHolder.Position = UDim2.new(0.5, 0, 0, 20)
    NotifHolder.Size = UDim2.fromOffset(420, 320)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.ZIndex = 500
    NotifHolder.Parent = parent
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = NotifHolder
end

local function notify(text, type)
    if not NotifHolder then return end
    type = type or "info"

    local color, icon
    if type == "success" then color = C.Success; icon = "✓"
    elseif type == "error" then color = C.Error; icon = "✕"
    elseif type == "warning" then color = Color3.fromRGB(255, 200, 50); icon = "!"
    else color = C.Accent; icon = "i" end

    local notif = Instance.new("Frame")
    notif.Size = UDim2.fromOffset(CFG.NOTIF_W, CFG.NOTIF_H)
    notif.BackgroundColor3 = C.Surface
    notif.BorderSizePixel = 0
    notif.ZIndex = 501
    notif.Parent = NotifHolder
    registerTheme(notif, "Surface", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = notif

    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.fromOffset(32, 32)
    iconBg.Position = UDim2.new(0, 12, 0.5, -16)
    iconBg.BackgroundColor3 = color
    iconBg.BorderSizePixel = 0
    iconBg.ZIndex = 502
    iconBg.Parent = notif

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconBg

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.fromScale(1, 1)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = Color3.new(1, 1, 1)
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextSize = 16
    iconLbl.ZIndex = 503
    iconLbl.Parent = iconBg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.fromOffset(54, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = CFG.FONT_LABEL
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 502
    label.Parent = notif
    registerTheme(label, "Text", "TextColor3")

    notif.Position = UDim2.fromOffset(0, -80)
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(0, 0)
    }):Play()

    task.delay(3, function()
        if notif and notif.Parent then
            TweenService:Create(notif, TweenInfo.new(0.3), {
                Position = UDim2.fromOffset(0, -80),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(iconLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.35)
            if notif then notif:Destroy() end
        end
    end)
end

-- ============================================================
-- CARD
-- ============================================================
local function makeCard(parent, title, layoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.Surface
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.LayoutOrder = layoutOrder or 1
    card.ZIndex = 1
    card.Parent = parent
    registerTheme(card, "Surface", "BackgroundColor3")

    local cardShadow = Instance.new("Frame")
    cardShadow.Name = "CardShadow"
    cardShadow.Size = UDim2.new(1, 8, 1, 10)
    cardShadow.Position = UDim2.fromOffset(0, 5)
    cardShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cardShadow.BackgroundTransparency = 0.48
    cardShadow.BorderSizePixel = 0
    cardShadow.ZIndex = 0
    cardShadow.Parent = card
    local cardShadowCorner = Instance.new("UICorner")
    cardShadowCorner.CornerRadius = UDim.new(0, 14)
    cardShadowCorner.Parent = cardShadow

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = card

    local cardGradient = Instance.new("UIGradient")
    cardGradient.Rotation = 90
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 25, 29)),
        ColorSequenceKeypoint.new(0.55, C.Surface),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 14)),
    })
    cardGradient.Parent = card

    local gloss = Instance.new("Frame")
    gloss.Name = "Gloss"
    gloss.Size = UDim2.new(1, -18, 0, 1)
    gloss.Position = UDim2.fromOffset(9, 1)
    gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gloss.BackgroundTransparency = 0.86
    gloss.BorderSizePixel = 0
    gloss.ZIndex = 2
    gloss.Parent = card
    local glossCorner = Instance.new("UICorner")
    glossCorner.CornerRadius = UDim.new(1, 0)
    glossCorner.Parent = gloss

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1.6
    stroke.Transparency = 0.22
    stroke.Parent = card
    registerTheme(stroke, "Accent", "Color")

    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, CFG.CARD_HEADER)
    headerFrame.BackgroundColor3 = C.Surface2
    headerFrame.BorderSizePixel = 0
    headerFrame.ZIndex = 2
    headerFrame.Parent = card
    registerTheme(headerFrame, "Surface2", "BackgroundColor3")

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Rotation = 0
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 34, 39)),
        ColorSequenceKeypoint.new(0.55, C.Surface2),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
    })
    headerGradient.Parent = headerFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 13)
    headerCorner.Parent = headerFrame

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = C.Accent
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = headerFrame

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    registerTheme(dot, "Accent", "BackgroundColor3")

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.fromOffset(26, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = C.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = CFG.FONT_TITLE
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = headerFrame
    registerTheme(titleLabel, "Text", "TextColor3")

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, CFG.CARD_HEADER)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = card

    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingTop = UDim.new(0, CFG.CARD_PAD_TOP)
    contentPad.PaddingBottom = UDim.new(0, CFG.CARD_PAD_BOT)
    contentPad.PaddingLeft = UDim.new(0, CFG.CARD_PAD_SIDE)
    contentPad.PaddingRight = UDim.new(0, CFG.CARD_PAD_SIDE)
    contentPad.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, CFG.CARD_GAP)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    return card, content
end

-- ============================================================
-- TOGGLE
-- ============================================================
local function makeToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, CFG.TOGGLE_H)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -(CFG.TOGGLE_W + 12), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = CFG.FONT_LABEL
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = frame
    registerTheme(label, "Text", "TextColor3")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(CFG.TOGGLE_W + 6, IS_MOBILE and 28 or 26)
    btn.Position = UDim2.new(1, -CFG.TOGGLE_W, 0.5, -(IS_MOBILE and 13 or 12))
    btn.BackgroundColor3 = default and C.Accent or C.Surface3
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 4
    btn.Parent = frame
    registerTheme(btn, default and "Accent" or "Surface3", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = default and C.Accent or Color3.fromRGB(80, 82, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.15
    btnStroke.Parent = btn
    if default then registerTheme(btnStroke, "Accent", "Color") end

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(CFG.TOGGLE_KNOB, CFG.TOGGLE_KNOB)
    knob.Position = default and UDim2.new(1, -(CFG.TOGGLE_KNOB + 3), 0.5, -CFG.TOGGLE_KNOB/2) or UDim2.new(0, 3, 0.5, -CFG.TOGGLE_KNOB/2)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 5
    knob.Parent = btn

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and C.Accent or C.Surface3
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -(CFG.TOGGLE_KNOB + 3), 0.5, -CFG.TOGGLE_KNOB/2) or UDim2.new(0, 3, 0.5, -CFG.TOGGLE_KNOB/2)
        }):Play()
        if callback then callback(state) end
    end)
end

-- ============================================================
-- DROPDOWN GLOBAL
-- ============================================================
_G.VRILZ_DropdownLayer = nil
_G.VRILZ_DropdownCloseOverlay = nil
_G.VRILZ_DropdownActive = nil

local function setupDropdownLayer(parent)
    _G.VRILZ_DropdownLayer = Instance.new("Frame")
    _G.VRILZ_DropdownLayer.Name = "DropdownLayer"
    _G.VRILZ_DropdownLayer.Size = UDim2.fromScale(1, 1)
    _G.VRILZ_DropdownLayer.BackgroundTransparency = 1
    _G.VRILZ_DropdownLayer.ZIndex = 2000
    _G.VRILZ_DropdownLayer.Parent = parent

    _G.VRILZ_DropdownCloseOverlay = Instance.new("TextButton")
    _G.VRILZ_DropdownCloseOverlay.Size = UDim2.fromScale(1, 1)
    _G.VRILZ_DropdownCloseOverlay.BackgroundTransparency = 1
    _G.VRILZ_DropdownCloseOverlay.Text = ""
    _G.VRILZ_DropdownCloseOverlay.ZIndex = 1999
    _G.VRILZ_DropdownCloseOverlay.Visible = false
    _G.VRILZ_DropdownCloseOverlay.Parent = _G.VRILZ_DropdownLayer

    _G.VRILZ_DropdownCloseOverlay.MouseButton1Click:Connect(function()
        if _G.VRILZ_DropdownActive and _G.VRILZ_DropdownActive.close then
            _G.VRILZ_DropdownActive.close()
        end
        _G.VRILZ_DropdownActive = nil
        _G.VRILZ_DropdownCloseOverlay.Visible = false
    end)
end

local function makeDropdownGlobal(anchorFrame, items, default, onSelect)
    local isOpen = false
    local selectedValue = default or items[1] or "Choose..."

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    container.BackgroundColor3 = C.Surface3
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = anchorFrame
    registerTheme(container, "Surface3", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = container
    registerTheme(stroke, "Accent", "Color")

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(1, -44, 1, 0)
    selectedLbl.Position = UDim2.fromOffset(12, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = selectedValue
    selectedLbl.TextColor3 = C.Text
    selectedLbl.Font = Enum.Font.GothamSemibold
    selectedLbl.TextSize = CFG.FONT_LABEL
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    selectedLbl.ZIndex = 4
    selectedLbl.Parent = container
    registerTheme(selectedLbl, "Text", "TextColor3")

    local arrow = Instance.new("Frame")
    arrow.Name = "DropdownChevron"
    arrow.Size = UDim2.fromOffset(IS_MOBILE and 20 or 22, IS_MOBILE and 16 or 18)
    arrow.Position = UDim2.new(1, -(IS_MOBILE and 27 or 29), 0.5, -(IS_MOBILE and 8 or 9))
    arrow.BackgroundTransparency = 1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 4
    arrow.Parent = container

    local chevronL = Instance.new("Frame")
    chevronL.Name = "Left"
    chevronL.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    chevronL.Position = UDim2.new(0.5, -(IS_MOBILE and 7 or 8), 0.5, -1)
    chevronL.BackgroundColor3 = C.Accent2
    chevronL.BorderSizePixel = 0
    chevronL.Rotation = 45
    chevronL.ZIndex = 5
    chevronL.Parent = arrow
    registerTheme(chevronL, "Accent2", "BackgroundColor3")

    local chevronR = Instance.new("Frame")
    chevronR.Name = "Right"
    chevronR.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    chevronR.Position = UDim2.new(0.5, 1, 0.5, -1)
    chevronR.BackgroundColor3 = C.Accent2
    chevronR.BorderSizePixel = 0
    chevronR.Rotation = -45
    chevronR.ZIndex = 5
    chevronR.Parent = arrow
    registerTheme(chevronR, "Accent2", "BackgroundColor3")

    local listFrame = Instance.new("ScrollingFrame")
    local popupWidth = CFG.DROPDOWN_POPUP_W
    listFrame.Size = UDim2.fromOffset(popupWidth, 0)
    listFrame.BackgroundColor3 = C.Surface2
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = C.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Visible = false
    listFrame.ZIndex = 2001
    listFrame.Parent = _G.VRILZ_DropdownLayer
    registerTheme(listFrame, "Surface2", "BackgroundColor3")

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.2
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    registerTheme(listStroke, "Accent", "Color")

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.PaddingLeft = UDim.new(0, 4)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = listFrame

    local itemHeight = CFG.DROPDOWN_ITEM
    local maxH = math.min(#items * (itemHeight + 2) + 10, IS_MOBILE and 126 or 148)

    local function closeList()
        isOpen = false
        chevronL.Rotation = 45
        chevronR.Rotation = -45
        local w = listFrame.Size.X.Offset
        TweenService:Create(listFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(w, 0)}):Play()
        task.delay(0.2, function()
            if not isOpen then listFrame.Visible = false end
        end)
        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = false
        end
        _G.VRILZ_DropdownActive = nil
    end

    local function openList()
        if _G.VRILZ_DropdownActive and _G.VRILZ_DropdownActive.close then
            _G.VRILZ_DropdownActive.close()
        end

        isOpen = true
        listFrame.Visible = true
        chevronL.Rotation = -45
        chevronR.Rotation = 45

        local width = math.min(CFG.DROPDOWN_POPUP_W, math.max(140, container.AbsoluteSize.X - 12))
        listFrame.Size = UDim2.fromOffset(width, 0)

        local containerAbsX = container.AbsolutePosition.X
        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsW = container.AbsoluteSize.X
        local containerAbsH = container.AbsoluteSize.Y
        local viewport = workspace.CurrentCamera.ViewportSize
        local screenW = viewport.X
        local screenH = viewport.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH + 8)
        local realMaxH = math.min(maxH, math.max(spaceBelow, 90))

        local popupRight = math.min(screenW - 8, containerAbsX + containerAbsW)
        local popupLeft = math.max(8, popupRight - width)
        listFrame.Position = UDim2.fromOffset(popupLeft, containerAbsY + containerAbsH + 6)

        TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(width, realMaxH)
        }):Play()

        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = true
        end

        _G.VRILZ_DropdownActive = {
            close = closeList,
            listFrame = listFrame,
            container = container
        }
    end

    container.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if isOpen then closeList() else openList() end
        end
    end)

    for i, item in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, -8, 0, itemHeight)
        opt.Position = UDim2.fromOffset(4, 0)
        opt.BackgroundColor3 = C.Surface3
        opt.Text = item
        opt.TextColor3 = C.Text
        opt.Font = Enum.Font.GothamSemibold
        opt.TextSize = CFG.FONT_LABEL
        opt.AutoButtonColor = false
        opt.ZIndex = 2002
        opt.LayoutOrder = i
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")
        registerTheme(opt, "Text", "TextColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 8)
        optCorner.Parent = opt

        if item == selectedValue then
            opt.BackgroundColor3 = C.Accent
        end

        opt.MouseButton1Click:Connect(function()
            selectedValue = item
            selectedLbl.Text = item
            closeList()
            if onSelect then onSelect(item) end
        end)
    end

    return container
end

-- ============================================================
-- DROPDOWN MULTI-SELECT
-- ============================================================
local function makeDropdownMulti(anchorFrame, items, sharedTable, itemColors, onChanged)
    local isOpen = false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    container.BackgroundColor3 = C.Surface3
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = anchorFrame
    registerTheme(container, "Surface3", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = container
    registerTheme(stroke, "Accent", "Color")

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(1, -44, 1, 0)
    selectedLbl.Position = UDim2.fromOffset(12, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = "..."
    selectedLbl.TextColor3 = C.Text
    selectedLbl.Font = Enum.Font.GothamSemibold
    selectedLbl.TextSize = CFG.FONT_LABEL
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    selectedLbl.ZIndex = 4
    selectedLbl.Parent = container
    registerTheme(selectedLbl, "Text", "TextColor3")

    local arrow = Instance.new("Frame")
    arrow.Name = "RarityChevron"
    arrow.Size = UDim2.fromOffset(IS_MOBILE and 20 or 22, IS_MOBILE and 16 or 18)
    arrow.Position = UDim2.new(1, -(IS_MOBILE and 27 or 29), 0.5, -(IS_MOBILE and 8 or 9))
    arrow.BackgroundTransparency = 1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 4
    arrow.Parent = container

    local arrowL = Instance.new("Frame")
    arrowL.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    arrowL.Position = UDim2.new(0.5, -(IS_MOBILE and 7 or 8), 0.5, -1)
    arrowL.BackgroundColor3 = C.Accent
    arrowL.BorderSizePixel = 0
    arrowL.Rotation = 45
    arrowL.ZIndex = 5
    arrowL.Parent = arrow
    registerTheme(arrowL, "Accent", "BackgroundColor3")

    local arrowR = Instance.new("Frame")
    arrowR.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    arrowR.Position = UDim2.new(0.5, 1, 0.5, -1)
    arrowR.BackgroundColor3 = C.Accent
    arrowR.BorderSizePixel = 0
    arrowR.Rotation = -45
    arrowR.ZIndex = 5
    arrowR.Parent = arrow
    registerTheme(arrowR, "Accent", "BackgroundColor3")

    local listFrame = Instance.new("ScrollingFrame")
    local popupWidth = CFG.DROPDOWN_POPUP_W
    listFrame.Size = UDim2.fromOffset(popupWidth, 0)
    listFrame.BackgroundColor3 = C.Surface2
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = C.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Visible = false
    listFrame.ZIndex = 2001
    listFrame.Parent = _G.VRILZ_DropdownLayer
    registerTheme(listFrame, "Surface2", "BackgroundColor3")

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.2
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    registerTheme(listStroke, "Accent", "Color")

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.PaddingLeft = UDim.new(0, 4)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = listFrame

    local itemHeight = CFG.DROPDOWN_ITEM
    local maxH = math.min(#items * (itemHeight + 2) + 10, IS_MOBILE and 126 or 148)

    local optionButtons = {}

    local function updateLabel()
        local selected = {}
        for _, r in ipairs(items) do
            if sharedTable[r] then table.insert(selected, r) end
        end
        if #selected == 0 then
            selectedLbl.Text = "Select..."
        elseif #selected <= 2 then
            selectedLbl.Text = table.concat(selected, ", ")
        else
            selectedLbl.Text = #selected .. " selected"
        end
    end

    local function updateButtonVisual(item)
        local opt = optionButtons[item]
        if not opt then return end
        local on = sharedTable[item] == true
        opt.chk.Text = on and "✓" or "○"
        opt.bg.BackgroundColor3 = on and C.Surface2 or C.Surface3
    end

    local function closeList()
        isOpen = false
        arrowL.Rotation = 45
        arrowR.Rotation = -45
        local w = listFrame.Size.X.Offset
        TweenService:Create(listFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(w, 0)}):Play()
        task.delay(0.2, function()
            if not isOpen then listFrame.Visible = false end
        end)
        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = false
        end
        _G.VRILZ_DropdownActive = nil
    end

    local function openList()
        if _G.VRILZ_DropdownActive and _G.VRILZ_DropdownActive.close then
            _G.VRILZ_DropdownActive.close()
        end

        isOpen = true
        listFrame.Visible = true
        arrowL.Rotation = -45
        arrowR.Rotation = 45

        local width = math.min(CFG.DROPDOWN_POPUP_W, math.max(140, container.AbsoluteSize.X - 12))
        listFrame.Size = UDim2.fromOffset(width, 0)

        local containerAbsX = container.AbsolutePosition.X
        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsW = container.AbsoluteSize.X
        local containerAbsH = container.AbsoluteSize.Y
        local viewport = workspace.CurrentCamera.ViewportSize
        local screenW = viewport.X
        local screenH = viewport.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH + 8)
        local realMaxH = math.min(maxH, math.max(spaceBelow, 90))

        local popupRight = math.min(screenW - 8, containerAbsX + containerAbsW)
        local popupLeft = math.max(8, popupRight - width)
        listFrame.Position = UDim2.fromOffset(popupLeft, containerAbsY + containerAbsH + 6)

        TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(width, realMaxH)
        }):Play()

        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = true
        end

        _G.VRILZ_DropdownActive = {
            close = closeList,
            listFrame = listFrame,
            container = container
        }
    end

    container.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if isOpen then closeList() else openList() end
        end
    end)

    for i, item in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, -8, 0, itemHeight)
        opt.Position = UDim2.fromOffset(4, 0)
        opt.BackgroundColor3 = C.Surface3
        opt.Text = ""
        opt.AutoButtonColor = false
        opt.ZIndex = 2002
        opt.LayoutOrder = i
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 5)
        optCorner.Parent = opt

        local chk = Instance.new("TextLabel")
        chk.Size = UDim2.fromOffset(24, itemHeight)
        chk.Position = UDim2.fromOffset(8, 0)
        chk.BackgroundTransparency = 1
        chk.Text = sharedTable[item] and "✓" or "○"
        chk.TextColor3 = C.Accent
        chk.Font = Enum.Font.GothamBold
        chk.TextSize = 14
        chk.ZIndex = 2003
        chk.Parent = opt

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -40, 1, 0)
        txt.Position = UDim2.fromOffset(36, 0)
        txt.BackgroundTransparency = 1
        txt.Text = item
        txt.TextColor3 = C.Text
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = CFG.FONT_LABEL
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.ZIndex = 2003
        txt.Parent = opt

        optionButtons[item] = {bg = opt, chk = chk, txt = txt}

        opt.MouseButton1Click:Connect(function()
            sharedTable[item] = not sharedTable[item]
            updateButtonVisual(item)
            updateLabel()
            if onChanged then onChanged(sharedTable) end
        end)
    end

    updateLabel()
    return container
end

-- ============================================================
-- BUILD MAIN WINDOW
-- ============================================================
local function buildMainWindow(parent)
    local screenGui = parent
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)

    local winW, winH
    if IS_MOBILE then
        winW = math.floor(viewport.X * CFG.WIN_W_PCT)
        winH = math.floor(viewport.Y * CFG.WIN_H_PCT)
    else
        winW = math.min(CFG.WIN_W, math.floor(viewport.X * 0.7))
        winH = math.min(CFG.WIN_H, math.floor(viewport.Y * 0.78))
    end

    local main = Instance.new("Frame")
    main.Name = "MainWindow"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.Size = UDim2.fromOffset(winW, winH)
    main.BackgroundColor3 = C.BG
    main.BorderSizePixel = 0
    main.ZIndex = 1
    main.Parent = screenGui
    registerTheme(main, "BG", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = main

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 2.6
    stroke.Transparency = 0.08
    stroke.Parent = main
    registerTheme(stroke, "Accent", "Color")

    -- HEADER
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, CFG.HEADER_H)
    header.BackgroundColor3 = C.Surface
    header.BorderSizePixel = 0
    header.ZIndex = 10
    header.Parent = main
    registerTheme(header, "Surface", "BackgroundColor3")

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 18)
    headerCorner.Parent = header

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.fromOffset(IS_MOBILE and 30 or 36, IS_MOBILE and 30 or 36)
    logo.Position = UDim2.fromOffset(IS_MOBILE and 10 or 12, (CFG.HEADER_H - (IS_MOBILE and 30 or 36)) / 2)
    logo.BackgroundColor3 = C.Accent
    logo.Text = "VH"
    logo.TextColor3 = Color3.new(1, 1, 1)
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = IS_MOBILE and 16 or 20
    logo.ZIndex = 11
    logo.Parent = header
    registerTheme(logo, "Accent", "BackgroundColor3")

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 20)
    title.Position = UDim2.fromOffset(IS_MOBILE and 48 or 58, IS_MOBILE and 8 or 10)
    title.BackgroundTransparency = 1
    title.Text = "VRILZHUB"
    title.TextColor3 = C.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = IS_MOBILE and 13 or 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11
    title.Parent = header
    registerTheme(title, "Text", "TextColor3")

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 300, 0, 14)
    subtitle.Position = UDim2.fromOffset(IS_MOBILE and 48 or 58, IS_MOBILE and 26 or 28)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Anime Dice · v1.0.0"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = IS_MOBILE and 9 or 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 11
    subtitle.Parent = header
    registerTheme(subtitle, "Muted", "TextColor3")

    -- Min & Close
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    minBtn.Position = UDim2.new(1, -(IS_MOBILE and 74 or 84), 0.5, -(IS_MOBILE and 14 or 16))
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "−"
    minBtn.TextColor3 = C.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = IS_MOBILE and 18 or 20
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 14
    minBtn.Parent = header
    registerTheme(minBtn, "Surface3", "BackgroundColor3")
    registerTheme(minBtn, "Text", "TextColor3")
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    closeBtn.Position = UDim2.new(1, -(IS_MOBILE and 38 or 44), 0.5, -(IS_MOBILE and 14 or 16))
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = IS_MOBILE and 20 or 22
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 14
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    -- BODY
    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 1, -(CFG.HEADER_H + 20))
    body.Position = UDim2.new(0, 10, 0, CFG.HEADER_H + 10)
    body.BackgroundTransparency = 1
    body.ZIndex = 2
    body.Parent = main

    local sidebarW = CFG.SIDEBAR_W

    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, sidebarW, 1, 0)
    sidebar.BackgroundColor3 = C.Surface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 3
    sidebar.ClipsDescendants = true
    sidebar.Parent = body
    registerTheme(sidebar, "Surface", "BackgroundColor3")
    Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 14)

    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Size = UDim2.fromScale(1, 1)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 2
    sidebarScroll.ScrollBarImageColor3 = C.Accent
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebarScroll.ZIndex = 4
    sidebarScroll.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarScroll

    local sidebarPad = Instance.new("UIPadding")
    sidebarPad.PaddingTop = UDim.new(0, IS_MOBILE and 6 or 10)
    sidebarPad.PaddingBottom = UDim.new(0, IS_MOBILE and 6 or 10)
    sidebarPad.PaddingLeft = UDim.new(0, 6)
    sidebarPad.PaddingRight = UDim.new(0, 6)
    sidebarPad.Parent = sidebarScroll

    -- PAGE HOLDER
    local pageHolder = Instance.new("ScrollingFrame")
    pageHolder.Size = UDim2.new(1, -(sidebarW + 10), 1, 0)
    pageHolder.Position = UDim2.new(0, sidebarW + 10, 0, 0)
    pageHolder.BackgroundTransparency = 1
    pageHolder.BorderSizePixel = 0
    pageHolder.ScrollBarThickness = 4
    pageHolder.ScrollBarImageColor3 = C.Accent
    pageHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    pageHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageHolder.ZIndex = 3
    pageHolder.Parent = body
    registerTheme(pageHolder, "Accent", "ScrollBarImageColor3")

    local pageHolderPad = Instance.new("UIPadding")
    pageHolderPad.PaddingTop = UDim.new(0, 4)
    pageHolderPad.PaddingBottom = UDim.new(0, 40)
    pageHolderPad.PaddingLeft = UDim.new(0, IS_MOBILE and 6 or 10)
    pageHolderPad.PaddingRight = UDim.new(0, IS_MOBILE and 6 or 10)
    pageHolderPad.Parent = pageHolder

    -- OPEN BUTTON (minimize)
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.fromOffset(CFG.OPEN_BTN, CFG.OPEN_BTN)
    openBtn.Position = UDim2.fromOffset(20, 20)
    openBtn.BackgroundColor3 = C.Surface
    openBtn.Text = "VH"
    openBtn.TextColor3 = C.Accent
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = IS_MOBILE and 18 or 20
    openBtn.BorderSizePixel = 0
    openBtn.Visible = false
    openBtn.ZIndex = 400
    openBtn.Parent = screenGui
    registerTheme(openBtn, "Surface", "BackgroundColor3")
    registerTheme(openBtn, "Accent", "TextColor3")
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 16)

    openBtn.MouseButton1Click:Connect(function()
        openBtn.Visible = false
        main.Visible = true
        main.Size = UDim2.fromOffset(0, 0)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(winW, winH)
        }):Play()
    end)

    minBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.delay(0.3, function()
            main.Visible = false
            openBtn.Visible = true
        end)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end)

    -- TAB SYSTEM
    local pages = {}
    local navs = {}

    local function registerTab(id, icon, label)
        local tabH = CFG.TAB_H
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, tabH)
        btn.BackgroundColor3 = C.Surface3
        btn.BackgroundTransparency = 0.5
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 5
        btn.Parent = sidebarScroll
        registerTheme(btn, "Surface3", "BackgroundColor3")

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = btn

        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = C.Accent
        tabStroke.Thickness = 1
        tabStroke.Transparency = 0.82
        tabStroke.Parent = btn
        registerTheme(tabStroke, "Accent", "Color")

        local ic = Instance.new("TextLabel")
        if CFG.TAB_SHOW_LABEL then
            ic.Size = UDim2.fromOffset(28, tabH)
            ic.Position = UDim2.fromOffset(10, 0)
        else
            ic.Size = UDim2.fromScale(1, 1)
        end
        ic.BackgroundTransparency = 1
        ic.Text = icon
        ic.TextSize = CFG.TAB_ICON
        ic.Font = Enum.Font.GothamBold
        ic.TextColor3 = C.Accent
        ic.ZIndex = 6
        ic.Parent = btn
        registerTheme(ic, "Accent", "TextColor3")

        local lbl
        if CFG.TAB_SHOW_LABEL then
            lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -44, 1, 0)
            lbl.Position = UDim2.fromOffset(42, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = C.Muted
            lbl.TextSize = CFG.FONT_LABEL
            lbl.Font = Enum.Font.GothamSemibold
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 6
            lbl.Parent = btn
            registerTheme(lbl, "Muted", "TextColor3")
        end

        navs[id] = {btn = btn, ic = ic, lbl = lbl}

        local function switchTo()
            for n, p in pairs(pages) do
                if p then p.Visible = false end
            end
            if pages[id] then pages[id].Visible = true end
            for n, x in pairs(navs) do
                if n == id then
                    x.btn.BackgroundColor3 = C.Accent
                    x.btn.BackgroundTransparency = 0
                    x.ic.TextColor3 = Color3.new(1, 1, 1)
                    if x.btn:FindFirstChildOfClass("UIStroke") then
                        x.btn:FindFirstChildOfClass("UIStroke").Transparency = 0.15
                    end
                    if x.lbl then x.lbl.TextColor3 = Color3.new(1, 1, 1) end
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    x.ic.TextColor3 = C.Accent
                    if x.btn:FindFirstChildOfClass("UIStroke") then
                        x.btn:FindFirstChildOfClass("UIStroke").Transparency = 0.82
                    end
                    if x.lbl then x.lbl.TextColor3 = C.Muted end
                end
            end
        end

        btn.MouseButton1Click:Connect(switchTo)
        return btn, switchTo
    end

    local function createPage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = C.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ScrollingEnabled = true
        page.Visible = false
        page.ZIndex = 7
        page.Parent = pageHolder

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 120)
        end)
        task.defer(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 120)
        end)

        return page
    end

    -- ============================================================
    -- TAB 1: INFO
    -- ============================================================
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "🎲 ANIME DICE INFO", 1)

    local avRow = Instance.new("Frame")
    avRow.Size = UDim2.new(1, 0, 0, IS_MOBILE and 60 or 70)
    avRow.BackgroundTransparency = 1
    avRow.LayoutOrder = 1
    avRow.Parent = infoContent

    local avSz = IS_MOBILE and 50 or 60
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(avSz, avSz)
    avatar.Position = UDim2.fromOffset(0, 5)
    avatar.BackgroundColor3 = C.Surface3
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    avatar.ZIndex = 3
    avatar.Parent = avRow
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    local avStroke = Instance.new("UIStroke")
    avStroke.Color = C.Accent
    avStroke.Thickness = 2.5
    avStroke.Parent = avatar
    registerTheme(avStroke, "Accent", "Color")

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -(avSz + 15), 0, 22)
    nameLbl.Position = UDim2.fromOffset(avSz + 15, IS_MOBILE and 10 or 12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = LocalPlayer.DisplayName
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = IS_MOBILE and 13 or 15
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 3
    nameLbl.Parent = avRow
    registerTheme(nameLbl, "Text", "TextColor3")

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -(avSz + 15), 0, 16)
    userLbl.Position = UDim2.fromOffset(avSz + 15, IS_MOBILE and 30 or 34)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "@" .. LocalPlayer.Name
    userLbl.TextColor3 = C.Muted
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextSize = IS_MOBILE and 10 or 11
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.ZIndex = 3
    userLbl.Parent = avRow
    registerTheme(userLbl, "Muted", "TextColor3")

    -- Update card
    local updateCard, updateContent = makeCard(infoPage, "📢 UPDATE INFORMATION", 2)

    local infoLines = {
        "Version        : 1.0.0",
        "Game           : Anime Dice",
        "Status         : Online ✅",
        "Features       : Auto Roll, Auto Sell, Auto Claim",
        "                 Auto Equip Best, Auto TP",
    }
    for i, line in ipairs(infoLines) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text = line
        lbl.TextColor3 = C.Muted
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = CFG.FONT_MUTED
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = i
        lbl.ZIndex = 3
        lbl.Parent = updateContent
        registerTheme(lbl, "Muted", "TextColor3")
    end

    -- Discord card
    local discordCard, discordContent = makeCard(infoPage, "💬 JOIN DISCORD", 3)
    local DISCORD_LINK = "https://discord.gg/psWhrYWbq"

    local discordLinkLbl = Instance.new("TextLabel")
    discordLinkLbl.Size = UDim2.new(1, 0, 0, 18)
    discordLinkLbl.BackgroundTransparency = 1
    discordLinkLbl.Text = "discord.gg/psWhrYWbq"
    discordLinkLbl.TextColor3 = C.Accent
    discordLinkLbl.Font = Enum.Font.GothamBold
    discordLinkLbl.TextSize = CFG.FONT_LABEL
    discordLinkLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLinkLbl.LayoutOrder = 1
    discordLinkLbl.ZIndex = 3
    discordLinkLbl.Parent = discordContent
    registerTheme(discordLinkLbl, "Accent", "TextColor3")

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, 0, 0, 32)
    discordBtn.BackgroundColor3 = C.Accent
    discordBtn.Text = "[ CLICK TO JOIN ]"
    discordBtn.TextColor3 = Color3.new(1, 1, 1)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = CFG.FONT_LABEL
    discordBtn.AutoButtonColor = false
    discordBtn.LayoutOrder = 2
    discordBtn.ZIndex = 3
    discordBtn.Parent = discordContent
    registerTheme(discordBtn, "Accent", "BackgroundColor3")
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)

    discordBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        notify("✓ Discord link copied!", "success")
    end)

    registerTab("Info", "ℹ", "Info")

    -- ============================================================
    -- TAB 2: SETTINGS
    -- ============================================================
    local setPage = createPage("Settings")
    pages.Settings = setPage

    -- ANTI-AFK
    local afkCard, afkContent = makeCard(setPage, "🛡 ANTI-AFK", 1)

    makeToggle(afkContent, "Enable Anti-AFK", true, function(v)
        Shared.AntiAFK_Enabled = v
        if v then notify("🛡 Anti-AFK: ON", "success")
        else notify("🛡 Anti-AFK: OFF", "info") end
    end)

    -- THEME
    local themeCard, themeContent = makeCard(setPage, "🎨 THEME", 2)

    local themeLbl = Instance.new("TextLabel")
    themeLbl.Size = UDim2.new(1, 0, 0, 16)
    themeLbl.BackgroundTransparency = 1
    themeLbl.Text = "Select Theme:"
    themeLbl.TextColor3 = C.Muted
    themeLbl.Font = Enum.Font.GothamSemibold
    themeLbl.TextSize = CFG.FONT_MUTED
    themeLbl.TextXAlignment = Enum.TextXAlignment.Left
    themeLbl.ZIndex = 3
    themeLbl.Parent = themeContent
    registerTheme(themeLbl, "Muted", "TextColor3")

    local themeList = {"Brutal", "Ice", "Fire", "Pink", "Green", "Blue", "Mustard", "Olive"}
    makeDropdownGlobal(themeContent, themeList, CurrentTheme, function(v)
        applyTheme(v)
        notify("Theme: " .. v, "success")
    end)

    registerTab("Settings", "⚙", "Settings")

    -- ============================================================
    -- SET DEFAULT TAB
    -- ============================================================
    pages.Info.Visible = true
    navs.Info.btn.BackgroundColor3 = C.Accent
    navs.Info.btn.BackgroundTransparency = 0
    navs.Info.ic.TextColor3 = Color3.new(1, 1, 1)
    if navs.Info.lbl then navs.Info.lbl.TextColor3 = Color3.new(1, 1, 1) end

    -- DRAG WINDOW
    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouseX = UserInputService:GetMouseLocation().X
            if mouseX > (header.AbsolutePosition.X + header.AbsoluteSize.X - 90) then return end
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    return main
end

-- ============================================================
-- SIMPLE LOADING (langsung main, tanpa key system dulu)
-- ============================================================
local function startMain(parent)
    buildMainWindow(parent)
    notify("Welcome, " .. LocalPlayer.DisplayName, "success")
end

-- ============================================================
-- UI.INIT
-- ============================================================
function UI.Init(sharedState)
    Shared = sharedState or {}
    Shared.Notify = notify
    _G.VRILZ_UI_Shared = Shared

    -- ===== ANIME DICE STATE =====
    Shared.AntiAFK_Enabled = true

    -- ===== SCREEN GUI =====
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_AnimeDice"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    setupNotifHolder(ScreenGui)
    setupDropdownLayer(ScreenGui)

    -- Langsung build main window
    startMain(ScreenGui)
end

return UI
