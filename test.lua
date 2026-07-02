local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ НАСТРОЙКА КЛЮЧА ]]
local CORRECT_KEY = "Lordikhhh"

-- [[ НАСТРОЙКИ ]]
local Smoothness = 0.15 
local AimPart = "Head"

local states = { 
    Fly = false, FlySpeed = 60,
    Invis = false, 
    SpeedToggle = false, WalkSpeedVal = 100,
    ESP = false,
    Aimbot = false,
    Aim_FOV = 150,
    PushToggle = false, -- Включение отталкивания
    PushDist = 15       -- Дистанция для триггера отталкивания
}

local menuToggles = {}

if CoreGui:FindFirstChild("DeltaMegaMenu") then CoreGui.DeltaMegaMenu:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMegaMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function styleElement(element, radius, strokeColor)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = element
    if strokeColor then
        local stroke = Instance.new("UIStroke")
        stroke.Color = strokeColor
        stroke.Thickness = 1.5
        stroke.Parent = element
    end
end

-- [[ UI ОКНА ВВОДА КЛЮЧА ]]
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 300, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -150, 0.4, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
styleElement(KeyFrame, 12, Color3.fromRGB(255, 0, 100))
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "ENTER PREMIUM KEY"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 16
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 240, 0, 35)
KeyInput.Position = UDim2.new(0.5, -120, 0, 55)
KeyInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.BackgroundTransparency = 0.95
KeyInput.Text = ""
KeyInput.PlaceholderText = "Введите секретный ключ..."
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
styleElement(KeyInput, 8, Color3.fromRGB(50, 50, 60))
KeyInput.Parent = KeyFrame

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0, 140, 0, 35)
CheckKeyBtn.Position = UDim2.new(0.5, -70, 0, 110)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
CheckKeyBtn.Text = "Проверить"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.TextSize = 14
CheckKeyBtn.Font = Enum.Font.GothamBold
styleElement(CheckKeyBtn, 8)
CheckKeyBtn.Parent = KeyFrame

-- [[ UI ГЛАВНОГО МЕНЮ ]]
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 340, 0, 420)
MainPanel.Position = UDim2.new(0.5, -170, 0.25, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Draggable = true
styleElement(MainPanel, 14, Color3.fromRGB(255, 0, 100))
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "LORD HUB VIP v5.5"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, 0, 1, -50)
ScrollContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 650) -- Увеличено под новые элементы
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = MainPanel

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 110, 0, 35)
ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Text = "CLOSE MENU"
ToggleMenuBtn.Visible = false
styleElement(ToggleMenuBtn, 8, Color3.fromRGB(255, 0, 100))
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
    ToggleMenuBtn.Text = MainPanel.Visible and "CLOSE MENU" or "OPEN MENU"
end)

local QuickAimBtn = Instance.new("TextButton")
QuickAimBtn.Size = UDim2.new(0, 110, 0, 35)
QuickAimBtn.Position = UDim2.new(0.05, 0, 0.05, 42)
QuickAimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
QuickAimBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
QuickAimBtn.TextSize = 14
QuickAimBtn.Font = Enum.Font.SourceSansBold
QuickAimBtn.Text = "AIM: OFF"
QuickAimBtn.Visible = false
styleElement(QuickAimBtn, 8, Color3.fromRGB(50, 50, 60))
QuickAimBtn.Parent = ScreenGui

local function updateQuickAimVisual(isActive)
    states.Aimbot = isActive
    if isActive then
        QuickAimBtn.Text = "AIM: ON"
        QuickAimBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
        if QuickAimBtn:FindFirstChildOfClass("UIStroke") then QuickAimBtn.UIStroke.Color = Color3.fromRGB(255, 0, 100) end
    else
        QuickAimBtn.Text = "AIM: OFF"
        QuickAimBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        if QuickAimBtn:FindFirstChildOfClass("UIStroke") then QuickAimBtn.UIStroke.Color = Color3.fromRGB(50, 50, 60) end
    end
    if menuToggles["Включить Аимбот"] then
        menuToggles["Включить Аимбот"].BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
    end
end

QuickAimBtn.MouseButton1Click:Connect(function() updateQuickAimVisual(not states.Aimbot) end)

local QuickFlyBtn = Instance.new("TextButton")
QuickFlyBtn.Size = UDim2.new(0, 110, 0, 35)
QuickFlyBtn.Position = UDim2.new(0.05, 0, 0.05, 84)
QuickFlyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
QuickFlyBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
QuickFlyBtn.TextSize = 14
QuickFlyBtn.Font = Enum.Font.SourceSansBold
QuickFlyBtn.Text = "FLY: OFF"
QuickFlyBtn.Visible = false
styleElement(QuickFlyBtn, 8, Color3.fromRGB(50, 50, 60))
QuickFlyBtn.Parent = ScreenGui

