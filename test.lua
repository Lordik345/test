local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ НАСТРОЙКА КЛЮЧА ]]
local CORRECT_KEY = "Lordikhhh"

-- [[ НАСТРОЙКИ ]]
local Smoothness = 0.08 -- Скорость доводки аима под Rivals
local AimPart = "Head"

local states = { 
    Fly = false, FlySpeed = 60,
    Invis = false, 
    SpeedToggle = false, WalkSpeedVal = 100,
    ESP = false,
    Aimbot = false,
    Aim_FOV = 180
}

local menuToggles = {}
local espObjects = {} -- Хранилище объектов отрисовки ESP

-- Удаляем старое меню
if CoreGui:FindFirstChild("DeltaMegaMenu") then CoreGui.DeltaMegaMenu:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMegaMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- FOV Круг
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 100)
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = states.Aim_FOV
FOVCircle.Filled = false
FOVCircle.Visible = false

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
MainTitle.Text = "LORD HUB VIP v4.0 (RIVALS SUITE)"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, 0, 1, -50)
ScrollContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = MainPanel

-- Кнопка открытия/закрытия меню
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 90, 0, 35)
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

-- [[ БЫСТРАЯ КНОПКА АИМА НА ЭКРАНЕ ]]
local QuickAimBtn = Instance.new("TextButton")
QuickAimBtn.Size = UDim2.new(0, 90, 0, 35)
QuickAimBtn.Position = UDim2.new(0.05, 0, 0.05, 42) -- Под кнопкой меню
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
        QuickAimBtn.UIStroke.Color = Color3.fromRGB(255, 0, 100)
    else
        QuickAimBtn.Text = "AIM: OFF"
        QuickAimBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        QuickAimBtn.UIStroke.Color = Color3.fromRGB(50, 50, 60)
    end
    if menuToggles["Включить Аимбот"] then
        menuToggles["Включить Аимбот"].BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
    end
end

QuickAimBtn.MouseButton1Click:Connect(function()
    updateQuickAimVisual(not states.Aimbot)
end)

-- [[ НОВАЯ БЫСТРАЯ КНОПКА ФЛАЯ НА ЭКРАНЕ ]]
local QuickFlyBtn = Instance.new("TextButton")
QuickFlyBtn.Size = UDim2.new(0, 90, 0, 35)
QuickFlyBtn.Position = UDim2.new(0.05, 0, 0.05, 84) -- Под кнопкой аима
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
        QuickFlyBtn.UIStroke.Color = Color3.fromRGB(255, 0, 100)
    else
        QuickFlyBtn.Text = "FLY: OFF"
        QuickFlyBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        QuickFlyBtn.UIStroke.Color = Color3.fromRGB(50, 50, 60)
    end
    if menuToggles["Режим полета (Fly)"] then
        menuToggles["Режим полета (Fly)"].BackgroundColor3 = isActive and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
    end
end

QuickFlyBtn.MouseButton1Click:Connect(function()
    updateQuickFlyVisual(not states.Fly)
end)


-- [[ КОНСТРУКТОРЫ UI ЭЛЕМЕНТОВ МЕНЮ ]]
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

-- [[ ПРОВЕКА КОМАНД ДЛЯ RIVALS ]]
local function checkIsTeammate(player)
    if player == LocalPlayer then return true end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team
    end
    return false
end

-- [[ ИНИЦИАЛИЗАЦИЯ И СИСТЕМА ESP ДЛЯ RIVALS ]]
local function createESP(player)
    if espObjects[player] then return end
    
    local drawings = {
        Box = Drawing.new("Square"),
        Name = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthBarBg = Drawing.new("Square")
    }
    
    drawings.Box.Thickness = 1.5
    drawings.Box.Filled = false
    drawings.Box.Color = Color3.fromRGB(255, 0, 100)
    
    drawings.Name.Size = 13
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Color = Color3.fromRGB(255, 255, 255)
    
    drawings.HealthBarBg.Filled = true
    drawings.HealthBarBg.Color = Color3.fromRGB(30, 30, 35)
    
    drawings.HealthBar.Filled = true
    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 100)
    
    espObjects[player] = drawings
