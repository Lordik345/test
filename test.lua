local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ НАСТРОЙКА КЛЮЧА ]]
local CORRECT_KEY = "Lordikhhh"

-- [[ НАСТРОЙКИ АИМБОТА ]]
local Smoothness = 0.2 -- Плавность: чем меньше, тем быстрее наводка (0.1 - быстро, 0.4 - плавно)
local AimPart = "Head"  -- Куда целиться: "Head" (голова) или "HumanoidRootPart" (тело)

local states = { 
    Fly = false, FlySpeed = 60,
    Invis = false, 
    SpeedToggle = false, WalkSpeedVal = 100,
    PushPlayers = false,
    ESP = false,
    Aimbot = false,
    Aim_FOV = 150
}

-- Удаляем старое меню, если оно было запущено ранее
if CoreGui:FindFirstChild("DeltaMegaMenu") then CoreGui.DeltaMegaMenu:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMegaMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- FOV Круг для Аимбота
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

-- [[ 1. ОКНО ВВОДА КЛЮЧА ]]
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

-- [[ 2. ГЛАВНОЕ МЕНЮ ФУНКЦИЙ ]]
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 340, 0, 420)
MainPanel.Position = UDim2.new(0.5, -170, 0.25, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainPanel.Visible = false -- Скрыто, пока не введен ключ
MainPanel.Active = true
MainPanel.Draggable = true
styleElement(MainPanel, 14, Color3.fromRGB(255, 0, 100))
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "LORD HUB VIP v4.0"
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

-- Кнопка для скрытия/открытия меню на экране
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 90, 0, 35)
ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Text = "CLOSE MENU"
ToggleMenuBtn.Visible = false -- Скрыта до ввода ключа
styleElement(ToggleMenuBtn, 8, Color3.fromRGB(255, 0, 100))
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
    ToggleMenuBtn.Text = MainPanel.Visible and "CLOSE MENU" or "OPEN MENU"
end)

-- Конструкторы элементов UI
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

-- Вспомогательная функция для проверки команд (для Аима и ESP)
local function checkIsTeammate(player)
    if not player then return false end
    if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
        return true
    elseif LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor == player.TeamColor then
        return true
    end
    return false
end

-- Вспомогательная функция проверки видимости цели за стенами
local function isPlayerVisible(targetChar)
    if not targetChar or not targetChar:FindFirstChild(AimPart) then return false end
    local castPoints = {Camera.CFrame.Position, targetChar[AimPart].Position}
    local ignoreList = {LocalPlayer.Character, targetChar}
    local parts = Camera:GetPartsObscuringTarget(castPoints, ignoreList)
    return #parts == 0
end

-- [[ ЛОГИКА ФУНКЦИОНАЛА ]]

-- 1. Режим полета (Fly)
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

-- 2. Локальная невидимость
local function setInvis(state)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then if part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0 end end
    end
end

-- 3. Box ESP (Только противники)
local function createBoxESP(player)
    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(255, 0, 100)
    box.Thickness = 1.5
    box.Filled = false
    box.Visible = false
    
    RunService.RenderStepped:Connect(function()
        if states.ESP and player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            if player ~= LocalPlayer and not checkIsTeammate(player) then
                local position, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local sizeX, sizeY = 2000 / position.Z, 3000 / position.Z
                    box.Size = Vector2.new(sizeX, sizeY)
                    box.Position = Vector2.new(position.X - sizeX / 2, position.Y - sizeY / 2)
                    box.Visible = true
                    return
                end
            end
        end
        box.Visible = false
    end)
end
for _, p in pairs(Players:GetPlayers()) do createBoxESP(p) end
Players.PlayerAdded:Connect(createBoxESP)

-- 4. Поиск ближайшего врага для Аимбота
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
                        if isPlayerVisible(player.Character) then
                            shortestDistance = distanceToCenter
                            closestTarget = player.Character[AimPart]
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Основной цикл Аимбота и FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = states.Aim_FOV
    FOVCircle.Visible = states.Aimbot
    
    if states.Aimbot then
        local target = getClosestPlayerToCenter()
        if target then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Smoothness)
        end
    end
end)

-- 5. Скорость бега
RunService.Heartbeat:Connect(function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = states.SpeedToggle and states.WalkSpeedVal or 16 end
end)

-- Создаем элементы управления в меню
createToggle("Режим полета (Fly)", false, function(s) states.Fly = s end)
createToggle("Невидимость (Локально)", false, function(s) states.Invis = s setInvis(s) end)
createToggle("Мега Скорость бега", false, function(s) states.SpeedToggle = s end)
createToggle("Включить Box ESP (Враги)", false, function(s) states.ESP = s end)
createToggle("Включить Аимбот", false, function(s) states.Aimbot = s end)
createSlider("Радиус Аима (Aim FOV)", 30, 500, 150, function(v) states.Aim_FOV = v end)

-- [[ ЛОГИКА АВТОНОМНОЙ ПРОВЕРКИ КЛЮЧА ]]
CheckKeyBtn.MouseButton1Click:Connect(function()
    local typedKey = KeyInput.Text
    
    if typedKey == CORRECT_KEY then
        -- Ключ подошел! Переключаем окна
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
    else
        -- Неправильный ввод
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "НЕВЕРНЫЙ КЛЮЧ!"
        KeyInput.PlaceholderColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
