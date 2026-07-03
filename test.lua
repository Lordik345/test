-- =======================================================================
-- LORDIKHHH HUB | MULTI-GAME (MM2 & FISCH) | ULTIMATE VERSION
-- =======================================================================

local CorrectKey = "Lordikhhh"
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lordikhhh Hub | MM2 & Fisch",
   LoadingTitle = "Загрузка Lordikhhh Hub...",
   LoadingSubtitle = "by Lordikhhh",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true, 
   KeySettings = {
      Title = "Ключ-Система | Lordikhhh",
      Subtitle = "Введите ключ доступа",
      Note = "Правильный ключ: Lordikhhh",
      FileName = "LordikhhhKeyConfig",
      SaveKey = true, 
      Key = {CorrectKey}
   }
})

-- Сервисы и переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Общие переменные
local EspEnabled = false
local EspAllEnabled = false
local AutoFarmEnabled = false
local FlyEnabled = false
local SilentAimEnabled = false
local NoclipEnabled = false
local FlySpeed = 50
local FlyConnection = nil

-- Переменные для FISCH
local AutoFishEnabled = false
local WalkOnWaterEnabled = false
local WaterPlatform = nil

-- =======================================================================
-- ОБЩИЕ ФУНКЦИИ И MM2 ЛОГИКА
-- =======================================================================

local function GetPlayerRole(player)
    if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        return "Sheriff"
    else
        return "Innocent"
    end
end

local function GetDroppedGun()
    for _, v in pairs(Workspace:GetDescendants()) do
        if (v.Name == "GunDrop" or v.Name == "Gun") and not v:IsDescendantOf(Players) then
            return v
        end
    end
    return nil
end

local function GetClosestTarget()
    local ClosestPlayer = nil
    local MaxDistance = 1000
    local MousePos = UserInputService:GetMouseLocation()
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            local ScreenPos, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(Player.Character.Head.Position)
            if OnScreen then
                local Distance = (Vector2.new(MousePos.X, MousePos.Y) - Vector2.new(ScreenPos.X, ScreenPos.Y)).Magnitude
                if Distance < MaxDistance then
                    MaxDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end
    return ClosestPlayer
end

-- Silent Aim Hook
local oldFireServer; oldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if SilentAimEnabled and method == "FireServer" and (self.Name == "ShootGun" or self.Name == "Shoot") then
        local Target = GetClosestTarget()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            args[1] = Target.Character.Head.Position
            return oldFireServer(self, unpack(args))
        end
    end
    return oldFireServer(self, ...)
end)

-- Fly logic
local function ToggleFly(enabled)
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if not RootPart or not Humanoid then return end

    if enabled then
        if FlyConnection then FlyConnection:Disconnect() end
        local BV = Instance.new("BodyVelocity", RootPart); BV.Name = "FlightVelocity"; BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        local BG = Instance.new("BodyGyro", RootPart); BG.Name = "FlightGyro"; BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); BG.P = 2e4
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled then return end
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            local Camera = Workspace.CurrentCamera
            local MoveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Camera.CFrame.RightVector end
            RootPart.FlightVelocity.Velocity = MoveDirection * FlySpeed
            RootPart.FlightGyro.CFrame = Camera.CFrame
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() end
        if RootPart:FindFirstChild("FlightVelocity") then RootPart.FlightVelocity:Destroy() end
        if RootPart:FindFirstChild("FlightGyro") then RootPart.FlightGyro:Destroy() end
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- =======================================================================
-- ЛОГИКА ДЛЯ ИГРЫ FISCH
-- =======================================================================

-- Логика хождения по воде
RunService.Heartbeat:Connect(function()
    if WalkOnWaterEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if not WaterPlatform or not WaterPlatform.Parent then
            WaterPlatform = Instance.new("Part")
            WaterPlatform.Name = "WaterWalkPlatform"
            WaterPlatform.Size = Vector3.new(100, 1, 100)
            WaterPlatform.Anchored = true
            WaterPlatform.Transparency = 0.8 -- Слегка видимая плита под ногами
            WaterPlatform.Color = Color3.fromRGB(0, 255, 255)
            WaterPlatform.Parent = Workspace
        end
        -- Держим платформу чуть ниже уровня океана (обычно Y = 0 или около того в Fisch)
        local rootPos = LocalPlayer.Character.HumanoidRootPart.Position
        WaterPlatform.CFrame = CFrame.new(rootPos.X, 1.5, rootPos.Z) -- Настройка высоты подстроена под уровень воды
    else
        if WaterPlatform then
            WaterPlatform:Destroy()
            WaterPlatform = nil
        end
    end
end)

