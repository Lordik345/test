_G.CorrectKey = "Lordikhhh" -- Твой ключ доступа

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local states = { 
    Fly = false, FlySpeed = 60,
    Invis = false, 
    SpeedToggle = false, WalkSpeedVal = 100,
    PushPlayers = false,
    ESP = false,
    Aimbot = false,
    Aim_FOV = 150 -- Дефолтный радиус центрального круга аима
}

if CoreGui:FindFirstChild("DeltaMegaMenu") then CoreGui.DeltaMegaMenu:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMegaMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Создание фиксированного круга FOV строго по центру экрана
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

-- [[ 1. ОКНО СИСТЕМЫ КЛЮЧА ]]
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
KeyInput.PlaceholderText = "Вставь ключ сюда..."
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
CheckKeyBtn.Text = "Вход"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.TextSize = 14
CheckKeyBtn.Font = Enum.Font.GothamBold
styleElement(CheckKeyBtn, 8)
CheckKeyBtn.Parent = KeyFrame

-- [[ 2. ГЛАВНОЕ МЕНЮ ФУНКЦИЙ ]]
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
MainTitle.Text = "LORD HUB VIP v3.5"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 16
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, 0, 1, -50)
ScrollContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = MainPanel

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 90, 0, 35)
ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Text = "OPEN MENU"
ToggleMenuBtn.Visible = false
styleElement(ToggleMenuBtn, 8, Color3.fromRGB(255, 0, 100))
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

-- [[ КОНСТРУКТОРЫ ДЛЯ МЕНЮ ]]
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

    local active = default
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
        callback(active)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    buttonY = buttonY + 63
end

-- [[ ЛОГИКА ФУНКЦИЙ ЧИТА ]]

-- 1. УМНЫЙ ПОЛЕТ (Fly под камеру и джойстик)
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
            local finalDirection = (lookVector * localZ) + (rightVector * localX)
            FlyBV.Velocity = finalDirection.Unit * states.FlySpeed
        else
            FlyBV.Velocity = Vector3.new(0, 0, 0)
        end
    else
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
    end
end)

-- 2. Невидимость
local function setInvis(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0 end
        end
    end
end

-- 3. BOX ESP (Квадратная обводка врагов)
local function createBoxESP(player)
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 100)
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if states.ESP and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            local isEnemy = (LocalPlayer.Team == nil or player.Team ~= LocalPlayer.Team)
            if isEnemy and player ~= LocalPlayer then
                local rootPart = player.Character.HumanoidRootPart
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    local sizeX = 2000 / position.Z
                    local sizeY = 3000 / position.Z
                    
                    box.Size = Vector2.new(sizeX, sizeY)
                    box.Position = Vector2.new(position.X - sizeX / 2, position.Y - sizeY / 2)
                    box.Visible = true
                    return
                end
            end
        end
        box.Visible = false
        if not player or not player.Parent then
            box:Destroy()
            conn:Disconnect()
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do createBoxESP(p) end
Players.PlayerAdded:Connect(createBoxESP)

-- 4. AIMBOT С ЦЕНТРАЛЬНЫМ НАСТРАИВАЕМЫМ FOV
local function getClosestPlayerToCenter()
    local closestTarget = nil
    local shortestDistance = math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            if player.Team and player.Team == LocalPlayer.Team then continue end
            
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local distanceToCenter = (targetPos - centerScreen).Magnitude
                
                -- Проверка: находится ли враг внутри текущего динамического радиуса FOV
                if distanceToCenter <= states.Aim_FOV and distanceToCenter < shortestDistance then
                    shortestDistance = distanceToCenter
                    closestTarget = head
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Position = centerScreen
    FOVCircle.Radius = states.Aim_FOV -- Синхронизируем радиус круга со значением из ползунка
    FOVCircle.Visible = states.Aimbot
    
    if states.Aimbot then
        local target = getClosestPlayerToCenter()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- 5. Скорость бега
RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = states.SpeedToggle and states.WalkSpeedVal or 16 end
end)

-- 6. Отталкивание
local BAMV = Instance.new("BodyAngularVelocity")
BAMV.AngularVelocity = Vector3.new(0, 99999, 0)
BAMV.MaxTorque = Vector3.new(0, math.huge, 0)
BAMV.Name = "PushForce"

RunService.Heartbeat:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root and states.PushPlayers then
        if not root:FindFirstChild("PushForce") then BAMV.Parent = root end
        root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
    elseif root and root:FindFirstChild("PushForce") then
        root.PushForce:Destroy()
    end
end)

-- [[ ИНИЦИАЛИЗАЦИЯ ТУМБЛЕРОВ И ПОЛЗУНКОВ В МЕНЮ ]]
createToggle("Режим полета (Fly Joystick)", false, function(s) states.Fly = s end)
createToggle("Невидимость (Локально)", false, function(s) states.Invis = s setInvis(s) end)
createToggle("Мега Скорость бега", false, function(s) states.SpeedToggle = s end)
createToggle("Отталкивать игроков (Fling)", false, function(s) states.PushPlayers = s end)
createToggle("Включить Box ESP (Враги)", false, function(s) states.ESP = s end)
createToggle("Включить Аимбот", false, function(s) states.Aimbot = s end)

-- Ползунок настройки радиуса FOV для Аима (Минимум: 30, Максимум: 500)
createSlider("Радиус Аима (Aim FOV)", 30, 500, 150, function(value)
    states.Aim_FOV = value
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if states.Invis then setInvis(true) end
end)

-- [[ ПРОВЕРКА КЛЮЧА ]]
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == _G.CorrectKey then
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "НЕВЕРНЫЙ КЛЮЧ!"
        KeyInput.PlaceholderColor3 = Color3.fromRGB(255, 50, 50)
        task.wait(1.5)
        KeyInput.PlaceholderText = "Вставь ключ сюда..."
        KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
    end
end)
