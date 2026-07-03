-- [[ 99 NIGHTS MM2: SILENT AIM & AUTO-SHOOT EDITION ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- КЛЮЧ
local CORRECT_KEY = "Lordikhhh"

local states = { 
    RoleESP = false,
    CoinESP = false,
    AutoCoin = false,
    Fly = false,
    SilentAim = false,  -- Убийство при промахе
    AutoShoot = false,  -- Автоматический выстрел
    FlySpeed = 45
}

local UI_NAME = "Nights99_MM2_GodMode"
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild(UI_NAME) then PlayerGui[UI_NAME]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local function styleElement(element, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = element
end

-- [[ ОКНО КЛЮЧА ]]
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 280, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -140, 0.4, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
styleElement(KeyFrame, 10)
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "ВВЕДИТЕ КЛЮЧ"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 14
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 220, 0, 35)
KeyInput.Position = UDim2.new(0.5, -110, 0, 50)
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ключ тут..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
styleElement(KeyInput, 6)
KeyInput.Parent = KeyFrame

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0, 120, 0, 35)
CheckKeyBtn.Position = UDim2.new(0.5, -60, 0, 105)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
CheckKeyBtn.Text = "Войти"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
styleElement(CheckKeyBtn, 6)
CheckKeyBtn.Parent = KeyFrame

-- [[ ОКНО ПРИВЕТСТВИЯ ]]
local WelcomeFrame = Instance.new("Frame")
WelcomeFrame.Size = UDim2.new(0, 300, 0, 130)
WelcomeFrame.Position = UDim2.new(0.5, -150, 0.4, -65)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
WelcomeFrame.Visible = false
styleElement(WelcomeFrame, 12)
WelcomeFrame.Parent = ScreenGui

local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Size = UDim2.new(1, 0, 0, 50)
WelcomeTitle.Position = UDim2.new(0, 0, 0, 15)
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Text = "SILENT AIM & AUTO-FIRE ЗАГРУЖЕНЫ!"
WelcomeTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
WelcomeTitle.TextSize = 14
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.TextWrapped = true
WelcomeTitle.Parent = WelcomeFrame

local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, 0, 0, 30)
CreatorLabel.Position = UDim2.new(0, 0, 0, 65)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Создатель: Lordikhhh"
CreatorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreatorLabel.TextSize = 13
CreatorLabel.Font = Enum.Font.Gotham
CreatorLabel.Parent = WelcomeFrame

-- [[ ГЛАВНОЕ МЕНЮ ]]
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 310, 0, 440)
MainPanel.Position = UDim2.new(0.5, -155, 0.3, -220)
MainPanel.BackgroundColor3 = Color3.fromRGB(18, 15, 15)
MainPanel.Visible = false
styleElement(MainPanel, 12)
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "99 NIGHTS MM2 V4"
MainTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, 0, 1, -55)
SettingsScroll.Position = UDim2.new(0, 0, 0, 45)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 430)
SettingsScroll.ScrollBarThickness = 3
SettingsScroll.Parent = MainPanel

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 90, 0, 30)
ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 50)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Text = "СКРЫТЬ"
ToggleMenuBtn.Visible = false
styleElement(ToggleMenuBtn, 6)
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
    ToggleMenuBtn.Text = MainPanel.Visible and "СКРЫТЬ" or "МЕНЮ"
end)

-- [[ КОНСТРУКТОР ЭЛЕМЕНТОВ МЕНЮ ]]
local buttonY = 5
local function createToggle(name, stateKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 35)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 25, 25)
    styleElement(Frame, 6)
    Frame.Parent = SettingsScroll
    
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Position = UDim2.new(0, 10, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = name
    Text.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text.TextSize = 12
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 60, 0, 24)
    ToggleBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 60, 60)
    ToggleBtn.Text = "ВЫКЛ"
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.TextSize = 10
    styleElement(ToggleBtn, 4)
    ToggleBtn.Parent = Frame

    ToggleBtn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        ToggleBtn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(200, 0, 50) or Color3.fromRGB(70, 60, 60)
        ToggleBtn.Text = states[stateKey] and "ВКЛ" or "ВЫКЛ"
    end)
    buttonY = buttonY + 42
end

