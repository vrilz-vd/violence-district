-- ============================================================
-- VRILZHUB FEATURES — VIOLENCE DISTRICT
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- STATE
-- ============================================================
local State = {
    Running = true,
    Generators = {},
    TrackedESP = {},
    TrackedPlayerESP = {},
    SELECTED_GEN_INDEX = 1,
    SELECTED_PLAYER = nil,
    NotifiedGens = {},
}

-- ============================================================
-- HELPER
-- ============================================================
local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

-- ============================================================
-- SPEED
-- ============================================================
function Features.setSpeed(value)
    local hum = getHum()
    if hum then
        hum.WalkSpeed = value
    end
end

function Features.setJump(value)
    local hum = getHum()
    if hum then
        hum.JumpPower = value
        hum.UseJumpPower = true
    end
end

function Features.applySpeed()
    local hum = getHum()
    if hum then
        hum.WalkSpeed = Shared.Speed_Value or 100
        hum.JumpPower = Shared.Jump_Value or 100
        hum.UseJumpPower = true
    end
end

-- ============================================================
-- LOAD GENERATOR
-- ============================================================
function Features.loadGenerators()
    State.Generators = {}
    local map = Workspace:FindFirstChild("Map")
    if not map then return end

    local function addFolder(name)
        local folder = map:FindFirstChild(name)
        if not folder then return end
        for _, gen in ipairs(folder:GetChildren()) do
            local part = gen:IsA("BasePart") and gen or gen:FindFirstChildWhichIsA("BasePart", true)
            if part then
                table.insert(State.Generators, {
                    name = gen.Name,
                    object = gen,
                    part = part,
                    position = part.Position,
                })
            end
        end
    end

    addFolder("Generators")
    addFolder("newGenerators")
end

function Features.getGenerators()
    return State.Generators
end

-- ============================================================
-- ESP GENERATOR
-- ============================================================
local function createGenESP(genData)
    local gen = genData.object
    local part = genData.part
    if not part or not part.Parent then return nil end

    local hl = Instance.new("Highlight")
    hl.Name = "VRILZ_ESP_HL"
    hl.FillColor = Color3.fromRGB(255, 200, 50)
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.6
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = gen
    hl.Parent = gen

    local bb = Instance.new("BillboardGui")
    bb.Name = "VRILZ_ESP_BB"
    bb.Size = UDim2.fromOffset(100, 20)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 1000
    bb.Adornee = part
    bb.Parent = part

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 0.3
    lbl.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    lbl.TextColor3 = Color3.fromRGB(255, 200, 50)
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.TextStrokeTransparency = 0.3
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.Text = ""
    lbl.Parent = bb

    local cnr = Instance.new("UICorner")
    cnr.CornerRadius = UDim.new(0, 4)
    cnr.Parent = lbl

    local str = Instance.new("UIStroke")
    str.Color = Color3.fromRGB(255, 200, 50)
    str.Thickness = 1
    str.Transparency = 0.4
    str.Parent = lbl

    return {hl = hl, bb = bb, lbl = lbl, part = part}
end

local function removeGenESP(genData)
    local data = State.TrackedESP[genData]
    if not data then return end
    if data.hl then data.hl:Destroy() end
    if data.bb then data.bb:Destroy() end
    State.TrackedESP[genData] = nil
end

