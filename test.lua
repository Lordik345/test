-- [[ TSB ULTIMATE TOP HUB: RAYFIELD EDITION ]] --

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
        Orbit = true,
        Fly = false,
        FlySpeed = 50
    }

    local function getTarget(name)
        if not name then return nil end
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
        LoadingSubtitle = "by Delta Edition",
        ConfigurationSaving = { Enabled = false }
    })

    local FarmTab = Window:CreateTab("Auto Farm", "sword")
    local MoveTab = Window:CreateTab("Movement", "move")

    -- Выбор цели
    local Dropdown = FarmTab:CreateDropdown({
        Name = "Выбрать цель",
        Options = {},
        CurrentOption = "",
        MultipleOptions = false,
        Callback = function(v)
            Settings.Target = getTarget(v[1])
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
            Dropdown:Refresh(list, true)
        end
    })

    -- Настройки Авто-Фарма
    FarmTab:CreateToggle({
        Name = "Auto Farm (Атака M1)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoFarm = v end
    })

    FarmTab:CreateToggle({
        Name = "Auto Skills (Скиллы)",
        CurrentValue = false,
        Callback = function(v) Settings.AutoSkills = v end
    })

    FarmTab:CreateToggle({
        Name = "Orbit Mode (Вращение во время боя)",
        CurrentValue = true,
        Callback = function(v) Settings.Orbit = v end
    })

    FarmTab:CreateToggle({
        Name = "Underground Mode (Под землёй)",
        CurrentValue = false,
        Callback = function(v) Settings.Underground = v end
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

    -- === ГЛАВНЫЙ ЦИКЛ ===
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        -- Noclip для подземного режима
        if Settings.Underground then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then 
                    part.CanCollide = false 
                end
            end
        end

        -- Логика Авто-Фарма
        if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
            local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local yOffset = Settings.Underground and -3.5 or 0
                local newPos

                if Settings.Orbit then
                    local time = tick() * 10
                    newPos = targetHRP.CFrame * CFrame.new(math.cos(time) * 2.5, yOffset, math.sin(time) * 2.5)
                else
                    newPos = targetHRP.CFrame * CFrame.new(0, yOffset, 2)
                end

                -- Разворот персонажа ЛИЦОМ к цели (чтобы попадали скиллы)
                char.HumanoidRootPart.CFrame = CFrame.new(newPos.Position, targetHRP.Position)

                -- Атака M1
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                task.wait(0.05)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))

                -- Прожатие скиллов поочерёдно
                if Settings.AutoSkills then
                    local skillKeys = {"1", "2", "3", "4"}
                    local randomKey = skillKeys[math.random(1, #skillKeys)]
                    
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[randomKey], false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[randomKey], false, game)
                end
            end
        end

        -- Логика Полёта
        if Settings.Fly then
            local hrp = char.HumanoidRootPart
            local dir = Vector3.new(0,0,0)
            local uis = game:GetService("UserInputService")

            if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end

            hrp.Velocity = dir * Settings.FlySpeed
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
