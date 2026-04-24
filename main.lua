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
local CombatTab = Window:CreateTab("Combat", "crosshair")

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

local SelectedTarget = nil
local FireLoop = nil

local function getPlayerList()
   local list = {}
   for _, player in pairs(players:GetPlayers()) do
       if player ~= plr then
           table.insert(list, player.Name)
       end
   end
   return list
end

CombatTab:CreateDropdown({
   Name = "Select Target",
   Options = getPlayerList(),
   CurrentOption = nil,
   Flag = "TargetDropdown",
   Callback = function(selected)
       SelectedTarget = players:FindFirstChild(selected)
   end
})

CombatTab:CreateButton({
   Name = "Refresh Players",
   Callback = function()
       local dropdown = Rayfield.Flags["TargetDropdown"]
       if dropdown then
           dropdown:SetOptions(getPlayerList())
       end
   end
})

CombatTab:CreateButton({
   Name = "Fire",
   Callback = function()
       if not SelectedTarget then
           Rayfield:Notify({
               Title = "Error",
               Content = "Select a target first!",
               Duration = 3,
               Image = 4483362458,
           })
           return
       end

       if FireLoop then
           FireLoop:Disconnect()
           FireLoop = nil
       end

       FireLoop = RunService.Heartbeat:Connect(function()
           if not SelectedTarget or not SelectedTarget.Character then return end

           local head = SelectedTarget.Character:FindFirstChild("Head")
           if not head then return end

           local backpack = plr:FindFirstChild("Backpack")
           if not backpack then return end

           local gun = backpack:FindFirstChild("AK-74M")
           if not gun then
               gun = plr.Character and plr.Character:FindFirstChild("AK-74M")
           end
           if not gun then return end

           local fireRemote = gun:FindFirstChild("Fire")
           if not fireRemote then return end

           local args = {
               [1] = true,
               [2] = head.Position,
               [3] = false,
               [4] = 12,
           }

           fireRemote:FireServer(unpack(args))
       end)

       Rayfield:Notify({
           Title = "Fire",
           Content = "Firing at " .. SelectedTarget.Name,
           Duration = 3,
           Image = 4483362458,
       })
   end
})

CombatTab:CreateButton({
   Name = "Stop Fire",
   Callback = function()
       if FireLoop then
           FireLoop:Disconnect()
           FireLoop = nil
       end
   end
})

Rayfield:Notify({
   Title = "Slow Hub",
   Content = "Loaded successfully!",
   Duration = 4,
   Image = 4483362458,
})
