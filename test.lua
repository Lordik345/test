-- [[ ESP СКРИПТ ДЛЯ 99 НОЧЕЙ С КЛЮЧОМ И ВКЛ/ВЫКЛ ТУМБЛЕРАМИ ]]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ НАСТРОЙКА КЛЮЧА ]]
local CORRECT_KEY = "Lordikhhh"

-- Состояния кнопок (по умолчанию все ВЫКЛЮЧЕНО)
local states = { 
    ItemsESP = false,
    ChildrenESP = false,
    BastionESP = false
}

local UI_NAME = "Nights99_Premium_Hub_v2"
if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = UI_NAME
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
KeyInput.PlaceholderText = "Введите ключ..."
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
MainPanel.Size = UDim2.new(0, 330, 0, 240)
MainPanel.Position = UDim2.new(0.5, -165, 0.35, -120)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Draggable = true
styleElement(MainPanel, 14, Color3.fromRGB(255, 0, 100))
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "99 NIGHTS PREMIUM ESP"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Size = UDim2.new(1, 0, 1, -50)
ScrollContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 200)
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.Parent = MainPanel

-- Кнопка скрыть/показать меню
local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 100, 0, 35)
ToggleMenuBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 0, 100)
ToggleMenuBtn.TextSize = 13
ToggleMenuBtn.Font = Enum.Font.GothamBold
ToggleMenuBtn.Text = "CLOSE MENU"
ToggleMenuBtn.Visible = false
styleElement(ToggleMenuBtn, 8, Color3.fromRGB(255, 0, 100))
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
    ToggleMenuBtn.Text = MainPanel.Visible and "CLOSE MENU" or "OPEN MENU"
end)

-- [[ КОНСТРУКТОР КНОПОК ВКЛ/ВЫКЛ ]]
local buttonY = 10
local function createToggle(name, stateKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 290, 0, 40)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    styleElement(Frame, 8)
    Frame.Parent = ScrollContainer
    
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(0.65, 0, 1, 0)
    Text.Position = UDim2.new(0, 12, 0, 0)
    Text.BackgroundTransparency = 1
    Text.Text = name
    Text.TextColor3 = Color3.fromRGB(220, 220, 220)
    Text.TextSize = 13
    Text.Font = Enum.Font.Gotham
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 65, 0, 26)
    ToggleBtn.Position = UDim2.new(0.74, 0, 0.18, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    ToggleBtn.Text = "ВЫКЛ"
    ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.GothamBold
    styleElement(ToggleBtn, 6)
    ToggleBtn.Parent = Frame

    -- Клик переключает состояние true / false
    ToggleBtn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        
        if states[stateKey] then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100) -- Яркий розовый при включении
            ToggleBtn.Text = "ВКЛ"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- Серый при выключении
            ToggleBtn.Text = "ВЫКЛ"
            ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)
    buttonY = buttonY + 48
end

-- [[ ЛОГИКА СИСТЕМЫ ESP ]]
local function createObjectESP(object, color, nameText, stateKey)
    if not object:IsA("Model") and not object:IsA("BasePart") then return end
    if object:FindFirstChild("NightsESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NightsESP_Highlight"
    highlight.FillColor = color
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Adornee = object
    highlight.Enabled = states[stateKey]
    highlight.Parent = object

    local bGui = Instance.new("BillboardGui")
    bGui.Name = "NightsESP_Gui"
    bGui.Size = UDim2.new(0, 150, 0, 40)
    bGui.AlwaysOnTop = true
    bGui.ExtentsOffset = Vector3.new(0, 3, 0)
    bGui.Enabled = states[stateKey]
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Text = nameText
    label.Parent = bGui
    
    local targetPart = object:IsA("BasePart") and object or (object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart"))
    if targetPart then
        bGui.Adornee = targetPart
        bGui.Parent = object
    end

    -- Этот поток постоянно проверяет, включена ли функция кнопкой
    task.spawn(function()
        while object and object.Parent and highlight and bGui do
            if states[stateKey] and targetPart then
                local dist = math.floor((targetPart.Position - Camera.CFrame.Position).Magnitude)
                label.Text = nameText .. " [" .. dist .. "m]"
                highlight.Enabled = true
                bGui.Enabled = true
            else
                -- Если в меню выключили — убираем ESP с карты полностью
                highlight.Enabled = false
                bGui.Enabled = false
            end
            task.wait(0.3)
        end
    end)
end

local function scanMap(object)
    local name = object.Name:lower()
    if name:find("child") or name:find("kid") or name:find("baby") or name:find("ребенок") then
        createObjectESP(object, Color3.fromRGB(255, 215, 0), "👶 РЕБЕНОК", "ChildrenESP")
    elseif name:find("bastion") or name:find("diamond") or name:find("бастион") then
        createObjectESP(object, Color3.fromRGB(0, 191, 255), "💎 БАСТИОН", "BastionESP")
    elseif name:find("item") or name:find("pickup") or name:find("scrap") or object:FindFirstChildOfClass("ClickDetector") then
        createObjectESP(object, Color3.fromRGB(50, 255, 50), "📦 ПРЕДМЕТ", "ItemsESP")
    end
end

workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    if obj and obj.Parent then scanMap(obj) end
end)

for _, desc in pairs(workspace:GetDescendants()) do scanMap(desc) end

-- [[ ДОБАВЛЕНИЕ КНОПОК В МЕНЮ ]]
createToggle("ESP на Предметы / Лут", "ItemsESP")
createToggle("ESP на Детей (Задания)", "ChildrenESP")
createToggle("ESP на Алмазный Бастион", "BastionESP")

-- [[ ЛОГИКА ПРОВЕРКИ КЛЮЧА ]]
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "НЕВЕРНЫЙ КЛЮЧ!"
        KeyInput.PlaceholderColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
