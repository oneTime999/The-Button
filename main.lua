-- Services
local Players          = game:GetService("Players")
local Workspace        = game:GetService("Workspace")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local isMobile  = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- ============================================================
-- RARIDADES
-- ============================================================
local RARITY_COLORS = {
    OG        = Color3.fromRGB(255, 215, 0),   -- Dourado
    Cosmic    = Color3.fromRGB(0,   220, 255), -- Ciano
    Legendary = Color3.fromRGB(255, 120, 0),   -- Laranja
    Mythic    = Color3.fromRGB(220, 50,  255), -- Roxo
}

local bossRarity = {
    -- OG
    ["Buddha Admiral"]     = "OG",
    ["Earthquake Titan"]   = "OG",
    ["Hero Marine"]        = "OG",
    ["Pirate King"]        = "OG",
    -- Cosmic
    ["Dark Emperor"]       = "Cosmic",
    ["Dragon Emperor"]     = "Cosmic",
    ["Hawk Swordsman"]     = "Cosmic",
    ["Magma Admiral"]      = "Cosmic",
    ["Red Emperor"]        = "Cosmic",
    ["Soul Empress"]       = "Cosmic",
    ["Sun Warrior"]        = "Cosmic",
    -- Legendary
    ["Flame Chief"]        = "Legendary",
    ["Giraffe Agent"]      = "Legendary",
    ["Grass Admiral"]      = "Legendary",
    ["Leopard Assassin"]   = "Legendary",
    ["Seraph Hawk"]        = "Legendary",
    ["Wildfire King"]      = "Legendary",
    -- Mythic
    ["Black Leg Fighter"]  = "Mythic",
    ["Boiling Samurai"]    = "Mythic",
    ["Dark King"]          = "Mythic",
    ["Elder Demon"]        = "Mythic",
    ["Gravity Admiral"]    = "Mythic",
    ["Light Admiral"]      = "Mythic",
    ["Surgeon Pirate"]     = "Mythic",
    ["Three Blade Warrior"]= "Mythic",
}

local targetNames = {}
for name in pairs(bossRarity) do targetNames[name] = true end

local function getRarity(name) return bossRarity[name] or "Legendary" end
local function getRarityColor(name) return RARITY_COLORS[getRarity(name)] end

-- ============================================================
-- ESTADO DO ESP
-- ============================================================
local espEnabled    = true
local rarityEnabled = { OG = true, Cosmic = true, Legendary = true, Mythic = true }
local activeESP     = {} -- model -> { highlight, billboard, distLabel, connection }

