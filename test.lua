-- [[ TSB ULTIMATE TOP HUB: OVERHEAD DAMAGE EDITION ]] --

local KEY_TO_ENTER = "TOP"

local function startHub()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local Settings = {
        AutoFarm = false,
        Target = nil,
        AutoSkills = false,
        
        -- Режимы позиционирования
        Overhead = false,        
        OverheadHeight = 7,      
        Underground = false,
        UndergroundDepth = 8,
        AirFarm = false,
        AirHeight = 20,

        Fly = false,
        FlySpeed = 50,

        -- Настройки Auto Lock / Aim
        AutoLock = false,
        LockSmoothness = 0.2,
        ShowFOV = false,
        UseFOVCheck = false,
        FOVRadius = 150,

        -- Защита
        AutoBlock = false,
        BlockDistance = 12,
        AutoDash = false,
        DashCooldown = 3,
        IsBlocking = false,
        LastDash = 0
    }

    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(255, 50, 50)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.8
    FOVCircle.Visible = false

    local function getTarget(name)
        if not name or name == "" then return nil end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(name:lower()) or p.DisplayName:lower():find(name:lower()) then 
                return p 
            end
        end
        return nil
    end

    local function isTargetInFOV(targetChar)
        if not targetChar or not targetChar:FindFirstChild("HumanoidRootPart") then return false end
        local screenPos, onScreen = Camera:WorldToViewportPoint(targetChar.HumanoidRootPart.Position)
        if not onScreen then return false end

        local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        local targetPos2D = Vector2.new(screenPos.X, screenPos.Y)
        return (mousePos - targetPos2D).Magnitude <= Settings.FOVRadius
    end

    local Window = Rayfield:CreateWindow({
        Name = "TSB TOP HUB | Ultimate Edition",
        LoadingTitle = "TSB TOP HUB",
        LoadingSubtitle = "Loaded Successfully",
        ConfigurationSaving = { Enabled = false }
    })

    local FarmTab = Window:CreateTab("Auto Farm", "sword")
    local CombatTab = Window:CreateTab("Combat Lock", "crosshair")
    local DefenseTab = Window:CreateTab("Defense", "shield")
    local MoveTab = Window:CreateTab("Movement", "move")

    local Dropdown = FarmTab:CreateDropdown({
        Name = "Выбрать цель (Target)",
        Options = {"Нет целей"},
        CurrentOption = "",
        MultipleOptions = false,
        Callback = function(v)
            local selected = type(v) == "table" and v[1] or v
            Settings.Target = getTarget(selected)
        end
    })

    FarmTab:CreateButton({
        Name = "Обновить список игроков",
        Callback = function()
            local list = {}
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then 
                    table.insert(list, p.Name) 
                end
            end
            Dropdown:Refresh(#list > 0 and list or {"Нет целей"}, true)
        end
    })

    FarmTab:CreateToggle({
        Name = "Auto Farm (Атака M1)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoFarm = v end
    })

    FarmTab:CreateToggle({
        Name = "Overhead Mode (Атака СВЕРХУ)",
        CurrentValue = false,
        Callback = function(v) Settings.Overhead = v end
    })

    FarmTab:CreateSlider({
        Name = "Высота атаки сверху",
        Range = {3, 18},
        Increment = 1,
        CurrentValue = 7,
        Callback = function(v) Settings.OverheadHeight = v end
    })

    FarmTab:CreateToggle({
        Name = "Underground Mode (Атака из-под земли)",
        CurrentValue = false,
        Callback = function(v) Settings.Underground = v end
    })

    FarmTab:CreateSlider({
        Name = "Глубина под землёй",
        Range = {3, 20},
        Increment = 1,
        CurrentValue = 8,
        Callback = function(v) Settings.UndergroundDepth = v end
    })

    FarmTab:CreateToggle({
        Name = "Air Fight (Бой в воздухе)",
        CurrentValue = false,
        Callback = function(v) Settings.AirFarm = v end
    })

    FarmTab:CreateSlider({
        Name = "Высота боя в воздухе",
        Range = {5, 80},
        Increment = 5,
        CurrentValue = 20,
        Callback = function(v) Settings.AirHeight = v end
    })

    FarmTab:CreateToggle({
        Name = "Auto Skills (Использовать скиллы)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoSkills = v end
    })

    -- COMBAT LOCK & FOV
    CombatTab:CreateToggle({
        Name = "Auto Lock (Захват Камеры / Aim)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoLock = v end
    })

    CombatTab:CreateSlider({
        Name = "Плавность наведения прицела",
        Range = {0.05, 1},
        Increment = 0.05,
        CurrentValue = 0.2,
        Callback = function(v) Settings.LockSmoothness = v end
    })

    CombatTab:CreateToggle({
        Name = "Показывать круг FOV",
        CurrentValue = false,
        Callback = function(v) Settings.ShowFOV = v end
    })

    CombatTab:CreateToggle({
        Name = "Фильтр Aim Lock по FOV",
        CurrentValue = false,
        Callback = function(v) Settings.UseFOVCheck = v end
    })

    CombatTab:CreateSlider({
        Name = "Радиус FOV (Размер)",
        Range = {50, 800},
        Increment = 10,
        CurrentValue = 150,
        Callback = function(v) Settings.FOVRadius = v end
    })

    DefenseTab:CreateToggle({
        Name = "Auto Block (Авто-Блок)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoBlock = v end
    })

    DefenseTab:CreateSlider({
        Name = "Дистанция блока",
        Range = {5, 25},
        Increment = 1,
        CurrentValue = 12,
        Callback = function(v) Settings.BlockDistance = v end
    })

    DefenseTab:CreateToggle({
        Name = "Auto Dash (Уклонение)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoDash = v end
    })

    MoveTab:CreateToggle({
        Name = "Fly (Полёт)",
        CurrentValue = false,
        Callback = function(v) Settings.Fly = v end
    })

    MoveTab:CreateSlider({
        Name = "Скорость полёта",
        Range = {10, 200},
        Increment = 5,
        CurrentValue = 50,
        Callback = function(v) Settings.FlySpeed = v end
    })

    -- Цикл авто-блока и уклонения
    task.spawn(function()
        while task.wait(0.05) do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and Settings.Target and Settings.Target.Character then
                local hrp = char.HumanoidRootPart
                local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")

                if targetHRP then
                    local dist = (hrp.Position - targetHRP.Position).Magnitude

                    if Settings.AutoBlock and dist <= Settings.BlockDistance then
                        if not Settings.IsBlocking then
                            Settings.IsBlocking = true
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        end
                    else
                        if Settings.IsBlocking then
                            Settings.IsBlocking = false
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        end
                    end

                    if Settings.AutoDash and dist <= (Settings.BlockDistance - 2) then
                        if tick() - Settings.LastDash >= Settings.DashCooldown then
                            Settings.LastDash = tick()
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
                            task.wait(0.05)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
                        end
                    end
                end
            else
                if Settings.IsBlocking then
                    Settings.IsBlocking = false
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end
            end
        end
    end)

    -- Цикл кликов M1 и прожима скиллов
    task.spawn(function()
        while task.wait(0.08) do
            if Settings.AutoFarm and Settings.Target and Settings.Target.Character and not Settings.IsBlocking then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.02)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)

                if Settings.AutoSkills then
                    local skillKeys = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}
                    local randomKey = skillKeys[math.random(1, #skillKeys)]
                    
                    VirtualInputManager:SendKeyEvent(true, randomKey, false, game)
                    task.wait(0.02)
                    VirtualInputManager:SendKeyEvent(false, randomKey, false, game)
                end
            end
        end
    end)

    -- Главный физический цикл: Позиционирование, FOV, Auto Lock
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = Settings.ShowFOV
        FOVCircle.Radius = Settings.FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        -- Отключение коллизий для спец-режимов
        if Settings.Underground or Settings.Overhead or Settings.AirFarm then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false 
                end
            end
        end

        -- Логика AUTO LOCK
        if Settings.AutoLock and Settings.Target and Settings.Target.Character then
            local targetChar = Settings.Target.Character
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                local canLock = true
                if Settings.UseFOVCheck then
                    canLock = isTargetInFOV(targetChar)
                end

                if canLock then
                    local currentCF = Camera.CFrame
                    local targetCF = CFrame.new(Camera.CFrame.Position, targetHRP.Position)
                    Camera.CFrame = currentCF:Lerp(targetCF, Settings.LockSmoothness)
                end
            end
        end

        -- Расчёт позиционирования авто-фарма
        if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
            local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                hrp.AssemblyLinearVelocity = Vector3.zero
                
                if Settings.Overhead then
                    local topPos = targetHRP.Position + Vector3.new(0, Settings.OverheadHeight, 0)
                    local baseCF = CFrame.new(topPos, targetHRP.Position)
                    hrp.CFrame = baseCF * CFrame.Angles(math.rad(-90), 0, 0)

                elseif Settings.Underground then
                    local underPos = targetHRP.Position - Vector3.new(0, Settings.UndergroundDepth, 0)
                    local baseCF = CFrame.new(underPos, targetHRP.Position)
                    hrp.CFrame = baseCF * CFrame.Angles(math.rad(90), 0, 0)

                elseif Settings.AirFarm then
                    local airPos = targetHRP.Position + Vector3.new(0, Settings.AirHeight, 0)
                    hrp.CFrame = CFrame.new(airPos, targetHRP.Position)
                else
                    local backVector = targetHRP.CFrame.LookVector * -2.5
                    local targetPosition = targetHRP.Position + backVector
                    hrp.CFrame = CFrame.new(targetPosition, targetHRP.Position)
                end
            end
        end

        -- Полёт
        if Settings.Fly then
            local dir = Vector3.zero
            local uis = game:GetService("UserInputService")

            if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end

            if dir.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + (dir.Unit * (Settings.FlySpeed / 50))
            end
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

-- Меню ввода ключа
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 120)
Frame.Position = UDim2.new(0.5, -120, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Frame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Введите Ключ"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

local Input = Instance.new("TextBox", Frame)
Input.Size = UDim2.new(0.8, 0, 0, 30)
Input.Position = UDim2.new(0.1, 0, 0.35, 0)
Input.PlaceholderText = "Ключ..."
Input.Text = ""
Input.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(0.8, 0, 0, 30)
Btn.Position = UDim2.new(0.1, 0, 0.68, 0)
Btn.Text = "Войти"
Btn.BackgroundColor3 = Color3.fromRGB(60, 120, 240)
Btn.TextColor3 = Color3.fromRGB(255, 255, 255)

Btn.MouseButton1Click:Connect(function()
    if Input.Text == KEY_TO_ENTER then
        ScreenGui:Destroy()
        startHub()
    else
        Input.Text = ""
        Input.PlaceholderText = "Неверный ключ!"
    end
end)
