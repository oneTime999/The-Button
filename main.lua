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
local CombatTab = Window:CreateTab("Combat", "sword")

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

local function getChar()
    return plr.Character
end

local function getHRP()
    local c = getChar()
    if c then
        return c:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local Connections = {}
local function ToggleLoop(name, callback)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
    if callback then
        Connections[name] = RunService.RenderStepped:Connect(callback)
    end
end

local function SetAttr(name, value)
    local h = getHum()
    if h then
        h:SetAttribute(name, value)
    end
end

local function ClearAllLoops()
    for name, conn in pairs(Connections) do
        if conn then
            conn:Disconnect()
        end
        Connections[name] = nil
    end
end

local function ApplyAllActive()
    local h = getHum()
    if not h then return end

    if Rayfield.Flags["GodMode"].CurrentValue then
        h:SetAttribute("DamageReduction", 0)
        h:SetAttribute("Armor", 100)
        h:SetAttribute("FallDamageResistance", 100)
        h:SetAttribute("ExplosionResistance", 100)
        h:SetAttribute("Invulnerable", true)
    end

    if Rayfield.Flags["InfStaminaToggle"].CurrentValue then
        h:SetAttribute("Stamina", math.huge)
        h:SetAttribute("MaxStamina", math.huge)
        h:SetAttribute("CantSprint", false)
    end

    if Rayfield.Flags["SuperSpeed"].CurrentValue then
        h:SetAttribute("BaseWalkSpeed", 30)
        h:SetAttribute("CantSprint", false)
    end

    if Rayfield.Flags["InfInventory"].CurrentValue then
        h:SetAttribute("InventorySize", math.huge)
        h:SetAttribute("BagSize", math.huge)
        h:SetAttribute("MaxBagSize", math.huge)
        h:SetAttribute("CurrentWeight", 0)
    end

    if Rayfield.Flags["SuperDmg"].CurrentValue then
        h:SetAttribute("MeleeDamageMultiplier", 100)
        h:SetAttribute("HitCooldown", false)
        h:SetAttribute("MeleeDamageCooldown", false)
    end

    if Rayfield.Flags["AntiDebuff"].CurrentValue then
        h:SetAttribute("Immobile", false)
        h:SetAttribute("Stunned", false)
        h:SetAttribute("Ragdolled", false)
        h:SetAttribute("Downed", false)
        h:SetAttribute("Grabbed", false)
        h:SetAttribute("Carried", false)
        h:SetAttribute("Carrying", false)
        h:SetAttribute("CantEquip", false)
        h:SetAttribute("CantEmote", false)
        h:SetAttribute("CantShiftLock", false)
        h:SetAttribute("InstaDie", false)
        h:SetAttribute("CantCarry", false)
        h:SetAttribute("CantSprint", false)
    end

    if Rayfield.Flags["InfBlock"].CurrentValue then
        h:SetAttribute("BlockDurability", math.huge)
        h:SetAttribute("MaxBlockDurability", math.huge)
        h:SetAttribute("BlockPercent", 0)
    end

    if Rayfield.Flags["AutoRevive"].CurrentValue then
        h:SetAttribute("ReviveChance", 1)
        h:SetAttribute("ReviveTime", 0)
        h:SetAttribute("Downed", false)
        h:SetAttribute("BeingRevived", false)
    end

    if Rayfield.Flags["FastRegen"].CurrentValue then
        h:SetAttribute("RegenMultiplier", 100)
        h:SetAttribute("BaseMaxHealth", 999)
    end

    if Rayfield.Flags["AntiAim"].CurrentValue then
        h:SetAttribute("CanBeHit", false)
        h:SetAttribute("Invulnerable", true)
    end

    if Rayfield.Flags["NoRecoil"].CurrentValue then
        h:SetAttribute("MouseLock", false)
        h:SetAttribute("LockHeadHorizontal", false)
        h:SetAttribute("RotateOveride", false)
        h:SetAttribute("BodyToMouse", false)
    end

    if Rayfield.Flags["AlwaysCombat"].CurrentValue then
        h:SetAttribute("InCombat", true)
    end

    if Rayfield.Flags["NoPVP"].CurrentValue then
        h:SetAttribute("PVPException", true)
        h:SetAttribute("PlayerDamage", false)
    end

    if Rayfield.Flags["FullAmmo"].CurrentValue then
        h:SetAttribute("LightAmmo", 999)
        h:SetAttribute("RifleAmmo", 999)
        h:SetAttribute("ShotgunAmmo", 999)
    end

    if Rayfield.Flags["SuperArmor"].CurrentValue then
        h:SetAttribute("EquippedArmor", "Heavy")
        h:SetAttribute("Armor", 100)
    end

    if Rayfield.Flags["AntiGrab"].CurrentValue then
        h:SetAttribute("Grabbed", false)
        h:SetAttribute("Carried", false)
        h:SetAttribute("Carrying", false)
        h:SetAttribute("CantCarry", false)
    end

    if Rayfield.Flags["GodWalk"].CurrentValue then
        h:SetAttribute("BypassAntiFling", true)
        h:SetAttribute("Ragdolled", false)
        h:SetAttribute("Stunned", false)
    end

    if Rayfield.Flags["CursorFree"].CurrentValue then
        h:SetAttribute("CursorOveride", false)
        h:SetAttribute("MouseLock", false)
    end

    if Rayfield.Flags["TeamBypass"].CurrentValue then
        h:SetAttribute("Team", "None")
    end

    if Rayfield.Flags["TargetImmune"].CurrentValue then
        h:SetAttribute("Targeted", false)
    end

    if Rayfield.Flags["ForceShiftLock"].CurrentValue then
        h:SetAttribute("ForcedShiftLock", true)
        h:SetAttribute("CantShiftLock", false)
    end

    if Rayfield.Flags["HideGear"].CurrentValue then
        h:SetAttribute("HideHolsters", true)
    end

    if Rayfield.Flags["AutoBlock"].CurrentValue then
        h:SetAttribute("BlockDurability", math.huge)
        h:SetAttribute("MaxBlockDurability", math.huge)
        h:SetAttribute("BlockPercent", 0)
        h:SetAttribute("Blocking", true)
    end

    if Rayfield.Flags["AutoAttack"].CurrentValue then
        h:SetAttribute("MeleeDamageCooldown", false)
        h:SetAttribute("HitCooldown", false)
        h:SetAttribute("MeleeDamageMultiplier", 100)
    end

    if Rayfield.Flags["KillAura"].CurrentValue then
        h:SetAttribute("MeleeDamageCooldown", false)
        h:SetAttribute("HitCooldown", false)
    end
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

    local folder = obj:FindFirstChild("ESP_Folder")
    if folder then return end

    folder = Instance.new("Folder")
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

    local folder = player.Character:FindFirstChild("PlayerESP_Folder")
    if folder then return end

    folder = Instance.new("Folder")
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
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 1
    highlight.Adornee = player.Character
    highlight.Parent = folder
