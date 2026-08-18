-- [[ TSB TOP HUB - WITH KEY SYSTEM ]] --

-- 1. СИСТЕМА КЛЮЧА
local KEY_TO_ENTER = "TOP"
local isAuthorized = false

local function startHub()
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    local Settings = {
        AutoFarm = false, Target = nil, AutoSkills = false, Underground = false, Fly = false, FlySpeed = 50
    }

    -- === Функции ===
    local function getTarget(name)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(name:lower()) then return p end
        end
        return nil
    end

    -- === Интерфейс ===
    local Window = Rayfield:CreateWindow({Name = "TSB TOP HUB", LoadingTitle = "Проверка ключа...", LoadingSubtitle = "Успешно"})
    local FarmTab = Window:CreateTab("Auto Farm", "sword")
    local MoveTab = Window:CreateTab("Movement", "move")

    -- Выбор цели
    local Dropdown = FarmTab:CreateDropdown({Name = "Выбрать цель", Options = {}, Callback = function(v) Settings.Target = getTarget(v[1]) end})
    FarmTab:CreateButton({Name = "Обновить список игроков", Callback = function()
        local list = {}
        for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(list, p.Name) end end
        Dropdown:Refresh(list, true)
    end})

    -- Фарм
    FarmTab:CreateToggle({Name = "Auto Farm (Атака)", Callback = function(v) Settings.AutoFarm = v end})
    FarmTab:CreateToggle({Name = "Auto Skills", Callback = function(v) Settings.AutoSkills = v end})
    FarmTab:CreateToggle({Name = "Underground Mode", Callback = function(v) Settings.Underground = v end})

    -- Полет
    MoveTab:CreateToggle({Name = "Fly (Полет)", Callback = function(v) Settings.Fly = v end})
    MoveTab:CreateSlider({Name = "Fly Speed", Range = {10, 200}, CurrentValue = 50, Callback = function(v) Settings.FlySpeed = v end})

    -- === Главный цикл ===
    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        -- Noclip/Underground
        if Settings.Underground then
            for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end

        -- Auto Farm
        if Settings.AutoFarm and Settings.Target and Settings.Target.Character then
            local targetHRP = Settings.Target.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local offset = Settings.Underground and -3 or 0
                char.HumanoidRootPart.CFrame = targetHRP.CFrame * CFrame.new(0, offset, 2)
                
                -- Атака
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
                task.wait(0.1)
                game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
                
                -- Скиллы
                if Settings.AutoSkills then
                    for i = 1, 4 do
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode["Button" .. i], false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode["Button" .. i], false, game)
                    end
                end
            end
        end

        -- Fly
        if Settings.Fly then
            local hrp = char.HumanoidRootPart
            local dir = Vector3.new(0,0,0)
            local uis = game:GetService("UserInputService")
            if uis:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
            hrp.Velocity = dir * Settings.FlySpeed
        end
    end)
end

-- 2. ЛОГИКА ВВОДА КЛЮЧА
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui); Frame.Size = UDim2.new(0, 200, 0, 100); Frame.Position = UDim2.new(0.5, -100, 0.5, -50); Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
local Input = Instance.new("TextBox", Frame); Input.Size = UDim2.new(0.9, 0, 0, 30); Input.Position = UDim2.new(0.05, 0, 0.1, 0); Input.PlaceholderText = "Введите ключ..."
local Btn = Instance.new("TextButton", Frame); Btn.Size = UDim2.new(0.9, 0, 0, 30); Btn.Position = UDim2.new(0.05, 0, 0.5, 0); Btn.Text = "Войти"

Btn.MouseButton1Click:Connect(function()
    if Input.Text == KEY_TO_ENTER then
        ScreenGui:Destroy()
        startHub()
    else
        Input.Text = ""
        Input.PlaceholderText = "Неверно!"
    end
end)
