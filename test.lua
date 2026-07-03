-- [[ 99 NIGHTS ULTRA-LIGHT LITE HUB ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- КЛЮЧ
local CORRECT_KEY = "Lordikhhh"

local states = { 
    ItemsESP = false,
    ChildrenESP = false,
    BastionESP = false,
    Fly = false,
    FlySpeed = 50
}

-- Выводим напрямую в PlayerGui (защита игры мимо)
local UI_NAME = "Nights99_Lite_Hub"
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
KeyTitle.Text = "ВВЕДИТЕ КЛЮЧ"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.TextSize = 14
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 220, 0, 35)
KeyInput.Position = UDim2.new(0.5, -110, 0, 50)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ключ тут..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14
styleElement(KeyInput, 6)
KeyInput.Parent = KeyFrame

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Size = UDim2.new(0, 120, 0, 35)
CheckKeyBtn.Position = UDim2.new(0.5, -60, 0, 105)
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
CheckKeyBtn.Text = "Войти"
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
styleElement(CheckKeyBtn, 6)
CheckKeyBtn.Parent = KeyFrame

-- [[ ГЛАВНОЕ МЕНЮ ]]
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 320, 0, 430)
MainPanel.Position = UDim2.new(0.5, -160, 0.3, -215)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainPanel.Visible = false
styleElement(MainPanel, 12)
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 40)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "99 NIGHTS LITE HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 14
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, 0, 0, 260)
SettingsScroll.Position = UDim2.new(0, 0, 0, 40)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 380)
SettingsScroll.ScrollBarThickness = 2
SettingsScroll.Parent = MainPanel

local TpSectionTitle = Instance.new("TextLabel")
TpSectionTitle.Size = UDim2.new(1, 0, 0, 20)
TpSectionTitle.Position = UDim2.new(0, 15, 0, 305)
TpSectionTitle.BackgroundTransparency = 1
TpSectionTitle.Text = "ТЕЛЕПОРТ К ДЕТЯМ:"
TpSectionTitle.TextColor3 = Color3.fromRGB(255, 0, 100)
TpSectionTitle.TextSize = 11
TpSectionTitle.Font = Enum.Font.GothamBold
TpSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
TpSectionTitle.Parent = MainPanel

local TpButtonsContainer = Instance.new("ScrollingFrame")
TpButtonsContainer.Size = UDim2.new(1, 0, 0, 95)
TpButtonsContainer.Position = UDim2.new(0, 0, 0, 325)
TpButtonsContainer.BackgroundTransparency = 1
TpButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 100)
TpButtonsContainer.ScrollBarThickness = 2
TpButtonsContainer.Parent = MainPanel

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TpButtonsContainer
UIListLayout.Padding = UDim.new(0, 5)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = TpButtonsContainer
UIPadding.PaddingLeft = UDim.new(0, 15)

local ToggleMenuBtn = Instance.new("TextButton")
ToggleMenuBtn.Size = UDim2.new(0, 90, 0, 30)
ToggleMenuBtn.Position = UDim2.new(0.02, 0, 0.02, 0)
ToggleMenuBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
ToggleMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleMenuBtn.Text = "СКРЫТЬ"
ToggleMenuBtn.Visible = false
styleElement(ToggleMenuBtn, 6)
ToggleMenuBtn.Parent = ScreenGui

ToggleMenuBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
    ToggleMenuBtn.Text = MainPanel.Visible and "СКРЫТЬ" or "МЕНЮ"
end)

-- [[ КОНСТРУКТОРЫ КНОПОК ]]
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
    Text.TextColor3 = Color3.fromRGB(200, 200, 200)
    Text.TextSize = 12
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 60, 0, 24)
    ToggleBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    ToggleBtn.Text = "ВЫКЛ"
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleBtn.TextSize = 10
    styleElement(ToggleBtn, 4)
    ToggleBtn.Parent = Frame

    ToggleBtn.MouseButton1Click:Connect(function()
        states[stateKey] = not states[stateKey]
        ToggleBtn.BackgroundColor3 = states[stateKey] and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(60, 60, 70)
        ToggleBtn.Text = states[stateKey] and "ВКЛ" or "ВЫКЛ"
    end)
    buttonY = buttonY + 40
end

local function createActionButton(name, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 280, 0, 32)
    Btn.Position = UDim2.new(0, 15, 0, buttonY)
    Btn.BackgroundColor3 = color
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 11
    styleElement(Btn, 6)
    Btn.Parent = SettingsScroll
    Btn.MouseButton1Click:Connect(callback)
    buttonY = buttonY + 38
end

-- [[ СИСТЕМА ДЕТЕЙ ]]
local childrenData = {}
local childCounter = 0

local function removeChildFromMenu(object)
    if childrenData[object] then
        if childrenData[object].Button then childrenData[object].Button:Destroy() end
        childrenData[object] = nil
    end
end

local function addChildToMenu(object, rootPart)
    if childrenData[object] then return end
    childCounter = childCounter + 1
    local currentNum = childCounter

    local TpBtn = Instance.new("TextButton")
    TpBtn.Size = UDim2.new(0, 270, 0, 26)
    TpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TpBtn.Text = "👶 Ребёнок №" .. currentNum
    TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TpBtn.TextSize = 11
    styleElement(TpBtn, 4)
    TpBtn.Parent = TpButtonsContainer

    childrenData[object] = { Root = rootPart, Button = TpBtn }

    TpBtn.MouseButton1Click:Connect(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and rootPart and rootPart.Parent then
            myRoot.CFrame = rootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end)
