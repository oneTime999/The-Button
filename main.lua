local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Slow Hub",
    Icon = 0,
    LoadingTitle = "Slow Hub",
    LoadingSubtitle = "by Slow Hub Team",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
})

local ESPTab = Window:CreateTab("Esp", "Eye")
local AimTab = Window:CreateTab("Aim", "Crosshair")
local MiscTab = Window:CreateTab("Misc", "Settings")

local players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char and char:FindFirstChildWhichIsA("Humanoid")

local function clearESP()
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == "ESP_Folder" then
            item:Destroy()
        end
    end
end

local function createESP(obj)
    local toolType = obj:GetAttribute("ToolType")
    if toolType and obj then
        local folder = obj:FindFirstChild("ESP_Folder")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "ESP_Folder"
            folder.Parent = obj

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
            text.TextColor3 = Color3.fromRGB(255, 0, 0)
            text.TextStrokeTransparency = 0
            text.Text = obj.Name .. " : " .. tostring(toolType)
            text.Parent = bgui

            local highlight = Instance.new("Highlight")
            highlight.Name = "ToolHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 1
            highlight.FillTransparency = 0.7
            highlight.Adornee = obj
            highlight.Parent = folder
        end
    end
end

local playerESPUpdate = nil

local function createPlayerESP(player)
    if not (player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")) then return end
    local folder = player.Character:FindFirstChild("PlayerESP_Folder")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "PlayerESP_Folder"
        folder.Parent = player.Character

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
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 1
        highlight.Adornee = player.Character
        highlight.Parent = folder
    end
end

local function clearPlayerESP()
    for _, esp in pairs(workspace:GetDescendants()) do
        if esp.Name == "PlayerESP_Folder" then
            esp:Destroy()
        end
    end
end

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
                end
            end
            if not playerESPUpdate then
                playerESPUpdate = RunService.Heartbeat:Connect(function()
                    for _, player in pairs(players:GetPlayers()) do
                        if player ~= plr and player.Character then
                            local folder = player.Character:FindFirstChild("PlayerESP_Folder")
                            if folder then
                                local bgui = folder:FindFirstChild("NameESP")
                                if bgui then
                                    local text = bgui:FindFirstChildWhichIsA("TextLabel")
                                    local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
                                    if text and humanoid then
                                        text.Text = player.Name .. " : " .. tostring(math.floor(humanoid.Health))
                                        if player:GetAttribute("Ghost") then
                                            text.TextColor3 = Color3.fromRGB(0, 255, 255)
                                        end
                                    end
                                end
                            else
                                createPlayerESP(player)
                            end
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

local aimTarget = nil
local aimEnabled = false
local aimConnection = nil
local originalCameraType = camera.CameraType
local originalCameraSubject = camera.CameraSubject

local function getPlayerList()
    local list = {}
    for _, p in pairs(players:GetPlayers()) do
        if p ~= plr then
            table.insert(list, p.Name)
        end
    end
    if #list == 0 then
        table.insert(list, "No players")
    end
    return list
end

local playerList = getPlayerList()

local AimDropdown = AimTab:CreateDropdown({
    Name = "Select Player",
    Options = playerList,
    CurrentOption = playerList[1],
    Flag = "AimTarget",
    Callback = function(value)
        aimTarget = value
    end
})

aimTarget = playerList[1]

players.PlayerAdded:Connect(function()
    local updated = getPlayerList()
    AimDropdown:Refresh(updated, updated[1])
end)

players.PlayerRemoving:Connect(function()
    local updated = getPlayerList()
    AimDropdown:Refresh(updated, updated[1])
end)

AimTab:CreateToggle({
    Name = "Camera Lock (Head)",
    CurrentValue = false,
    Flag = "AimLock",
    Callback = function(value)
        aimEnabled = value
        if value then
            originalCameraType = camera.CameraType
            originalCameraSubject = camera.CameraSubject
            camera.CameraType = Enum.CameraType.Scriptable

            aimConnection = RunService.RenderStepped:Connect(function()
                if not aimEnabled then return end
                local target = players:FindFirstChild(aimTarget)
                if target and target.Character then
                    local head = target.Character:FindFirstChild("Head")
                    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
                    if head and rootPart then
                        local direction = (head.Position - rootPart.Position).Unit
                        camera.CFrame = CFrame.new(rootPart.Position + Vector3.new(0, 1.5, 0), head.Position)
                    end
                end
            end)
        else
            if aimConnection then
                aimConnection:Disconnect()
                aimConnection = nil
            end
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = plr.Character and plr.Character:FindFirstChildWhichIsA("Humanoid")
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

MiscTab:CreateToggle({
    Name = "Remove Hit Cooldown",
    CurrentValue = false,
    Flag = "RmvHitCooldown",
    Callback = function(value)
        if value then
            hum:GetAttributeChangedSignal("HitCooldown"):Connect(function()
                hum:SetAttribute("HitCooldown", false)
            end)
        end
    end
})

MiscTab:CreateToggle({
    Name = "Remove Fall Damage",
    CurrentValue = false,
    Flag = "RmvFallDamage",
    Callback = function(value)
        local falldamage = char:FindFirstChild("FallDamage")
        if falldamage then
            falldamage.Enabled = not value
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
        hum:SetAttribute("MaxStamina", math.huge)
        hum:SetAttribute("Stamina", math.huge)
    end
})

Rayfield:Notify({
    Title = "Slow Hub",
    Content = "Loaded successfully!",
    Duration = 4,
    Image = 4483362458,
})
