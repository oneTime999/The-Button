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
local StatsTab = Window:CreateTab("Stats", "shield")

local players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char and char:FindFirstChildWhichIsA("Humanoid")

local function getHum()
	local c = plr.Character
	if c then
		return c:FindFirstChildWhichIsA("Humanoid")
	end
	return nil
end

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

MiscTab:CreateButton({
	Name = "Inf Bag",
	Callback = function()
		hum:SetAttribute("BagSize", math.huge)
		hum:SetAttribute("MaxBagSize", math.huge)
		hum:SetAttribute("InventorySize", math.huge)
	end
})

local StatsConnections = {}

local function SetAttr(name, value)
	local h = getHum()
	if h then
		h:SetAttribute(name, value)
	end
end

local function ToggleLoop(name, callback)
	if StatsConnections[name] then
		StatsConnections[name]:Disconnect()
		StatsConnections[name] = nil
	end
	if callback then
		StatsConnections[name] = RunService.Heartbeat:Connect(callback)
	end
end

StatsTab:CreateToggle({
	Name = "God Mode",
	CurrentValue = false,
	Flag = "GodMode",
	Callback = function(v)
		if v then
			ToggleLoop("GodMode", function()
				SetAttr("DamageReduction", 0)
				SetAttr("Armor", 100)
				SetAttr("FallDamageResistance", 100)
				SetAttr("ExplosionResistance", 100)
				SetAttr("Invulnerable", true)
			end)
		else
			ToggleLoop("GodMode", nil)
			SetAttr("DamageReduction", 1)
			SetAttr("Armor", 1)
			SetAttr("FallDamageResistance", 1)
			SetAttr("ExplosionResistance", 99.9)
			SetAttr("Invulnerable", false)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Infinite Stamina",
	CurrentValue = false,
	Flag = "InfStaminaToggle",
	Callback = function(v)
		if v then
			ToggleLoop("InfStamina", function()
				SetAttr("Stamina", math.huge)
				SetAttr("MaxStamina", math.huge)
				SetAttr("CantSprint", false)
			end)
		else
			ToggleLoop("InfStamina", nil)
			SetAttr("Stamina", 100)
			SetAttr("MaxStamina", 100)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Super Speed",
	CurrentValue = false,
	Flag = "SuperSpeed",
	Callback = function(v)
		if v then
			ToggleLoop("SuperSpeed", function()
				SetAttr("BaseWalkSpeed", 22)
				SetAttr("CantSprint", false)
			end)
		else
			ToggleLoop("SuperSpeed", nil)
			SetAttr("BaseWalkSpeed", 14)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Infinite Inventory",
	CurrentValue = false,
	Flag = "InfInventory",
	Callback = function(v)
		if v then
			ToggleLoop("InfInventory", function()
				SetAttr("InventorySize", math.huge)
				SetAttr("BagSize", math.huge)
				SetAttr("MaxBagSize", math.huge)
				SetAttr("CurrentWeight", 0)
			end)
		else
			ToggleLoop("InfInventory", nil)
			SetAttr("InventorySize", 3)
			SetAttr("BagSize", 0)
			SetAttr("MaxBagSize", 0)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Super Damage",
	CurrentValue = false,
	Flag = "SuperDmg",
	Callback = function(v)
		if v then
			ToggleLoop("SuperDmg", function()
				SetAttr("MeleeDamageMultiplier", 50)
				SetAttr("HitCooldown", false)
				SetAttr("MeleeDamageCooldown", false)
			end)
		else
			ToggleLoop("SuperDmg", nil)
			SetAttr("MeleeDamageMultiplier", 1)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Anti Debuffs",
	CurrentValue = false,
	Flag = "AntiDebuff",
	Callback = function(v)
		if v then
			ToggleLoop("AntiDebuff", function()
				SetAttr("Immobile", false)
				SetAttr("Stunned", false)
				SetAttr("Ragdolled", false)
				SetAttr("Downed", false)
				SetAttr("Grabbed", false)
				SetAttr("Carried", false)
				SetAttr("Carrying", false)
				SetAttr("CantEquip", false)
				SetAttr("CantEmote", false)
				SetAttr("CantShiftLock", false)
				SetAttr("InstaDie", false)
			end)
		else
			ToggleLoop("AntiDebuff", nil)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Infinite Block",
	CurrentValue = false,
	Flag = "InfBlock",
	Callback = function(v)
		if v then
			ToggleLoop("InfBlock", function()
				SetAttr("BlockDurability", math.huge)
				SetAttr("MaxBlockDurability", math.huge)
				SetAttr("BlockPercent", 0)
				SetAttr("Blocking", false)
			end)
		else
			ToggleLoop("InfBlock", nil)
			SetAttr("BlockDurability", 25)
			SetAttr("MaxBlockDurability", 25)
			SetAttr("BlockPercent", 0.4)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Auto Revive",
	CurrentValue = false,
	Flag = "AutoRevive",
	Callback = function(v)
		if v then
			ToggleLoop("AutoRevive", function()
				SetAttr("ReviveChance", 1)
				SetAttr("ReviveTime", 0)
				SetAttr("Downed", false)
				SetAttr("BeingRevived", false)
			end)
		else
			ToggleLoop("AutoRevive", nil)
			SetAttr("ReviveChance", 0)
			SetAttr("ReviveTime", 5)
		end
	end
})

