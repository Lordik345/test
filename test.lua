_G.CorrectKey = "Lordikhhh" -- Твой ключ доступа

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local states = { 
    Fly = false, 
    ESP = false, 
    Invis = false, 
    SpeedToggle = false,
    PushPlayers = false,
    FlySpeed = 50,
    WalkSpeedVal = 100
}

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
KeyInput.BackgroundColor3 = Color3.fromRGB(255, 255, 30)
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
MainPanel.Size = UDim2.new(0, 330, 0, 360)
MainPanel.Position = UDim2.new(0.5, -165, 0.25, -180)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Draggable = true
styleElement(MainPanel, 14, Color3.fromRGB(255, 0, 100))
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "DELTA DELUXE MENU"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 18
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

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
local buttonY = 50
local function createToggle(name, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 290, 0, 45)
    Frame.Position = UDim2.new(0, 20, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
    styleElement(Frame, 8)
    Frame.Parent = MainPanel
    
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Position = UDim2.new(0, 15, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = name
    Text.TextColor3 = Color3.fromRGB(230, 230, 230)
    Text.TextSize = 14
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 24)
    ToggleBtn.Position = UDim2.new(0.8, 0, 0.23, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleBtn.Text = ""
    styleElement(ToggleBtn, 12)
    ToggleBtn.Parent = Frame

    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(50, 50, 60)
        callback(active)
    end)

    buttonY = buttonY + 52
end

-- [[ ЛОГИКА ФУНКЦИЙ ЧИТА ]]

-- 1. Полет (Fly)
local BodyVelocity, BodyGyro
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if states.Fly and root and hum then
        if not BodyVelocity or BodyVelocity.Parent ~= root then
            BodyVelocity = Instance.new("BodyVelocity", root)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
        if not BodyGyro or BodyGyro.Parent ~= root then
            BodyGyro = Instance.new("BodyGyro", root)
            BodyGyro.P = 9e4
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        end
        BodyVelocity.Velocity = hum.MoveDirection * states.FlySpeed
        BodyGyro.CFrame = Camera.CFrame
        if hum.MoveDirection.Magnitude == 0 then BodyVelocity.Velocity = Vector3.new(0, 0.1, 0) end
    else
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    end
end)

-- 2. Невидимость (Invisibility)
local function setInvis(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if part.Name ~= "HumanoidRootPart" then part.Transparency = state and 1 or 0 end
        end
    end
end

-- 3. УМНЫЙ ESP (Только противники)
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function addHighlight(character)
        task.wait(0.3)
        -- Проверка: включен ли ESP, нет ли уже подсветки, и является ли игрок врагом
        local isEnemy = (LocalPlayer.Team == nil or player.Team ~= LocalPlayer.Team)
        
        if states.ESP and isEnemy and not character:FindFirstChild("Enemy_ESP") then
            local hl = Instance.new("Highlight", character)
            hl.Name = "Enemy_ESP"
            hl.FillColor = Color3.fromRGB(255, 0, 50) -- Красный/розовый для врагов
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.4
        end
    end
    
    if player.Character then addHighlight(player.Character) end
    player.CharacterAdded:Connect(addHighlight)
end

local function toggleESP(state)
    states.ESP = state
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local old = p.Character:FindFirstChild("Enemy_ESP")
            if old then old:Destroy() end
            if state then applyESP(p) end
        end
    end
end

-- Постоянная проверка на смену команд в реальном времени
RunService.Heartbeat:Connect(function()
    if states.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hasESP = p.Character:FindFirstChild("Enemy_ESP")
                local isEnemy = (LocalPlayer.Team == nil or p.Team ~= LocalPlayer.Team)
                
                if isEnemy and not hasESP then
                    applyESP(p)
                elseif not isEnemy and hasESP then
                    hasESP:Destroy() -- Убираем подсветку, если враг стал союзником
                end
            end
        end
    end
end)

Players.PlayerAdded:Connect(applyESP)

-- 4. Скорость бега (Speed)
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if states.SpeedToggle and hum then
        hum.WalkSpeed = states.WalkSpeedVal
    elseif hum and not states.SpeedToggle then
        if hum.WalkSpeed == states.WalkSpeedVal then hum.WalkSpeed = 16 end
    end
end)

-- 5. Отталкивание игроков (Fling / Push)
local BAMV = Instance.new("BodyAngularVelocity")
BAMV.AngularVelocity = Vector3.new(0, 99999, 0)
BAMV.MaxTorque = Vector3.new(0, math.huge, 0)
BAMV.Name = "PushForce"

RunService.Heartbeat:Connect(function()
    if states.PushPlayers then
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if not root:FindFirstChild("PushForce") then
                BAMV.Parent = root
            end
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) 
        end
    else
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("PushForce") then
            root.PushForce:Destroy()
        end
    end
end)

-- [[ ИНИЦИАЛИЗАЦИЯ КНОПОК В МЕНЮ ]]
createToggle("Режим полета (Fly)", function(s) states.Fly = s end)
createToggle("Невидимость (Локально)", function(s) states.Invis = s setInvis(s) end)
createToggle("ESP (Только ПРОТИВНИКИ)", function(s) toggleESP(s) end)
createToggle("Мега Скорость бега", function(s) states.SpeedToggle = s end)
createToggle("Отталкивать игроков (Fling)", function(s) states.PushPlayers = s end)

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
