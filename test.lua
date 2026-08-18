-- [[ TSB ULTIMATE TOP HUB: AIR FIGHT & COMBAT EDITION ]] --

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
        Underground = false,
        Orbit = false,
        Fly = false,
        FlySpeed = 50,
        -- Настройки боя в воздухе
        AirFarm = false,
        AirHeight = 20,
        -- Настройки защиты
        AutoBlock = false,
        BlockDistance = 12,
        AutoDash = false,
        DashCooldown = 3,
        IsBlocking = false,
        LastDash = 0
    }

    local function getTarget(name)
        if not name or name == "" then return nil end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(name:lower()) or p.DisplayName:lower():find(name:lower()) then 
                return p 
            end
        end
        return nil
    end

    -- === ИНТЕРФЕЙС RAYFIELD ===
    local Window = Rayfield:CreateWindow({
        Name = "TSB TOP HUB | Ultimate",
        LoadingTitle = "TSB TOP HUB",
        LoadingSubtitle = "Air & Behind Farm Fixed",
        ConfigurationSaving = { Enabled = false }
    })

    local FarmTab = Window:CreateTab("Auto Farm", "sword")
    local DefenseTab = Window:CreateTab("Defense", "shield")
    local MoveTab = Window:CreateTab("Movement", "move")

    -- Выбор цели
    local Dropdown = FarmTab:CreateDropdown({
        Name = "Выбрать цель",
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

    -- Настройки Авто-Фарма
    FarmTab:CreateToggle({
        Name = "Auto Farm (Атака M1)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoFarm = v end
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
        Name = "Auto Skills (Скиллы)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoSkills = v end
    })

    FarmTab:CreateToggle({
        Name = "Orbit Mode (Вращение во время боя)",
        CurrentValue = false,
        Callback = function(v) Settings.Orbit = v end
    })

    FarmTab:CreateToggle({
        Name = "Underground Mode (Под землёй)",
        CurrentValue = false,
        Callback = function(v) Settings.Underground = v end
    })

    -- Настройки Защиты
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

    DefenseTab:CreateSlider({
        Name = "Кулдаун уклонения (сек)",
        Range = {1, 10},
        Increment = 0.5,
        CurrentValue = 3,
        Callback = function(v) Settings.DashCooldown = v end
    })

    -- Настройки Движения
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

    -- === ЛОГИКА АВТО-БЛОКА И У КЛОНЕНИЯ ===
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

    -- === ЦИКЛ АТАКИ И СКИЛЛОВ ===
    task.spawn(function()
        while task.wait(0.1) do
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

    -- === ГЛАВНЫЙ ЦИКЛ ПЕРЕМЕЩЕНИЯ И ФАРМА (60 FPS) ===
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart

        -- Noclip включен при авто-фарме
        if Settings.Underground or Settings.AutoFarm or Settings.AirFarm then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false 
                end
            end
        end

        -- Позиционирование Авто-Фарма
        if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
            local targetChar = Settings.Target.Character
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")

            if targetHRP then
                local yOffset = 0
                if Settings.AirFarm then
                    yOffset = Settings.AirHeight
                elseif Settings.Underground then
                    yOffset = -3.5
                end

                if Settings.AirFarm then
                    targetHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end

                local targetCF = targetHRP.CFrame
                local newCFrame

                if Settings.Orbit then
                    local t = tick() * 6
                    newCFrame = targetCF * CFrame.new(math.cos(t) * 1.8, yOffset, math.sin(t) * 1.8)
                else
                    -- Дистанция 1.8 студа ЗА СПИНОЙ цели (CFrame.new(0, yOffset, 1.8))
                    newCFrame = targetCF * CFrame.new(0, yOffset, 1.8)
                end

                -- Вращение лицом прямо на цель
                hrp.CFrame = CFrame.new(newCFrame.Position, targetHRP.Position)
                hrp.AssemblyLinearVelocity = Vector3.zero
            end
        end

        -- Полёт через CFrame
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

-- === МЕНЮ ВВОДА КЛЮЧА ===
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
