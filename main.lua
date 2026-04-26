local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Slow Hub",
    SubTitle = "by Slow Hub Team",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightShift
})

local ESPTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
local MiscTab = Window:AddTab({ Title = "Misc", Icon = "settings" })

local Options = Fluent.Options

local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local plr = players.LocalPlayer

local function getHum()
    local c = plr.Character
    if c then
        return c:FindFirstChildWhichIsA("Humanoid")
    end
    return nil
end

local ESPFolders = {}
local function clearESP()
    for _, folder in ipairs(ESPFolders) do
        if folder and folder.Parent then
            folder:Destroy()
        end
    end
    table.clear(ESPFolders)
end

local function createESP(obj)
    local toolType = obj:GetAttribute("ToolType")
    if not toolType then return end
    if obj:FindFirstChild("ESP_Folder") then return end

    local folder = Instance.new("Folder")
    folder.Name = "ESP_Folder"
    folder.Parent = obj
    table.insert(ESPFolders, folder)

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "NameESP"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    bgui.Enabled = true
    bgui.AlwaysOnTop = true
    bgui.Adornee = obj
    bgui.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextStrokeTransparency = 0
    text.Text = obj.Name .. " : " .. tostring(toolType)
    text.Parent = bgui

    local highlight = Instance.new("Highlight")
    highlight.Name = "ToolHighlight"
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = obj
    highlight.Parent = folder
end

local PlayerESPs = {}
local function clearPlayerESP()
    for _, folder in ipairs(PlayerESPs) do
        if folder and folder.Parent then
            folder:Destroy()
        end
    end
    table.clear(PlayerESPs)
end

