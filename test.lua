-- =======================================================================
-- LORDIKHHH HUB | MURDER MYSTERY 2 | ULTIMATE VERSION
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
local FlySpeed = 50

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

-- Fly Logic
local function ToggleFly(enabled)
    local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    if enabled then
        local BV = Instance.new("BodyVelocity", RootPart); BV.Name = "FlightVelocity"; BV.MaxForce = Vector3.new(9e9, 9e9, 9e9); BV.Velocity = Vector3.new(0,0,0)
        local BG = Instance.new("BodyGyro", RootPart); BG.Name = "FlightGyro"; BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); BG.P = 9e4; BG.CFrame = RootPart.CFrame
        RunService.RenderStepped:Connect(function()
            if FlyEnabled then
                local Dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Workspace.CurrentCamera.CFrame.RightVector end
                RootPart.FlightVelocity.Velocity = Dir * FlySpeed
                RootPart.FlightGyro.CFrame = Workspace.CurrentCamera.CFrame
            end
        end)
    else
        if RootPart:FindFirstChild("FlightVelocity") then RootPart.FlightVelocity:Destroy() end
        if RootPart:FindFirstChild("FlightGyro") then RootPart.FlightGyro:Destroy() end
    end
end

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