StatsTab:CreateToggle({
	Name = "Fast Regen",
	CurrentValue = false,
	Flag = "FastRegen",
	Callback = function(v)
		if v then
			ToggleLoop("FastRegen", function()
				SetAttr("RegenMultiplier", 100)
				SetAttr("BaseMaxHealth", 999)
			end)
		else
			ToggleLoop("FastRegen", nil)
			SetAttr("RegenMultiplier", 99)
			SetAttr("BaseMaxHealth", 125)
		end
	end
})

plr.CharacterAdded:Connect(function(newChar)
	char = newChar
	hum = newChar:WaitForChild("Humanoid")
	task.wait(0.5)
	if Rayfield.Flags["GodMode"].CurrentValue then
		SetAttr("DamageReduction", 0)
		SetAttr("Armor", 100)
		SetAttr("FallDamageResistance", 100)
		SetAttr("ExplosionResistance", 100)
		SetAttr("Invulnerable", true)
	end
	if Rayfield.Flags["InfStaminaToggle"].CurrentValue then
		SetAttr("Stamina", math.huge)
		SetAttr("MaxStamina", math.huge)
	end
	if Rayfield.Flags["SuperSpeed"].CurrentValue then
		SetAttr("BaseWalkSpeed", 22)
	end
	if Rayfield.Flags["InfInventory"].CurrentValue then
		SetAttr("InventorySize", math.huge)
		SetAttr("BagSize", math.huge)
		SetAttr("MaxBagSize", math.huge)
	end
	if Rayfield.Flags["SuperDmg"].CurrentValue then
		SetAttr("MeleeDamageMultiplier", 50)
	end
	if Rayfield.Flags["InfBlock"].CurrentValue then
		SetAttr("BlockDurability", math.huge)
		SetAttr("MaxBlockDurability", math.huge)
		SetAttr("BlockPercent", 0)
	end
	if Rayfield.Flags["AutoRevive"].CurrentValue then
		SetAttr("ReviveChance", 1)
		SetAttr("ReviveTime", 0)
	end
	if Rayfield.Flags["FastRegen"].CurrentValue then
		SetAttr("RegenMultiplier", 100)
		SetAttr("BaseMaxHealth", 999)
	end
end)

Rayfield:Notify({
	Title = "Slow Hub",
	Content = "Loaded successfully!",
	Duration = 4,
	Image = 4483362458,
})