end

local playerESPUpdate = nil

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

local ItemESPConnection = workspace.ChildAdded:Connect(function(obj)
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
            local c = getChar()
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

StatsTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfStaminaToggle",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Super Speed",
    CurrentValue = false,
    Flag = "SuperSpeed",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Infinite Inventory",
    CurrentValue = false,
    Flag = "InfInventory",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Super Damage",
    CurrentValue = false,
    Flag = "SuperDmg",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Anti Debuffs",
    CurrentValue = false,
    Flag = "AntiDebuff",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Infinite Block",
    CurrentValue = false,
    Flag = "InfBlock",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Auto Revive",
    CurrentValue = false,
    Flag = "AutoRevive",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Fast Regen",
    CurrentValue = false,
    Flag = "FastRegen",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Anti Aim",
    CurrentValue = false,
    Flag = "AntiAim",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Always Combat",
    CurrentValue = false,
    Flag = "AlwaysCombat",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "No PVP Damage",
    CurrentValue = false,
    Flag = "NoPVP",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Full Ammo",
    CurrentValue = false,
    Flag = "FullAmmo",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Super Armor",
    CurrentValue = false,
    Flag = "SuperArmor",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Anti Grab",
    CurrentValue = false,
    Flag = "AntiGrab",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "God Walk",
    CurrentValue = false,
    Flag = "GodWalk",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Cursor Free",
    CurrentValue = false,
    Flag = "CursorFree",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Team Bypass",
    CurrentValue = false,
    Flag = "TeamBypass",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Target Immune",
    CurrentValue = false,
    Flag = "TargetImmune",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Force ShiftLock",
    CurrentValue = false,
    Flag = "ForceShiftLock",
    Callback = function(v) end
})

StatsTab:CreateToggle({
    Name = "Hide Gear",
    CurrentValue = false,
    Flag = "HideGear",
    Callback = function(v) end
})

CombatTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(v)
        if v then
            ToggleLoop("KillAura", function()
                local hrp = getHRP()
                if not hrp then return end
                for _, target in pairs(players:GetPlayers()) do
                    if target ~= plr and target.Character then
                        local th = target.Character:FindFirstChildWhichIsA("Humanoid")
                        local thrp = target.Character:FindFirstChild("HumanoidRootPart")
                        if th and thrp and th.Health > 0 then
                            local dist = (hrp.Position - thrp.Position).Magnitude
                            if dist < 12 then
                                local h = getHum()
                                if h then
                                    h:SetAttribute("MeleeDamageCooldown", false)
                                    h:SetAttribute("HitCooldown", false)
                                end
                            end
                        end
                    end
                end
            end)
        else
            ToggleLoop("KillAura", nil)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Auto Block",
    CurrentValue = false,
    Flag = "AutoBlock",
    Callback = function(v)
        if v then
            ToggleLoop("AutoBlock", function()
                local h = getHum()
                if h then
                    h:SetAttribute("BlockDurability", math.huge)
                    h:SetAttribute("MaxBlockDurability", math.huge)
                    h:SetAttribute("BlockPercent", 0)
                    h:SetAttribute("Blocking", true)
                end
            end)
        else
            ToggleLoop("AutoBlock", nil)
            SetAttr("Blocking", false)
        end
    end
})

CombatTab:CreateToggle({
    Name = "Auto Attack",
    CurrentValue = false,
    Flag = "AutoAttack",
    Callback = function(v)
        if v then
            ToggleLoop("AutoAttack", function()
                local h = getHum()
                if h then
                    h:SetAttribute("MeleeDamageCooldown", false)
                    h:SetAttribute("HitCooldown", false)
                    h:SetAttribute("MeleeDamageMultiplier", 100)
                end
            end)
        else
            ToggleLoop("AutoAttack", nil)
        end
    end
})

local ReachParts = {}
CombatTab:CreateToggle({
    Name = "Reach",
    CurrentValue = false,
    Flag = "Reach",
    Callback = function(v)
        if v then
            local c = getChar()
            if not c then return end
            local tool = c:FindFirstChildWhichIsA("Tool")
            if not tool then return end
            for _, part in pairs(tool:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(ReachParts, {part = part, originalSize = part.Size})
                    part.Size = Vector3.new(10, 10, 10)
                    part.Massless = true
                end
            end
        else
            for _, data in ipairs(ReachParts) do
                if data.part and data.part.Parent then
                    data.part.Size = data.originalSize
                end
            end
            table.clear(ReachParts)
        end
    end
})

CombatTab:CreateButton({
    Name = "One Shot",
    Callback = function()
        local h = getHum()
        if h then
            h:SetAttribute("MeleeDamageMultiplier", 999)
            h:SetAttribute("HitCooldown", false)
            h:SetAttribute("MeleeDamageCooldown", false)
        end
    end
})

CombatTab:CreateButton({
    Name = "Full Heal",
    Callback = function()
        local h = getHum()
        if h then
            h:SetAttribute("BaseMaxHealth", 999)
            h.Health = 999
        end
    end
})

CombatTab:CreateButton({
    Name = "Reset Stats",
    Callback = function()
        local h = getHum()
        if not h then return end
        h:SetAttribute("DamageReduction", 1)
        h:SetAttribute("Armor", 1)
        h:SetAttribute("FallDamageResistance", 1)
        h:SetAttribute("ExplosionResistance", 99.9)
        h:SetAttribute("Invulnerable", false)
        h:SetAttribute("Stamina", 100)
        h:SetAttribute("MaxStamina", 100)
        h:SetAttribute("BaseWalkSpeed", 14)
        h:SetAttribute("InventorySize", 3)
        h:SetAttribute("BagSize", 0)
        h:SetAttribute("MaxBagSize", 0)
        h:SetAttribute("MeleeDamageMultiplier", 1)
        h:SetAttribute("BlockDurability", 25)
        h:SetAttribute("MaxBlockDurability", 25)
        h:SetAttribute("BlockPercent", 0.4)
        h:SetAttribute("ReviveChance", 0)
        h:SetAttribute("ReviveTime", 5)
        h:SetAttribute("RegenMultiplier", 99)
        h:SetAttribute("BaseMaxHealth", 125)
        h:SetAttribute("CanBeHit", false)
        h:SetAttribute("InCombat", false)
        h:SetAttribute("PVPException", false)
        h:SetAttribute("PlayerDamage", false)
        h:SetAttribute("LightAmmo", 0)
        h:SetAttribute("RifleAmmo", 0)
        h:SetAttribute("ShotgunAmmo", 0)
        h:SetAttribute("EquippedArmor", "None")
    end
})

RunService.RenderStepped:Connect(ApplyAllActive)

plr.CharacterAdded:Connect(function(newChar)
    task.wait(0.3)
    ApplyAllActive()
end)

Rayfield:Notify({
    Title = "Slow Hub",
    Content = "Loaded successfully!",
    Duration = 4,
    Image = 4483362458,
})