local function updateQuickFlyVisual(isActive)
    states.Fly = isActive
    if isActive then
        QuickFlyBtn.Text = "FLY: ON"
        QuickFlyBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
        if QuickFlyBtn:FindFirstChildOfClass("UIStroke") then QuickFlyBtn.UIStroke.Color = Color3.fromRGB(255, 0, 100) end
    else
        QuickFlyBtn.Text = "FLY: OFF"
        QuickFlyBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        if QuickFlyBtn:FindFirstChildOfClass("UIStroke") then QuickFlyBtn.UIStroke.Color = Color3.fromRGB(50, 50, 60) end
    end
    if menuToggles["Режим полета (Fly)"] then
        menuToggles["Режим полета (Fly)"].BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
    end
end

QuickFlyBtn.MouseButton1Click:Connect(function() updateQuickFlyVisual(not states.Fly) end)

-- [[ КОНСТРУКТОРЫ ЭЛЕМЕНТОВ МЕНЮ ]]
local buttonY = 10
local function createToggle(name, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 40)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    styleElement(Frame, 8)
    Frame.Parent = ScrollContainer
    
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Position = UDim2.new(0, 12, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = name
    Text.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text.TextSize = 13
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 46, 0, 22)
    ToggleBtn.Position = UDim2.new(0.82, 0, 0.22, 0)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
    ToggleBtn.Text = ""
    styleElement(ToggleBtn, 11)
    ToggleBtn.Parent = Frame

    menuToggles[name] = ToggleBtn

    local active = default
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
        
        if name == "Включить Аимбот" then
            updateQuickAimVisual(active)
        elseif name == "Режим полета (Fly)" then
            updateQuickFlyVisual(active)
        else
            callback(active)
        end
    end)
    buttonY = buttonY + 48
end

local function createSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 55)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    styleElement(Frame, 8)
    Frame.Parent = ScrollContainer

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 0, 25)
    Text.Position = UDim2.new(0, 12, 0, 2)
    Text.BackgroundTransparency = 1
    Text.Text = name
    Text.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text.TextSize = 13
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.25, 0, 0, 25)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 2)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 0, 100)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame

    local SliderTrack = Instance.new("Frame")
    SliderTrack.Size = UDim2.new(0, 276, 0, 6)
    SliderTrack.Position = UDim2.new(0, 12, 0, 35)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    styleElement(SliderTrack, 3)
    SliderTrack.Parent = Frame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    styleElement(SliderFill, 3)
    SliderFill.Parent = SliderTrack

    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 14, 0, 14)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    styleElement(SliderButton, 7, Color3.fromRGB(255, 0, 100))
    SliderButton.Parent = SliderTrack

    local dragging = false
    local function updateSlider(input)
        local deltaX = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (deltaX * (max - min)))
        SliderFill.Size = UDim2.new(deltaX, 0, 1, 0)
        SliderButton.Position = UDim2.new(deltaX, -7, 0.5, -7)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
    buttonY = buttonY + 63
end

-- [[ ИНИЦИАЛИЗАЦИЯ ЭЛЕМЕНТОВ МЕНЮ ]]
createToggle("Включить Аимбот", states.Aimbot, function(val) states.Aimbot = val end)
createSlider("Радиус Аима (FOV)", 10, 500, states.Aim_FOV, function(val) states.Aim_FOV = val end)
createToggle("Режим полета (Fly)", states.Fly, function(val) states.Fly = val end)
createSlider("Скорость полета", 10, 200, states.FlySpeed, function(val) states.FlySpeed = val end)
createToggle("Включить ESP (Подсветка)", states.ESP, function(val) states.ESP = val end)
createToggle("Авто-Отталкивание", states.PushToggle, function(val) states.PushToggle = val val end)
createSlider("Дистанция триггера", 5, 50, states.PushDist, function(val) states.PushDist = val end)

-- [[ ЛОГИКА КЛЮЧА ]]
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
        QuickAimBtn.Visible = true
        QuickFlyBtn.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "НЕВЕРНЫЙ КЛЮЧ!"
        task.delay(2, function()
            if KeyInput then KeyInput.PlaceholderText = "Введите секретный ключ..." end
        end)
    end
end)

local function checkIsTeammate(player)
    if player == LocalPlayer then return true end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team
    end
    return false
end