function Features.startGenESP()
    task.spawn(function()
        while State.Running do
            if Shared.ESP_Generators_Enabled then
                for _, genData in ipairs(State.Generators) do
                    if not State.TrackedESP[genData] then
                        local esp = createGenESP(genData)
                        if esp then
                            State.TrackedESP[genData] = esp
                        end
                    end
                end

                local hrp = getHRP()
                for genData, data in pairs(State.TrackedESP) do
                    if not genData.object.Parent then
                        removeGenESP(genData)
                    elseif data.lbl and hrp then
                        local dist = (genData.position - hrp.Position).Magnitude
                        local text = ""
                        if Shared.ESP_GenName_Enabled then
                            text = "⚡ " .. genData.name
                        end
                        if Shared.ESP_GenDist_Enabled then
                            text = text .. " [" .. math.floor(dist) .. "m]"
                        end
                        data.lbl.Text = text
                    end
                end
            else
                for genData in pairs(State.TrackedESP) do
                    removeGenESP(genData)
                end
            end
            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- ESP PLAYER
-- ============================================================
local function createPlayerESP(player)
    local char = player.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local hl = Instance.new("Highlight")
    hl.Name = "VRILZ_PESP_HL"
    hl.FillColor = Color3.fromRGB(100, 200, 255)
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.5
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = char
    hl.Parent = char

    local bb = Instance.new("BillboardGui")
    bb.Name = "VRILZ_PESP_BB"
    bb.Size = UDim2.fromOffset(120, 20)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 1000
    bb.Adornee = hrp
    bb.Parent = hrp

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 0.3
    lbl.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.Text = player.Name
    lbl.Parent = bb

    local cnr = Instance.new("UICorner")
    cnr.CornerRadius = UDim.new(0, 4)
    cnr.Parent = lbl

    local str = Instance.new("UIStroke")
    str.Color = Color3.fromRGB(100, 200, 255)
    str.Thickness = 1
    str.Transparency = 0.4
    str.Parent = lbl

    return {hl = hl, bb = bb, lbl = lbl, part = hrp, player = player}
end

local function removePlayerESP(player)
    local data = State.TrackedPlayerESP[player]
    if not data then return end
    if data.hl then data.hl:Destroy() end
    if data.bb then data.bb:Destroy() end
    State.TrackedPlayerESP[player] = nil
end

function Features.startPlayerESP()
    task.spawn(function()
        while State.Running do
            if Shared.ESP_Players_Enabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not State.TrackedPlayerESP[player] then
                            local esp = createPlayerESP(player)
                            if esp then
                                State.TrackedPlayerESP[player] = esp
                            end
                        end
                    end
                end

                local hrp = getHRP()
                for player, data in pairs(State.TrackedPlayerESP) do
                    if not player.Character or not player.Character.Parent then
                        removePlayerESP(player)
                    elseif data.lbl and hrp and data.part then
                        local dist = (data.part.Position - hrp.Position).Magnitude
                        local text = player.Name
                        if Shared.ESP_PlayerDist_Enabled then
                            text = text .. " [" .. math.floor(dist) .. "m]"
                        end
                        data.lbl.Text = text
                    end
                end
            else
                for player in pairs(State.TrackedPlayerESP) do
                    removePlayerESP(player)
                end
            end
            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- TELEPORT
-- ============================================================
function Features.teleportToGen(index)
    local genData = State.Generators[index]
    if not genData then return false end
    local hrp = getHRP()
    if not hrp then return false end
    hrp.CFrame = CFrame.new(genData.position + Vector3.new(0, 3, 0))
    return true
end

function Features.teleportToPlayer(player)
    if not player then return false end
    local hrp = getHRP()
    if not hrp then return false end
    local targetChar = player.Character
    if not targetChar then return false end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end
    hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(0, 3, 0))
    return true
end

-- ============================================================
-- AUTO LOOPS
-- ============================================================
function Features.startAutoLoops()
    -- Auto TP Generator
    task.spawn(function()
        while State.Running do
            if Shared.AutoTP_Gen_Enabled then
                Features.teleportToGen(State.SELECTED_GEN_INDEX)
            end
            task.wait(0.5)
        end
    end)

    -- Auto TP Player
    task.spawn(function()
        while State.Running do
            if Shared.AutoTP_Player_Enabled and State.SELECTED_PLAYER then
                Features.teleportToPlayer(State.SELECTED_PLAYER)
            end
            task.wait(0.5)
        end
    end)

    -- Auto Repair
    task.spawn(function()
        while State.Running do
            if Shared.AutoRepair_Enabled then
                local hrp = getHRP()
                if hrp then
                    for _, genData in ipairs(State.Generators) do
                        local dist = (genData.position - hrp.Position).Magnitude
                        if dist < 10 then
                            for _, obj in ipairs(genData.object:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") then
                                    pcall(function()
                                        obj.HoldDuration = 0
                                        fireproximityprompt(obj)
                                    end)
                                end
                            end
                            break
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end

-- ============================================================
-- INIT
-- ============================================================
function Features.Init(shared)
    Shared = shared
    Shared.Features = Features
    Shared.setSpeed = Features.setSpeed
    Shared.setJump = Features.setJump
    Shared.applySpeed = Features.applySpeed

    Features.loadGenerators()
    Features.applySpeed()
    Features.startGenESP()
    Features.startPlayerESP()
    Features.startAutoLoops()

    print("[VRILZHUB] Violence District Features loaded")
end

return Features
