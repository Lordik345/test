-- [[ TSB ULTIMATE: PREMIUM EDITION ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    AutoFarm = false,
    Target = nil,
    PredictionFactor = 0.15, -- Настройка предсказания
    Smoothness = 0.25,       -- Плавность движений
    AutoSkills = false
}

-- Улучшенный ESP
local Highlight = Instance.new("Highlight")
Highlight.FillColor = Color3.fromRGB(255, 0, 0)
Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
Highlight.Parent = nil 

local Window = Rayfield:CreateWindow({
    Name = "TSB PREMIUM | Elite Auto-Farm",
    LoadingTitle = "Initializing Premium Systems...",
    LoadingSubtitle = "by TSB-PRO"
})

local FarmTab = Window:CreateTab("Auto Farm", "sword")
local VisualTab = Window:CreateTab("Visuals", "eye")

-- Выбор цели
local Dropdown = FarmTab:CreateDropdown({
    Name = "Выбрать жертву",
    Options = {"Нет целей"},
    Callback = function(v)
        local name = type(v) == "table" and v[1] or v
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name == name then
                Settings.Target = p
                Highlight.Parent = p.Character
            end
        end
    end
})

FarmTab:CreateToggle({
    Name = "Premium Auto-Farm (Predictive)",
    Callback = function(v) Settings.AutoFarm = v end
})

FarmTab:CreateSlider({
    Name = "Плавность (Smoothness)",
    Range = {0.1, 0.5},
    Increment = 0.05,
    CurrentValue = 0.25,
    Callback = function(v) Settings.Smoothness = v end
})

-- Логика Премиум Фарма (Tween + Prediction)
task.spawn(function()
    while task.wait() do
        if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
            local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if targetHRP and myHRP then
                -- Предикшн: куда враг придет через долю секунды
                local predictedPos = targetHRP.Position + (targetHRP.Velocity * Settings.PredictionFactor)
                local targetCF = CFrame.new(predictedPos + Vector3.new(0, 3, 2), predictedPos)
                
                -- Плавное перемещение (Tweening)
                local tween = TweenService:Create(myHRP, TweenInfo.new(Settings.Smoothness, Enum.EasingStyle.Linear), {CFrame = targetCF})
                tween:Play()
                
                -- Умная атака
                if (myHRP.Position - targetHRP.Position).Magnitude < 15 then
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,true,game,1)
                    task.wait(0.05)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,0,0,false,game,1)
                end
            end
        end
    end
end)

-- Обновление списка
FarmTab:CreateButton({
    Name = "Refresh Target List",
    Callback = function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(list, p.Name) end
        end
        Dropdown:Refresh(list, true)
    end
})