-- [[ БЕЗОПАСНЫЙ ОБХОД ДЛЯ ESP (HIGHLIGHTS) ]]
local function applyBypassESP(player)
    if player == LocalPlayer then return end
    
    local function setupChar(char)
        if checkIsTeammate(player) then return end
        
        if char:FindFirstChild("LordESP_Highlight") then char.LordESP_Highlight:Destroy() end
        if char:FindFirstChild("LordESP_Gui") then char.LordESP_Gui:Destroy() end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "LordESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 100)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = char
        highlight.Enabled = states.ESP
        highlight.Parent = char

        local bGui = Instance.new("BillboardGui")
        bGui.Name = "LordESP_Gui"
        bGui.Size = UDim2.new(0, 200, 0, 50)
        bGui.AlwaysOnTop = true
        bGui.ExtentsOffset = Vector3.new(0, 3, 0)
        bGui.Adornee = char:FindFirstChild("Head")
        bGui.Enabled = states.ESP
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Parent = bGui
        bGui.Parent = char

        task.spawn(function()
            while char and char.Parent and bGui and bGui.Parent do
                if states.ESP and char:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((char.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude)
                    label.Text = player.Name .. " [" .. dist .. "m]"
                    bGui.Enabled = true
                    highlight.Enabled = true
                else
                    bGui.Enabled = false
                    highlight.Enabled = false
                end
                task.wait(0.2)
            end
        end)
    end

    if player.Character then setupChar(player.Character) end
    player.CharacterAdded:Connect(setupChar)
end

for _, p in pairs(Players:GetPlayers()) do applyBypassESP(p) end
Players.PlayerAdded:Connect(applyBypassESP)

-- [[ ПОИСК ЦЕЛИ ДЛЯ АИМА ]]
local function getClosestPlayerToCenter()
    local closestTarget, shortestDistance = nil, states.Aim_FOV
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not checkIsTeammate(player) then
            local part = player.Character:FindFirstChild(AimPart)
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if part and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                    if distanceToCenter < shortestDistance then
                        shortestDistance = distanceToCenter
                        closestTarget = part
                    end
                end
            end
        end
    end
    return closestTarget
end

-- [[ ЦИКЛ АИМБОТА ]]
RunService.RenderStepped:Connect(function()
    if states.Aimbot then
        local target = getClosestPlayerToCenter()
        if target then
            local currentCFrame = Camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, target.Position)
            Camera.CFrame = currentCFrame:Lerp(targetCFrame, Smoothness)
        end
    end
end)

-- [[ ЛОГИКА ФЛАЯ С НАСТРОЙКОЙ СКОРОСТИ ]]
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if states.Fly and root and hum then
            if not FlyBV or FlyBV.Parent ~= root then 
                FlyBV = Instance.new("BodyVelocity", root) 
                FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) 
            end
            if not FlyBG or FlyBG.Parent ~= root then 
                FlyBG = Instance.new("BodyGyro", root) 
                FlyBG.P = 9e4 
                FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) 
            end
            
            FlyBG.CFrame = Camera.CFrame
            local moveDir = hum.MoveDirection
            
            if moveDir.Magnitude > 0 then
                local lookVector = Camera.CFrame.LookVector
                local rightVector = Camera.CFrame.RightVector
                local localX = moveDir:Dot(Camera.CFrame.RightVector)
                local localZ = moveDir:Dot(Camera.CFrame.LookVector)
                FlyBV.Velocity = ((lookVector * localZ) + (rightVector * localX)).Unit * states.FlySpeed
            else
                FlyBV.Velocity = Vector3.new(0, 0, 0)
            end
        else
            if FlyBV then FlyBV:Destroy() FlyBV = nil end
            if FlyBG then FlyBG:Destroy() FlyBG = nil end
        end
    end)
end)

-- [[ ЛОГИКА АВТО-ОТТАЛКИВАНИЯ (ПОДХОДИШЬ -> ОТТАЛКИВАЕТ) ]]
RunService.Heartbeat:Connect(function()
    if not states.PushToggle then return end
    
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not checkIsTeammate(player) then
            local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
            
            if enemyRoot and enemyHum and enemyHum.Health > 0 then
                local distance = (enemyRoot.Position - myRoot.Position).Magnitude
                
                -- Если враг ближе установленной дистанции
                if distance <= states.PushDist then
                    pcall(function()
                        local direction = (enemyRoot.Position - myRoot.Position).Unit
                        local pushVelocity = (direction * 180) + Vector3.new(0, 100, 0) -- Направление отталкивания
                        
                        -- Создаем импульс движения
                        local bv = Instance.new("
