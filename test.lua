-- [[ 99 NIGHTS PREMIUM HUD: STRICT CHILDREN EDITION ]]
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ НАСТРОЙКА КЛЮЧА ]]
local CORRECT_KEY = "Lordikhhh"

local states = { 
    ItemsESP = false,
    ChildrenESP = false,
    BastionESP = false,
    Fly = false,
    FlySpeed = 50
}

local UI_NAME = "Nights99_Strict_Hub"
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
MainPanel.Size = UDim2.new(0, 340, 0, 420)
MainPanel.Position = UDim2.new(0.5, -170, 0.3, -210)
MainPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
MainPanel.Visible = false
MainPanel.Active = true
MainPanel.Draggable = true
styleElement(MainPanel, 14, Color3.fromRGB(255, 0, 100))
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 45)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "99 NIGHTS STRICT HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, 0, 0, 210)
SettingsScroll.Position = UDim2.new(0, 0, 0, 45)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
SettingsScroll.ScrollBarThickness = 4
SettingsScroll.Parent = MainPanel

local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 310, 0, 2)
Line.Position = UDim2.new(0, 15, 0, 260)
Line.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Line.BorderSizePixel = 0
Line.Parent = MainPanel

local TpSectionTitle = Instance.new("TextLabel")
TpSectionTitle.Size = UDim2.new(1, 0, 0, 25)
TpSectionTitle.Position = UDim2.new(0, 15, 0, 268)
TpSectionTitle.BackgroundTransparency = 1
TpSectionTitle.Text = "СПИСОК ДЕТЕЙ ДЛЯ ЗАДАНИЯ:"
TpSectionTitle.TextColor3 = Color3.fromRGB(255, 0, 100)
TpSectionTitle.TextSize = 11
TpSectionTitle.Font = Enum.Font.GothamBold
TpSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
TpSectionTitle.Parent = MainPanel

local TpButtonsContainer = Instance.new("ScrollingFrame")
TpButtonsContainer.Size = UDim2.new(1, 0, 0, 115)
TpButtonsContainer.Position = UDim2.new(0, 0, 0, 295)
TpButtonsContainer.BackgroundTransparency = 1
TpButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 120)
TpButtonsContainer.ScrollBarThickness = 4
TpButtonsContainer.Parent = MainPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TpButtonsContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = TpButtonsContainer
UIPadding.PaddingLeft = UDim.new(0, 15)
UIPadding.PaddingTop = UDim.new(0, 2)

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

-- [[ КОНСТРУКТОРЫ КНОПОК И СЛАЙДЕРОВ ]]
local buttonY = 10
local function createToggle(name, stateKey)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 290, 0, 40)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    styleElement(Frame, 8)
    Frame.Parent = SettingsScroll
    
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

    ToggleBtn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        if states[stateKey] then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
            ToggleBtn.Text = "ВКЛ"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            ToggleBtn.Text = "ВЫКЛ"
            ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
    end)
    buttonY = buttonY + 48
end

local function createSlider(name, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 290, 0, 55)
    Frame.Position = UDim2.new(0, 15, 0, buttonY)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    styleElement(Frame, 8)
    Frame.Parent = SettingsScroll

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
    SliderTrack.Size = UDim2.new(0, 266, 0, 6)
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

-- [[ СИСТЕМА ДИНАМИЧЕСКИХ КНОПОК ]]
local childrenData = {}
local childCounter = 0

local function updateTpListLayout()
    local count = 0
    for _ in pairs(childrenData) do count = count + 1 end
    TpButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, count * 36)
end

local function removeChildFromMenu(object)
    if childrenData[object] then
        if childrenData[object].Button then childrenData[object].Button:Destroy() end
        childrenData[object] = nil
        updateTpListLayout()
    end
end

local function addChildToMenu(object, rootPart)
    if childrenData[object] then return end
    childCounter = childCounter + 1
    local currentNum = childCounter

    local TpBtn = Instance.new("TextButton")
    TpBtn.Size = UDim2.new(0, 290, 0, 30)
    TpBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    TpBtn.Text = "👶 Ребёнок №" .. currentNum .. " [Расчет...]"
    TpBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    TpBtn.TextSize = 12
    TpBtn.Font = Enum.Font.GothamBold
    styleElement(TpBtn, 6, Color3.fromRGB(255, 0, 100))
    TpBtn.Parent = TpButtonsContainer

    childrenData[object] = { Root = rootPart, Button = TpBtn }
    updateTpListLayout()

    TpBtn.MouseButton1Click:Connect(function()
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot and rootPart and rootPart.Parent then
            myRoot.CFrame = rootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end)

    task.spawn(function()
        while object and object.Parent and rootPart and TpBtn do
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local dist = math.floor((rootPart.Position - myRoot.Position).Magnitude)
                TpBtn.Text = "👶 Ребёнок №" .. currentNum .. " [" .. dist .. "м]"
            end
            task.wait(0.5)
        end
        removeChildFromMenu(object)
    end)
