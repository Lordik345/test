-- [[ БИБЛИОТЕКА ИНТЕРФЕЙСА И НАСТРОЙКИ ]]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Переменные состояний
local _G = {
    FlyEnabled = false,
    ESPEnabled = false,
    InvisEnabled = false,
    FlySpeed = 50
}

-- Удаление старого меню, если скрипт перезапускается
if CoreGui:FindFirstChild("DeltaCustomMenu") then
    CoreGui.DeltaCustomMenu:Destroy()
end

-- [[ СОЗДАНИЕ КРАСИВОГО GUI ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCustomMenu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Кнопка Скрыть/Показать меню (для мобилок)
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 80, 0, 35)
ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(180, 100, 255)
ToggleMenuBtn.TextSize = 14
ToggleMenuBtn.Font = Enum.Font.SourceSansBold
ToggleMenuBtn.Text = "MENU"
ToggleMenuBtn.Parent = ScreenGui

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 8)
UICornerBtn.Parent = ToggleMenuBtn

-- Главная панель меню
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 320, 0, 260)
MainPanel.Position = UDim2.new(0.35, 0, 0.25, 0)
MainPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainPanel.BorderSizePixel = 0
MainPanel.Active = true
MainPanel.Draggable = true -- Можно перетаскивать пальцем по экрану
MainPanel.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainPanel

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(140, 60, 255) -- Фиолетовое неоновое свечение
MainStroke.Thickness = 2
MainStroke.Parent = MainPanel

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "DELTA CHEATS v1.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainPanel

-- Логика кнопки Скрыть/Показать
ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

-- [[ ФУНКЦИЯ ДЛЯ СОЗДАНИЯ КРАСИВЫХ КНОПОК-ПЕРЕКЛЮЧАТЕЛЕЙ (TOGGLES) ]]
local buttonY = 55
local function createToggle(name, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 280, 0, 45)
    Frame.Position = UDim2.new(0, 20, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Parent = MainPanel
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 8)
    FrameCorner.Parent = Frame

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.7, 0, 1, 0)
    Text.Position = UDim2.new(0, 15, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = name
    Text.TextColor3 = Color3.fromRGB(200, 200, 200)
    Text.TextSize = 15
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
    ToggleBtn.Position = UDim2.new(0.8, 0, 0.22, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = Frame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleBtn

    local state = false
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(140, 60, 255) -- Включен (Фиолетовый)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)  -- Выключен (Серый)
        end
        callback(state)
    end)

    buttonY = buttonY + 55
end


-- [[ СИСТЕМА ФУНКЦИЙ (ЛОГИКА ЧИТОВ) ]]

-- 1. ПОЛЕТ (Fly)
local BodyVelocity, BodyGyro
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if _G.FlyEnabled and root and hum then
        if not BodyVelocity or BodyVelocity.Parent ~= root then
            BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Parent = root
        end
        if not BodyGyro or BodyGyro.Parent ~= root then
            BodyGyro = Instance.new("BodyGyro")
            BodyGyro.P = 9e4
            BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            BodyGyro.Parent = root
        end

        BodyVelocity.Velocity = hum.MoveDirection * _G.FlySpeed
        BodyGyro.CFrame = Camera.CFrame

        if hum.MoveDirection.Magnitude == 0 then
            BodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
        end
    else
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    end
end)

-- 2. НЕВИДИМОСТЬ (Invisibility)
local function updateInvis(state)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            if part.Name ~= "HumanoidRootPart" then
                part.Transparency = state and 1 or 0
            end
        end
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if _G.InvisEnabled then updateInvis(true) end
end)

-- 3. ESP (Подсветка игроков)
local function applyESP(player)
    if player == LocalPlayer then return end
    
    local function addHighlight(character)
        task.wait(0.2)
        if _G.ESPEnabled and not character:FindFirstChild("MenuESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "MenuESP"
            highlight.FillColor = Color3.fromRGB(140, 60, 255) -- В цвет меню
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.4
            highlight.Adornee = character
            highlight.Parent = character
        end
    end

    if player.Character then addHighlight(player.Character) end
    player.CharacterAdded:Connect(addHighlight)
end

-- Обновление ESP при включении/выключении тумблера
local function toggleESP(state)
    _G.ESPEnabled = state
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            local oldESP = player.Character:FindFirstChild("MenuESP")
            if oldESP then oldESP:Destroy() end
            
            if state then
                applyESP(player)
            end
        end
    end
end

Players.PlayerAdded:Connect(applyESP)


-- [[ ИНИЦИАЛИЗАЦИЯ ТУМБЛЕРОВ В МЕНЮ ]]

createToggle("Включить Полет (Fly)", function(state)
    _G.FlyEnabled = state
end)

createToggle("Невидимость (Локально)", function(state)
    _G.InvisEnabled = state
    updateInvis(state)
end)

createToggle("Подсветка игроков (ESP)", function(state)
    toggleESP(state)
end)