local function createPlayerESP(player)
    if not (player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")) then return end
    if player.Character:FindFirstChild("PlayerESP_Folder") then return end

    local folder = Instance.new("Folder")
    folder.Name = "PlayerESP_Folder"
    folder.Parent = player.Character
    table.insert(PlayerESPs, folder)

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "NameESP"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    bgui.Enabled = true
    bgui.AlwaysOnTop = true
    bgui.Adornee = player.Character
    bgui.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(0, 255, 0)
    text.TextStrokeTransparency = 0
    text.Text = player.Name .. " : " .. tostring(math.floor(player.Character:FindFirstChildWhichIsA("Humanoid").Health))
    text.Parent = bgui

    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = player.Character
    highlight.Parent = folder
end

local function updatePlayerESPColor(player)
    if not player.Character then return end
    local folder = player.Character:FindFirstChild("PlayerESP_Folder")
    if not folder then return end

    local bgui = folder:FindFirstChild("NameESP")
    if not bgui then return end

    local text = bgui:FindFirstChildWhichIsA("TextLabel")
    local highlight = folder:FindFirstChild("PlayerHighlight")
    if not text or not highlight then return end

    local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end

    local canBeHit = humanoid:GetAttribute("CanBeHit")
    if canBeHit == false then
        text.TextColor3 = Color3.fromRGB(255, 0, 0)
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
    else
        text.TextColor3 = Color3.fromRGB(0, 255, 0)
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
    end

    if player:GetAttribute("Ghost") then
        text.TextColor3 = Color3.fromRGB(0, 255, 255)
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
    end

    if humanoid.Health > 0 then
        text.Text = player.Name .. " : " .. tostring(math.floor(humanoid.Health))
    end
end

local function createZombieESP(model)
    if not model:IsA("Model") then return end
    if model:FindFirstChild("ZombieESP_Folder") then return end

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end

    local folder = Instance.new("Folder")
    folder.Name = "ZombieESP_Folder"
    folder.Parent = model

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ZombieNameESP"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 4, 0)
    bgui.Enabled = true
    bgui.AlwaysOnTop = true
    bgui.Adornee = hrp
    bgui.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(0, 100, 0)
    text.TextStrokeTransparency = 0
    text.Text = "[ZOMBIE] " .. model.Name
    text.Parent = bgui

    local highlight = Instance.new("Highlight")
    highlight.Name = "ZombieHighlight"
    highlight.FillColor = Color3.fromRGB(0, 100, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = folder
end

local function createProjectDeltaESP(model)
    if not model:IsA("Model") then return end
    if model:FindFirstChild("ProjectDeltaESP_Folder") then return end

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end

    local folder = Instance.new("Folder")
    folder.Name = "ProjectDeltaESP_Folder"
    folder.Parent = model

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ProjectDeltaNameESP"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 4, 0)
    bgui.Enabled = true
    bgui.AlwaysOnTop = true
    bgui.Adornee = hrp
    bgui.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 0, 255)
    text.TextStrokeTransparency = 0
    text.Text = "[DELTA] " .. model.Name
    text.Parent = bgui

    local highlight = Instance.new("Highlight")
    highlight.Name = "ProjectDeltaHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = folder
end

local function createProjectBetaESP(model)
    if not model:IsA("Model") then return end
    if model:FindFirstChild("ProjectBetaESP_Folder") then return end

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end

    local folder = Instance.new("Folder")
    folder.Name = "ProjectBetaESP_Folder"
    folder.Parent = model

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ProjectBetaNameESP"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 4, 0)
    bgui.Enabled = true
    bgui.AlwaysOnTop = true
    bgui.Adornee = hrp
    bgui.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(0, 0, 0)
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    text.Text = "[BETA] " .. model.Name
    text.Parent = bgui

    local highlight = Instance.new("Highlight")
    highlight.Name = "ProjectBetaHighlight"
    highlight.FillColor = Color3.fromRGB(0, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = folder
end

local function createProjectAlphaESP(model)
    if not model:IsA("Model") then return end
    if model:FindFirstChild("ProjectAlphaESP_Folder") then return end

    local hrp = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Torso") or model:FindFirstChildWhichIsA("BasePart")
    if not hrp then return end

    local folder = Instance.new("Folder")
    folder.Name = "ProjectAlphaESP_Folder"
    folder.Parent = model

    local bgui = Instance.new("BillboardGui")
    bgui.Name = "ProjectAlphaNameESP"
    bgui.Size = UDim2.new(0, 200, 0, 50)
    bgui.StudsOffset = Vector3.new(0, 4, 0)
    bgui.Enabled = true
    bgui.AlwaysOnTop = true
    bgui.Adornee = hrp
    bgui.Parent = folder

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 165, 0)
    text.TextStrokeTransparency = 0
    text.Text = "[ALPHA] " .. model.Name
    text.Parent = bgui

    local highlight = Instance.new("Highlight")
    highlight.Name = "ProjectAlphaHighlight"
    highlight.FillColor = Color3.fromRGB(255, 165, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.FillTransparency = 0.7
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = folder
end

local function scanZombies()
    local folder = workspace:FindFirstChild("Zombies")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        createZombieESP(child)
    end
end

local function scanProjectDelta()
    local folder = workspace:FindFirstChild("Project Delta")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        createProjectDeltaESP(child)
    end
end

local function scanProjectBeta()
    local folder = workspace:FindFirstChild("Project Beta")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        createProjectBetaESP(child)
    end
end

local function scanProjectAlpha()
    local folder = workspace:FindFirstChild("Project Alpha")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        createProjectAlphaESP(child)
    end
end

local function clearZombieESP()
    local folder = workspace:FindFirstChild("Zombies")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        local esp = child:FindFirstChild("ZombieESP_Folder")
        if esp then esp:Destroy() end
    end
end

local function clearProjectDeltaESP()
    local folder = workspace:FindFirstChild("Project Delta")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        local esp = child:FindFirstChild("ProjectDeltaESP_Folder")
        if esp then esp:Destroy() end
    end
end

local function clearProjectBetaESP()
    local folder = workspace:FindFirstChild("Project Beta")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        local esp = child:FindFirstChild("ProjectBetaESP_Folder")
        if esp then esp:Destroy() end
    end
end

local function clearProjectAlphaESP()
    local folder = workspace:FindFirstChild("Project Alpha")
    if not folder then return end
    for _, child in pairs(folder:GetChildren()) do
        local esp = child:FindFirstChild("ProjectAlphaESP_Folder")
        if esp then esp:Destroy() end
    end
end

local playerESPUpdate = nil
local ZombieESPUpdate = nil
local ProjectESPUpdate = nil

local function disableAllESPs()
    _G.ItemESPEnabled = false
    clearESP()
    clearPlayerESP()
    clearZombieESP()
    clearProjectDeltaESP()
    clearProjectBetaESP()
    clearProjectAlphaESP()

    if playerESPUpdate then
        playerESPUpdate:Disconnect()
        playerESPUpdate = nil
    end
    if ZombieESPUpdate then
        ZombieESPUpdate:Disconnect()
        ZombieESPUpdate = nil
    end
    if ProjectESPUpdate then
        ProjectESPUpdate:Disconnect()
        ProjectESPUpdate = nil
    end

    Options.ItemESP:SetValue(false)
    Options.PlayerESP:SetValue(false)
    Options.ZombieESP:SetValue(false)
    Options.ProjectESP:SetValue(false)
end

ESPTab:AddToggle("ItemESP", { Title = "Items ESP", Default = false }):OnChanged(function(value)
    if value then
        for _, item in pairs(workspace:GetChildren()) do
            createESP(item)
        end
        _G.ItemESPEnabled = true
    else
        _G.ItemESPEnabled = false
        clearESP()
    end
end)

workspace.ChildAdded:Connect(function(obj)
    if _G.ItemESPEnabled then
        createESP(obj)
    end
end)

ESPTab:AddToggle("PlayerESP", { Title = "Players ESP", Default = false }):OnChanged(function(value)
    if value then
        for _, player in pairs(players:GetPlayers()) do
            if player ~= plr then
                createPlayerESP(player)
                updatePlayerESPColor(player)
            end
        end
        if not playerESPUpdate then
            playerESPUpdate = RunService.Heartbeat:Connect(function()
                for _, player in pairs(players:GetPlayers()) do
                    if player ~= plr and player.Character then
                        local folder = player.Character:FindFirstChild("PlayerESP_Folder")
                        if not folder then
                            createPlayerESP(player)
                        end
                        updatePlayerESPColor(player)
                    end
                end
            end)
        end
    else
        clearPlayerESP()
        if playerESPUpdate then
            playerESPUpdate:Disconnect()
            playerESPUpdate = nil
        end
    end
end)

ESPTab:AddToggle("ZombieESP", { Title = "Zombies ESP", Default = false }):OnChanged(function(value)
    if value then
        scanZombies()
        if ZombieESPUpdate then ZombieESPUpdate:Disconnect() end
        ZombieESPUpdate = RunService.Heartbeat:Connect(function()
            scanZombies()
            local f = workspace:FindFirstChild("Zombies")
            if not f then return end
            for _, model in pairs(f:GetChildren()) do
                if model:FindFirstChild("ZombieESP_Folder") then
                    local espFolder = model:FindFirstChild("ZombieESP_Folder")
                    local bgui = espFolder:FindFirstChild("ZombieNameESP")
                    local text = bgui and bgui:FindFirstChildWhichIsA("TextLabel")
                    local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                    if text and humanoid then
                        text.Text = "[ZOMBIE] " .. model.Name .. " : " .. tostring(math.floor(humanoid.Health))
                    end
                end
            end
        end)
    else
        clearZombieESP()
        if ZombieESPUpdate then
            ZombieESPUpdate:Disconnect()
            ZombieESPUpdate = nil
        end
    end
end)

ESPTab:AddToggle("ProjectESP", { Title = "Project ESP", Default = false }):OnChanged(function(value)
    if value then
        scanProjectDelta()
        scanProjectBeta()
        scanProjectAlpha()
        if ProjectESPUpdate then ProjectESPUpdate:Disconnect() end
        ProjectESPUpdate = RunService.Heartbeat:Connect(function()
            scanProjectDelta()
            scanProjectBeta()
            scanProjectAlpha()

            local fd = workspace:FindFirstChild("Project Delta")
            if fd then
                for _, model in pairs(fd:GetChildren()) do
                    if model:FindFirstChild("ProjectDeltaESP_Folder") then
                        local espFolder = model:FindFirstChild("ProjectDeltaESP_Folder")
                        local bgui = espFolder:FindFirstChild("ProjectDeltaNameESP")
                        local text = bgui and bgui:FindFirstChildWhichIsA("TextLabel")
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if text and humanoid then
                            text.Text = "[DELTA] " .. model.Name .. " : " .. tostring(math.floor(humanoid.Health))
                        end
                    end
                end
            end

            local fb = workspace:FindFirstChild("Project Beta")
            if fb then
                for _, model in pairs(fb:GetChildren()) do
                    if model:FindFirstChild("ProjectBetaESP_Folder") then
                        local espFolder = model:FindFirstChild("ProjectBetaESP_Folder")
                        local bgui = espFolder:FindFirstChild("ProjectBetaNameESP")
                        local text = bgui and bgui:FindFirstChildWhichIsA("TextLabel")
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if text and humanoid then
                            text.Text = "[BETA] " .. model.Name .. " : " .. tostring(math.floor(humanoid.Health))
                        end
                    end
                end
            end

            local fa = workspace:FindFirstChild("Project Alpha")
            if fa then
                for _, model in pairs(fa:GetChildren()) do
                    if model:FindFirstChild("ProjectAlphaESP_Folder") then
                        local espFolder = model:FindFirstChild("ProjectAlphaESP_Folder")
                        local bgui = espFolder:FindFirstChild("ProjectAlphaNameESP")
                        local text = bgui and bgui:FindFirstChildWhichIsA("TextLabel")
                        local humanoid = model:FindFirstChildWhichIsA("Humanoid")
                        if text and humanoid then
                            text.Text = "[ALPHA] " .. model.Name .. " : " .. tostring(math.floor(humanoid.Health))
                        end
                    end
                end
            end
        end)
    else
        clearProjectDeltaESP()
        clearProjectBetaESP()
        clearProjectAlphaESP()
        if ProjectESPUpdate then
            ProjectESPUpdate:Disconnect()
            ProjectESPUpdate = nil
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        disableAllESPs()
    end
end)

local Noclipping = nil
MiscTab:AddToggle("Noclip", { Title = "Noclip", Default = false }):OnChanged(function(value)
    if value then
        Noclipping = RunService.Stepped:Connect(function()
            if plr.Character then
                for _, child in pairs(plr.Character:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                    end
                end
            end
        end)
    else
        if Noclipping then
            Noclipping:Disconnect()
            Noclipping = nil
        end
    end
end)

local HitCooldownConnection = nil
MiscTab:AddToggle("RmvHitCooldown", { Title = "Remove Hit Cooldown", Default = false }):OnChanged(function(value)
    if value then
        local function setup()
            local h = getHum()
            if not h then return end
            if HitCooldownConnection then
                HitCooldownConnection:Disconnect()
            end
            HitCooldownConnection = h:GetAttributeChangedSignal("HitCooldown"):Connect(function()
                local hu = getHum()
                if hu then
                    hu:SetAttribute("HitCooldown", false)
                end
            end)
        end
        setup()
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Options.RmvHitCooldown.Value then
                setup()
            end
        end)
    else
        if HitCooldownConnection then
            HitCooldownConnection:Disconnect()
            HitCooldownConnection = nil
        end
    end
end)

MiscTab:AddToggle("RmvFallDamage", { Title = "Remove Fall Damage", Default = false }):OnChanged(function(value)
    local function update()
        local c = plr.Character
        if not c then return end
        local falldamage = c:FindFirstChild("FallDamage")
        if falldamage then
            falldamage.Enabled = not value
        end
    end
    update()
    if value then
        plr.CharacterAdded:Connect(function()
            task.wait(0.3)
            if Options.RmvFallDamage.Value then
                update()
            end
        end)
    end
end)

MiscTab:AddButton({
    Title = "Visible Landmines",
    Callback = function()
        local mineField = workspace:FindFirstChild("Minefield")
        if mineField then
            for _, part in pairs(mineField:GetChildren()) do
                if part.Name == "Landmine" then
                    part.Transparency = 0
                end
            end
        end
    end
})

MiscTab:AddButton({
    Title = "Inf Stamina",
    Callback = function()
        local h = getHum()
        if h then
            h:SetAttribute("MaxStamina", math.huge)
            h:SetAttribute("Stamina", math.huge)
        end
    end
})

MiscTab:AddButton({
    Title = "Inf Bag",
    Callback = function()
        local h = getHum()
        if h then
            h:SetAttribute("BagSize", math.huge)
            h:SetAttribute("MaxBagSize", math.huge)
            h:SetAttribute("InventorySize", math.huge)
        end
    end
})

Fluent:Notify({
    Title = "Slow Hub",
    Content = "Loaded successfully! Press K to disable all ESPs",
    Duration = 4
})

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DirectHitUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -220)
MainFrame.Size = UDim2.new(0, 300, 0, 480)
MainFrame.Active = true
MainFrame.Visible = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
Title.Size = UDim2.new(1, 0, 0, 38)
Title.Font = Enum.Font.GothamBold
Title.Text = "DIRECT HIT  [R-SHIFT]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local WeaponList = {"AK-74M", "AS-VAL", "CS5", "L106", "M27", "M4A1", "Minigun"}
local SelectedWeapon = WeaponList[1]

local WeaponLabel = Instance.new("TextLabel")
WeaponLabel.Parent = MainFrame
WeaponLabel.BackgroundTransparency = 1
WeaponLabel.Position = UDim2.new(0.05, 0, 0.09, 0)
WeaponLabel.Size = UDim2.new(0.9, 0, 0, 18)
WeaponLabel.Font = Enum.Font.GothamMedium
WeaponLabel.Text = "WEAPON"
WeaponLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
WeaponLabel.TextSize = 10
WeaponLabel.TextXAlignment = Enum.TextXAlignment.Left

local WeaponScroll = Instance.new("ScrollingFrame")
WeaponScroll.Parent = MainFrame
WeaponScroll.Size = UDim2.new(0.9, 0, 0, 40)
WeaponScroll.Position = UDim2.new(0.05, 0, 0.14, 0)
WeaponScroll.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
WeaponScroll.BorderSizePixel = 0
WeaponScroll.CanvasSize = UDim2.new(2, 0, 0, 0)
WeaponScroll.ScrollBarThickness = 0

local WeaponCorner = Instance.new("UICorner")
WeaponCorner.CornerRadius = UDim.new(0, 6)
WeaponCorner.Parent = WeaponScroll

local WeaponLayout = Instance.new("UIListLayout")
WeaponLayout.Parent = WeaponScroll
WeaponLayout.FillDirection = Enum.FillDirection.Horizontal
WeaponLayout.Padding = UDim.new(0, 6)
WeaponLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local WeaponButtons = {}
for _, name in ipairs(WeaponList) do
    local b = Instance.new("TextButton")
    b.Parent = WeaponScroll
    b.Size = UDim2.new(0, 70, 0, 28)
    b.Text = name
    b.BackgroundColor3 = (name == SelectedWeapon) and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(35, 35, 40)
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 10
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = b

    b.MouseButton1Click:Connect(function()
        SelectedWeapon = name
        for _, btn in pairs(WeaponButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        end
        b.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    end)
    
    table.insert(WeaponButtons, b)
end

local AimMode = "Head"

local PartLabel = Instance.new("TextLabel")
PartLabel.Parent = MainFrame
PartLabel.BackgroundTransparency = 1
PartLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
PartLabel.Size = UDim2.new(0.9, 0, 0, 18)
PartLabel.Font = Enum.Font.GothamMedium
PartLabel.Text = "TARGET PART"
PartLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
PartLabel.TextSize = 10
PartLabel.TextXAlignment = Enum.TextXAlignment.Left

local PartFrame = Instance.new("Frame")
PartFrame.Parent = MainFrame
PartFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
PartFrame.Position = UDim2.new(0.05, 0, 0.27, 0)
PartFrame.Size = UDim2.new(0.9, 0, 0, 34)

local PartCorner = Instance.new("UICorner")
PartCorner.CornerRadius = UDim.new(0, 6)
PartCorner.Parent = PartFrame

local HeadButton = Instance.new("TextButton")
HeadButton.Parent = PartFrame
HeadButton.Size = UDim2.new(0.5, -2, 1, 0)
HeadButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
HeadButton.Text = "HEAD"
HeadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadButton.Font = Enum.Font.GothamBold
HeadButton.TextSize = 12

local HeadCorner = Instance.new("UICorner")
HeadCorner.CornerRadius = UDim.new(0, 6)
HeadCorner.Parent = HeadButton

local TorsoButton = Instance.new("TextButton")
TorsoButton.Parent = PartFrame
TorsoButton.Position = UDim2.new(0.5, 2, 0, 0)
TorsoButton.Size = UDim2.new(0.5, -2, 1, 0)
TorsoButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TorsoButton.Text = "TORSO"
TorsoButton.TextColor3 = Color3.fromRGB(200, 200, 200)
TorsoButton.Font = Enum.Font.GothamBold
TorsoButton.TextSize = 12

local TorsoCorner = Instance.new("UICorner")
TorsoCorner.CornerRadius = UDim.new(0, 6)
TorsoCorner.Parent = TorsoButton

HeadButton.MouseButton1Click:Connect(function()
    AimMode = "Head"
    HeadButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    HeadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TorsoButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TorsoButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

TorsoButton.MouseButton1Click:Connect(function()
    AimMode = "Torso"
    TorsoButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    TorsoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeadButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    HeadButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

local SearchBar = Instance.new("TextBox")
SearchBar.Parent = MainFrame
SearchBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SearchBar.Position = UDim2.new(0.05, 0, 0.34, 0)
SearchBar.Size = UDim2.new(0.9, 0, 0, 30)
SearchBar.Font = Enum.Font.Gotham
SearchBar.PlaceholderText = "Search player..."
SearchBar.Text = ""
SearchBar.TextColor3 = Color3.fromRGB(200, 200, 200)
SearchBar.TextSize = 12
SearchBar.ClearTextOnFocus = false

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBar

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = MainFrame
PlayerList.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
PlayerList.Position = UDim2.new(0.05, 0, 0.41, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0, 140)
PlayerList.ScrollBarThickness = 3
PlayerList.ScrollBarImageColor3 = Color3.fromRGB(0, 140, 255)
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.BorderSizePixel = 0

local PlayerListCorner = Instance.new("UICorner")
PlayerListCorner.CornerRadius = UDim.new(0, 6)
PlayerListCorner.Parent = PlayerList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerList
ListLayout.Padding = UDim.new(0, 4)

local FireButton = Instance.new("TextButton")
FireButton.Parent = MainFrame
FireButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
FireButton.Position = UDim2.new(0.05, 0, 0.74, 0)
FireButton.Size = UDim2.new(0.9, 0, 0, 55)
FireButton.Font = Enum.Font.GothamBold
FireButton.Text = "FIRE"
FireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FireButton.TextSize = 22

local FireCorner = Instance.new("UICorner")
FireCorner.CornerRadius = UDim.new(0, 8)
FireCorner.Parent = FireButton

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.865, 0)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 16)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Ready"
StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
StatusLabel.TextSize = 10
StatusLabel.TextXAlignment = Enum.TextXAlignment.Center

local Dragging, DragInput, DragStart, StartPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local TargetPlayer = nil

local function Populate()
    for _, child in ipairs(PlayerList:GetChildren()) do 
        if child:IsA("TextButton") then child:Destroy() end 
    end
    
    local playersTable = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playersTable, p)
        end
    end
    
    table.sort(playersTable, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)
    
    local filterText = SearchBar.Text:lower()
    
    for _, p in ipairs(playersTable) do
        if filterText == "" or string.find(p.Name:lower(), filterText, 1, true) then
            local b = Instance.new("TextButton")
            b.Parent = PlayerList
            b.Size = UDim2.new(1, -5, 0, 28)
            b.BackgroundColor3 = (TargetPlayer == p) and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(35, 35, 40)
            b.Text = "  " .. p.Name .. "  [" .. math.floor(p:DistanceFromCharacter(LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position or Vector3.new())) .. "m]"
            b.TextColor3 = Color3.fromRGB(220, 220, 220)
            b.Font = Enum.Font.Gotham
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.TextSize = 11
            
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 4)
            bc.Parent = b

            b.MouseButton1Click:Connect(function()
                TargetPlayer = p
                for _, v in ipairs(PlayerList:GetChildren()) do 
                    if v:IsA("TextButton") then 
                        v.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                    end 
                end
                b.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                StatusLabel.Text = "Target: " .. p.Name .. " (" .. AimMode .. ")"
                StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            end)
        end
    end
