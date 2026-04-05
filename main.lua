-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Detectar se é mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Lista completa dos bosses
local targetNames = {
    "Buddha Admiral", "Earthquake Titan", "Hero Marine", "Pirate King",
    "Dark Emperor", "Dragon Emperor", "Hawk Swordsman", "Magma Admiral",
    "Red Emperor", "Soul Empress", "Sun Warrior", "Flame Chief",
    "Giraffe Agent", "Grass Admiral", "Leopard Assassin", "Seraph Hawk",
    "Wildfire King", "Black Leg Fighter", "Boiling Samurai", "Dark King",
    "Elder Demon", "Gravity Admiral", "Light Admiral", "Surgeon Pirate",
    "Three Blade Warrior"
}

-- ============================================================
-- LIMPAR VIP (executa 1x ao iniciar)
-- ============================================================
task.spawn(function()
    local success, err = pcall(function()
        local vip = Workspace:WaitForChild("Zones", 10)
        if vip then
            local vipFolder = vip:WaitForChild("Vip", 5)
            if vipFolder then
                for _, child in ipairs(vipFolder:GetChildren()) do
                    child:Destroy()
                end
            end
        end
    end)
    if not success then
        warn("VIP clear falhou: " .. tostring(err))
    end
end)

-- ============================================================
-- RARIDADES REAIS DO JOGO
-- ============================================================
local RARITY_COLORS = {
    OG        = Color3.fromRGB(255, 215, 0),   -- Dourado
    Cosmic    = Color3.fromRGB(0,   220, 255), -- Ciano
    Legendary = Color3.fromRGB(255, 120, 0),   -- Laranja
    Mythic    = Color3.fromRGB(220, 50,  255), -- Roxo vibrante
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

local function getRarityColor(bossName)
    local rarity = bossRarity[bossName] or "Legendary"
    return RARITY_COLORS[rarity], rarity
end

-- Configurações adaptativas
local CONFIG = {
    FolderName = "Things",
    ButtonHeight = isMobile and 70 or 50,
    ButtonSpacing = isMobile and 12 or 8,
    FrameWidth = isMobile and 280 or 240,
    FrameHeight = isMobile and 350 or 400,
    DragAreaHeight = isMobile and 50 or 40,
    TeleportOffset = CFrame.new(0, 8, 0),
    UpdateInterval = 0.3
}

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BossTeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, CONFIG.FrameWidth, 0, CONFIG.FrameHeight)
mainFrame.Position = UDim2.new(0, 20, 0.5, -CONFIG.FrameHeight/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, CONFIG.DragAreaHeight)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local fixCorner = Instance.new("Frame")
fixCorner.Size = UDim2.new(1, 0, 0, 10)
fixCorner.Position = UDim2.new(0, 0, 1, -10)
fixCorner.BackgroundColor3 = header.BackgroundColor3
fixCorner.BorderSizePixel = 0
fixCorner.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎯 BOSSES"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = isMobile and 20 or 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleBtn"
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(1, -90, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
toggleButton.Text = "−"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 24
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = header

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0.5, -20)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "BossList"
scrollingFrame.Size = UDim2.new(1, -20, 1, -CONFIG.DragAreaHeight - 15)
scrollingFrame.Position = UDim2.new(0, 10, 0, CONFIG.DragAreaHeight + 10)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = isMobile and 8 or 6
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, CONFIG.ButtonSpacing)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 5)
uiPadding.PaddingBottom = UDim.new(0, 5)
uiPadding.Parent = scrollingFrame

-- Estado
local isMinimized = false
local originalSize = mainFrame.Size
local activeButtons = {}

-- DRAG — só ativa no header, usa threshold para não bloquear scroll/clique
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local totalDelta = Vector2.new(0, 0)
    local DRAG_THRESHOLD = 5 -- pixels mínimos para considerar drag

    local function updateInput(input)
        local delta = input.Position - dragStart
        totalDelta = Vector2.new(math.abs(delta.X), math.abs(delta.Y))

        if totalDelta.Magnitude < DRAG_THRESHOLD then return end

        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y

        local screenSize = GuiService.AbsoluteWindowSize
        local frameAbsSize = frame.AbsoluteSize

        newX = math.clamp(newX, 0, screenSize.X - frameAbsSize.X)
        newY = math.clamp(newY, 0, screenSize.Y - frameAbsSize.Y)

        frame.Position = UDim2.new(0, newX, 0, newY)
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            totalDelta = Vector2.new(0, 0)

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            updateInput(input)
        end
    end)