end

-- [[ СИСТЕМА СТРОГОГО ESP ]]
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

    task.spawn(function()
        while object and object.Parent and highlight and bGui do
            if states[stateKey] and targetPart then
                local dist = math.floor((targetPart.Position - Camera.CFrame.Position).Magnitude)
                label.Text = nameText .. " [" .. dist .. "m]"
                highlight.Enabled = true
                bGui.Enabled = true
            else
                highlight.Enabled = false
                bGui.Enabled = false
            end
            task.wait(0.3)
        end
    end)
end

-- СТРОГИЙ СКАНИРОВЩИК (Только целевые квестовые объекты)
local function scanMap(object)
    if not object or not object.Parent then return end
    local name = object.Name:lower()
    
    if LocalPlayer.Character and object:IsDescendantOf(LocalPlayer.Character) then return end
    if Players:GetPlayerFromCharacter(object) or Players:GetPlayerFromCharacter(object.Parent) then return end

    -- 1. Алмазный Бастион
    if name:find("bastion") or name:find("diamond") or name:find("бастион") then
        createObjectESP(object, Color3.fromRGB(0, 191, 255), "💎 БАСТИОН", "BastionESP")
        return
    end

    -- 2. СТРОГАЯ проверка на детей для заданий
    local prompt = object:FindFirstChildOfClass("ProximityPrompt") or object:FindFirstChildOfClass("ClickDetector")
    local promptText = prompt and (prompt:IsA("ProximityPrompt") and prompt.ObjectText:lower() or "") or ""
    local actionText = prompt and (prompt:IsA("ProximityPrompt") and prompt.ActionText:lower() or "") or ""
    
    local hasChildName = name:find("child") or name:find("kid") or name:find("baby") or name:find("ребенок") or name:find("missing")
    local hasQuestPrompt = promptText:find("child") or promptText:find("ребенок") or actionText:find("спасти") or actionText:find("взять") or actionText:find("rescue") or actionText:find("help")

    -- Нам подходят только те, у кого совпадает имя ИЛИ на ком висит prompt взаимодействия для спасения
    if hasChildName or (object:FindFirstChildOfClass("Humanoid") and hasQuestPrompt) then
        local root = object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart")
        if root then
            createObjectESP(object, Color3.fromRGB(255, 215, 0), "👶 РЕБЕНОК", "ChildrenESP")
            addChildToMenu(object, root)
        end
        return
    end

    -- 3. Лут / Скрап (Только если включено)
    if name:find("item") or name:find("pickup") or name:find("scrap") then
        createObjectESP(object, Color3.fromRGB(50, 255, 50), "📦 ПРЕДМЕТ", "ItemsESP")
    end
end

workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.2)
    if obj and obj.Parent then scanMap(obj) end
end)

for _, desc in pairs(workspace:GetDescendants()) do scanMap(desc) end

RunService.Heartbeat:Connect(function()
    for obj, _ in pairs(childrenData) do
        if not obj or not obj.Parent then removeChildFromMenu(obj) end
    end
    local empty = true
    for _ in pairs(childrenData) do empty = false break end
    if empty then childCounter = 0 end
end)

-- [[ ПОЛЕТ (FLY) ]]
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
                FlyBV.Velocity = ((lookVector * (moveDir:Dot(lookVector))) + (rightVector * (moveDir:Dot(rightVector)))).Unit * states.FlySpeed
            else
                FlyBV.Velocity = Vector3.new(0, 0, 0)
            end
        else
            if FlyBV then FlyBV:Destroy() FlyBV = nil end
            if FlyBG then FlyBG:Destroy() FlyBG = nil end
        end
    end)
end)

-- [[ ИНИЦИАЛИЗАЦИЯ ]]
createToggle("ESP на Предметы / Лут", "ItemsESP")
createToggle("ESP на Детей (Задания)", "ChildrenESP")
createToggle("ESP на Алмазный Бастион", "BastionESP")

createToggle("Включить Полет (Fly)", "Fly")
createSlider("Скорость полета", 20, 150, 50, function(v) states.FlySpeed = v end)

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
