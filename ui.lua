-- ============================================================
-- VRILZHUB UI - ANIME DICE v1.0
-- ============================================================

local UI = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local function getFeatures()
    return _G.VRILZ_Features
end

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

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

local RarityList = {
    "Common", "Uncommon", "Rare", "Epic", "Legendary",
    "Mythical", "Divine", "Celestial", "Exotic",
    "Secret I", "Secret II", "Exclusive"
}

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
-- TITLE SYSTEM
-- ============================================================
local OWNER_USERID = 5126297278
local TITLE_GUI_NAME = "VRILZ_TitleTag"
local titleGuiRef = nil
local titleLoopRunning = false
local TITLE_SAVE_FILE = "vrilz_title.txt"

local function saveCustomTitle(title)
    if writefile then
        pcall(function() writefile(TITLE_SAVE_FILE, title or "") end)
    end
    _G.VRILZ_CustomTitle = title
end

local function loadCustomTitle()
    if _G.VRILZ_CustomTitle then return _G.VRILZ_CustomTitle end
    if readfile and isfile then
        local ok, exists = pcall(isfile, TITLE_SAVE_FILE)
        if ok and exists then
            local okRead, content = pcall(readfile, TITLE_SAVE_FILE)
            if okRead and content then
                content = content:gsub("^%s+", ""):gsub("%s+$", "")
                if content ~= "" then
                    _G.VRILZ_CustomTitle = content
                    return content
                end
            end
        end
    end
    return nil
end

local function clearCustomTitle()
    _G.VRILZ_CustomTitle = nil
    if delfile and isfile then
        local ok, exists = pcall(isfile, TITLE_SAVE_FILE)
        if ok and exists then pcall(delfile, TITLE_SAVE_FILE) end
    end
end

local function canCustomTitle()
    if LocalPlayer.UserId == OWNER_USERID then return true end
    if Shared and Shared.KeyType then
        local kt = tostring(Shared.KeyType):upper()
        if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then return true end
    end
    return false
end

local function getTitleText()
    if LocalPlayer.UserId == OWNER_USERID then
        local custom = _G.VRILZ_CustomTitle
        if custom and custom ~= "" then return "[OWNER " .. custom .. "]" end
        return "[OWNER]"
    end
    if canCustomTitle() then
        local custom = _G.VRILZ_CustomTitle
        if custom and custom ~= "" then return "[OWNER " .. custom .. "]" end
    end
    return "[VH COMMUNITY]"
end

local function getTitleColors()
    if LocalPlayer.UserId == OWNER_USERID or canCustomTitle() then
        return {
            Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 127, 0),
            Color3.fromRGB(255, 255, 0), Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(139, 0, 255), Color3.fromRGB(255, 0, 255),
        }
    end
    return { Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255) }
end

local function removeTitle()
    if titleGuiRef then
        pcall(function() titleGuiRef:Destroy() end)
        titleGuiRef = nil
    end
end

local function buildTitle()
    removeTitle()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = TITLE_GUI_NAME
    bb.Size = UDim2.fromOffset(220, 32)
    bb.StudsOffset = Vector3.new(0, 2.8, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 500
    bb.Adornee = head
    bb.Parent = head
    titleGuiRef = bb

    local lbl = Instance.new("TextLabel")
    lbl.Name = "TitleLabel"
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = getTitleText()
    lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.2
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 15
    lbl.Parent = bb

    if not titleLoopRunning then
        titleLoopRunning = true
        task.spawn(function()
            local idx = 1
            while titleLoopRunning do
                task.wait(0.12)
                if not Shared.ShowTitle then idx = 1 continue end
                local colors = getTitleColors()
                if titleGuiRef and titleGuiRef.Parent then
                    local label = titleGuiRef:FindFirstChild("TitleLabel")
                    if label then label.TextColor3 = colors[idx] end
                end
                idx = idx + 1
                if idx > #colors then idx = 1 end
            end
        end)
    end
end

local function refreshTitle()
    if Shared.ShowTitle then buildTitle() else removeTitle() end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    refreshTitle()
end)

