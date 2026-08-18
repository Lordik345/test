-- [[ TSB ULTIMATE: GOD SHREDDER V8 ]] --

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
        AutoTargetSwitch = true,
        Target = nil,
        AutoSkills = false,
        
        -- Ювелирная настройка хитбокса
        FarmDistance = 2.0,     -- Идеальная дистанция для сбривания
        HeightOffset = 0.8,     -- Пробитие блока сверху
        
        Fly = false,
        FlySpeed = 60,

        -- Aim & FOV
        AutoLock = false,
        LockSmoothness = 0.4,
        ShowFOV = false,
        FOVRadius = 160,

        -- Защита
        AntiStun = true,
        IsBlocking = false
    }

    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.Color = Color3.fromRGB(0, 255, 150)
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.9
    FOVCircle.Visible = false

    -- Ультрабыстрый поиск живой цели
    local function getBestTarget()
        local myChar = LocalPlayer.Character
        if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
        local myPos = myChar.HumanoidRootPart.Position

        local bestTarget = nil
        local minDist = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")

                if hum and hum.Health > 0 and hrp then
                    local dist = (myPos - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        bestTarget = player
                    end
                end
            end
        end
        return bestTarget
    end

    local Window = Rayfield:CreateWindow({
        Name = "TSB GOD SHREDDER | V8 ZERO-DELAY",
        LoadingTitle = "Engine Initialized...",
        LoadingSubtitle = "Maximum DPS & Zero Lag",
        ConfigurationSaving = { Enabled = false }
    })

    local FarmTab = Window:CreateTab("Auto Farm", "zap")
    local CombatTab = Window:CreateTab("Combat Lock", "crosshair")
    local MoveTab = Window:CreateTab("Movement", "move")

    FarmTab:CreateToggle({
        Name = "⚡ SHREDDER ENGINE (Быстрый Фарм)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoFarm = v end
    })

    FarmTab:CreateToggle({
        Name = "🔄 Auto Target Switch (Авто-смена целей)",
        CurrentValue = true,
        Callback = function(v) Settings.AutoTargetSwitch = v end
    })

    FarmTab:CreateToggle({
        Name = "🔥 Auto Skills (Быстрый спам 1-4)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoSkills = v end
    })

    FarmTab:CreateSlider({
        Name = "Дистанция привязки",
        Range = {0.5, 5},
        Increment = 0.1,
        CurrentValue = 2.0,
        Callback = function(v) Settings.FarmDistance = v end
    })

    FarmTab:CreateSlider({
        Name = "Высота (Пробитие Блока)",
        Range = {-1, 5},
        Increment = 0.1,
        CurrentValue = 0.8,
        Callback = function(v) Settings.HeightOffset = v end
    })

    -- COMBAT LOCK
    CombatTab:CreateToggle({
        Name = "Auto Lock (Захват Камеры)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoLock = v end
    })

    CombatTab:CreateToggle({
        Name = "Показывать круг FOV",
        CurrentValue = false,
        Callback = function(v) Settings.ShowFOV = v end
    })

    CombatTab:CreateSlider({
        Name = "Радиус FOV",
        Range = {50, 800},
        Increment = 10,
        CurrentValue = 160,
        Callback = function(v) Settings.FOVRadius = v end
    })

    -- MOVEMENT
    MoveTab:CreateToggle({
        Name = "Fly (Полёт)",
        CurrentValue = false,
        Callback = function(v) Settings.Fly = v end
    })

    -- Логика мгновенной авто-смены целей
    task.spawn(function()
        while task.wait(0.05) do
            if Settings.AutoFarm and Settings.AutoTargetSwitch then
                local valid = false
                if Settings.Target and Settings.Target.Parent and Settings.Target.Character then
                    local hum = Settings.Target.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        valid = true
                    end
                end

                if not valid then
                    Settings.Target = getBestTarget()
                end
            end
        end
    end)

    -- Анти-стан (Мгновенная срезка комбо)
    local function bindAntiStun(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hum.HealthChanged:Connect(function()
                if Settings.AntiStun and not Settings.IsBlocking then
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(0.15)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
                end
            end)
        end
    end

    if LocalPlayer.Character then bindAntiStun(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(bindAntiStun)

    -- УЛЬТРА-СКОРОСТНОЙ ПОТОК АТАКИ (SHREDDER STREAM)
    task.spawn(function()
        local skills = {Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}
        local skillIdx = 1

        while true do
            RunService.Heartbeat:Wait()
            if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
                -- Удар M1
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)

                -- Спам навыками
                if Settings.AutoSkills then
                    local key = skills[skillIdx]
                    VirtualInputManager:SendKeyEvent(true, key, false, game)
                    VirtualInputManager:SendKeyEvent(false, key, false, game)
                    
                    skillIdx = (skillIdx % #skills) + 1
                end
            end
        end
    end)

    -- ГЛАВНЫЙ ЦИКЛ ПОЗИЦИОНИРОВАНИЯ (БЕЗ ЛАГОВ)
    RunService.RenderStepped:Connect(function()
        FOVCircle.Visible = Settings.ShowFOV
        FOVCircle.Radius = Settings.FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        -- Отключение физики коллизий для идеального «залипания»
        if Settings.AutoFarm then
            for _, p in pairs(char:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end

        -- Привязка хитбокса и моментальный разворот
        if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
            local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                hrp.AssemblyLinearVelocity = Vector3.zero
                
                -- Рассчитываем точку строго за спиной врага с учётом высоты
                local targetCF = targetHRP.CFrame
                local shredPos = targetCF.Position - (targetCF.LookVector * Settings.FarmDistance) + Vector3.new(0, Settings.HeightOffset, 0)
                
                -- Жесткий замок позиции на цель
                hrp.CFrame = CFrame.new(shredPos, targetHRP.Position)
            end
        end

        -- Auto Lock (Камера)
        if Settings.AutoLock and Settings.Target and Settings.Target.Character then
            local tHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")
            if tHRP then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, tHRP.Position), Settings.LockSmoothness)
            end
        end
    end)
end

-- GUI Ввода Ключа
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 120)
Frame.Position = UDim2.new(0.5, -120, 0.5, -60)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
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
Input.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)

local Btn = Instance.new("TextButton", Frame)
Btn.Size = UDim2.new(0.8, 0, 0, 30)
Btn.Position = UDim2.new(0.1, 0, 0.68, 0)
Btn.Text = "Войти"
Btn.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
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