-- ============================================================
-- CRIAR ESP
-- ============================================================
local function createESP(model)
    if activeESP[model] then return end

    local rarity = getRarity(model.Name)
    local color  = RARITY_COLORS[rarity]

    -- Highlight (atravessa paredes)
    local hl = Instance.new("Highlight")
    hl.Name                = "BossESP_HL"
    hl.FillColor           = color
    hl.OutlineColor        = color
    hl.FillTransparency    = 0.72
    hl.OutlineTransparency = 0
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee             = model
    hl.Enabled             = espEnabled and rarityEnabled[rarity]
    hl.Parent              = model

    -- BillboardGui com nome + raridade + distância
    local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")

    local bb = Instance.new("BillboardGui")
    bb.Name        = "BossESP_BB"
    bb.Size        = UDim2.new(0, 170, 0, 52)
    bb.StudsOffset = Vector3.new(0, 5, 0)
    bb.AlwaysOnTop = true
    bb.Adornee     = root
    bb.Enabled     = espEnabled and rarityEnabled[rarity]
    bb.Parent      = model

    -- Nome
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size                   = UDim2.new(1, 0, 0.44, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text                   = model.Name
    nameLbl.TextColor3             = color
    nameLbl.TextSize               = isMobile and 14 or 13
    nameLbl.Font                   = Enum.Font.GothamBold
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    nameLbl.Parent                 = bb

    -- Raridade
    local rarityLbl = Instance.new("TextLabel")
    rarityLbl.Size                   = UDim2.new(1, 0, 0.32, 0)
    rarityLbl.Position               = UDim2.new(0, 0, 0.44, 0)
    rarityLbl.BackgroundTransparency = 1
    rarityLbl.Text                   = "★ " .. rarity
    rarityLbl.TextColor3             = color
    rarityLbl.TextSize               = isMobile and 11 or 10
    rarityLbl.Font                   = Enum.Font.Gotham
    rarityLbl.TextStrokeTransparency = 0
    rarityLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    rarityLbl.Parent                 = bb

    -- Distância
    local distLbl = Instance.new("TextLabel")
    distLbl.Size                   = UDim2.new(1, 0, 0.24, 0)
    distLbl.Position               = UDim2.new(0, 0, 0.76, 0)
    distLbl.BackgroundTransparency = 1
    distLbl.Text                   = ""
    distLbl.TextColor3             = Color3.fromRGB(210, 210, 210)
    distLbl.TextSize               = isMobile and 10 or 9
    distLbl.Font                   = Enum.Font.Gotham
    distLbl.TextStrokeTransparency = 0.2
    distLbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    distLbl.Parent                 = bb

    -- Limpar ao destruir o model
    local conn = model.AncestryChanged:Connect(function(_, parent)
        if not parent then
            local data = activeESP[model]
            if data then
                pcall(function() data.highlight:Destroy() end)
                pcall(function() data.billboard:Destroy() end)
                pcall(function() data.conn:Disconnect() end)
                activeESP[model] = nil
            end
        end
    end)

    activeESP[model] = {
        highlight = hl,
        billboard = bb,
        distLabel = distLbl,
        conn      = conn,
        rarity    = rarity,
    }
end

-- ============================================================
-- REMOVER ESP
-- ============================================================
local function removeESP(model)
    local data = activeESP[model]
    if not data then return end
    pcall(function() data.highlight:Destroy() end)
    pcall(function() data.billboard:Destroy() end)
    pcall(function() data.conn:Disconnect() end)
    activeESP[model] = nil
end

-- ============================================================
-- ATUALIZAR VISIBILIDADE
-- ============================================================
local function refreshVisibility()
    for model, data in pairs(activeESP) do
        local visible = espEnabled and rarityEnabled[data.rarity]
        data.highlight.Enabled = visible
        data.billboard.Enabled = visible
    end
end

-- ============================================================
-- HEARTBEAT — atualizar distância
-- ============================================================
RunService.Heartbeat:Connect(function()
    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for model, data in pairs(activeESP) do
        if model.Parent and data.billboard.Enabled then
            local root = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
            if root then
                local dist = math.floor((hrp.Position - root.Position).Magnitude)
                data.distLabel.Text = dist .. " studs"
            end
        end
    end
end)

-- ============================================================
-- MONITORAR PASTA Things
-- ============================================================
task.spawn(function()
    local folder = Workspace:WaitForChild("Things", 15)
    if not folder then warn("[ESP] Pasta Things não encontrada") return end

    for _, obj in ipairs(folder:GetChildren()) do
        if obj:IsA("Model") and targetNames[obj.Name] then
            createESP(obj)
        end
    end

    folder.ChildAdded:Connect(function(child)
        task.wait(0.2)
        if child:IsA("Model") and targetNames[child.Name] and child.Parent then
            createESP(child)
        end
    end)

    folder.ChildRemoved:Connect(function(child)
        removeESP(child)
    end)
end)

-- Scan periódico de backup (a cada 2s)
task.spawn(function()
    while true do
        task.wait(2)
        local folder = Workspace:FindFirstChild("Things")
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if obj:IsA("Model") and targetNames[obj.Name] and not activeESP[obj] then
                    createESP(obj)
                end
            end
            for model in pairs(activeESP) do
                if not model.Parent then removeESP(model) end
            end
        end
    end
end)

-- ============================================================
-- LOOP VIP CLEAR (a cada 0.1s)
-- ============================================================
task.spawn(function()
    while true do
        pcall(function()
            local zones = Workspace:FindFirstChild("Zones")
            if zones then
                local vip = zones:FindFirstChild("Vip")
                if vip then
                    for _, child in ipairs(vip:GetChildren()) do
                        child:Destroy()
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)

-- ============================================================
-- GUI DE CONTROLE
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name          = "BossESP_GUI"
screenGui.ResetOnSpawn  = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent        = playerGui

local PANEL_W = isMobile and 215 or 185
local HDR_H   = isMobile and 46 or 36
local BTN_H   = isMobile and 40 or 32
local SPACING = isMobile and 8 or 6
local ROWS    = 5 -- 1 geral + 4 raridades
local PANEL_H = HDR_H + 10 + ROWS * BTN_H + (ROWS - 1) * SPACING + 10

local mainFrame = Instance.new("Frame")
mainFrame.Size              = UDim2.new(0, PANEL_W, 0, PANEL_H)
mainFrame.Position          = UDim2.new(0, 16, 0.5, -PANEL_H / 2)
mainFrame.BackgroundColor3  = Color3.fromRGB(16, 16, 20)
mainFrame.BackgroundTransparency = 0.06
mainFrame.BorderSizePixel   = 0
mainFrame.Active            = true
mainFrame.Parent            = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Sombra
local shadow = Instance.new("ImageLabel")
shadow.AnchorPoint        = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position           = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size               = UDim2.new(1, 36, 1, 36)
shadow.ZIndex             = -1
shadow.Image              = "rbxassetid://5554236805"
shadow.ImageColor3        = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency  = 0.55
shadow.ScaleType          = Enum.ScaleType.Slice
shadow.SliceCenter        = Rect.new(23, 23, 277, 277)
shadow.Parent             = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size             = UDim2.new(1, 0, 0, HDR_H)
header.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
header.BorderSizePixel  = 0
header.Parent           = mainFrame

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Tapa cantos inferiores do header
local hFix = Instance.new("Frame")
hFix.Size            = UDim2.new(1, 0, 0, 8)
hFix.Position        = UDim2.new(0, 0, 1, -8)
hFix.BackgroundColor3 = header.BackgroundColor3
hFix.BorderSizePixel = 0
hFix.Parent          = header

local titleLbl = Instance.new("TextLabel")
titleLbl.Size               = UDim2.new(1, -46, 1, 0)
titleLbl.Position           = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "👁  BOSS ESP"
titleLbl.TextColor3         = Color3.fromRGB(255, 215, 0)
titleLbl.TextSize           = isMobile and 17 or 14
titleLbl.Font               = Enum.Font.GothamBold
titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
titleLbl.Parent             = header

local minBtn = Instance.new("TextButton")
minBtn.Size             = UDim2.new(0, 30, 0, 30)
minBtn.Position         = UDim2.new(1, -38, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(46, 46, 56)
minBtn.Text             = "−"
minBtn.TextColor3       = Color3.fromRGB(255, 255, 255)
minBtn.TextSize         = 18
minBtn.Font             = Enum.Font.GothamBold
minBtn.Parent           = header

Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Body
local body = Instance.new("Frame")
body.Size               = UDim2.new(1, -16, 0, PANEL_H - HDR_H - 14)
body.Position           = UDim2.new(0, 8, 0, HDR_H + 8)
body.BackgroundTransparency = 1
body.Parent             = mainFrame

local bodyLayout = Instance.new("UIListLayout")
bodyLayout.Padding    = UDim.new(0, SPACING)
bodyLayout.SortOrder  = Enum.SortOrder.LayoutOrder
bodyLayout.Parent     = body

-- Criar toggle pill
local function makeToggle(labelText, color, order, initState, onChange)
    local row = Instance.new("Frame")
    row.Size            = UDim2.new(1, 0, 0, BTN_H)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    row.BorderSizePixel = 0
    row.LayoutOrder     = order
    row.Parent          = body

    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    -- Barra lateral colorida
    local bar = Instance.new("Frame")
    bar.Size            = UDim2.new(0, 3, 0.65, 0)
    bar.Position        = UDim2.new(0, 0, 0.175, 0)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    bar.Parent          = row
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

    local lbl = Instance.new("TextLabel")
    lbl.Size               = UDim2.new(1, -66, 1, 0)
    lbl.Position           = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = labelText
    lbl.TextColor3         = color
    lbl.TextSize           = isMobile and 13 or 11
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.Parent             = row

    -- Pill
    local pill = Instance.new("Frame")
    pill.Size            = UDim2.new(0, 44, 0, 22)
    pill.Position        = UDim2.new(1, -50, 0.5, -11)
    pill.BackgroundColor3 = initState and Color3.fromRGB(45, 200, 90) or Color3.fromRGB(70, 70, 82)
    pill.BorderSizePixel = 0
    pill.Parent          = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size            = UDim2.new(0, 16, 0, 16)
    knob.Position        = initState and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent          = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local state = initState
    local clickArea = Instance.new("TextButton")
    clickArea.Size               = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text               = ""
    clickArea.Parent             = row

    clickArea.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(pill, TweenInfo.new(0.18), {
            BackgroundColor3 = state and Color3.fromRGB(45, 200, 90) or Color3.fromRGB(70, 70, 82)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.18), {
            Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        }):Play()
        onChange(state)
    end)
end

-- Toggle geral
makeToggle("ESP  (Todos)", Color3.fromRGB(240, 240, 240), 0, true, function(s)
    espEnabled = s
    refreshVisibility()
end)

-- Toggles por raridade
makeToggle("★  OG",        RARITY_COLORS.OG,        1, true, function(s) rarityEnabled.OG        = s refreshVisibility() end)
makeToggle("★  Cosmic",    RARITY_COLORS.Cosmic,    2, true, function(s) rarityEnabled.Cosmic    = s refreshVisibility() end)
makeToggle("★  Legendary", RARITY_COLORS.Legendary, 3, true, function(s) rarityEnabled.Legendary = s refreshVisibility() end)
makeToggle("★  Mythic",    RARITY_COLORS.Mythic,    4, true, function(s) rarityEnabled.Mythic    = s refreshVisibility() end)

-- Minimizar
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    TweenService:Create(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
        Size = minimized
            and UDim2.new(0, PANEL_W, 0, HDR_H + 8)
            or  UDim2.new(0, PANEL_W, 0, PANEL_H)
    }):Play()
    body.Visible = not minimized
    minBtn.Text  = minimized and "+" or "−"
end)

-- Tecla P
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.P then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Drag
do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                      or input.UserInputType == Enum.UserInputType.Touch) then
            local d  = input.Position - dragStart
            local sw = game:GetService("GuiService").AbsoluteWindowSize
            local fs = mainFrame.AbsoluteSize
            mainFrame.Position = UDim2.new(0,
                math.clamp(startPos.X.Offset + d.X, 0, sw.X - fs.X), 0,
                math.clamp(startPos.Y.Offset + d.Y, 0, sw.Y - fs.Y))
        end
    end)
end