end

-- NOTIFICAÇÃO
local function showNotification(text)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 220, 0, 40)
    notif.Position = UDim2.new(0.5, -110, 0, -50)
    notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    notif.Text = text
    notif.TextColor3 = Color3.fromRGB(255, 215, 0)
    notif.TextSize = 14
    notif.Font = Enum.Font.GothamBold
    notif.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, -110, 0, 20)
    }):Play()

    task.delay(2, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(0.5, -110, 0, -50),
            TextTransparency = 1,
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- TELEPORTE
local function teleportToModel(model)
    local character = player.Character
    if not character then
        showNotification("❌ Personagem não encontrado!")
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        showNotification("❌ Você está morto!")
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        showNotification("❌ HumanoidRootPart não encontrado!")
        return
    end

    local targetCFrame = nil

    if model.PrimaryPart then
        targetCFrame = model.PrimaryPart.CFrame
    else
        local bossHrp = model:FindFirstChild("HumanoidRootPart")
        if bossHrp then
            targetCFrame = bossHrp.CFrame
        else
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    targetCFrame = part.CFrame
                    break
                end
            end
        end
    end

    if targetCFrame then
        hrp.CFrame = targetCFrame * CONFIG.TeleportOffset
        showNotification("✅ Teleportado: " .. model.Name)
    else
        showNotification("❌ Boss sem posição válida!")
    end
end

-- ============================================================
-- REMOVER BOTÃO — definido ANTES de createBossButton
-- (corrige o bug principal: função usada antes de existir)
-- ============================================================
local function removeBossButton(model)
    local button = activeButtons[model]
    if not button then return end

    TweenService:Create(button, TweenInfo.new(0.2), {
        Size = UDim2.new(0, 0, 0, CONFIG.ButtonHeight),
        BackgroundTransparency = 1
    }):Play()

    task.wait(0.2)
    if button and button.Parent then
        button:Destroy()
    end
    activeButtons[model] = nil

    local totalHeight = uiListLayout.AbsoluteContentSize.Y + 20
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- CRIAR BOTÃO
local function createBossButton(model)
    if activeButtons[model] then return end

    local button = Instance.new("TextButton")
    button.Name = model.Name
    button.Size = UDim2.new(1, 0, 0, CONFIG.ButtonHeight)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    button.Text = ""
    button.AutoButtonColor = false   -- ← evita conflito visual com hover manual
    button.LayoutOrder = #scrollingFrame:GetChildren()
    button.Parent = scrollingFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 215, 0)
    stroke.Thickness = 1.5
    stroke.Parent = button

    local rarityColor, rarityName = getRarityColor(model.Name)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -10, 0.55, 0)
    nameLabel.Position = UDim2.new(0, 5, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "⚔️ " .. model.Name
    nameLabel.TextColor3 = rarityColor          -- ← cor da raridade
    nameLabel.TextSize = isMobile and 16 or 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = button

    -- Linha inferior: raridade à esquerda, dica à direita
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Size = UDim2.new(0.5, -5, 0.38, 0)
    rarityLabel.Position = UDim2.new(0, 5, 0.6, 0)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = "★ " .. rarityName
    rarityLabel.TextColor3 = rarityColor        -- ← mesma cor da raridade
    rarityLabel.TextSize = isMobile and 11 or 9
    rarityLabel.Font = Enum.Font.GothamBold
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    rarityLabel.Parent = button

    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(0.5, -5, 0.38, 0)
    subLabel.Position = UDim2.new(0.5, 0, 0.6, 0)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "Toque para tp"
    subLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    subLabel.TextSize = isMobile and 11 or 9
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextXAlignment = Enum.TextXAlignment.Right
    subLabel.Parent = button

    -- Borda lateral colorida com a cor da raridade
    local rarityBar = Instance.new("Frame")
    rarityBar.Size = UDim2.new(0, 4, 1, -8)
    rarityBar.Position = UDim2.new(1, -8, 0, 4)
    rarityBar.BackgroundColor3 = rarityColor
    rarityBar.BorderSizePixel = 0
    rarityBar.Parent = button

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 4)
    barCorner.Parent = rarityBar

    -- Hover
    local function animateHover(enter)
        local targetColor = enter and Color3.fromRGB(60, 60, 70) or Color3.fromRGB(40, 40, 45)
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = targetColor
        }):Play()
    end

    button.MouseEnter:Connect(function() animateHover(true) end)
    button.MouseLeave:Connect(function() animateHover(false) end)

    -- ============================================================
    -- CLIQUE: usa MouseButton1Click (mouse) + TouchTap (mobile)
    -- Evita que o drag do frame bloqueie o toque no botão
    -- ============================================================
    local function doTeleport()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        }):Play()
        task.wait(0.1)
        animateHover(false)

        if model and model.Parent then
            teleportToModel(model)
        else
            showNotification("❌ Boss não existe mais!")
            removeBossButton(model)
        end
    end

    button.MouseButton1Click:Connect(doTeleport)

    -- Touch explícito para garantir funcionamento no mobile
    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            doTeleport()
        end
    end)

    -- Animação de entrada
    button.Size = UDim2.new(0, 0, 0, CONFIG.ButtonHeight)
    TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(1, 0, 0, CONFIG.ButtonHeight)
    }):Play()

    activeButtons[model] = button

    local totalHeight = uiListLayout.AbsoluteContentSize.Y + 20
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

    -- Monitorar destruição do modelo
    model.AncestryChanged:Connect(function(_, parent)
        if not parent and activeButtons[model] then
            removeBossButton(model)
        end
    end)