end

-- [[ ОБЛЕГЧЕННЫЙ ESP (БЕЗ HIGHLIGHT) ]]
local function createObjectESP(object, color, nameText, stateKey)
    if not object:IsA("Model") and not object:IsA("BasePart") then return end
    if object:FindFirstChild("NightsESP_Gui") then return end

    local bGui = Instance.new("BillboardGui")
    bGui.Name = "NightsESP_Gui"
    bGui.Size = UDim2.new(0, 130, 0, 30)
    bGui.AlwaysOnTop = true
    bGui.ExtentsOffset = Vector3.new(0, 3, 0)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextSize = 11
    label.Text = nameText
    label.Parent = bGui
    
    local targetPart = object:IsA("BasePart") and object or (object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart"))
    if targetPart then
        bGui.Adornee = targetPart
        bGui.Parent = object
    end

    task.spawn(function()
        while object and object.Parent and bGui do
            if states[stateKey] and targetPart then
                local dist = math.floor((targetPart.Position - Camera.CFrame.Position).Magnitude)
                label.Text = nameText .. " [" .. dist .. "m]"
                bGui.Enabled = true
            else
                bGui.Enabled = false
            end
            task.wait(0.5)
        end
    end)
end

local function scanMap(object)
    if not object or not object.Parent then return end
    local name = object.Name:lower()
    
    if LocalPlayer.Character and object:IsDescendantOf(LocalPlayer.Character) then return end

    if name:find("bastion") or name:find("diamond") or name:find("бастион") then
        createObjectESP(object, Color3.fromRGB(0, 191, 255), "💎 БАСТИОН", "BastionESP")
        return
    end

    local prompt = object:FindFirstChildOfClass("ProximityPrompt") or object:FindFirstChildOfClass("ClickDetector")
    local pText = prompt and (prompt:IsA("ProximityPrompt") and prompt.ObjectText:lower() .. prompt.ActionText:lower() or "") or ""
    
    local hasChildName = name:find("child") or name:find("kid") or name:find("baby") or name:find("ребенок")
    local hasQuestPrompt = pText:find("child") or pText:find("ребенок") or pText:find("спасти") or pText:find("rescue")

    if hasChildName or (object:FindFirstChildOfClass("Humanoid") and hasQuestPrompt) then
        local root = object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart")
        if root then
            createObjectESP(object, Color3.fromRGB(255, 215, 0), "👶 РЕБЕНК", "ChildrenESP")
            addChildToMenu(object, root)
        end
        return
    end

    if states.ItemsESP and (name:find("item") or name:find("pickup") or name:find("scrap") or prompt) then
        createObjectESP(object, Color3.fromRGB(50, 255, 50), "📦 ЛУТ", "ItemsESP")
    end
end

workspace.DescendantAdded:Connect(scanMap)
for _, desc in pairs(workspace:GetDescendants()) do scanMap(desc) end

-- [[ МАГНИТ ВЕЩЕЙ (БЕЗ ДВИЖЕНИЯ ИГРОКА) ]]
local function teleportItemsToMe(itemType)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, desc in pairs(workspace:GetDescendants()) do
        if desc:IsA("BasePart") then
            local name = desc.Name:lower()
            local prompt = desc:FindFirstChildOfClass("ProximityPrompt") or desc:FindFirstChildOfClass("ClickDetector")
            local pText = prompt and (prompt:IsA("ProximityPrompt") and prompt.ObjectText:lower() .. prompt.ActionText:lower() or "") or ""
            
            local isTarget = false
            if itemType == "resources" and (name:find("wood") or name:find("gas") or name:find("coal") or name:find("fuel") or pText:find("wood") or pText:find("gas") or pText:find("coal")) then
                isTarget = true
            elseif itemType == "food" and (name:find("food") or name:find("med") or name:find("cola") or name:find("apple") or pText:find("food") or pText:find("med") or pText:find("eat")) then
                isTarget = true
            end
            
            if isTarget then
                desc.Anchored = false
                desc.CFrame = myRoot.CFrame * CFrame.new(0, -1, -3)
            end
        end
    end
end

-- [[ ЛИТЕ-ПОЛЕТ ]]
local FlyBV
RunService.RenderStepped:Connect(function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if states.Fly and root and hum then
        if not FlyBV or FlyBV.Parent ~= root then
            FlyBV = Instance.new("BodyVelocity", root)
            FlyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            FlyBV.Velocity = Camera.CFrame.LookVector * states.FlySpeed
        else
            FlyBV.Velocity = Vector3.new(0, 0, 0)
        end
    else
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
    end
end)

-- [[ ИНИЦИАЛИЗАЦИЯ ]]
createToggle("ESP на Лут", "ItemsESP")
createToggle("ESP на Детей", "ChildrenESP")
createToggle("ESP на Бастион", "BastionESP")
createToggle("Включить Полет", "Fly")

createActionButton("🔥 Стянуть ресурсы (Уголь/Дрова/Бензин)", Color3.fromRGB(200, 100, 0), function() teleportItemsToMe("resources") end)
createActionButton("🍎 Стянуть припасы (Еда/Аптечки)", Color3.fromRGB(50, 150, 50), function() teleportItemsToMe("food") end)

CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CORRECT_KEY then
        KeyFrame:Destroy()
        MainPanel.Visible = true
        ToggleMenuBtn.Visible = true
    else
        KeyInput.Text = "НЕВЕРНО!"
        task.wait(1)
        KeyInput.Text = ""
    end
end)