-- Авто-Рыбалка цикл
spawn(function()
    while wait(1) do
        if AutoFishEnabled and LocalPlayer.Character then
            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if tool and tool: some_validation_or_name_check_here -- Замените на имя вашей удочки, если нужно
               -- Логика отправки клика/события для заброса удочки
               -- В Fisch обычно используется RemoteEvent или активация Tool:Activate()
               tool:Activate()
            end
        end
    end
end)

-- Ноуклип и ферма MM2
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

spawn(function()
    while wait(0.5) do
        if AutoFarmEnabled then
            local container = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
            if container then
                for _, coin in pairs(container:GetChildren()) do
                    if coin:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                        wait(0.1)
                    end
                end
            end
        end
    end
end)

-- =======================================================================
-- МЕНЮ И ВКЛАДКИ
-- =======================================================================

-- Вкладка Fisch (Рыбалка)
local FischTab = Window:CreateTab("Fisch (Рыбалка)", 4483362458)

FischTab:CreateToggle({
    Name = "Авто-заброс удочки",
    Callback = function(v) AutoFishEnabled = v end
})

FischTab:CreateToggle({
    Name = "Ходьба по воде",
    Callback = function(v) WalkOnWaterEnabled = v end
})

FischTab:CreateSlider({
    Name = "Скорость ходьбы (WalkSpeed)",
    Range = {16, 150},
    CurrentValue = 16,
    Callback = function(v)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

-- Телепорты по островам Fisch
FischTab:CreateButton({Name = "ТП: Moosewood (Спавн)", Callback = function() 
    if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(383, 16, 243) end 
end})

FischTab:CreateButton({Name = "ТП: Roselit Bay", Callback = function() 
    if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1693, 15, 663) end 
end})

FischTab:CreateButton({Name = "ТП: Terrapin Island", Callback = function() 
    if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-180, 16, 1945) end 
end})

FischTab:CreateButton({Name = "ТП: Snowcap Island", Callback = function() 
    if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2643, 137, 2410) end 
end})

FischTab:CreateButton({Name = "ТП: Sunken Ship", Callback = function() 
    if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3044, -15, 2307) end 
end})


-- Вкладки MM2
local VisualsTab = Window:CreateTab("MM2: Визуалы", 4483362458)
VisualsTab:CreateToggle({Name = "ESP (Убийца/Шериф)", Callback = function(v) EspEnabled = v end})
VisualsTab:CreateToggle({Name = "ESP на ВСЕХ игроков", Callback = function(v) EspAllEnabled = v end})

local CombatTab = Window:CreateTab("MM2: Бой", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim", Callback = function(v) SilentAimEnabled = v end})

local TeleportTab = Window:CreateTab("MM2: Телепорты", 4483362458)
TeleportTab:CreateButton({Name = "ТП к Убийце", Callback = function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and GetPlayerRole(pl) == "Murderer" and pl.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
end})
TeleportTab:CreateButton({Name = "ТП к Шерифу", Callback = function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and GetPlayerRole(pl) == "Sheriff" and pl.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
end})

local FarmTab = Window:CreateTab("MM2: Фарм и Полет", 4483362458)
FarmTab:CreateToggle({Name = "Авто-фарм монет", Callback = function(v) AutoFarmEnabled = v end})
FarmTab:CreateToggle({Name = "Полет (Fly WASD)", Callback = function(v) FlyEnabled = v; ToggleFly(v) end})
FarmTab:CreateSlider({Name = "Скорость полета", Range = {10, 200}, CurrentValue = 50, Callback = function(v) FlySpeed = v end})

local MiscTab = Window:CreateTab("Разное", 4483362458)
MiscTab:CreateToggle({Name = "Noclip (Сквозь стены)", Callback = function(v) NoclipEnabled = v end})

-- ESP Loop
RunService.RenderStepped:Connect(function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local role = GetPlayerRole(pl)
            local hl = pl.Character:FindFirstChild("Highlight")
            local shouldHighlight = false
            local highlightColor = Color3.fromRGB(255, 255, 255)
            
            if EspAllEnabled then
                shouldHighlight = true
                highlightColor = (role == "Murderer" and Color3.fromRGB(255,0,0) or role == "Sheriff" and Color3.fromRGB(0,0,255) or Color3.fromRGB(0,255,0))
            elseif EspEnabled and (role == "Murderer" or role == "Sheriff") then
                shouldHighlight = true
                highlightColor = (role == "Murderer" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 255))
            end
            
            if shouldHighlight then
                if not hl then hl = Instance.new("Highlight", pl.Character) end
                hl.FillColor = highlightColor
            elseif hl then hl:Destroy() end
        end
    end
end)

Rayfield:Notify({Title = "Успешно", Content = "Lordikhhh Hub готов к работе в MM2 и Fisch!", Duration = 3})
