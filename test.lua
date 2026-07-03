-- =======================================================================
-- LORDIKHHH HUB | MURDER MYSTERY 2 | ULTIMATE VERSION (SILENT AIM & CAMERA FLY)
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

local EspEnabled = false
local CoinEspEnabled = false
local AutoFarmEnabled = false
local FlyEnabled = false
local SilentAimEnabled = false
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

local function TeleportTo(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function FlingPlayer(targetPlayer)
    local Character = targetPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        local HumanoidRootPart = Character.HumanoidRootPart
        local FlingForce = Instance.new("BodyVelocity")
        FlingForce.Velocity = Vector3.new(math.random(200, 500), 500, math.random(200, 500))
        FlingForce.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlingForce.Parent = HumanoidRootPart
        wait(0.2)
        FlingForce:Destroy()
    end
end

-- Функция для поиска ближайшей цели для Silent Aim
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

-- Логика полета по направлению взгляда (Camera Fly)
local function ToggleFly(enabled)
    local Character = LocalPlayer.Character
    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end

    if enabled then
        if FlyConnection then FlyConnection:Disconnect() end

        local BV = Instance.new("BodyVelocity")
        BV.Name = "FlightVelocity"
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.Parent = RootPart

        local BG = Instance.new("BodyGyro")
        BG.Name = "FlightGyro"
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.P = 1e4
        BG.CFrame = RootPart.CFrame
        BG.Parent = RootPart

        FlyConnection = RunService.RenderStepped:Connect(function()
            if not FlyEnabled or not RootPart or not RootPart:FindFirstChild("FlightVelocity") then 
                if FlyConnection then FlyConnection:Disconnect() end
                return 
            end

            local Camera = Workspace.CurrentCamera
            local MoveDirection = Vector3.new(0, 0, 0)

            local Look = Camera.CFrame.LookVector
            local Right = Camera.CFrame.RightVector

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then MoveDirection = MoveDirection + Look end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then MoveDirection = MoveDirection - Look end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then MoveDirection = MoveDirection - Right end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then MoveDirection = MoveDirection + Right end

            RootPart.FlightVelocity.Velocity = MoveDirection * FlySpeed
            RootPart.FlightGyro.CFrame = Camera.CFrame
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() end
        if RootPart:FindFirstChild("FlightVelocity") then RootPart.FlightVelocity:Destroy() end
        if RootPart:FindFirstChild("FlightGyro") then RootPart.FlightGyro:Destroy() end
    end
end

-- Перехват мета-методов (Хук) для работы Silent Aim
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if SilentAimEnabled and method == "FireServer" and self.Name == "ShootGun" then
        local Target = GetClosestTarget()
        if Target and Target.Character and Target.Character:FindFirstChild("Head") then
            args[1] = Target.Character.Head.Position
            return self.FireServer(self, unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

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
VisualsTab:CreateToggle({Name = "ESP (Убийца/Шериф)", Callback = function(v) EspEnabled = v end})
VisualsTab:CreateToggle({Name = "Подсветка Монет", Callback = function(v) CoinEspEnabled = v end})

local CombatTab = Window:CreateTab("Бой (Combat)", 4483362458)
CombatTab:CreateToggle({Name = "Silent Aim (Невидимый аим)", Callback = function(v) SilentAimEnabled = v end})

local TeleportTab = Window:CreateTab("Телепорты", 4483362458)
TeleportTab:CreateButton({Name = "ТП к Убийце", Callback = function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and GetPlayerRole(pl) == "Murderer" and pl.Character then
            TeleportTo(pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
        end
    end
end})
TeleportTab:CreateButton({Name = "ТП к Пистолету", Callback = function()
    local g = GetDroppedGun()
    if g then TeleportTo(g:IsA("Model") and g:GetPivot() * CFrame.new(0,2,0) or g.CFrame * CFrame.new(0,2,0)) end
end})
TeleportTab:CreateButton({Name = "Оттолкнуть ближайшего (Fling)", Callback = function()
    local closest, minD = nil, 15
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (pl.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < minD then closest = pl; minD = dist end
        end
    end
    if closest then FlingPlayer(closest) end
end})

local FarmTab = Window:CreateTab("Фарм и Полет", 4483362458)
FarmTab:CreateToggle({Name = "Авто-фарм монет", Callback = function(v) AutoFarmEnabled = v end})
FarmTab:CreateToggle({Name = "Полет (Fly)", Callback = function(v) FlyEnabled = v; ToggleFly(v) end})
FarmTab:CreateSlider({Name = "Скорость полета", Range = {10, 200}, CurrentValue = 50, Callback = function(v) FlySpeed = v end})

-- ESP Loop
RunService.RenderStepped:Connect(function()
    for _, pl in pairs(Players:GetPlayers()) do
        if pl.Character then
            local role = GetPlayerRole(pl)
            local hl = pl.Character:FindFirstChild("Highlight")
            if EspEnabled and (role == "Murderer" or role == "Sheriff") then
                if not hl then hl = Instance.new("Highlight", pl.Character) end
                hl.FillColor = (role == "Murderer" and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,0,255))
            elseif hl then hl:Destroy() end
        end
    end
end)

Rayfield:Notify({Title = "Успешно", Content = "Lordikhhh Hub готов к работе!", Duration = 3})