_G.VRILZ_RefreshTitle = refreshTitle

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
    if type == "success" then color = C.Success; icon = "v"
    elseif type == "error" then color = C.Error; icon = "x"
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
    arrow.ZIndex = 4
    arrow.Parent = container

    local chevronL = Instance.new("Frame")
    chevronL.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    chevronL.Position = UDim2.new(0.5, -(IS_MOBILE and 7 or 8), 0.5, -1)
    chevronL.BackgroundColor3 = C.Accent2
    chevronL.BorderSizePixel = 0
    chevronL.Rotation = 45
    chevronL.ZIndex = 5
    chevronL.Parent = arrow
    registerTheme(chevronL, "Accent2", "BackgroundColor3")

    local chevronR = Instance.new("Frame")
    chevronR.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    chevronR.Position = UDim2.new(0.5, 1, 0.5, -1)
    chevronR.BackgroundColor3 = C.Accent2
    chevronR.BorderSizePixel = 0
    chevronR.Rotation = -45
    chevronR.ZIndex = 5
    chevronR.Parent = arrow
    registerTheme(chevronR, "Accent2", "BackgroundColor3")

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.fromOffset(CFG.DROPDOWN_POPUP_W, 0)
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
        if _G.VRILZ_DropdownCloseOverlay then _G.VRILZ_DropdownCloseOverlay.Visible = false end
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

        if _G.VRILZ_DropdownCloseOverlay then _G.VRILZ_DropdownCloseOverlay.Visible = true end

        _G.VRILZ_DropdownActive = { close = closeList, listFrame = listFrame, container = container }
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
-- DROPDOWN MULTI
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
    arrow.Size = UDim2.fromOffset(IS_MOBILE and 20 or 22, IS_MOBILE and 16 or 18)
    arrow.Position = UDim2.new(1, -(IS_MOBILE and 27 or 29), 0.5, -(IS_MOBILE and 8 or 9))
    arrow.BackgroundTransparency = 1
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
    listFrame.Size = UDim2.fromOffset(CFG.DROPDOWN_POPUP_W, 0)
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
        if #selected == 0 then selectedLbl.Text = "Select..."
        elseif #selected <= 2 then selectedLbl.Text = table.concat(selected, ", ")
        else selectedLbl.Text = #selected .. " selected" end
    end

    local function updateButtonVisual(item)
        local opt = optionButtons[item]
        if not opt then return end
        local on = sharedTable[item] == true
        opt.chk.Text = on and "v" or "o"
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
        if _G.VRILZ_DropdownCloseOverlay then _G.VRILZ_DropdownCloseOverlay.Visible = false end
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

        if _G.VRILZ_DropdownCloseOverlay then _G.VRILZ_DropdownCloseOverlay.Visible = true end

        _G.VRILZ_DropdownActive = { close = closeList, listFrame = listFrame, container = container }
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
        chk.Text = sharedTable[item] and "v" or "o"
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
-- FPS WINDOW
-- ============================================================
local function buildFPSWindow(parent)
    local fpsWin = Instance.new("Frame")
    fpsWin.Name = "FPSWindow"
    fpsWin.Size = UDim2.fromOffset(IS_MOBILE and 160 or 180, IS_MOBILE and 64 or 70)
    fpsWin.Position = UDim2.fromOffset(20, 90)
    fpsWin.BackgroundColor3 = C.Surface
    fpsWin.BackgroundTransparency = 0.1
    fpsWin.BorderSizePixel = 0
    fpsWin.Visible = false
    fpsWin.ZIndex = 60
    fpsWin.Parent = parent
    registerTheme(fpsWin, "Surface", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = fpsWin

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = fpsWin
    registerTheme(stroke, "Accent", "Color")

    local fpsLbl = Instance.new("TextLabel")
    fpsLbl.Size = UDim2.new(1, -20, 0, 24)
    fpsLbl.Position = UDim2.fromOffset(10, 8)
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS: --"
    fpsLbl.TextColor3 = C.Text
    fpsLbl.Font = Enum.Font.GothamBold
    fpsLbl.TextSize = IS_MOBILE and 12 or 14
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
    fpsLbl.ZIndex = 61
    fpsLbl.Parent = fpsWin
    registerTheme(fpsLbl, "Text", "TextColor3")

    local pingLbl = Instance.new("TextLabel")
    pingLbl.Size = UDim2.new(1, -20, 0, 20)
    pingLbl.Position = UDim2.fromOffset(10, IS_MOBILE and 30 or 34)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "PING: --"
    pingLbl.TextColor3 = C.Accent2
    pingLbl.Font = Enum.Font.GothamBold
    pingLbl.TextSize = IS_MOBILE and 11 or 12
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    pingLbl.ZIndex = 61
    pingLbl.Parent = fpsWin
    registerTheme(pingLbl, "Accent2", "TextColor3")

    local frames, last = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local elapsed = os.clock() - last
        if elapsed >= 0.5 then
            local fps = math.floor(frames / elapsed)
            local ping = 0
            pcall(function()
                ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            fpsLbl.Text = "FPS: " .. fps
            pingLbl.Text = "PING: " .. ping .. "ms"
            frames = 0
            last = os.clock()
        end
    end)

    return fpsWin
end

-- ============================================================
-- LIVE CHAT CLIENT
-- ============================================================
_G.VRILZ_ChatClient = _G.VRILZ_ChatClient or { listeners = {}, lastTs = 0, polling = false }
local ChatClient = _G.VRILZ_ChatClient

local function getChatHttpRequest()
    return (syn and syn.request) or (http and http.request) or (http_request) or (request)
end

local function chatHttpJSON(url, method, bodyTable)
    local HttpService = game:GetService("HttpService")
    local ok, res = pcall(function()
        local req = getChatHttpRequest()
        if req then
            local opts = { Url = url, Method = method, Headers = {["Content-Type"] = "application/json"} }
            if bodyTable then opts.Body = HttpService:JSONEncode(bodyTable) end
            return req(opts)
        end
        if method == "POST" then
            return { StatusCode = 200, Body = HttpService:PostAsync(url, HttpService:JSONEncode(bodyTable), Enum.HttpContentType.ApplicationJson) }
        end
        return { StatusCode = 200, Body = HttpService:GetAsync(url) }
    end)
    if not ok or not res then return nil end
    local okDecode, data = pcall(function() return HttpService:JSONDecode(res.Body or res.body or "") end)
    if not okDecode then return nil end
    return data
end

function ChatClient.onMessage(cb) table.insert(ChatClient.listeners, cb) end

function ChatClient.send(text)
    if type(text) ~= "string" then return false, "invalid" end
    text = text:gsub("[\n\r]", " "):sub(1, 200)
    if text == "" then return false, "empty" end
    local data = chatHttpJSON(KEY_SYSTEM_URL:gsub("/$", "") .. "/api/chat/send", "POST", {
        userId = LocalPlayer.UserId, username = LocalPlayer.Name,
        displayName = LocalPlayer.DisplayName, text = text,
    })
    if data and data.success then return true end
    return false, (data and data.message) or "network error"
end

function ChatClient.pollOnce()
    local url = KEY_SYSTEM_URL:gsub("/$", "") .. "/api/chat/poll?since=" .. tostring(ChatClient.lastTs)
    local data = chatHttpJSON(url, "GET", nil)
    if not data or not data.success or type(data.messages) ~= "table" then return end
    for _, m in ipairs(data.messages) do
        local ts = tonumber(m.ts or 0)
        if ts > ChatClient.lastTs then ChatClient.lastTs = ts end
        local msg = {
            userId = tonumber(m.i or 0), username = tostring(m.u or "?"),
            displayName = tostring(m.d or m.u or "?"), text = tostring(m.t or ""),
            time = os.date("%H:%M", math.floor(ts / 1000)), ts = ts,
        }
        table.insert(Shared.LiveChat_Messages, msg)
        while #Shared.LiveChat_Messages > Shared.LiveChat_MaxMessages do
            table.remove(Shared.LiveChat_Messages, 1)
        end
        for _, cb in ipairs(ChatClient.listeners) do task.spawn(cb, msg) end
    end
end

function ChatClient.start()
    if ChatClient.polling then return end
    ChatClient.polling = true
    task.spawn(function()
        while ChatClient.polling do
            pcall(ChatClient.pollOnce)
            task.wait(Shared.LiveChat_PollInterval or 1.5)
        end
    end)
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
    Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 8)

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
    subtitle.Text = "Anime Dice v1.0.0"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = IS_MOBILE and 9 or 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 11
    subtitle.Parent = header
    registerTheme(subtitle, "Muted", "TextColor3")

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    minBtn.Position = UDim2.new(1, -(IS_MOBILE and 74 or 84), 0.5, -(IS_MOBILE and 14 or 16))
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "-"
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
    closeBtn.Text = "x"
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
    sidebarPad.PaddingTop = UDim.new(0, 10)
    sidebarPad.PaddingBottom = UDim.new(0, 10)
    sidebarPad.PaddingLeft = UDim.new(0, 6)
    sidebarPad.PaddingRight = UDim.new(0, 6)
    sidebarPad.Parent = sidebarScroll

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
    pageHolderPad.PaddingLeft = UDim.new(0, 10)
    pageHolderPad.PaddingRight = UDim.new(0, 10)
    pageHolderPad.Parent = pageHolder

    -- OPEN BUTTON
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
            main.Visible = false
            openBtn.Visible = true
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
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)

        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = C.Accent
        tabStroke.Thickness = 1
        tabStroke.Transparency = 0.82
        tabStroke.Parent = btn
        registerTheme(tabStroke, "Accent", "Color")

        local ic = Instance.new("TextLabel")
        ic.Size = UDim2.fromScale(1, 1)
        ic.BackgroundTransparency = 1
        ic.Text = icon
        ic.TextSize = CFG.TAB_ICON
        ic.Font = Enum.Font.GothamBold
        ic.TextColor3 = C.Accent
        ic.ZIndex = 6
        ic.Parent = btn
        registerTheme(ic, "Accent", "TextColor3")

        navs[id] = {btn = btn, ic = ic}

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
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    x.ic.TextColor3 = C.Accent
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
        layout.Padding = UDim.new(0, 12)
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

    -- TAB INFO
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "ANIME DICE INFO", 1)

    local avRow = Instance.new("Frame")
    avRow.Size = UDim2.new(1, 0, 0, 70)
    avRow.BackgroundTransparency = 1
    avRow.LayoutOrder = 1
    avRow.Parent = infoContent

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(60, 60)
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
    nameLbl.Size = UDim2.new(1, -75, 0, 22)
    nameLbl.Position = UDim2.fromOffset(75, 12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = LocalPlayer.DisplayName
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 15
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 3
    nameLbl.Parent = avRow
    registerTheme(nameLbl, "Text", "TextColor3")

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -75, 0, 16)
    userLbl.Position = UDim2.fromOffset(75, 34)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "@" .. LocalPlayer.Name
    userLbl.TextColor3 = C.Muted
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextSize = 11
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.ZIndex = 3
    userLbl.Parent = avRow
    registerTheme(userLbl, "Muted", "TextColor3")

    local sessionLbl = Instance.new("TextLabel")
    sessionLbl.Size = UDim2.new(1, 0, 0, 20)
    sessionLbl.BackgroundTransparency = 1
    sessionLbl.Text = "Session: 00:00"
    sessionLbl.TextColor3 = C.Accent2
    sessionLbl.Font = Enum.Font.GothamBold
    sessionLbl.TextSize = CFG.FONT_LABEL
    sessionLbl.TextXAlignment = Enum.TextXAlignment.Left
    sessionLbl.LayoutOrder = 2
    sessionLbl.ZIndex = 3
    sessionLbl.Parent = infoContent
    registerTheme(sessionLbl, "Accent2", "TextColor3")

    local sessionStart = os.clock()
    task.spawn(function()
        while sessionLbl.Parent do
            task.wait(1)
            local elapsed = math.floor(os.clock() - sessionStart)
            local m = math.floor(elapsed / 60)
            local s = elapsed % 60
            sessionLbl.Text = string.format("Session: %02d:%02d", m, s)
        end
    end)

    local updateCard, updateContent = makeCard(infoPage, "UPDATE INFORMATION", 2)

    local infoLines = {
        "Version : 1.0.0",
        "Game    : Anime Dice",
        "Status  : Online",
        "Features: Auto Roll, Auto Sell, Auto Claim",
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

    local discordCard, discordContent = makeCard(infoPage, "JOIN DISCORD", 3)
    local DISCORD_LINK = "https://discord.gg/psWhrYWbq"

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, 0, 0, 32)
    discordBtn.BackgroundColor3 = C.Accent
    discordBtn.Text = "CLICK TO JOIN"
    discordBtn.TextColor3 = Color3.new(1, 1, 1)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = CFG.FONT_LABEL
    discordBtn.AutoButtonColor = false
    discordBtn.LayoutOrder = 1
    discordBtn.ZIndex = 3
    discordBtn.Parent = discordContent
    registerTheme(discordBtn, "Accent", "BackgroundColor3")
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)

    discordBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        notify("Discord link copied!", "success")
    end)

    registerTab("Info", "i", "Info")

    -- TAB SETTINGS
    local setPage = createPage("Settings")
    pages.Settings = setPage

    local afkCard, afkContent = makeCard(setPage, "ANTI-AFK", 1)

    makeToggle(afkContent, "Enable Anti-AFK", true, function(v)
        Shared.AntiAFK_Enabled = v
        if v then notify("Anti-AFK: ON", "success")
        else notify("Anti-AFK: OFF", "info") end
    end)

    local themeCard, themeContent = makeCard(setPage, "THEME", 2)

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

    local themeList = {"Brutal", "Ice", "Fire", "Pink", "Green", "Blue", "Mustard", "Olive"}
    makeDropdownGlobal(themeContent, themeList, CurrentTheme, function(v)
        applyTheme(v)
        notify("Theme: " .. v, "success")
    end)

    local titleCard, titleContent = makeCard(setPage, "TITLE", 3)

    makeToggle(titleContent, "Show Title", true, function(v)
        Shared.ShowTitle = v
        if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
        if v then notify("Title: ON", "success")
        else notify("Title: OFF", "info") end
    end)

    local chatCard, chatContent = makeCard(setPage, "LIVE CHAT", 4)

    makeToggle(chatContent, "Show Live Chat Window", false, function(v)
        if _G.VRILZ_LiveChatWindow then
            _G.VRILZ_LiveChatWindow.Visible = v
            if v then
                pcall(function()
                    if ChatClient and ChatClient.start then ChatClient.start() end
                end)
                notify("Live Chat opened", "success")
            else
                notify("Live Chat closed", "info")
            end
        end
    end)

    local fpsCard, fpsContent = makeCard(setPage, "GRAPHICS", 5)

    local fpsWin = buildFPSWindow(screenGui)
    UI._fpsWindow = fpsWin

    makeToggle(fpsContent, "FPS Window", false, function(v)
        if fpsWin then fpsWin.Visible = v end
    end)

    registerTab("Settings", "S", "Settings")

    pages.Info.Visible = true
    navs.Info.btn.BackgroundColor3 = C.Accent
    navs.Info.btn.BackgroundTransparency = 0
    navs.Info.ic.TextColor3 = Color3.new(1, 1, 1)

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
-- BUILD LIVE CHAT WINDOW
-- ============================================================
local function buildLiveChatWindow(parent)
    print("[CHAT] buildLiveChatWindow START")

    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local isMob = IS_MOBILE

    local winW = isMob and math.floor(viewport.X * 0.92) or math.min(520, math.floor(viewport.X * 0.55))
    local winH = isMob and math.floor(viewport.Y * 0.7) or 520

    local win = Instance.new("Frame")
    win.Name = "LiveChatWindow"
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.Position = UDim2.fromScale(0.5, 0.5)
    win.Size = UDim2.fromOffset(winW, winH)
    win.BackgroundColor3 = C.BG
    win.BorderSizePixel = 0
    win.Visible = false
    win.ZIndex = 600
    win.Parent = parent
    registerTheme(win, "BG", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = win

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 2.2
    stroke.Transparency = 0.15
    stroke.Parent = win
    registerTheme(stroke, "Accent", "Color")

    local headerH = 42
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, headerH)
    header.BackgroundColor3 = C.Surface
    header.BorderSizePixel = 0
    header.ZIndex = 610
    header.Parent = win
    registerTheme(header, "Surface", "BackgroundColor3")

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -100, 1, 0)
    titleLbl.Position = UDim2.fromOffset(30, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "LIVE CHAT"
    titleLbl.TextColor3 = C.Text
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = isMob and 12 or 13
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 613
    titleLbl.Parent = header
    registerTheme(titleLbl, "Text", "TextColor3")

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(28, 28)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "x"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 613
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

    closeBtn.MouseButton1Click:Connect(function()
        win.Visible = false
    end)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 1, -(headerH + 16))
    body.Position = UDim2.new(0, 10, 0, headerH + 8)
    body.BackgroundTransparency = 1
    body.ZIndex = 605
    body.Parent = win

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 1, -50)
    listFrame.BackgroundColor3 = C.Surface2
    listFrame.BackgroundTransparency = 0.4
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = C.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.ZIndex = 606
    listFrame.Parent = body
    registerTheme(listFrame, "Surface2", "BackgroundColor3")

    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 12)
    lc.Parent = listFrame

    local lp = Instance.new("UIPadding")
    lp.PaddingTop = UDim.new(0, 8)
    lp.PaddingBottom = UDim.new(0, 8)
    lp.PaddingLeft = UDim.new(0, 8)
    lp.PaddingRight = UDim.new(0, 8)
    lp.Parent = listFrame

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 6)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Parent = listFrame

    local emptyLbl = Instance.new("TextLabel")
    emptyLbl.Size = UDim2.new(1, 0, 0, 40)
    emptyLbl.BackgroundTransparency = 1
    emptyLbl.Text = "No messages yet..."
    emptyLbl.TextColor3 = C.Muted
    emptyLbl.Font = Enum.Font.GothamSemibold
    emptyLbl.TextSize = CFG.FONT_LABEL
    emptyLbl.ZIndex = 607
    emptyLbl.Parent = listFrame
    registerTheme(emptyLbl, "Muted", "TextColor3")

    local inputBg = Instance.new("Frame")
    inputBg.Size = UDim2.new(1, 0, 0, 42)
    inputBg.Position = UDim2.new(0, 0, 1, -42)
    inputBg.BackgroundColor3 = C.Surface3
    inputBg.BorderSizePixel = 0
    inputBg.ZIndex = 606
    inputBg.Parent = body
    registerTheme(inputBg, "Surface3", "BackgroundColor3")
    Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 10)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -76, 1, 0)
    box.Position = UDim2.fromOffset(12, 0)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.PlaceholderText = "Type message..."
    box.PlaceholderColor3 = C.Muted
    box.TextColor3 = C.Text
    box.Font = Enum.Font.GothamSemibold
    box.TextSize = CFG.FONT_LABEL
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.ZIndex = 607
    box.Parent = inputBg
    registerTheme(box, "Text", "TextColor3")

    local sendBtn = Instance.new("TextButton")
    sendBtn.Size = UDim2.fromOffset(60, 32)
    sendBtn.Position = UDim2.new(1, -68, 0.5, -16)
    sendBtn.BackgroundColor3 = C.Accent
    sendBtn.Text = "SEND"
    sendBtn.TextColor3 = Color3.new(1, 1, 1)
    sendBtn.Font = Enum.Font.GothamBold
    sendBtn.TextSize = 11
    sendBtn.AutoButtonColor = false
    sendBtn.BorderSizePixel = 0
    sendBtn.ZIndex = 607
    sendBtn.Parent = inputBg
    registerTheme(sendBtn, "Accent", "BackgroundColor3")
    Instance.new("UICorner", sendBtn).CornerRadius = UDim.new(0, 8)

    local msgCounter = 0
    local OWNER_IDS = { [5126297278] = true }

    local function scrollBottom()
        task.defer(function()
            listFrame.CanvasPosition = Vector2.new(0, listFrame.AbsoluteCanvasSize.Y)
        end)
    end

    local function renderMessage(msg)
        if emptyLbl.Parent then emptyLbl:Destroy() end

        local isMe = (msg.userId == LocalPlayer.UserId)
        local isOwner = (OWNER_IDS[msg.userId] == true)
        local avatarSize = isMob and 26 or 34
        local avatarGap = isMob and 6 or 10

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 0)
        row.AutomaticSize = Enum.AutomaticSize.Y
        row.BackgroundColor3 = isOwner and Color3.fromRGB(45, 20, 10) or (isMe and C.Surface3 or C.Surface)
        row.BackgroundTransparency = 0.3
        row.BorderSizePixel = 0
        msgCounter = msgCounter + 1
        row.LayoutOrder = msgCounter
        row.ZIndex = 607
        row.Parent = listFrame
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

        local rp = Instance.new("UIPadding")
        rp.PaddingTop = UDim.new(0, 8)
        rp.PaddingBottom = UDim.new(0, 8)
        rp.PaddingLeft = UDim.new(0, 10)
        rp.PaddingRight = UDim.new(0, 10)
        rp.Parent = row

        local avContainer = Instance.new("Frame")
        avContainer.Size = UDim2.fromOffset(avatarSize, avatarSize)
        avContainer.Position = UDim2.fromOffset(0, 0)
        avContainer.BackgroundColor3 = C.Surface2
        avContainer.BorderSizePixel = 0
        avContainer.ZIndex = 608
        avContainer.Parent = row
        Instance.new("UICorner", avContainer).CornerRadius = UDim.new(1, 0)

        local avImg = Instance.new("ImageLabel")
        avImg.Size = UDim2.fromScale(1, 1)
        avImg.BackgroundTransparency = 1
        avImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(msg.userId) .. "&w=100&h=100"
        avImg.ZIndex = 609
        avImg.Parent = avContainer
        Instance.new("UICorner", avImg).CornerRadius = UDim.new(1, 0)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -(avatarSize + avatarGap), 0, 18)
        nameLbl.Position = UDim2.fromOffset(avatarSize + avatarGap, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = (isMe and "You" or msg.displayName)
        nameLbl.TextColor3 = isOwner and Color3.fromRGB(255, 200, 50) or (isMe and C.Accent2 or C.Accent)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 609
        nameLbl.Parent = row

        local bodyLbl = Instance.new("TextLabel")
        bodyLbl.Size = UDim2.new(1, -(avatarSize + avatarGap), 0, 0)
        bodyLbl.AutomaticSize = Enum.AutomaticSize.Y
        bodyLbl.Position = UDim2.fromOffset(avatarSize + avatarGap, 20)
        bodyLbl.BackgroundTransparency = 1
        bodyLbl.Text = msg.text
        bodyLbl.TextColor3 = C.Text
        bodyLbl.Font = Enum.Font.GothamSemibold
        bodyLbl.TextSize = CFG.CHAT_FONT
        bodyLbl.TextWrapped = true
        bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
        bodyLbl.TextYAlignment = Enum.TextYAlignment.Top
        bodyLbl.ZIndex = 608
        bodyLbl.Parent = row
        registerTheme(bodyLbl, "Text", "TextColor3")

        scrollBottom()
    end

    for _, m in ipairs(Shared.LiveChat_Messages) do
        renderMessage(m)
    end

    ChatClient.onMessage(function(msg)
        renderMessage(msg)
    end)

    local function doSend()
        local text = box.Text
        if text == "" then return end
        sendBtn.Text = "..."
        task.spawn(function()
            local ok, err = ChatClient.send(text)
            if ok then box.Text = ""
            else notify("Chat: " .. tostring(err), "error") end
            sendBtn.Text = "SEND"
        end)
    end

    sendBtn.MouseButton1Click:Connect(doSend)
    box.FocusLost:Connect(function(enter)
        if enter then doSend() end
    end)

    print("[CHAT] buildLiveChatWindow OK")
    return win
end

-- ============================================================
-- LOADING SCREEN
-- ============================================================
local function buildLoadingScreen(parent)
    local winW = IS_MOBILE and 280 or 360
    local winH = IS_MOBILE and 200 or 240

    local loading = Instance.new("Frame")
    loading.Name = "LoadingScreen"
    loading.AnchorPoint = Vector2.new(0.5, 0.5)
    loading.Position = UDim2.fromScale(0.5, 0.5)
    loading.Size = UDim2.fromOffset(0, 0)
    loading.BackgroundColor3 = Color3.fromRGB(5, 0, 2)
    loading.BorderSizePixel = 0
    loading.ZIndex = 300
    loading.ClipsDescendants = true
    loading.Parent = parent

    local stroke1 = Instance.new("UIStroke")
    stroke1.Color = Color3.fromRGB(255, 30, 60)
    stroke1.Thickness = 3
    stroke1.Parent = loading

    local vHolder = Instance.new("Frame")
    vHolder.Size = UDim2.fromScale(1, 0.55)
    vHolder.Position = UDim2.fromScale(0, 0.15)
    vHolder.BackgroundTransparency = 1
    vHolder.ZIndex = 305
    vHolder.Parent = loading

    local vLabel = Instance.new("TextLabel")
    vLabel.Size = UDim2.fromScale(1, 1)
    vLabel.BackgroundTransparency = 1
    vLabel.Text = "V"
    vLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    vLabel.Font = Enum.Font.GothamBlack
    vLabel.TextSize = 1
    vLabel.ZIndex = 306
    vLabel.Parent = vHolder

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, -20, 0, 18)
    loadingText.Position = UDim2.new(0, 10, 0, winH - 68)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "LOADING..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.Font = Enum.Font.GothamBlack
    loadingText.TextSize = 12
    loadingText.TextXAlignment = Enum.TextXAlignment.Left
    loadingText.ZIndex = 306
    loadingText.Parent = loading

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 6)
    barBg.Position = UDim2.new(0, 10, 0, winH - 44)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 5, 10)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 305
    barBg.Parent = loading

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 306
    barFill.Parent = barBg

    local percentLbl = Instance.new("TextLabel")
    percentLbl.Size = UDim2.new(1, -20, 0, 14)
    percentLbl.Position = UDim2.new(0, 10, 0, winH - 26)
    percentLbl.BackgroundTransparency = 1
    percentLbl.Text = "0%"
    percentLbl.TextColor3 = Color3.fromRGB(255, 30, 60)
    percentLbl.Font = Enum.Font.GothamBlack
    percentLbl.TextSize = 10
    percentLbl.TextXAlignment = Enum.TextXAlignment.Right
    percentLbl.ZIndex = 306
    percentLbl.Parent = loading

    task.spawn(function()
        local startSize = 1
        local endSize = IS_MOBILE and 130 or 170
        local duration = 1.2
        for i = 1, 40 do
            task.wait(duration / 40)
            local t = i / 40
            local eased = 1 - (1 - t) ^ 3
            vLabel.TextSize = startSize + (endSize - startSize) * eased
        end
    end)

    task.spawn(function()
        loading.Size = UDim2.fromOffset(0, 0)
        TweenService:Create(loading, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(winW, winH)
        }):Play()
        task.wait(0.6)

        loadingText.Text = "INITIALIZING..."
        for i = 1, 30 do
            task.wait(0.1)
            local p = (i / 30) * 0.15
            barFill.Size = UDim2.new(p, 0, 1, 0)
            percentLbl.Text = math.floor(p * 100) .. "%"
        end

        local phases = {
            {text = "LOADING MODULES...", target = 0.4, duration = 1.5},
            {text = "CONNECTING SERVER...", target = 0.6, duration = 1.5},
            {text = "LOADING FEATURES...", target = 0.8, duration = 1.5},
            {text = "FINALIZING...", target = 1.0, duration = 1.5},
        }

        for _, phase in ipairs(phases) do
            loadingText.Text = phase.text
            local startP = barFill.Size.X.Scale
            local steps = math.floor(phase.duration / 0.05)
            for i = 1, steps do
                task.wait(0.05)
                local t = i / steps
                local p = startP + (phase.target - startP) * t
                barFill.Size = UDim2.new(p, 0, 1, 0)
                percentLbl.Text = math.floor(p * 100) .. "%"
            end
        end

        loadingText.Text = "READY!"
        percentLbl.Text = "100%"
        task.wait(0.5)

        TweenService:Create(loading, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.wait(0.5)

        if loading then loading:Destroy() end

        -- Build main window
        buildMainWindow(parent)
        -- Build live chat window (hidden)
        local liveChatWin = buildLiveChatWindow(parent)
        _G.VRILZ_LiveChatWindow = liveChatWin

        notify("Welcome, " .. LocalPlayer.DisplayName, "success")
    end)
end

-- ============================================================
-- UI.INIT
-- ============================================================
function UI.Init(sharedState)
    Shared = sharedState or {}
    Shared.Notify = notify
    _G.VRILZ_UI_Shared = Shared

    Shared.AntiAFK_Enabled = true
    Shared.ShowTitle = true

    Shared.LiveChat_Messages = {}
    Shared.LiveChat_MaxMessages = CFG.CHAT_MAX_MSG
    Shared.LiveChat_PollInterval = 1.5

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_AnimeDice"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local parentGui = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Parent = parentGui

    setupNotifHolder(ScreenGui)
    setupDropdownLayer(ScreenGui)

    task.spawn(function()
        task.wait(2)
        pcall(function()
            if _G.VRILZ_ChatClient and _G.VRILZ_ChatClient.start then
                _G.VRILZ_ChatClient.start()
            end
        end)
    end)

    task.spawn(function()
        task.wait(1)
        local savedTitle = loadCustomTitle()
        if savedTitle then print("[TITLE] Loaded: " .. savedTitle) end
        task.wait(1)
        if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
    end)

    buildLoadingScreen(ScreenGui)
end

_G.VRILZ_UI = UI
return UI
