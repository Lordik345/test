-- [[ 99 NIGHTS MM2: ANTI-CHEAT BYPASS EDITION ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local CORRECT_KEY = "Lordikhhh"

local states = { 
    RoleESP = false,
    CoinESP = false,
    AutoCoin = false,
    Fly = false,
    SkyTP = false,     -- Новый безопасный ТП сверху
    AutoShoot = false,
    FlySpeed = 45
}

local UI_NAME = "Nights99_MM2_Bypass"
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
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
styleElement(KeyFrame, 10)
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "АКТИВАЦИЯ ОБХОДА"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 14
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 220, 0, 35)
KeyInput.Position = UDim2.new(0.5, -110, 0, 50)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ключ..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
styleElement(KeyInput, 6)
KeyInput.Parent = KeyFrame

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0, 120, 0, 35)
CheckKeyBtn.Position = UDim2.new(0.5, -60, 0, 105)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
CheckKeyBtn.Text = "Запустить"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
styleElement(CheckKeyBtn, 6)
CheckKeyBtn.Parent = KeyFrame

-- [[ ГЛАВНОЕ МЕНЮ ]]
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 310, 0, 440)
MainPanel.Position = UDim2.new(0.5, -155, 0.3, -220)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainPanel.Visible = false
styleElement(MainPanel, 12)
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "99 NIGHTS MM2 BYPASS"
MainTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
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
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Text = "СКРЫТЬ"
ToggleMenuBtn.Visible = false
styleElement(ToggleMenuBtn, 6)
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
    ToggleMenuBtn.Text = MainPanel.Visible and "СКРЫТЬ" or "МЕНЮ"
end)

local buttonY = 5
local function createToggle(name, stateKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 35)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
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
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleBtn.Text = "ВЫКЛ"
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.TextSize = 10
    styleElement(ToggleBtn, 4)
    ToggleBtn.Parent = Frame

    ToggleBtn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        ToggleBtn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 60)
        ToggleBtn.Text = states[stateKey] and "ВКЛ" or "ВЫКЛ"
    end)
    buttonY = buttonY + 42
end

-- [[ АНТИ-ЧИТ ОБХОД: ПОИСК УБИЙЦЫ ]]
local function getMurderer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            -- Ищем нож даже если он спрятан (проверка по геймплейным тегам MM2)
            if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") or plr.Character:FindFirstChild("GlassKnife") then
                return plr
            end
        end
    end
    -- Запасной поиск по имени, если игра маскирует рюкзак
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("Knife") then return plr end
    end
    return nil
end

-- [[ БЕЗОПАСНАЯ АТАКУЮЩАЯ СТРАТЕГИЯ ]]
local function executeSkyShot()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local gun = myChar and myChar:FindFirstChild("Gun")
    
    if myRoot and gun then
        local murderer = getMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            local mudRoot = murderer.Character.HumanoidRootPart
            local oldCFrame = myRoot.CFrame
            
            -- Вместо резкого ТП плавно "роняем" персонажа над головой убийцы (Античит это пропускает)
            local skyPos = mudRoot.CFrame * CFrame.new(0, 8, 0) -- Высота 8 блоков (нож не достанет)
            
            myRoot.CFrame = skyPos
            task.wait(0.1)
            
            -- Принудительный клик ремноута
            local remote = gun:FindFirstChildOfClass("RemoteFunction") or gun:FindFirstChildOfClass("RemoteEvent") or gun:FindFirstChild("ShootGun")
            if remote then
                if remote:IsA("RemoteFunction") then
                    remote:InvokeServer(mudRoot.Position)
                else
                    remote:FireServer(mudRoot.Position)
                end
            end
            
            task.wait(0.1)
            myRoot.CFrame = oldCFrame -- Возврат
        end
    end
end

-- [[ АВТО-КЛИКЕР ПРИ ВКЛЮЧЕНИИ ФУНКЦИИ ]]
task.spawn(function()
    while true do
        if states.SkyTP and states.AutoShoot then
            executeSkyShot()
            task.wait(1.8) -- Безопасный интервал, чтобы не кикнуло за флуд ТП
        end
        task.wait(0.5)
    end
end)

-- [[ СИСТЕМА ФЛАЙ ]]
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

-- [[ КНОПКА: СЛЕДОВАТЬ ЗА ПИСТОЛЕТОМ ]]
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
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj.Name == "GunDrop" or obj.Name == "Gun") and obj:IsA("BasePart") then
                myRoot.CFrame = obj.CFrame * CFrame.new(0, 2, 0)
                break
            end
        end
    end)
    buttonY = buttonY + 42
end

-- [[ ОТОБРАЖЕНИЕ ESP ]]
task.spawn(function()
    while true do
        if states.RoleESP then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local root = plr.Character.HumanoidRootPart
                    local esp = root:FindFirstChild("MM2_ESP")
                    if not esp then
                        esp = Instance.new("BillboardGui", root)
                        esp.Name = "MM2_ESP"
                        esp.Size = UDim2.new(0, 100, 0, 30)
                        esp.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", esp)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.TextSize = 11
                        lbl.Font = Enum.Font.GothamBold
                    end
                    
                    if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then
                        esp.TextLabel.Text = plr.Name .. " [🔪 МАРДЕР]"
                        esp.TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then
                        esp.TextLabel.Text = plr.Name .. " [⭐ ШЕРИФ]"
                        esp.TextLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
                    else
                        esp.TextLabel.Text = plr.Name .. " [Мирный]"
                        esp.TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                    end
                    esp.Enabled = true
                end
            end
        end
        task.wait(1)
    end
end)

-- Инициализация интерфейса меню
createToggle("ВХ на игроков (Роли)", "RoleESP")
createToggle("⚡ Безопасный ТП сверху (SkyAttack)", "SkyTP")
createToggle("🤖 Авто-атака из воздуха", "AutoShoot")
createToggle("Включить Полет (Fly)", "Fly")
createActionButton("⚡ ТЕЛЕПОРТ К УПАВШЕМУ ПИСТОЛЕТУ")

CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
    else
        KeyInput.Text = "ОШИБКА!"
        task.wait(1)
        KeyInput.Text = ""
    end
end)
