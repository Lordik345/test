_G.CorrectKey = "Lordikhhh" -- Твой ключ доступа

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local states = { 
    Fly = false, FlySpeed = 60, -- Оптимальная скорость для управления джойстиком
    Invis = false, 
    SpeedToggle = false, WalkSpeedVal = 100,
    PushPlayers = false,
    
    -- Настройки ESP
    ESP = false,
    ESP_OnlyEnemies = true,
    
    -- Настройки Аима
    Aimbot = false,
    Aim_WallCheck = true,
    Aim_FOV = 150
}

if CoreGui:FindFirstChild("DeltaMegaMenu") then CoreGui.DeltaMegaMenu:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaMegaMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Создание круга FOV для Аима
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
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
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
MainPanel.Size = UDim2.new(0, 350, 0, 480)
MainPanel.Position = UDim2.new(0.5, -175, 0.2, -240)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Draggable = true
styleElement(MainPanel, 14, Color3.fromRGB(255, 0, 100))
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 40)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "LORD HUB VIP v2.5"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 16
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, 0, 1, -45)
ScrollContainer.Position = UDim2.new(0, 0, 0, 40)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 520)
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

-- [[ КОНСТРУКТОР ТУМБЛЕРОВ ]]
local buttonY = 10
local function createToggle(name, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 310, 0, 40)
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

-- [[ ЛОГИКА ФУНКЦИЙ ЧИТА ]]

-- 1. УМНЫЙ ПОЛЕТ (Fly под камеру и джойстик)
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if states.Fly and root and hum then
        -- Если объекты полета не созданы — создаем их
        if not FlyBV or FlyBV.Parent ~= root then
            FlyBV = Instance.new("BodyVelocity", root)
            FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
        if not FlyBG or FlyBG.Parent ~= root then
            FlyBG = Instance.new("BodyGyro", root)
            FlyBG.P = 9e4
            FlyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        end
        
        -- Удерживаем вращение персонажа вслед за взглядом камеры
        FlyBG.CFrame = Camera.CFrame
        
        -- Рассчитываем вектор движения на основе наклона камеры и джойстика
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            -- Рассчитываем вектор полета: проецируем движение джойстика на CFrame камеры
            local lookVector = Camera.CFrame.LookVector
            local rightVector = Camera.CFrame.RightVector
            
            -- Получаем локальное смещение джойстика
            local localX = moveDir:Dot(workspace.CurrentCamera.CFrame.RightVector)
            local localZ = moveDir:Dot(workspace.CurrentCamera.CFrame.LookVector)
            
            -- Итоговое направление полета (включая Y координату взгляда камеры)
            local finalDirection = (lookVector * localZ) + (rightVector * localX)
            FlyBV.Velocity = finalDirection.Unit * states.FlySpeed
        else
            -- Если джойстик отпущен — идеально зависаем в воздухе
            FlyBV.Velocity = Vector3.new(0, 0, 0)
        end
    else
        -- Очистка при выключении
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

-- 3. НАСТРАИВАЕМЫЙ ESP
local function applyESP(player)
    if player == LocalPlayer then return end
    local function addHighlight(character)
        task.wait(0.2)
        local isEnemy = (LocalPlayer.Team == nil or player.Team ~= LocalPlayer.Team)
        local allowed = not states.ESP_OnlyEnemies or isEnemy
        
        if states.ESP and allowed and not character:FindFirstChild("Custom_ESP") then
            local hl = Instance.new("Highlight", character)
            hl.Name = "Custom_ESP"
            hl.FillColor = isEnemy and Color3.fromRGB(255, 0, 50) or Color3.fromRGB(0, 255, 100)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.4
        end
    end
    if player.Character then addHighlight(player.Character) end
    player.CharacterAdded:Connect(addHighlight)
end

local function updateESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local old = p.Character:FindFirstChild("Custom_ESP")
            if old then old:Destroy() end
            if states.ESP then applyESP(p) end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if states.ESP then updateESP() end
end)

-- 4. НАСТРАИВАЕМЫЙ AIMBOT
local function getClosestPlayer()
    local closestTarget = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            if player.Team and player.Team == LocalPlayer.Team then continue end
            
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                local distanceToMouse = (targetPos - mousePos).Magnitude
                
                if distanceToMouse <= states.Aim_FOV and distanceToMouse < shortestDistance then
                    if states.Aim_WallCheck then
                        local parts = Camera:GetPartsObscuringTarget({Camera.CFrame.Position, head.Position}, {LocalPlayer.Character, player.Character})
                        if #parts > 0 then continue end
                    end
                    
                    shortestDistance = distanceToMouse
                    closestTarget = head
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = states.Aim_FOV
    FOVCircle.Visible = states.Aimbot
    
    if states.Aimbot then
        local target = getClosestPlayer()
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

-- [[ ИНИЦИАЛИЗАЦИЯ ТУМБЛЕРОВ В МЕНЮ ]]
createToggle("Режим полета (Fly Joystick)", false, function(s) states.Fly = s end)
createToggle("Невидимость (Локально)", false, function(s) states.Invis = s setInvis(s) end)
createToggle("Мега Скорость бега", false, function(s) states.SpeedToggle = s end)
createToggle("Отталкивать игроков (Fling)", false, function(s) states.PushPlayers = s end)

-- Настройки ESP
createToggle("Включить подсветку (ESP)", false, function(s) states.ESP = s updateESP() end)
createToggle("ESP: Только ПРОТИВНИКИ", true, function(s) states.ESP_OnlyEnemies = s updateESP() end)

-- Настройки Аима
createToggle("Включить Аимбот (Aimbot)", false, function(s) states.Aimbot = s end)
createToggle("Аим: Проверка стен (WallCheck)", true, function(s) states.Aim_WallCheck = s end)
createToggle("Аим: Большой радиус FOV", false, function(s) states.Aim_FOV = s and 300 or 150 end)

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