end

local function removeESP(player)
    if espObjects[player] then
        for _, drawing in pairs(espObjects[player]) do
            drawing:Destroy()
        end
        espObjects[player] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

-- Основной отрисовщик ESP и Аимбота
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = states.Aim_FOV
    FOVCircle.Visible = states.Aimbot
    
    for player, drawings in pairs(espObjects) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if states.ESP and char and root and hum and hum.Health > 0 and player ~= LocalPlayer and not checkIsTeammate(player) then
            local topPos, topOnScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
            local botPos, botOnScreen = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.8, 0))
            
            if topOnScreen and botOnScreen then
                local height = math.abs(topPos.Y - botPos.Y)
                local width = height * 0.55
                
                drawings.Box.Size = Vector2.new(width, height)
                drawings.Box.Position = Vector2.new(topPos.X - width / 2, topPos.Y)
                drawings.Box.Visible = true
                
                drawings.Name.Text = player.Name .. " [" .. math.floor(root.Position - Camera.CFrame.Position).Magnitude .. "m]"
                drawings.Name.Position = Vector2.new(topPos.X, topPos.Y - 17)
                drawings.Name.Visible = true
                
                local barWidth = 3
                local barHeight = height
                local barX = (topPos.X - width / 2) - 6
                
                drawings.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
                drawings.HealthBarBg.Position = Vector2.new(barX, topPos.Y)
                drawings.HealthBarBg.Visible = true
                
                local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                drawings.HealthBar.Size = Vector2.new(barWidth, barHeight * healthRatio)
                drawings.HealthBar.Position = Vector2.new(barX, topPos.Y + (barHeight * (1 - healthRatio)))
                drawings.HealthBar.Visible = true
                
                drawings.HealthBar.Color = Color3.fromHSV(healthRatio * 0.35, 1, 1)
                continue
            end
        end
        for _, drawing in pairs(drawings) do drawing.Visible = false end
    end
end)

-- [[ ЛОГИКА АИМБОТА ]]
local function getClosestPlayerToCenter()
    local closestTarget, shortestDistance = nil, math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            if not checkIsTeammate(player) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
                if onScreen then
                    local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                    if distanceToCenter <= states.Aim_FOV and distanceToCenter < shortestDistance then
                        shortestDistance = distanceToCenter
                        closestTarget = player.Character[AimPart]
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    if states.Aimbot then
        local target = getClosestPlayerToCenter()
        if target then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Smoothness)
        end
    end
end)

-- Логика полета (Fly)
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if states.Fly and root and hum then
        if not FlyBV or FlyBV.Parent ~= root then FlyBV = Instance.new("BodyVelocity", root) FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge) end
        if not FlyBG or FlyBG.Parent ~= root then FlyBG = Instance.new("BodyGyro", root) FlyBG.P = 9e4 FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) end
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

-- Невидимость
local function setInvis(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then if part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0 end end
    end
end

-- Скорость ходьбы
RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = states.SpeedToggle and states.WalkSpeedVal or 16 end
end)

-- Создание кнопок меню
createToggle("Режим полета (Fly)", false, function(active) updateQuickFlyVisual(active) end)
createToggle("Невидимость (Локально)", false, function(s) states.Invis = s setInvis(s) end)
createToggle("Мега Скорость бега", false, function(s) states.SpeedToggle = s end)
createToggle("Включить Box ESP (Враги)", false, function(s) states.ESP = s end)
createToggle("Включить Аимбот", false, function(active) updateQuickAimVisual(active) end)
createSlider("Радиус Аима (Aim FOV)", 30, 500, 180, function(v) states.Aim_FOV = v end)

-- Проверка локального ключа
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Vis