-- [[ НАСТРОЙКА СКОРОСТИ ПОЛЕТА ]]
local function createSpeedControl()
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 35)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 25, 25)
    styleElement(Frame, 6)
    Frame.Parent = SettingsScroll

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.5, 0, 1, 0)
    Text.Position = UDim2.new(0, 10, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = "Скорость полета"
    Text.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text.TextSize = 12
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local SpeedValueLabel = Instance.new("TextLabel")
    SpeedValueLabel.Size = UDim2.new(0, 40, 0, 24)
    SpeedValueLabel.Position = UDim2.new(0.62, 0, 0.15, 0)
    SpeedValueLabel.BackgroundTransparency = 1
    SpeedValueLabel.Text = tostring(states.FlySpeed)
    SpeedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedValueLabel.TextSize = 12
    SpeedValueLabel.Font = Enum.Font.GothamBold
    SpeedValueLabel.Parent = Frame

    local MinusBtn = Instance.new("TextButton")
    MinusBtn.Size = UDim2.new(0, 25, 0, 24)
    MinusBtn.Position = UDim2.new(0.52, 0, 0.15, 0)
    MinusBtn.BackgroundColor3 = Color3.fromRGB(70, 60, 60)
    MinusBtn.Text = "-"
    MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    styleElement(MinusBtn, 4)
    MinusBtn.Parent = Frame

    local PlusBtn = Instance.new("TextButton")
    PlusBtn.Size = UDim2.new(0, 25, 0, 24)
    PlusBtn.Position = UDim2.new(0.78, 0, 0.15, 0)
    PlusBtn.BackgroundColor3 = Color3.fromRGB(70, 60, 60)
    PlusBtn.Text = "+"
    PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    styleElement(PlusBtn, 4)
    PlusBtn.Parent = Frame

    MinusBtn.MouseButton1Click:Connect(function()
        if states.FlySpeed > 10 then
            states.FlySpeed = states.FlySpeed - 5
            SpeedValueLabel.Text = tostring(states.FlySpeed)
        end
    end)

    PlusBtn.MouseButton1Click:Connect(function()
        if states.FlySpeed < 150 then
            states.FlySpeed = states.FlySpeed + 5
            SpeedValueLabel.Text = tostring(states.FlySpeed)
        end
    end)

    buttonY = buttonY + 42
end

-- [[ КНОПКА ДЛЯ ТЕЛЕПОРТА К ПИСТОЛЕТУ ]]
local function createActionButton(name)
    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(0, 280, 0, 35)
    ActionBtn.Position = UDim2.new(0, 15, 0, buttonY)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    ActionBtn.Text = name
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.TextSize = 11
    styleElement(ActionBtn, 6)
    ActionBtn.Parent = SettingsScroll

    ActionBtn.MouseButton1Click:Connect(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        
        local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
        if gunDrop and gunDrop:IsA("BasePart") then
            myRoot.CFrame = gunDrop.CFrame * CFrame.new(0, 2, 0)
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "GunDrop" and obj:IsA("BasePart") then
                    myRoot.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                    break
                end
            end
        end
    end)
    buttonY = buttonY + 42
end

-- [[ ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ПОИСКА РОЛЕЙ ]]
local function getMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then
                return plr
            end
        end
    end
    return nil
end

local function getPlayerRole(plr)
    if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
        return "Murderer", Color3.fromRGB(255, 0, 50)
    elseif plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun")) then
        return "Sheriff", Color3.fromRGB(0, 150, 255)
    end
    return "Innocent", Color3.fromRGB(50, 255, 50)
end

-- [[ МОДИФИКАЦИЯ СТРЕЛЬБЫ (SILENT AIM / СТРЕЛЬБА МИМО) ]]
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if states.SilentAim and method == "InvokeServer" and tostring(self) == "ShootGun" then
        local murderer = getMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            -- Перехватываем направление выстрела и подменяем координаты на торс Убийцы
            args[2] = murderer.Character.HumanoidRootPart.Position
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

-- [[ АВТО-СТРЕЛЬБА ]]
task.spawn(function()
    while true do
        if states.AutoShoot then
            local myChar = LocalPlayer.Character
            local gun = myChar and myChar:FindFirstChild("Gun")
            
            if gun and gun:FindFirstChild("KnifeScript") then -- Проверка структуры оружия в MM2
                local murderer = getMurderer()
                if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Если включен также и SilentAim, клик уйдет точно в него, даже если мы смотрим в стену
                    local targetPos = murderer.Character.HumanoidRootPart.Position
                    gun.KnifeScript.OnServerInvoke:InvokeServer(targetPos)
                    task.wait(1) -- Задержка между выстрелами, чтобы избежать серверного кика
                end
            end
        end
        task.wait(0.2)
    end
end)

-- [[ СИСТЕМА ФЛАЙ (ПОЛЕТ) ]]
local FlyBV
RunService.RenderStepped:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if states.Fly and root and hum then
        if not FlyBV or FlyBV.Parent ~= root then
            FlyBV = Instance.new("BodyVelocity", root)
            FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
        if hum.MoveDirection.Magnitude > 0 then 
            FlyBV.Velocity = Camera.CFrame.LookVector * states.FlySpeed 
        else 
            FlyBV.Velocity = Vector3.new(0, 0, 0) 
        end
    else
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
    end
end)

