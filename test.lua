local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- === ПЕРЕМЕННЫЕ ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Settings = {
    AutoFarm = false, Target = nil, AttackDelay = 0.2, UndergroundMode = false,
    FlyEnabled = false, FlySpeed = 50
}

-- Объекты для полета
local bodyVel, bodyGyro

-- === ФУНКЦИИ ===
local function getPlayer(name)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) then return p end
    end
    return nil
end

-- Логика полета
local function toggleFly(enabled)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if enabled then
        bodyVel = Instance.new("BodyVelocity", hrp)
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 10000
        bodyGyro.D = 100
        bodyGyro.CFrame = hrp.CFrame
    else
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end

-- === RAYFIELD GUI ===
local Window = Rayfield:CreateWindow({
   Name = "TSB Pro Hub | Ultimate Edition",
   LoadingTitle = "TSB Hub Loading...",
   LoadingSubtitle = "by Delta",
   ConfigurationSaving = { Enabled = true, FileName = "TSB_Config" }
})

local FarmTab = Window:CreateTab("Auto Farm", "target")
local MovementTab = Window:CreateTab("Movement", "move")

-- Auto Farm Tab
local TargetDropdown = FarmTab:CreateDropdown({
   Name = "Выберите цель", Options = {}, CurrentOption = "",
   Callback = function(Option) Settings.Target = getPlayer(Option[1]) end,
})

FarmTab:CreateButton({ Name = "Обновить список игроков", Callback = function()
    local list = {}
    for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p.Name) end end
    TargetDropdown:Refresh(list, true)
end})

FarmTab:CreateToggle({ Name = "Включить Auto Farm", CurrentValue = false, Callback = function(v) Settings.AutoFarm = v end })
FarmTab:CreateToggle({ Name = "Underground Mode (Noclip)", CurrentValue = false, Callback = function(v) Settings.UndergroundMode = v end })

-- Movement Tab
MovementTab:CreateToggle({ Name = "Fly (Полет)", CurrentValue = false, Callback = function(v) 
    Settings.FlyEnabled = v 
    toggleFly(v)
end})

MovementTab:CreateSlider({ Name = "Fly Speed", Range = {10, 200}, Increment = 5, CurrentValue = 50, Callback = function(v) Settings.FlySpeed = v end })

-- === ОСНОВНОЙ ЦИКЛ ===
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    -- Noclip (для underground)
    if Settings.UndergroundMode then
        for _, part in pairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
    end

    -- Fly Logic
    if Settings.FlyEnabled and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local moveDir = Vector3.new(0,0,0)
        
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        
        bodyVel.Velocity = moveDir * Settings.FlySpeed
        bodyGyro.CFrame = Camera.CFrame
    end

    -- Auto Farm (Teleport & Attack)
    if Settings.AutoFarm and Settings.Target and Settings.Target.Character and char:FindFirstChild("HumanoidRootPart") then
        local targetChar = Settings.Target.Character
        if targetChar:FindFirstChild("HumanoidRootPart") then
            local yOffset = Settings.UndergroundMode and -3 or 0
            char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, yOffset, 2)
            
            -- Атака
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            task.wait(Settings.AttackDelay)
            game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
            
            -- Скиллы
            for i = 1, 4 do
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode["Button" .. i], false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode["Button" .. i], false, game)
            end
        end
    end
end)
