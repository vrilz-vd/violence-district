-- ============================================================
-- VRILZHUB UI — VIOLENCE DISTRICT v1.0
-- Adapted from Ride a Pet v5.5
-- ============================================================

local UI = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local UI_CONFIG = {
    MOBILE = {
        WIN_W_PCT = 0.88, WIN_H_PCT = 0.85,
        SIDEBAR_W = 70, TAB_H = 38, TAB_ICON = 18, TAB_SHOW_LABEL = false,
        CARD_HEADER = 28, CARD_PAD_TOP = 8, CARD_PAD_BOT = 8, CARD_PAD_SIDE = 10,
        CARD_GAP = 6, TOGGLE_H = 36, TOGGLE_W = 48, TOGGLE_KNOB = 20,
        DROPDOWN_H = 40, DROPDOWN_ITEM = 36, ACTION_H = 36,
        FONT_TITLE = 13, FONT_LABEL = 11, FONT_MUTED = 9, FONT_SMALL = 10,
        FONT_MED = 11, FONT_LARGE = 14,
        HEADER_H = 40, SEARCH_H = 30, NOTIF_W = 300, NOTIF_H = 52, OPEN_BTN = 52,
    },
    PC = {
        WIN_W = 800, WIN_H = 580,
        SIDEBAR_W = 140, TAB_H = 44, TAB_ICON = 16, TAB_SHOW_LABEL = true,
        CARD_HEADER = 30, CARD_PAD_TOP = 10, CARD_PAD_BOT = 12, CARD_PAD_SIDE = 14,
        CARD_GAP = 8, TOGGLE_H = 30, TOGGLE_W = 46, TOGGLE_KNOB = 18,
        DROPDOWN_H = 34, DROPDOWN_ITEM = 28, ACTION_H = 34,
        FONT_TITLE = 12, FONT_LABEL = 12, FONT_MUTED = 10, FONT_SMALL = 10,
        FONT_MED = 12, FONT_LARGE = 15,
        HEADER_H = 52, SEARCH_H = 34, NOTIF_W = 380, NOTIF_H = 52, OPEN_BTN = 56,
    },
}

local CFG = IS_MOBILE and UI_CONFIG.MOBILE or UI_CONFIG.PC

-- ====== THEME ======
local Themes = {
    Ice = {
        BG = Color3.fromRGB(5, 10, 20), Surface = Color3.fromRGB(10, 20, 35),
        Surface2 = Color3.fromRGB(15, 30, 50), Surface3 = Color3.fromRGB(20, 40, 65),
        Stroke = Color3.fromRGB(150, 220, 255), Text = Color3.fromRGB(240, 250, 255),
        Muted = Color3.fromRGB(150, 200, 240), Accent = Color3.fromRGB(50, 150, 255),
        Accent2 = Color3.fromRGB(150, 220, 255), Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Brutal = {
        BG = Color3.fromRGB(15, 5, 10), Surface = Color3.fromRGB(25, 10, 20),
        Surface2 = Color3.fromRGB(35, 15, 25), Surface3 = Color3.fromRGB(45, 20, 35),
        Stroke = Color3.fromRGB(255, 50, 80), Text = Color3.fromRGB(255, 240, 245),
        Muted = Color3.fromRGB(200, 150, 180), Accent = Color3.fromRGB(255, 50, 80),
        Accent2 = Color3.fromRGB(50, 150, 255), Accent3 = Color3.fromRGB(150, 220, 255),
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
    Purple = {
        BG = Color3.fromRGB(10, 5, 20), Surface = Color3.fromRGB(20, 10, 35),
        Surface2 = Color3.fromRGB(30, 15, 50), Surface3 = Color3.fromRGB(40, 20, 65),
        Stroke = Color3.fromRGB(180, 100, 255), Text = Color3.fromRGB(245, 240, 255),
        Muted = Color3.fromRGB(200, 170, 240), Accent = Color3.fromRGB(180, 100, 255),
        Accent2 = Color3.fromRGB(100, 200, 255), Accent3 = Color3.fromRGB(255, 100, 200),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Green = {
        BG = Color3.fromRGB(5, 15, 10), Surface = Color3.fromRGB(10, 30, 20),
        Surface2 = Color3.fromRGB(15, 45, 30), Surface3 = Color3.fromRGB(20, 60, 40),
        Stroke = Color3.fromRGB(50, 255, 150), Text = Color3.fromRGB(240, 255, 245),
        Muted = Color3.fromRGB(150, 220, 180), Accent = Color3.fromRGB(50, 255, 150),
        Accent2 = Color3.fromRGB(100, 200, 255), Accent3 = Color3.fromRGB(255, 200, 50),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
}

local CurrentTheme = "Ice"
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

-- ====== NOTIFICATION ======
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

-- ====== CARD ======
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = card
    registerTheme(stroke, "Accent", "Color")

    local rippleLayer = Instance.new("Frame")
    rippleLayer.Name = "RippleLayer"
    rippleLayer.Size = UDim2.fromScale(1, 1)
    rippleLayer.BackgroundTransparency = 1
    rippleLayer.ClipsDescendants = true
    rippleLayer.ZIndex = 99
    rippleLayer.Parent = card

    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local ripple = Instance.new("Frame")
            ripple.Size = UDim2.fromOffset(0, 0)
            ripple.Position = UDim2.fromOffset(input.Position.X - card.AbsolutePosition.X, input.Position.Y - card.AbsolutePosition.Y)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.BackgroundColor3 = C.Accent
            ripple.BackgroundTransparency = 0.7
            ripple.BorderSizePixel = 0
            ripple.ZIndex = 100
            ripple.Parent = rippleLayer

            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple

            TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(card.AbsoluteSize.X * 2, card.AbsoluteSize.X * 2),
                BackgroundTransparency = 1
            }):Play()

            task.delay(0.7, function()
                if ripple then ripple:Destroy() end
            end)
        end
    end)

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, CFG.CARD_HEADER)
    headerFrame.BackgroundColor3 = C.Surface2
    headerFrame.BorderSizePixel = 0
    headerFrame.ZIndex = 2
    headerFrame.Parent = card
    registerTheme(headerFrame, "Surface2", "BackgroundColor3")

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = headerFrame

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.new(0, 12, 0.5, -3)
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

