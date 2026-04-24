local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ManualFireUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Active = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "Manual Fire"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local WeaponInput = Instance.new("TextBox")
WeaponInput.Parent = MainFrame
WeaponInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
WeaponInput.BorderSizePixel = 0
WeaponInput.Position = UDim2.new(0.05, 0, 0.13, 0)
WeaponInput.Size = UDim2.new(0.9, 0, 0, 30)
WeaponInput.Font = Enum.Font.Gotham
WeaponInput.Text = "AK-74M"
WeaponInput.PlaceholderText = "Weapon Name..."
WeaponInput.TextColor3 = Color3.fromRGB(255, 255, 255)
WeaponInput.TextSize = 14

local RefreshButton = Instance.new("TextButton")
RefreshButton.Parent = MainFrame
RefreshButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
RefreshButton.BorderSizePixel = 0
RefreshButton.Position = UDim2.new(0.05, 0, 0.25, 0)
RefreshButton.Size = UDim2.new(0.9, 0, 0, 30)
RefreshButton.Font = Enum.Font.Gotham
RefreshButton.Text = "Refresh Players"
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshButton.TextSize = 13

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Parent = MainFrame
PlayerList.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
PlayerList.BorderSizePixel = 0
PlayerList.Position = UDim2.new(0.05, 0, 0.38, 0)
PlayerList.Size = UDim2.new(0.9, 0, 0, 130)
PlayerList.ScrollBarThickness = 3
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerList
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

local FireButton = Instance.new("TextButton")
FireButton.Parent = MainFrame
FireButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FireButton.BorderSizePixel = 0
FireButton.Position = UDim2.new(0.05, 0, 0.83, 0)
FireButton.Size = UDim2.new(0.9, 0, 0, 45)
FireButton.Font = Enum.Font.GothamBold
FireButton.Text = "FIRE"
FireButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FireButton.TextSize = 20

local Dragging, DragInput, DragStart, StartPos
Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)

local TargetPlayer = nil

local function PopulateList()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerBtn = Instance.new("TextButton")
            PlayerBtn.Parent = PlayerList
            PlayerBtn.Size = UDim2.new(1, 0, 0, 25)
            PlayerBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerBtn.Font = Enum.Font.Gotham
            PlayerBtn.TextSize = 12
            PlayerBtn.Text = player.Name
            PlayerBtn.BorderSizePixel = 0
            
            PlayerBtn.MouseButton1Click:Connect(function()
                TargetPlayer = player
                for _, btn in ipairs(PlayerList:GetChildren()) do
                    if btn:IsA("TextButton") then btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end
                end
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end)
        end
    end
end

PopulateList()
RefreshButton.MouseButton1Click:Connect(PopulateList)

FireButton.MouseButton1Click:Connect(function()
    if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("Head") then
        local WeaponName = WeaponInput.Text
        local Weapon = LocalPlayer.Backpack:FindFirstChild(WeaponName) or LocalPlayer.Character:FindFirstChild(WeaponName)
        
        if Weapon and Weapon:FindFirstChild("Fire") then
            local args = {
                [1] = true,
                [2] = TargetPlayer.Character.Head.Position,
                [3] = false,
                [4] = 12,
            }
            Weapon.Fire:FireServer(unpack(args))
        end
    end
end)


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Slow Hub",
    Icon = 0,
    LoadingTitle = "Slow Hub",
    LoadingSubtitle = "by oneTime.999",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
})

local ESPTab = Window:CreateTab("ESP", "eye")
local MiscTab = Window:CreateTab("Misc", "settings")

local players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

ESPTab:CreateToggle({
    Name = "Items ESP",
    CurrentValue = false,
    Flag = "ItemESP",
    Callback = function(value)
        if value then
            for _, item in pairs(workspace:GetChildren()) do
                createESP(item)
            end
            _G.ItemESPEnabled = true
        else
            _G.ItemESPEnabled = false
            clearESP()
        end
    end
})

workspace.ChildAdded:Connect(function(obj)
    if _G.ItemESPEnabled then
        createESP(obj)
    end
end)

ESPTab:CreateToggle({
    Name = "Players ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(value)
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
    end
})

ESPTab:CreateToggle({
    Name = "Zombies ESP",
    CurrentValue = false,
    Flag = "ZombieESP",
    Callback = function(value)
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
    end
})

ESPTab:CreateToggle({
    Name = "Project ESP",
    CurrentValue = false,
    Flag = "ProjectESP",
    Callback = function(value)
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
    end
})

local Noclipping = nil
MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(value)
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
    end
})

local HitCooldownConnection = nil
MiscTab:CreateToggle({
    Name = "Remove Hit Cooldown",
    CurrentValue = false,
    Flag = "RmvHitCooldown",
    Callback = function(value)
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
                if Rayfield.Flags["RmvHitCooldown"].CurrentValue then
                    setup()
                end
            end)
        else
            if HitCooldownConnection then
                HitCooldownConnection:Disconnect()
                HitCooldownConnection = nil
            end
        end
    end
})

MiscTab:CreateToggle({
    Name = "Remove Fall Damage",
    CurrentValue = false,
    Flag = "RmvFallDamage",
    Callback = function(value)
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
                if Rayfield.Flags["RmvFallDamage"].CurrentValue then
                    update()
                end
            end)
        end
    end
})

MiscTab:CreateButton({
    Name = "Visible Landmines",
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

MiscTab:CreateButton({
    Name = "Inf Stamina",
    Callback = function()
        local h = getHum()
        if h then
            h:SetAttribute("MaxStamina", math.huge)
            h:SetAttribute("Stamina", math.huge)
        end
    end
})

MiscTab:CreateButton({
    Name = "Inf Bag",
    Callback = function()
        local h = getHum()
        if h then
            h:SetAttribute("BagSize", math.huge)
            h:SetAttribute("MaxBagSize", math.huge)
            h:SetAttribute("InventorySize", math.huge)
        end
    end
})

Rayfield:Notify({
    Title = "Slow Hub",
    Content = "Loaded successfully!",
    Duration = 4,
    Image = 4483362458,
})