end

Populate()
Players.PlayerAdded:Connect(Populate)
Players.PlayerRemoving:Connect(Populate)
SearchBar:GetPropertyChangedSignal("Text"):Connect(Populate)

RunService.Heartbeat:Connect(function()
    if TargetPlayer and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local filterText = SearchBar.Text:lower()
        for _, b in ipairs(PlayerList:GetChildren()) do
            if b:IsA("TextButton") then
                local playerName = b.Text:match("^%s*(%S+)")
                if playerName then
                    local p = Players:FindFirstChild(playerName)
                    if p and p.Character and p.Character.PrimaryPart then
                        local dist = math.floor((p.Character.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude)
                        b.Text = "  " .. p.Name .. "  [" .. dist .. "m]"
                    end
                end
            end
        end
    end
end)

local function GetTargetPosition(targetPlayer)
    if not targetPlayer.Character then return nil end
    
    local targetPart = nil
    if AimMode == "Head" then
        targetPart = targetPlayer.Character:FindFirstChild("Head")
    else
        targetPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            or targetPlayer.Character:FindFirstChild("Torso")
            or targetPlayer.Character:FindFirstChild("UpperTorso")
    end
    
    if not targetPart then
        targetPart = targetPlayer.Character:FindFirstChild("Head")
            or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    
    if targetPart then
        return targetPart.Position
    end
    
    return nil
end

local function ExecuteFire()
    if not TargetPlayer then
        StatusLabel.Text = "No target selected!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    if not TargetPlayer.Character or not TargetPlayer.Character.Parent then
        StatusLabel.Text = "Target character not found!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local targetPos = GetTargetPosition(TargetPlayer)
    if not targetPos then
        StatusLabel.Text = "Could not find target part (" .. AimMode .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local tool = LocalPlayer.Backpack:FindFirstChild(SelectedWeapon) 
                or LocalPlayer.Character:FindFirstChild(SelectedWeapon)
    
    if not tool then
        StatusLabel.Text = "Weapon not found: " .. SelectedWeapon
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local fireEvent = tool:FindFirstChild("Fire")
    if not fireEvent then
        StatusLabel.Text = "No Fire event on " .. SelectedWeapon
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local success, errorMsg = pcall(function()
        fireEvent:FireServer(true, targetPos, (AimMode == "Head"), 12)
    end)
    
    if success then
        StatusLabel.Text = "Shot fired at " .. TargetPlayer.Name .. " (" .. AimMode .. ")"
        StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        StatusLabel.Text = "FireServer error: " .. tostring(errorMsg)
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

FireButton.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or 
        input.UserInputType == Enum.UserInputType.MouseButton1) then
        ExecuteFire()
    end
end)
