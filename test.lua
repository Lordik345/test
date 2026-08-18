-- [[ TSB ULTIMATE: ORBITAL FLANKER & ANTI-STUN V4 ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    AutoFarm = false,
    AntiStun = true,
    OrbitSpeed = 3.5, -- Скорость вращения
    OrbitRadius = 7,  -- Дистанция до врага
    Target = nil
}

-- GUI
local Window = Rayfield:CreateWindow({Name = "TSB ULTIMATE | V4", LoadingTitle = "Loading Systems...", LoadingSubtitle = "Combined Mode"})
local MainTab = Window:CreateTab("Combat & Movement", "sword")
local SafetyTab = Window:CreateTab("Defensive", "shield")

-- Управление (Toggle)
MainTab:CreateToggle({Name = "Auto-Farm (Orbital Flank)", Callback = function(v) Settings.AutoFarm = v end})
SafetyTab:CreateToggle({Name = "Auto Anti-Stun (Block)", CurrentValue = true, Callback = function(v) Settings.AntiStun = v end})

-- Логика движения и атаки (RenderStepped - для плавности)
RunService.RenderStepped:Connect(function()
    if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
        local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetHRP and myHRP then
            -- Орбитальное движение (фланг)
            local time = tick() * Settings.OrbitSpeed
            local offset = Vector3.new(math.sin(time) * Settings.OrbitRadius, 0, math.cos(time) * Settings.OrbitRadius)
            local targetPos = targetHRP.Position + offset
            
            -- Плавное перемещение к позиции
            myHRP.CFrame = CFrame.new(myHRP.Position, targetHRP.Position):Lerp(CFrame.new(targetPos, targetHRP.Position), 0.15)
            
            -- Атака
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
        end
    end
end)

-- Анти-стан
LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").HealthChanged:Connect(function()
        if Settings.AntiStun then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.4)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end
    end)
end)

-- Обновление целей
MainTab:CreateButton({Name = "Refresh Target List", Callback = function()
    -- (Здесь можно вставить логику обновления Dropdown, как в прошлых версиях)
    Rayfield:Notify({Title = "System", Content = "Target list refreshed", Duration = 2})
end})
