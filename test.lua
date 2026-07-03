-- =======================================================================
-- LORDIKHHH HUB | MURDER MYSTERY 2 | MAXED VERSION (ESP ALL & TP SHERIFF)
-- =======================================================================

local CorrectKey = "Lordikhhh"
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lordikhhh Hub | MM2",
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

local EspEnabled = false
local EspAllEnabled = false -- Переменная для ESP на всех игроков
local CoinEspEnabled = false
local AutoFarmEnabled = false
local FlyEnabled = false
local SilentAimEnabled = false
local NoclipEnabled = false
local FlySpeed = 50
local FlyConnection = nil

-- =======================================================================
-- ФУНКЦИИ
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

-- Стабильный Silent Aim (Hook)
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

-- ИСПРАВЛЕННЫЙ И ОТЗЫВЧИВЫЙ FLY НА СИСТЕМЕ ВЕКТОРОВ WASD
local function ToggleFly(enabled)
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if not RootPart or not Humanoid then return end

    if enabled then
        if FlyConnection then FlyConnection:Disconnect() end
        
        local BV = RootPart:FindFirstChild("FlightVelocity") or Instance.new("BodyVelocity")
        BV.Name = "FlightVelocity"
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = RootPart

        local BG = RootPart:FindFirstChild("FlightGyro") or Instance.new("BodyGyro")
        BG.Name = "FlightGyro"
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.P = 2e4
        BG.D = 100
        BG.CFrame = RootPart.CFrame
        BG.Parent = RootPart

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled or not RootPart or not RootPart:FindFirstChild("FlightVelocity") then 
                if FlyConnection then FlyConnection:Disconnect() end
                return 
            end
            
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

-- Цикл для обработки Ноуклипа (Сквозь стены)
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- AutoFarm Loop
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
-- МЕНЮ
-- =======================================================================

local VisualsTab = Window:CreateTab("Визуалы", 4483362458)
VisualsTab:CreateToggle({Name = "ESP (Только Убийца/Шериф)", Callback = function(v) EspEnabled = v end})
VisualsTab:CreateToggle({Name = "ESP на ВСЕХ игроков", Callback = function(v) EspAllEnabled = v end})

local CombatTab = Window:CreateTab("Бой", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim (Невидимый аим)", Callback = function(v) SilentAimEnabled = v end})

local TeleportTab = Window:CreateTab("Телепорты", 4483362458)
TeleportTab:CreateButton({Name = "ТП к Убийце", Callback = function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and GetPlayerRole(pl) == "Murderer" and pl.Character then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
end})
TeleportTab:CreateButton({Name = "ТП к Шерифу", Callback = function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and GetPlayerRole(pl) == "Sheriff" and pl.Character then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
end})
TeleportTab:CreateButton({Name = "ТП к Пистолету", Callback = function()
    local g = GetDroppedGun()
    if g then 
        local targetCFrame = g:IsA("Model") and g:GetPivot() * CFrame.new(0,2,0) or g.CFrame * CFrame.new(0,2,0)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
        end
    end
end})

local FarmTab = Window:CreateTab("Фарм и Полет", 4483362458)
FarmTab:CreateToggle({Name = "Авто-фарм монет", Callback = function(v) AutoFarmEnabled = v end})
FarmTab:CreateToggle({Name = "Полет (Fly WASD)", Callback = function(v) FlyEnabled = v; ToggleFly(v) end})
FarmTab:CreateSlider({Name = "Скорость полета", Range = {10, 200}, CurrentValue = 50, Callback = function(v) FlySpeed = v end})

local MiscTab = Window:CreateTab("Разное", 4483362458)
MiscTab:CreateToggle({Name = "Прохождение сквозь стены (Noclip)", Callback = function(v) NoclipEnabled = v end})

-- Улучшенный ESP Loop (С поддержкой обычных игроков)
RunService.RenderStepped:Connect(function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local role = GetPlayerRole(pl)
            local hl = pl.Character:FindFirstChild("Highlight")
            
            -- Проверяем условия включения ESP
            local shouldHighlight = false
            local highlightColor = Color3.fromRGB(255, 255, 255)
            
            if EspAllEnabled then
                shouldHighlight = true
                if role == "Murderer" then
                    highlightColor = Color3.fromRGB(255, 0, 0) -- Красный для Убийцы
                elseif role == "Sheriff" then
                    highlightColor = Color3.fromRGB(0, 0, 255) -- Синий для Шерифа
                else
                    highlightColor = Color3.fromRGB(0, 255, 0) -- Зеленый для Обычных игроков
                end
            elseif EspEnabled and (role == "Murderer" or role == "Sheriff") then
                shouldHighlight = true
                highlightColor = (role == "Murderer" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 255))
            end
            
            -- Применяем подсветку
            if shouldHighlight then
                if not hl then 
                    hl = Instance.new("Highlight")
                    hl.Parent = pl.Character
                end
                hl.FillColor = highlightColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillOpacity = 0.5
            elseif hl then 
                hl:Destroy() 
            end
        end
    end
end)

Rayfield:Notify({Title = "Успешно", Content = "Lordikhhh Hub готов к игре!", Duration = 3})
