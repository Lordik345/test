-- [[ 99 NIGHTS LITE HUB: SAFE AI & AUTO-FARM ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- КЛЮЧ
local CORRECT_KEY = "Lordikhhh"

local states = { 
    ItemsESP = false,
    ChildrenESP = false,
    BastionESP = false,
    Fly = false,
    AutoFarmTree = false,
    AutoFarmMetal = false,
    AutoFarmRes = false,
    AutoFarmFood = false,
    FlySpeed = 50
}

local UI_NAME = "Nights99_Metal_Hub"
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

-- [[ ПРОМЕЖУТОЧНОЕ ОКНО ПРИВЕТСТВИЯ ]]
local WelcomeFrame = Instance.new("Frame")
WelcomeFrame.Size = UDim2.new(0, 300, 0, 130)
WelcomeFrame.Position = UDim2.new(0.5, -150, 0.4, -65)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
WelcomeFrame.Visible = false
styleElement(WelcomeFrame, 12)
WelcomeFrame.Parent = ScreenGui

local WelcomeTitle = Instance.new("TextLabel")
WelcomeTitle.Size = UDim2.new(1, 0, 0, 50)
WelcomeTitle.Position = UDim2.new(0, 0, 0, 15)
WelcomeTitle.BackgroundTransparency = 1
WelcomeTitle.Text = "Спасибо за использование скрипта!"
WelcomeTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
WelcomeTitle.TextSize = 14
WelcomeTitle.Font = Enum.Font.GothamBold
WelcomeTitle.TextWrapped = true
WelcomeTitle.Parent = WelcomeFrame

local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, 0, 0, 30)
CreatorLabel.Position = UDim2.new(0, 0, 0, 65)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Text = "Создатель: Lordikhhh"
CreatorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreatorLabel.TextSize = 13
CreatorLabel.Font = Enum.Font.Gotham
CreatorLabel.Parent = WelcomeFrame


-- [[ ГЛАВНОЕ МЕНЮ ]]
local MainPanel = Instance.new("Frame")
MainPanel.Size = UDim2.new(0, 340, 0, 500)
MainPanel.Position = UDim2.new(0.5, -170, 0.3, -250)
MainPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainPanel.Visible = false
styleElement(MainPanel, 12)
MainPanel.Parent = ScreenGui

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 35)
MainTitle.BackgroundTransparency = 1
MainTitle.Text = "99 NIGHTS LITE HUB"
MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTitle.TextSize = 13
MainTitle.Font = Enum.Font.GothamBold
MainTitle.Parent = MainPanel

local TabBar = Instance.new("Frame", MainPanel)
TabBar.Size = UDim2.new(1, -20, 0, 30)
TabBar.Position = UDim2.new(0, 10, 0, 35)
TabBar.BackgroundTransparency = 1

local FunctionsTabBtn = Instance.new("TextButton", TabBar)
FunctionsTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
FunctionsTabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
FunctionsTabBtn.Text = "Функции"
FunctionsTabBtn.TextColor3 = Color3.new(1,1,1)
FunctionsTabBtn.Font = Enum.Font.GothamBold
FunctionsTabBtn.TextSize = 11
styleElement(FunctionsTabBtn, 5)

local AiTabBtn = Instance.new("TextButton", TabBar)
AiTabBtn.Size = UDim2.new(0.5, -5, 1, 0)
AiTabBtn.Position = UDim2.new(0.5, 5, 0, 0)
AiTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AiTabBtn.Text = "🤖 ИИ Чат"
AiTabBtn.TextColor3 = Color3.new(0.8,0.8,0.8)
AiTabBtn.Font = Enum.Font.GothamBold
AiTabBtn.TextSize = 11
styleElement(AiTabBtn, 5)

local FunctionsPage = Instance.new("Frame", MainPanel)
FunctionsPage.Size = UDim2.new(1, 0, 1, -75)
FunctionsPage.Position = UDim2.new(0, 0, 0, 75)
FunctionsPage.BackgroundTransparency = 1