-- ====== TOGGLE ======
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
    btn.Size = UDim2.fromOffset(CFG.TOGGLE_W, IS_MOBILE and 26 or 24)
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

-- ====== SLIDER ======
local function makeSlider(parent, text, minVal, maxVal, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = C.Muted
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = CFG.FONT_MUTED
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4
    lbl.Parent = frame
    registerTheme(lbl, "Muted", "TextColor3")

    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 60, 0, 14)
    valLbl.Position = UDim2.new(1, -60, 0, 0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = tostring(default)
    valLbl.TextColor3 = C.Accent
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = CFG.FONT_MUTED
    valLbl.TextXAlignment = Enum.TextXAlignment.Right
    valLbl.ZIndex = 4
    valLbl.Parent = frame
    registerTheme(valLbl, "Accent", "TextColor3")

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.Position = UDim2.fromOffset(0, 22)
    sliderBg.BackgroundColor3 = C.Surface3
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 4
    sliderBg.Parent = frame
    registerTheme(sliderBg, "Surface3", "BackgroundColor3")

    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(1, 0)
    sbc.Parent = sliderBg

    local initPct = (default - minVal) / (maxVal - minVal)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(initPct, 0, 1, 0)
    sliderFill.BackgroundColor3 = C.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 5
    sliderFill.Parent = sliderBg
    registerTheme(sliderFill, "Accent", "BackgroundColor3")

    local sfc = Instance.new("UICorner")
    sfc.CornerRadius = UDim.new(1, 0)
    sfc.Parent = sliderFill

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 1, 20)
    sliderBtn.Position = UDim2.new(0, 0, 0.5, -10)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.ZIndex = 6
    sliderBtn.Parent = sliderBg

    local dragging = false
    local currentValue = default

    local function updateFromX(mouseX)
        local rel = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(minVal + (maxVal - minVal) * rel)
        sliderFill.Size = UDim2.new(rel, 0, 1, 0)
        valLbl.Text = tostring(currentValue)
        if callback then callback(currentValue) end
    end

    sliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return currentValue
end

