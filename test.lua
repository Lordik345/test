-- [[ TSB Script with Key System, GUI & Auto-Combo for Delta ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ
local CORRECT_KEY = "TSB2026"
local Settings = {
    AutoFight = false,
    AutoCombo = false,
    FlyEnabled = false,
    FlySpeed = 60,
    AttackRange = 25
}

-- === 1. ИНТЕРФЕЙС (GUI) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TSB_Delta_Hub_Combo"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- КНОПКА ОТКРЫТИЯ/ЗАКРЫТИЯ МЕНЮ
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
OpenBtn.Text = "TSB"
OpenBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
OpenBtn.TextSize = 18
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.Active = true
OpenBtn.Draggable = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenBtn

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 310)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
Title.Text = "TSB HUB | Delta Edition"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- === ФОРМА ВВОДА КЛЮЧА ===
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(1, 0, 1, -40)
KeyFrame.Position = UDim2.new(0, 0, 0, 40)
KeyFrame.BackgroundTransparency = 1
KeyFrame.Parent = MainFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 40)
KeyInput.Position = UDim2.new(0.1, 0, 0.2, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
KeyInput.PlaceholderText = "Введите ключ..."
KeyInput.Text = ""
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.SourceSans
KeyInput.Parent = KeyFrame

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(0.8, 0, 0, 40)
KeyBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
KeyBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
KeyBtn.Text = "Войти"
KeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBtn.TextSize = 16
KeyBtn.Font = Enum.Font.SourceSansBold
KeyBtn.Parent = KeyFrame

-- === ПАНЕЛЬ ФУНКЦИЙ ===
local HackFrame = Instance.new("Frame")
HackFrame.Size = UDim2.new(1, 0, 1, -40)
HackFrame.Position = UDim2.new(0, 0, 0, 40)
HackFrame.BackgroundTransparency = 1
HackFrame.Visible = false
HackFrame.Parent = MainFrame

local AutoFightBtn = Instance.new("TextButton")
AutoFightBtn.Size = UDim2.new(0.8, 0, 0, 40)
AutoFightBtn.Position = UDim2.new(0.1, 0, 0.08, 0)
AutoFightBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AutoFightBtn.Text = "Auto Fight: OFF"
AutoFightBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
AutoFightBtn.TextSize = 15
AutoFightBtn.Font = Enum.Font.SourceSansBold
AutoFightBtn.Parent = HackFrame

local AutoComboBtn = Instance.new("TextButton")
AutoComboBtn.Size = UDim2.new(0.8, 0, 0, 40)
AutoComboBtn.Position = UDim2.new(0.1, 0, 0.38, 0)
AutoComboBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AutoComboBtn.Text = "Auto Combo: OFF"
AutoComboBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
AutoComboBtn.TextSize = 15
AutoComboBtn.Font = Enum.Font.SourceSansBold
AutoComboBtn.Parent = HackFrame

local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.8, 0, 0, 40)
FlyBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.fromRGB(255, 85, 85)
FlyBtn.TextSize = 15
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.Parent = HackFrame

-- Переключение отображения
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Авторизация
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame.Visible = false
        HackFrame.Visible = true
        Title.Text = "TSB HUB | Авторизовано"
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Неверный ключ!"
    end
end)

-- === 2. ЛОГИКА АТАКИ И ПОЛЁТА ===
local function doClick()
    if mouse1click then
        mouse1click()
    else
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(0.01)
        game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), Camera.CFrame)
    end
end

local function useSkill(skillNumber)
    local key = Enum.KeyCode["Button" .. skillNumber] or Enum.KeyCode[tostring(skillNumber)]
    game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
    task.wait(0.05)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
end

local function getClosestEnemy()
    local closest, minDist = nil, Settings.AttackRange
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
            if enemyHum and enemyHum.Health > 0 then
                local dist = (myChar.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = player.Character
                end
            end
        end
    end
    return closest
end

-- Кнопки GUI
AutoFightBtn.MouseButton1Click:Connect(function()
    Settings.AutoFight = not Settings.AutoFight
    AutoFightBtn.Text = Settings.AutoFight and "Auto Fight: ON" or "Auto Fight: OFF"
    AutoFightBtn.TextColor3 = Settings.AutoFight and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
end)

AutoComboBtn.MouseButton1Click:Connect(function()
    Settings.AutoCombo = not Settings.AutoCombo
    AutoComboBtn.Text = Settings.AutoCombo and "Auto Combo: ON" or "Auto Combo: OFF"
    AutoComboBtn.TextColor3 = Settings.AutoCombo and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
end)

-- Полёт
local flyBodyVel, flyBodyGyro
FlyBtn.MouseButton1Click:Connect(function()
    Settings.FlyEnabled = not Settings.FlyEnabled
    FlyBtn.Text = Settings.FlyEnabled and "Fly: ON" or "Fly: OFF"
    FlyBtn.TextColor3 = Settings.FlyEnabled and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)

    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if Settings.FlyEnabled then
        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        flyBodyVel.Parent = hrp

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.CFrame = hrp.CFrame
        flyBodyGyro.Parent = hrp
    else
        if flyBodyVel then flyBodyVel:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local moveDir = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end

        if flyBodyVel then flyBodyVel.Velocity = moveDir * Settings.FlySpeed end
        if flyBodyGyro then flyBodyGyro.CFrame = Camera.CFrame end
    end
end)

-- === 3. ЦИКЛ АВТО-КОМБО И ОБЫЧНОГО БОЯ ===
local isExecutingCombo = false

task.spawn(function()
    while task.wait(0.1) do
        local myChar = LocalPlayer.Character
        local enemy = getClosestEnemy()

        if myChar and myChar:FindFirstChild("HumanoidRootPart") and enemy and enemy:FindFirstChild("HumanoidRootPart") and not Settings.FlyEnabled then
            local myHrp = myChar.HumanoidRootPart
            local enemyHrp = enemy.HumanoidRootPart

            -- Удержание позиции возле противника
            myHrp.CFrame = CFrame.new(enemyHrp.Position - (enemyHrp.CFrame.LookVector * 2.2), enemyHrp.Position)

            -- Логика Auto Combo
            if Settings.AutoCombo and not isExecutingCombo then
                isExecutingCombo = true
                
                -- Выполнение комбо: 4 удара M1 + Скилл 1
                for i = 1, 4 do
                    doClick()
                    task.wait(0.25)
                end
                
                useSkill(1) -- Использование первого скилла (клавиша 1)
                task.wait(0.5)
                
                isExecutingCombo = false
            -- Логика обычного Auto Fight
            elseif Settings.AutoFight and not Settings.AutoCombo then
                doClick()
            end
        end
    end
end)