local AiPage = Instance.new("Frame", MainPanel)
AiPage.Size = UDim2.new(1, 0, 1, -75)
AiPage.Position = UDim2.new(0, 0, 0, 75)
AiPage.BackgroundTransparency = 1
AiPage.Visible = false

local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, 0, 0, 310)
SettingsScroll.Position = UDim2.new(0, 0, 0, 0)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 520)
SettingsScroll.ScrollBarThickness = 2
SettingsScroll.Parent = FunctionsPage

local TpSectionTitle = Instance.new("TextLabel")
TpSectionTitle.Size = UDim2.new(1, 0, 0, 20)
TpSectionTitle.Position = UDim2.new(0, 15, 0, 315)
TpSectionTitle.BackgroundTransparency = 1
TpSectionTitle.Text = "ТЕЛЕПОРТ К ДЕТЯМ:"
TpSectionTitle.TextColor3 = Color3.fromRGB(255, 0, 100)
TpSectionTitle.TextSize = 11
TpSectionTitle.Font = Enum.Font.GothamBold
TpSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
TpSectionTitle.Parent = FunctionsPage

local TpButtonsContainer = Instance.new("ScrollingFrame")
TpButtonsContainer.Size = UDim2.new(1, 0, 0, 85)
TpButtonsContainer.Position = UDim2.new(0, 0, 0, 335)
TpButtonsContainer.BackgroundTransparency = 1
TpButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 100)
TpButtonsContainer.ScrollBarThickness = 2
TpButtonsContainer.Parent = FunctionsPage

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