-- ====== FPS WINDOW ======
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
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = main

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.4
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
    headerCorner.CornerRadius = UDim.new(0, 14)
    headerCorner.Parent = header

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 14)
    headerFix.Position = UDim2.new(0, 0, 1, -14)
    headerFix.BackgroundColor3 = C.Surface
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 10
    headerFix.Parent = header

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.fromOffset(IS_MOBILE and 30 or 36, IS_MOBILE and 30 or 36)
    logo.Position = UDim2.fromOffset(IS_MOBILE and 10 or 12, (CFG.HEADER_H - (IS_MOBILE and 30 or 36)) / 2)
    logo.BackgroundColor3 = C.Accent
    logo.Text = "⚡"
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
    subtitle.Text = "Violence District · v1.0"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = IS_MOBILE and 9 or 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 11
    subtitle.Parent = header
    registerTheme(subtitle, "Muted", "TextColor3")

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    minBtn.Position = UDim2.new(1, -(IS_MOBILE and 66 or 78), 0.5, -(IS_MOBILE and 14 or 16))
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "−"
    minBtn.TextColor3 = C.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = IS_MOBILE and 18 or 20
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 11
    minBtn.Parent = header
    registerTheme(minBtn, "Surface3", "BackgroundColor3")
    registerTheme(minBtn, "Text", "TextColor3")

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    closeBtn.Position = UDim2.new(1, -(IS_MOBILE and 34 or 40), 0.5, -(IS_MOBILE and 14 or 16))
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = IS_MOBILE and 20 or 22
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 11
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

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

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar

    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = C.Accent
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = 0.7
    sidebarStroke.Parent = sidebar
    registerTheme(sidebarStroke, "Accent", "Color")

    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Size = UDim2.fromScale(1, 1)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 2
    sidebarScroll.ScrollBarImageColor3 = C.Accent
    sidebarScroll.ScrollBarImageTransparency = 0.5
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

    if not IS_MOBILE then
        local resizeHandle = Instance.new("TextButton")
        resizeHandle.Size = UDim2.fromOffset(22, 22)
        resizeHandle.Position = UDim2.new(1, -24, 1, -24)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Text = "◢"
        resizeHandle.TextColor3 = C.Accent
        resizeHandle.TextSize = 14
        resizeHandle.Font = Enum.Font.GothamBold
        resizeHandle.AutoButtonColor = false
        resizeHandle.ZIndex = 100
        resizeHandle.Parent = main
        registerTheme(resizeHandle, "Accent", "TextColor3")

        local resizing = false
        local resizeStart, startSize
        resizeHandle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resizeStart = i.Position
                startSize = main.Size
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - resizeStart
                local newX = math.clamp(startSize.X.Offset + delta.X, 600, 1200)
                local newY = math.clamp(startSize.Y.Offset + delta.Y, 400, 800)
                main.Size = UDim2.fromOffset(newX, newY)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
    end

    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.fromOffset(CFG.OPEN_BTN, CFG.OPEN_BTN)
    openBtn.Position = UDim2.fromOffset(20, 20)
    openBtn.BackgroundColor3 = C.Surface
    openBtn.Text = "⚡"
    openBtn.TextColor3 = C.Accent
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = IS_MOBILE and 24 or 28
    openBtn.BorderSizePixel = 0
    openBtn.Visible = false
    openBtn.ZIndex = 400
    openBtn.Parent = screenGui
    registerTheme(openBtn, "Surface", "BackgroundColor3")
    registerTheme(openBtn, "Accent", "TextColor3")

    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(1, 0)
    openCorner.Parent = openBtn

    local openStroke = Instance.new("UIStroke")
    openStroke.Color = C.Accent
    openStroke.Thickness = 2
    openStroke.Transparency = 0.3
    openStroke.Parent = openBtn

    local openDrag, openDS, openSP = false, nil, nil
    openBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            openDrag = true
            openDS = i.Position
            openSP = openBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if openDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - openDS
            openBtn.Position = UDim2.new(openSP.X.Scale, openSP.X.Offset + d.X, openSP.Y.Scale, openSP.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            openDrag = false
        end
    end)

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
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local ic = Instance.new("TextLabel")
        if CFG.TAB_SHOW_LABEL then
            ic.Size = UDim2.fromOffset(28, tabH)
            ic.Position = UDim2.fromOffset(10, 0)
        else
            ic.Size = UDim2.fromScale(1, 1)
            ic.Position = UDim2.fromOffset(0, 0)
        end
        ic.BackgroundTransparency = 1
        ic.Text = icon
        ic.TextSize = CFG.TAB_ICON
        ic.Font = Enum.Font.GothamBold
        ic.TextColor3 = C.Accent
        ic.ZIndex = 6
        ic.Parent = btn
        registerTheme(ic, "Accent", "TextColor3")

        if CFG.TAB_SHOW_LABEL then
            local lbl = Instance.new("TextLabel")
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
            navs[id] = {btn = btn, ic = ic, lbl = lbl}
        else
            navs[id] = {btn = btn, ic = ic, lbl = nil}
        end

        local function switchTo()
            for n, p in pairs(pages) do
                if p then p.Visible = (n == id) end
            end
            for n, x in pairs(navs) do
                if n == id then
                    x.btn.BackgroundColor3 = C.Accent
                    x.btn.BackgroundTransparency = 0
                    x.ic.TextColor3 = Color3.new(1, 1, 1)
                    if x.lbl then x.lbl.TextColor3 = Color3.new(1, 1, 1) end
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    x.ic.TextColor3 = C.Accent
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
        page.Visible = false
        page.ZIndex = 7
        page.Parent = pageHolder
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        return page
    end

    -- ============================================================
    -- TAB INFO
    -- ============================================================
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "INFORMASI CLIENT", 1)

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

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatar

    local avStroke = Instance.new("UIStroke")
    avStroke.Color = C.Accent
    avStroke.Thickness = 2
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

    local sessionLbl = Instance.new("TextLabel")
    sessionLbl.Size = UDim2.new(1, 0, 0, 20)
    sessionLbl.BackgroundTransparency = 1
    sessionLbl.Text = "Sesi: 00:00"
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
            sessionLbl.Text = string.format("Sesi: %02d:%02d", m, s)
        end
    end)

    local updateCard, updateContent = makeCard(infoPage, "📢 INFORMASI UPDATE", 2)

    local infoLines = {
        "Version        : 1.0",
        "Last Update    : 1 Oct 2026",
        "Status         : Online ✅",
        "Changelog      : ESP Generator, ESP Player",
        "                 Teleport, Speed, Auto Repair",
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

    local explCard, explContent = makeCard(infoPage, "🎮 EXPLOIT SUPPORT", 3)

    local explLines = {
        "✅ Delta       ✅ Fluxus",
        "✅ Xeno        ✅ Codex",
        "✅ Solara      ✅ Wave",
    }
    for i, line in ipairs(explLines) do
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
        lbl.Parent = explContent
        registerTheme(lbl, "Muted", "TextColor3")
    end

    local discordCard, discordContent = makeCard(infoPage, "💬 JOIN DISCORD", 4)
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
    discordBtn.Text = "[ KLIK UNTUK JOIN ]"
    discordBtn.TextColor3 = Color3.new(1, 1, 1)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = CFG.FONT_LABEL
    discordBtn.AutoButtonColor = false
    discordBtn.LayoutOrder = 2
    discordBtn.ZIndex = 3
    discordBtn.Parent = discordContent
    registerTheme(discordBtn, "Accent", "BackgroundColor3")

    local discordBtnCorner = Instance.new("UICorner")
    discordBtnCorner.CornerRadius = UDim.new(0, 8)
    discordBtnCorner.Parent = discordBtn

    discordBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        notify("✓ Discord link dicopy!", "success")
    end)

    registerTab("Info", "ℹ", "Info")

    -- ============================================================
    -- TAB GENERATOR
    -- ============================================================
    local genPage = createPage("Generator")
    pages.Generator = genPage

    local genEspCard, genEspContent = makeCard(genPage, "⚡ ESP GENERATOR", 1)
    makeToggle(genEspContent, "Aktifkan ESP Generator", false, function(v) Shared.ESP_Generators_Enabled = v end)
    makeToggle(genEspContent, "Tampilkan Nama", true, function(v) Shared.ESP_GenName_Enabled = v end)
    makeToggle(genEspContent, "Tampilkan Jarak", true, function(v) Shared.ESP_GenDist_Enabled = v end)

    local genTpCard, genTpContent = makeCard(genPage, "🌀 TELEPORT GENERATOR", 2)

    local genBtnHolder = Instance.new("Frame")
    genBtnHolder.Size = UDim2.new(1, 0, 0, 0)
    genBtnHolder.AutomaticSize = Enum.AutomaticSize.Y
    genBtnHolder.BackgroundTransparency = 1
    genBtnHolder.LayoutOrder = 1
    genBtnHolder.Parent = genTpContent

    local genGrid = Instance.new("UIGridLayout")
    genGrid.CellSize = UDim2.new(0.32, -4, 0, 30)
    genGrid.CellPadding = UDim2.new(0, 4, 0, 4)
    genGrid.SortOrder = Enum.SortOrder.LayoutOrder
    genGrid.Parent = genBtnHolder

    local genButtons = {}

    local function refreshGenButtons()
        for _, btn in ipairs(genButtons) do btn:Destroy() end
        genButtons = {}
        if Shared.Features and Shared.Features.loadGenerators then
            Shared.Features.loadGenerators()
        end
        local gens = (Shared.Features and Shared.Features.getGenerators and Shared.Features.getGenerators()) or {}
        for i, genData in ipairs(gens) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0.32, -4, 0, 30)
            btn.BackgroundColor3 = C.Surface3
            btn.Text = "#" .. i
            btn.TextColor3 = C.Text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 11
            btn.BorderSizePixel = 0
            btn.LayoutOrder = i
            btn.Parent = genBtnHolder
            registerTheme(btn, "Surface3", "BackgroundColor3")
            registerTheme(btn, "Text", "TextColor3")
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 6)
            bc.Parent = btn
            btn.MouseButton1Click:Connect(function()
                if Shared.Features and Shared.Features.teleportToGen then
                    Shared.Features.teleportToGen(i)
                    notify("✅ TP ke Generator #" .. i, "success")
                end
            end)
            table.insert(genButtons, btn)
        end
    end

    refreshGenButtons()

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 0, 30)
    refreshBtn.BackgroundColor3 = C.Surface3
    refreshBtn.Text = "🔄 Refresh Generator List"
    refreshBtn.TextColor3 = C.Text
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 11
    refreshBtn.BorderSizePixel = 0
    refreshBtn.LayoutOrder = 100
    refreshBtn.Parent = genTpContent
    registerTheme(refreshBtn, "Surface3", "BackgroundColor3")
    registerTheme(refreshBtn, "Text", "TextColor3")
    local rbc = Instance.new("UICorner")
    rbc.CornerRadius = UDim.new(0, 6)
    rbc.Parent = refreshBtn
    refreshBtn.MouseButton1Click:Connect(function()
        refreshGenButtons()
        notify("✅ Refresh", "success")
    end)

    makeToggle(genTpContent, "Auto TP Generator", false, function(v) Shared.AutoTP_Gen_Enabled = v end)

    registerTab("Generator", "⚡", "Generator")

    -- ============================================================
    -- TAB PLAYER
    -- ============================================================
    local playerPage = createPage("Player")
    pages.Player = playerPage

    local playerEspCard, playerEspContent = makeCard(playerPage, "🎯 PLAYER ESP", 1)
    makeToggle(playerEspContent, "Aktifkan Player ESP", false, function(v) Shared.ESP_Players_Enabled = v end)
    makeToggle(playerEspContent, "Tampilkan Jarak", true, function(v) Shared.ESP_PlayerDist_Enabled = v end)

    local playerTpCard, playerTpContent = makeCard(playerPage, "🌀 TELEPORT KE PLAYER", 2)

    local playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Size = UDim2.new(1, 0, 0, 200)
    playerListFrame.BackgroundColor3 = C.Surface2
    playerListFrame.BorderSizePixel = 0
    playerListFrame.ScrollBarThickness = 3
    playerListFrame.ScrollBarImageColor3 = C.Accent
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerListFrame.LayoutOrder = 1
    playerListFrame.Parent = playerTpContent
    registerTheme(playerListFrame, "Surface2", "BackgroundColor3")

    local plfCorner = Instance.new("UICorner")
    plfCorner.CornerRadius = UDim.new(0, 6)
    plfCorner.Parent = playerListFrame

    local plLayout = Instance.new("UIListLayout")
    plLayout.Padding = UDim.new(0, 4)
    plLayout.SortOrder = Enum.SortOrder.LayoutOrder
    plLayout.Parent = playerListFrame

    local plPad = Instance.new("UIPadding")
    plPad.PaddingTop = UDim.new(0, 4)
    plPad.PaddingBottom = UDim.new(0, 4)
    plPad.PaddingLeft = UDim.new(0, 4)
    plPad.PaddingRight = UDim.new(0, 4)
    plPad.Parent = playerListFrame

    local playerButtons = {}

    local function updatePlayerButtons()
        for _, data in ipairs(playerButtons) do
            if data.player == Shared.SelectedPlayer then
                data.btn.BackgroundColor3 = C.Accent
                data.btn.TextColor3 = Color3.new(1, 1, 1)
            else
                data.btn.BackgroundColor3 = C.Surface3
                data.btn.TextColor3 = C.Text
            end
        end
    end

    local function refreshPlayerList()
        for _, data in ipairs(playerButtons) do data.btn:Destroy() end
        playerButtons = {}

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = C.Surface3
                btn.Text = player.Name .. " (@" .. player.DisplayName .. ")"
                btn.TextColor3 = C.Text
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 10
                btn.BorderSizePixel = 0
                btn.Parent = playerListFrame
                registerTheme(btn, "Surface3", "BackgroundColor3")
                registerTheme(btn, "Text", "TextColor3")
                local bc = Instance.new("UICorner")
                bc.CornerRadius = UDim.new(0, 6)
                bc.Parent = btn
                btn.MouseButton1Click:Connect(function()
                    Shared.SelectedPlayer = player
                    updatePlayerButtons()
                end)
                table.insert(playerButtons, {btn = btn, player = player})
            end
        end
    end

    refreshPlayerList()

    local playerRefBtn = Instance.new("TextButton")
    playerRefBtn.Size = UDim2.new(1, 0, 0, 28)
    playerRefBtn.BackgroundColor3 = C.Surface3
    playerRefBtn.Text = "🔄 Refresh Player List"
    playerRefBtn.TextColor3 = C.Text
    playerRefBtn.Font = Enum.Font.GothamBold
    playerRefBtn.TextSize = 10
    playerRefBtn.BorderSizePixel = 0
    playerRefBtn.LayoutOrder = 2
    playerRefBtn.Parent = playerTpContent
    registerTheme(playerRefBtn, "Surface3", "BackgroundColor3")
    registerTheme(playerRefBtn, "Text", "TextColor3")
    local prbc = Instance.new("UICorner")
    prbc.CornerRadius = UDim.new(0, 6)
    prbc.Parent = playerRefBtn
    playerRefBtn.MouseButton1Click:Connect(function()
        refreshPlayerList()
        notify("✅ Refresh Player", "success")
    end)

    local tpPlayerBtn = Instance.new("TextButton")
    tpPlayerBtn.Size = UDim2.new(1, 0, 0, 30)
    tpPlayerBtn.BackgroundColor3 = C.Accent2
    tpPlayerBtn.Text = "🌀 Teleport ke Player"
    tpPlayerBtn.TextColor3 = Color3.new(1, 1, 1)
    tpPlayerBtn.Font = Enum.Font.GothamBold
    tpPlayerBtn.TextSize = 11
    tpPlayerBtn.BorderSizePixel = 0
    tpPlayerBtn.LayoutOrder = 3
    tpPlayerBtn.Parent = playerTpContent
    registerTheme(tpPlayerBtn, "Accent2", "BackgroundColor3")

    local tpbc = Instance.new("UICorner")
    tpbc.CornerRadius = UDim.new(0, 6)
    tpbc.Parent = tpPlayerBtn
    tpPlayerBtn.MouseButton1Click:Connect(function()
        if Shared.SelectedPlayer and Shared.Features and Shared.Features.teleportToPlayer then
            Shared.Features.teleportToPlayer(Shared.SelectedPlayer)
            notify("✅ TP ke " .. Shared.SelectedPlayer.Name, "success")
        else
            notify("❌ Pilih player dulu", "error")
        end
    end)

    makeToggle(playerTpContent, "Auto TP Player", false, function(v) Shared.AutoTP_Player_Enabled = v end)

    registerTab("Player", "🎯", "Player")

    -- ============================================================
    -- TAB AUTO
    -- ============================================================
    local autoPage = createPage("Auto")
    pages.Auto = autoPage

    local autoRepairCard, autoRepairContent = makeCard(autoPage, "🔧 AUTO REPAIR", 1)
    makeToggle(autoRepairContent, "Auto Repair Generator", false, function(v) Shared.AutoRepair_Enabled = v end)

    local speedCard, speedContent = makeCard(autoPage, "⚡ SPEED", 2)
    makeToggle(speedContent, "Aktifkan Speed", false, function(v) Shared.Speed_Enabled = v end)

    makeSlider(speedContent, "WalkSpeed", 16, 500, Shared.Speed_Value or 100, function(v)
        Shared.Speed_Value = v
        if Shared.setSpeed then Shared.setSpeed(v) end
    end)

    makeSlider(speedContent, "JumpPower", 50, 500, Shared.Jump_Value or 100, function(v)
        Shared.Jump_Value = v
        if Shared.setJump then Shared.setJump(v) end
    end)

    registerTab("Auto", "🔧", "Auto")

    -- ============================================================
    -- TAB SETTINGS
    -- ============================================================
    local setPage = createPage("Settings")
    pages.Settings = setPage

    local themeCard, themeContent = makeCard(setPage, "🎨 TEMA", 1)

    local themeLbl = Instance.new("TextLabel")
    themeLbl.Size = UDim2.new(1, 0, 0, 16)
    themeLbl.BackgroundTransparency = 1
    themeLbl.Text = "Pilih Tema:"
    themeLbl.TextColor3 = C.Muted
    themeLbl.Font = Enum.Font.GothamSemibold
    themeLbl.TextSize = CFG.FONT_MUTED
    themeLbl.TextXAlignment = Enum.TextXAlignment.Left
    themeLbl.ZIndex = 3
    themeLbl.Parent = themeContent
    registerTheme(themeLbl, "Muted", "TextColor3")

    local themeList = {"Ice", "Brutal", "Fire", "Purple", "Green"}
    local themeBtns = {}
    local themeHolder = Instance.new("Frame")
    themeHolder.Size = UDim2.new(1, 0, 0, 32)
    themeHolder.BackgroundTransparency = 1
    themeHolder.LayoutOrder = 2
    themeHolder.Parent = themeContent

    local themeLayout = Instance.new("UIListLayout")
    themeLayout.FillDirection = Enum.FillDirection.Horizontal
    themeLayout.Padding = UDim.new(0, 4)
    themeLayout.Parent = themeHolder

    for _, tName in ipairs(themeList) do
        local tBtn = Instance.new("TextButton")
        tBtn.Size = UDim2.fromOffset(60, 28)
        tBtn.BackgroundColor3 = tName == CurrentTheme and C.Accent or C.Surface3
        tBtn.Text = tName
        tBtn.TextColor3 = tName == CurrentTheme and Color3.new(1,1,1) or C.Text
        tBtn.Font = Enum.Font.GothamBold
        tBtn.TextSize = 10
        tBtn.BorderSizePixel = 0
        tBtn.Parent = themeHolder
        local tbc = Instance.new("UICorner")
        tbc.CornerRadius = UDim.new(0, 6)
        tbc.Parent = tBtn
        tBtn.MouseButton1Click:Connect(function()
            applyTheme(tName)
            notify("Tema: " .. tName, "success")
        end)
        table.insert(themeBtns, tBtn)
    end

    local fpsCard, fpsContent = makeCard(setPage, "📊 PERFORMANCE", 2)

    local fpsWin = buildFPSWindow(screenGui)
    UI._fpsWindow = fpsWin

    makeToggle(fpsContent, "FPS Boost", false, function(v)
        if v then
            pcall(function() Lighting.GlobalShadows = false end)
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            notify("FPS Boost aktif", "success")
        else
            pcall(function() Lighting.GlobalShadows = true end)
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
            notify("FPS Boost nonaktif", "info")
        end
    end)

    makeToggle(fpsContent, "FPS Window", false, function(v)
        if fpsWin then fpsWin.Visible = v end
    end)

    registerTab("Settings", "⚙", "Settings")

    pages.Info.Visible = true
    navs.Info.btn.BackgroundColor3 = C.Accent
    navs.Info.btn.BackgroundTransparency = 0
    navs.Info.ic.TextColor3 = Color3.new(1, 1, 1)
    if navs.Info.lbl then navs.Info.lbl.TextColor3 = Color3.new(1, 1, 1) end

    -- DRAG
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
-- LOADING SCREEN BRUTAL
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
    stroke1.Color = Color3.fromRGB(100, 200, 255)
    stroke1.Thickness = 3
    stroke1.Parent = loading

    local stroke2 = Instance.new("UIStroke")
    stroke2.Color = Color3.fromRGB(255, 255, 255)
    stroke2.Thickness = 1
    stroke2.Transparency = 0.7
    stroke2.Parent = loading

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 4)
    topBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 310
    topBar.Parent = loading

    local botBar = Instance.new("Frame")
    botBar.Size = UDim2.new(1, 0, 0, 4)
    botBar.Position = UDim2.new(0, 0, 1, -4)
    botBar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    botBar.BorderSizePixel = 0
    botBar.ZIndex = 310
    botBar.Parent = loading

    local vHolder = Instance.new("Frame")
    vHolder.Size = UDim2.fromScale(1, 0.55)
    vHolder.Position = UDim2.fromScale(0, 0.15)
    vHolder.BackgroundTransparency = 1
    vHolder.ZIndex = 305
    vHolder.Parent = loading

    local vGlow = Instance.new("TextLabel")
    vGlow.Size = UDim2.fromScale(1, 1)
    vGlow.BackgroundTransparency = 1
    vGlow.Text = "V"
    vGlow.TextColor3 = Color3.fromRGB(100, 200, 255)
    vGlow.TextTransparency = 0.3
    vGlow.Font = Enum.Font.GothamBlack
    vGlow.TextSize = 1
    vGlow.ZIndex = 304
    vGlow.Parent = vHolder

    local vRed = Instance.new("TextLabel")
    vRed.Size = UDim2.fromScale(1, 1)
    vRed.Position = UDim2.fromOffset(-2, 0)
    vRed.BackgroundTransparency = 1
    vRed.Text = "V"
    vRed.TextColor3 = Color3.fromRGB(255, 0, 0)
    vRed.TextTransparency = 0.6
    vRed.Font = Enum.Font.GothamBlack
    vRed.TextSize = 1
    vRed.ZIndex = 305
    vRed.Parent = vHolder

    local vBlue = Instance.new("TextLabel")
    vBlue.Size = UDim2.fromScale(1, 1)
    vBlue.Position = UDim2.fromOffset(2, 0)
    vBlue.BackgroundTransparency = 1
    vBlue.Text = "V"
    vBlue.TextColor3 = Color3.fromRGB(0, 100, 255)
    vBlue.TextTransparency = 0.6
    vBlue.Font = Enum.Font.GothamBlack
    vBlue.TextSize = 1
    vBlue.ZIndex = 305
    vBlue.Parent = vHolder

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
    loadingText.TextSize = IS_MOBILE and 11 or 12
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

    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(100, 200, 255)
    barStroke.Thickness = 1
    barStroke.Transparency = 0.3
    barStroke.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 306
    barFill.Parent = barBg

    local percentLbl = Instance.new("TextLabel")
    percentLbl.Size = UDim2.new(1, -20, 0, 14)
    percentLbl.Position = UDim2.new(0, 10, 0, winH - 26)
    percentLbl.BackgroundTransparency = 1
    percentLbl.Text = "0%"
    percentLbl.TextColor3 = Color3.fromRGB(100, 200, 255)
    percentLbl.Font = Enum.Font.GothamBlack
    percentLbl.TextSize = 10
    percentLbl.TextXAlignment = Enum.TextXAlignment.Right
    percentLbl.ZIndex = 306
    percentLbl.Parent = loading

    local brandLbl = Instance.new("TextLabel")
    brandLbl.Size = UDim2.new(1, -20, 0, 14)
    brandLbl.Position = UDim2.new(0, 10, 0, winH - 26)
    brandLbl.BackgroundTransparency = 1
    brandLbl.Text = "V R I L Z H U B"
    brandLbl.TextColor3 = Color3.fromRGB(150, 80, 100)
    brandLbl.Font = Enum.Font.GothamBold
    brandLbl.TextSize = 10
    brandLbl.TextXAlignment = Enum.TextXAlignment.Left
    brandLbl.ZIndex = 306
    brandLbl.Parent = loading

    task.spawn(function()
        while loading.Parent do
            task.wait(math.random(6, 15) / 100)
            local offset = math.random(1, 6)
            vRed.Position = UDim2.fromOffset(-offset, 0)
            vBlue.Position = UDim2.fromOffset(offset, 0)
            task.wait(0.05)
            vRed.Position = UDim2.fromOffset(-1, 0)
            vBlue.Position = UDim2.fromOffset(1, 0)
        end
    end)

    task.spawn(function()
        local startSize = 1
        local endSize = IS_MOBILE and 130 or 170
        local duration = 1.2
        local steps = 40
        for i = 1, steps do
            task.wait(duration / steps)
            local t = i / steps
            local eased = 1 - (1 - t) ^ 3
            local size = startSize + (endSize - startSize) * eased
            vLabel.TextSize = size
            vGlow.TextSize = size
            vRed.TextSize = size
            vBlue.TextSize = size
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
            task.wait(0.05)
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

        task.wait(0.4)

        TweenService:Create(loading, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.wait(0.5)

        if loading then loading:Destroy() end
        buildMainWindow(parent)
        notify("Welcome, " .. LocalPlayer.DisplayName, "success")
    end)
end

-- ============================================================
-- UI.INIT
-- ============================================================
function UI.Init(sharedState)
    Shared = sharedState
    Shared.Notify = notify

    Shared.ESP_Generators_Enabled = false
    Shared.ESP_GenName_Enabled = true
    Shared.ESP_GenDist_Enabled = true
    Shared.ESP_Players_Enabled = false
    Shared.ESP_PlayerDist_Enabled = true
    Shared.AutoTP_Gen_Enabled = false
    Shared.AutoTP_Player_Enabled = false
    Shared.AutoRepair_Enabled = false
    Shared.SelectedPlayer = nil
    Shared.Speed_Enabled = false
    Shared.Speed_Value = 100
    Shared.Jump_Value = 100

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_ViolenceDistrict"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    setupNotifHolder(ScreenGui)
    buildLoadingScreen(ScreenGui)
end

return UI