end

-- Minimizar/Maximizar
local function toggleMinimize()
    isMinimized = not isMinimized

    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, CONFIG.FrameWidth, 0, CONFIG.DragAreaHeight + 10)
        }):Play()
        toggleButton.Text = "+"
        scrollingFrame.Visible = false
        shadow.Visible = false
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = originalSize
        }):Play()
        toggleButton.Text = "−"
        scrollingFrame.Visible = true
        shadow.Visible = true
    end
end

toggleButton.MouseButton1Click:Connect(toggleMinimize)
closeButton.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

makeDraggable(mainFrame, header)

-- VERIFICAR NOME
local function isTargetName(name)
    for _, target in ipairs(targetNames) do
        if name == target then return true end
    end
    return false
end

-- MONITORAMENTO
local function startMonitoring()
    local thingsFolder = Workspace:WaitForChild(CONFIG.FolderName, 10)

    if not thingsFolder then
        warn("❌ Pasta 'Things' não encontrada!")
        return
    end

    showNotification("✅ Monitoramento iniciado!")

    for _, obj in ipairs(thingsFolder:GetChildren()) do
        if obj:IsA("Model") and isTargetName(obj.Name) then
            createBossButton(obj)
        end
    end

    thingsFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") and isTargetName(child.Name) then
            task.wait(0.3)
            if child.Parent then
                createBossButton(child)
                showNotification("🎯 " .. child.Name .. " apareceu!")
            end
        end
    end)

    thingsFolder.ChildRemoved:Connect(function(child)
        if activeButtons[child] then
            removeBossButton(child)
        end
    end)
end

-- Verificação periódica
task.spawn(function()
    while true do
        task.wait(CONFIG.UpdateInterval)
        local thingsFolder = Workspace:FindFirstChild(CONFIG.FolderName)
        if thingsFolder then
            for model, _ in pairs(activeButtons) do
                if not model.Parent or model.Parent ~= thingsFolder then
                    removeBossButton(model)
                end
            end

            for _, obj in ipairs(thingsFolder:GetChildren()) do
                if obj:IsA("Model") and isTargetName(obj.Name) and not activeButtons[obj] then
                    createBossButton(obj)
                end
            end
        end
    end
end)

startMonitoring()
showNotification("Pressione P para esconder")