FunctionsTabBtn.MouseButton1Click:Connect(function()
    FunctionsPage.Visible = true; AiPage.Visible = false
    FunctionsTabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    AiTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

AiTabBtn.MouseButton1Click:Connect(function()
    FunctionsPage.Visible = false; AiPage.Visible = true
    AiTabBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    FunctionsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

-- [[ ЭЛЕМЕНТЫ ИИ ЧАТА ]]
local AiLog = Instance.new("ScrollingFrame", AiPage)
AiLog.Size = UDim2.new(1, -20, 0, 330)
AiLog.Position = UDim2.new(0, 10, 0, 10)
AiLog.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
AiLog.CanvasSize = UDim2.new(0, 0, 0, 1000)
AiLog.ScrollBarThickness = 2
styleElement(AiLog, 6)

local AiLogLayout = Instance.new("UIListLayout", AiLog)
AiLogLayout.Padding = UDim.new(0, 6)

local AiInput = Instance.new("TextBox", AiPage)
AiInput.Size = UDim2.new(1, -110, 0, 35)
AiInput.Position = UDim2.new(0, 10, 0, 355)
AiInput.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AiInput.PlaceholderText = "Задай вопрос ИИ..."
AiInput.Text = ""
AiInput.TextColor3 = Color3.new(1,1,1)
AiInput.TextSize = 11
styleElement(AiInput, 6)

local AiSendBtn = Instance.new("TextButton", AiPage)
AiSendBtn.Size = UDim2.new(0, 80, 0, 35)
AiSendBtn.Position = UDim2.new(1, -90, 0, 355)
AiSendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
AiSendBtn.Text = "Спросить"
AiSendBtn.TextColor3 = Color3.new(1,1,1)
AiSendBtn.Font = Enum.Font.GothamBold
AiSendBtn.TextSize = 11
styleElement(AiSendBtn, 6)

local function addChatLabel(text, color)
    local lbl = Instance.new("TextLabel", AiLog)
    lbl.Size = UDim2.new(1, -10, 0, 40)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextSize = 11
    lbl.Font = Enum.Font.Gotham
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    AiLog.CanvasPosition = Vector2.new(0, AiLog.AbsoluteWindowSize.Y + 1000)
end

-- ИСПОЛЬЗУЕМ 100% СОВМЕСТИМЫЙ GET ЗАПРОС С ФИЛЬТРАЦИЕЙ СТРОК
local function requestAI(prompt)
    if prompt == "" then return end
    addChatLabel("Вы: " .. prompt, Color3.fromRGB(200, 200, 200))
    AiInput.Text = ""
    addChatLabel("ИИ: Думает...", Color3.fromRGB(255, 200, 0))
    
    task.spawn(function()
        -- Чистый GET запрос, понятный любому клиенту роблокса
        local cleanPrompt = HttpService:UrlEncode(prompt)
        local url = "https://text.pollinations.ai/" .. cleanPrompt .. "?model=openai"
        
        local success, res = pcall(function()
            return game:HttpGet(url)
        end)
        
        local last = AiLog:GetChildren()[#AiLog:GetChildren()]
        if last:IsA("TextLabel") and last.Text:find("Думает") then last:Destroy() end

        if success and res then
            addChatLabel("ИИ: " .. res, Color3.fromRGB(0, 255, 150))
        else
            addChatLabel("ИИ: Ошибка сети.", Color3.fromRGB(255, 50, 50))
        end
    end)
end

AiSendBtn.MouseButton1Click:Connect(function() requestAI(AiInput.Text) end)

-- [[ ЛОГИКА АВТО-ФАРМА ]]
local function startAutoFarm(stateKey, itemType)
    task.spawn(function()
        while states[stateKey] do
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local closestTarget = nil
                local minDistance = math.huge

                for _, obj in pairs(workspace:GetDescendants()) do
                    local name = obj.Name:lower()
                    local isMatch = false
                    local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                    local pText = prompt and (prompt.ObjectText:lower() .. prompt.ActionText:lower()) or ""

                    if itemType == "tree" then
                        if obj:IsA("Model") and (name:find("tree") or name:find("дерев")) and not obj:FindFirstChild("Tent") and not obj:FindFirstChild("tent") then
                            isMatch = true
                        end
                    elseif obj:IsA("BasePart") then
                        if itemType == "metal" and (name:find("metal") or name:find("iron") or name:find("steel") or name:find("желез") or name:find("метал") or pText:find("metal") or pText:find("iron")) then
                            isMatch = true
                        elseif itemType == "resources" and (name:find("wood") or name:find("gas") or name:find("coal") or name:find("fuel") or pText:find("wood") or pText:find("gas") or pText:find("coal")) then
                            isMatch = true
                        elseif itemType == "food" and (name:find("food") or name:find("med") or name:find("cola") or name:find("apple") or pText:find("food") or pText:find("med") or pText:find("eat")) then
                            isMatch = true
                        end
                    end

                    if isMatch then
                        local targetPart = obj:IsA("BasePart") and obj or (obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart"))
                        if targetPart then
                            local dist = (targetPart.Position - myRoot.Position).Magnitude
                            if dist < minDistance then
                                minDistance = dist
                                closestTarget = targetPart
                            end
                        end
                    end
                end

                if closestTarget then
                    myRoot.CFrame = closestTarget.CFrame * CFrame.new(0, 0, 3)
                    task.wait(0.2)
                    local prompt = closestTarget:FindFirstChildOfClass("ProximityPrompt") or closestTarget.Parent:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then fireproximityprompt(prompt) end
                    task.wait(0.4)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- [[ КОНСТРУКТОРЫ КНОПОК ]]
local buttonY = 5
local function createToggle(name, stateKey, farmType)
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
        if farmType and states[stateKey] then startAutoFarm(stateKey, farmType) end
    end)
    buttonY = buttonY + 40
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

-- [[ ОБЛЕГЧЕННЫЙ ESP ]]
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
            local isTentNow = object:FindFirstChild("Tent") or object:FindFirstChild("tent")
            if states[stateKey] and targetPart and not isTentNow then
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
    if object:FindFirstChild("Tent") or object:FindFirstChild("tent") or name:find("tent") or name:find("палатк") then return end

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

RunService.Heartbeat:Connect(function()
    for obj, _ in pairs(childrenData) do
        if not obj or not obj.Parent or obj:FindFirstChild("Tent") or obj:FindFirstChild("tent") then removeChildFromMenu(obj) end
    end
end)

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
        if hum.MoveDirection.Magnitude > 0 then FlyBV.Velocity = Camera.CFrame.LookVector * states.FlySpeed else FlyBV.Velocity = Vector3.new(0, 0, 0) end
    else
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
    end
end)

-- [[
