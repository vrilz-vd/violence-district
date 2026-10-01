-- ============================================================
-- VRILZHUB FEATURES — VIOLENCE DISTRICT v3.0
-- AUTO-DETECT Generator + Shared State
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

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
    if hum then hum.WalkSpeed = value end
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
-- 🔥 LOAD GENERATOR (AUTO-DETECT)
-- ============================================================
function Features.loadGenerators()
    Shared.Generators = {}
    
    -- Coba cari di beberapa tempat
    local map = Workspace:FindFirstChild("Map")
    local searchPaths = {}
    
    if map then
        table.insert(searchPaths, map:FindFirstChild("Generators"))
        table.insert(searchPaths, map:FindFirstChild("newGenerators"))
        table.insert(searchPaths, map:FindFirstChild("generators"))
    end
    
    table.insert(searchPaths, Workspace:FindFirstChild("Generators"))
    table.insert(searchPaths, Workspace:FindFirstChild("newGenerators"))
    
    for _, folder in ipairs(searchPaths) do
        if folder then
            for _, gen in ipairs(folder:GetChildren()) do
                local part = gen:IsA("BasePart") and gen or gen:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    table.insert(Shared.Generators, {
                        name = gen.Name,
                        object = gen,
                        part = part,
                        position = part.Position,
                    })
                end
            end
        end
    end
    
    -- FALLBACK: scan semua Workspace
    if #Shared.Generators == 0 then
        print("[VRILZ] Fallback scan Workspace...")
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("generator") then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    table.insert(Shared.Generators, {
                        name = obj.Name,
                        object = obj,
                        part = part,
                        position = part.Position,
                    })
                end
            end
        end
    end
    
    print("[VRILZ] Total generator: " .. #Shared.Generators)
    for i, gen in ipairs(Shared.Generators) do
        print("  #" .. i .. ": " .. gen.name)
    end
end

function Features.getGenerators()
    return Shared.Generators
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
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.Text = ""
    lbl.Parent = bb

    return {hl = hl, bb = bb, lbl = lbl, part = part}
end

local function removeGenESP(genData)
    local data = Shared.TrackedESP[genData]
    if not data then return end
    if data.hl then data.hl:Destroy() end
    if data.bb then data.bb:Destroy() end
    Shared.TrackedESP[genData] = nil
end

function Features.startGenESP()
    task.spawn(function()
        while Shared.Running do
            if Shared.ESP_Generators_Enabled then
                for _, genData in ipairs(Shared.Generators) do
                    if not Shared.TrackedESP[genData] then
                        local esp = createGenESP(genData)
                        if esp then
                            Shared.TrackedESP[genData] = esp
                        end
                    end
                end

                local hrp = getHRP()
                for genData, data in pairs(Shared.TrackedESP) do
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
                for genData in pairs(Shared.TrackedESP) do
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

    return {hl = hl, bb = bb, lbl = lbl, part = hrp, player = player}
end

local function removePlayerESP(player)
    local data = Shared.TrackedPlayerESP[player]
    if not data then return end
    if data.hl then data.hl:Destroy() end
    if data.bb then data.bb:Destroy() end
    Shared.TrackedPlayerESP[player] = nil
end

function Features.startPlayerESP()
    task.spawn(function()
        while Shared.Running do
            if Shared.ESP_Players_Enabled then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not Shared.TrackedPlayerESP[player] then
                            local esp = createPlayerESP(player)
                            if esp then
                                Shared.TrackedPlayerESP[player] = esp
                            end
                        end
                    end
                end

                local hrp = getHRP()
                for player, data in pairs(Shared.TrackedPlayerESP) do
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
                for player in pairs(Shared.TrackedPlayerESP) do
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
    local genData = Shared.Generators[index]
    if not genData then
        print("[VRILZ] ❌ Generator #" .. index .. " gak ada")
        return false
    end
    
    local hrp = getHRP()
    if not hrp then return false end
    
    local part = genData.part
    if not part or not part.Parent then
        part = genData.object:FindFirstChildWhichIsA("BasePart", true)
        if not part then return false end
    end
    
    hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
    print("[VRILZ] ✅ TP ke Generator #" .. index .. ": " .. genData.name)
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
    task.spawn(function()
        while Shared.Running do
            if Shared.AutoTP_Gen_Enabled then
                Features.teleportToGen(Shared.SELECTED_GEN_INDEX)
            end
            task.wait(0.5)
        end
    end)

    task.spawn(function()
        while Shared.Running do
            if Shared.AutoTP_Player_Enabled and Shared.SELECTED_PLAYER then
                Features.teleportToPlayer(Shared.SELECTED_PLAYER)
            end
            task.wait(0.5)
        end
    end)

    task.spawn(function()
        while Shared.Running do
            if Shared.AutoRepair_Enabled then
                local hrp = getHRP()
                if hrp then
                    for _, genData in ipairs(Shared.Generators) do
                        local part = genData.part
                        if part and part.Parent then
                            local dist = (part.Position - hrp.Position).Magnitude
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
            end
            task.wait(0.5)
        end
    end)
end

-- ============================================================
-- INIT
-- ============================================================
function Features.Init(sharedState)
    Shared = sharedState
    Shared.Features = Features
    Shared.setSpeed = Features.setSpeed
    Shared.setJump = Features.setJump
    Shared.applySpeed = Features.applySpeed

    Features.loadGenerators()
    Features.applySpeed()
    Features.startGenESP()
    Features.startPlayerESP()
    Features.startAutoLoops()

    print("[VRILZHUB] Violence District Features v3.0 loaded")
end

return Features