-- [[ ESP НА РОЛИ ]]
task.spawn(function()
    while true do
        if states.RoleESP then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root = plr.Character.HumanoidRootPart
                    local roleName, roleColor = getPlayerRole(plr)
                    
                    local esp = root:FindFirstChild("MM2_ESP")
                    if not esp then
                        esp = Instance.new("BillboardGui", root)
                        esp.Name = "MM2_ESP"
                        esp.Size = UDim2.new(0, 100, 0, 30)
                        esp.AlwaysOnTop = true
                        esp.ExtentsOffset = Vector3.new(0, 3, 0)
                        
                        local lbl = Instance.new("TextLabel", esp)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextSize = 12
                        lbl.Font = Enum.Font.GothamBold
                    end
                    esp.TextLabel.TextColor3 = roleColor
                    esp.TextLabel.Text = plr.Name .. " [" .. roleName .. "]"
                    esp.Enabled = true
                end
            end
        else
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character.HumanoidRootPart:FindFirstChild("MM2_ESP") then
                    plr.Character.HumanoidRootPart.MM2_ESP.Enabled = false
                end
            end
        end
        task.wait(1)
    end
end)

-- [[ ESP НА МОНЕТЫ И АВТО-СБОР ]]
task.spawn(function()
    while true do
        if states.CoinESP or states.AutoCoin then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name == "Coin_Container" or obj.Name == "CandyContainer" then
                    for _, coin in pairs(obj:GetChildren()) do
                        if coin:IsA("BasePart") then
                            if states.CoinESP and not coin:FindFirstChild("Coin_ESP") then
                                local bGui = Instance.new("BillboardGui", coin)
                                bGui.Name = "Coin_ESP"
                                bGui.Size = UDim2.new(0, 50, 0, 20)
                                bGui.AlwaysOnTop = true
                                
                                local lbl = Instance.new("TextLabel", bGui)
                                lbl.Size = UDim2.new(1, 0, 1, 0)
                                lbl.BackgroundTransparency = 1
                                lbl.Text = "🪙"
                                lbl.TextSize = 14
                            end
                            
                            if states.AutoCoin and myRoot and (coin.Position - myRoot.Position).Magnitude < 150 then
                                myRoot.CFrame = coin.CFrame
                                task.wait(0.3)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- [[ ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА ]]
createToggle("Показывать Роли (Wallhack)", "RoleESP")
createToggle("🎯 Silent Aim (Попадание при промахе)", "SilentAim")
createToggle("🤖 Авто-стрельба в Убийцу", "AutoShoot")
createToggle("Подсветка монет", "CoinESP")
createToggle("Плавный авто-сбор монет", "AutoCoin")
createToggle("Включить Полет (Fly)", "Fly")
createSpeedControl()
createActionButton("🎯 ЗАБРАТЬ ПИСТОЛЕТ ШЕРИФА")

-- ЛОГИКА КЛЮЧА
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        WelcomeFrame.Visible = true
        task.wait(2)
        WelcomeFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
    else 
        KeyInput.Text = "НЕВЕРНО!"
        task.wait(1)
        KeyInput.Text = "" 
    end
end)
