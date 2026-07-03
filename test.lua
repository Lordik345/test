-- =============================================================================
-- KEY SYSTEM (Ключ: Lordikhhh)
-- =============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LordikhhhMenu"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local KeyFrame = Instance.new("Frame")
local KeyInput = Instance.new("TextBox")
local CheckKeyBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Active = true
KeyFrame.Draggable = true

Title.Parent = KeyFrame
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "Введите Ключ"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 20

KeyInput.Parent = KeyFrame
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0.25, 0)
KeyInput.PlaceholderText = "Ключ тут..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)

CheckKeyBtn.Parent = KeyFrame
CheckKeyBtn.Position = UDim2.new(0.2, 0, 0.75, 0)
CheckKeyBtn.Size = UDim2.new(0.6, 0, 0.2, 0)
CheckKeyBtn.Text = "Проверить"
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local MainFrame
local FlySpeed = 50
local Flying = false

local function StartMainCheat()
    KeyFrame:Destroy()
    
    -- Создание Главного Меню
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 400, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local MainTitle = Instance.new("TextLabel")
    MainTitle.Parent = MainFrame
    MainTitle.Size = UDim2.new(0.8, 0, 0.15, 0)
    MainTitle.Text = "+1 Speed Keyboard Escape"
    MainTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.TextSize = 18
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    MainTitle.Position = UDim2.new(0.05, 0, 0, 0)

    -- КНОПКА ЗАКРЫТИЯ МЕНЮ [X]
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -40, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.TextSize = 18
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        print("Меню скрыто. Чтобы открыть снова, введите в консоль: game:GetService('CoreGui').LordikhhhMenu.MainFrame.Visible = true")
    end)
    
    -- Контейнер для кнопок
    local Container = Instance.new("ScrollingFrame")
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0.05, 0, 0.2, 0)
    Container.Size = UDim2.new(0.9, 0, 0.75, 0)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 1.5, 0)
    Container.ScrollBarThickness = 6
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)

    local function createToggle(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Text = name .. " [ВЫКЛ]"
        btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 16
        btn.Parent = Container
        
        local enabled = false
        btn.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                btn.Text = name .. " [ВКЛ]"
                btn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
            else
                btn.Text = name .. " [ВЫКЛ]"
                btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            end
            callback(enabled)
        end)
    end

    -- =============================================================================
    -- ФУНКЦИОНАЛ
    -- =============================================================================
    local Config = {AutoFarm = false, AutoRebirth = false, AutoWinWorld1 = false}
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- 1. Auto Farm Speed
    createToggle("Авто-Сбор Скорости", function(state)
        Config.AutoFarm = state
    end)
    
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Config.AutoFarm and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = LocalPlayer.Character.HumanoidRootPart
                local Pickups = workspace:FindFirstChild("Pickups") or workspace:FindFirstChild("Spawns") or workspace:FindFirstChild("Orbs")
                if Pickups then
                    for _, item in pairs(Pickups:GetChildren()) do
                        if item:IsA("BasePart") then
                            HRP.CFrame = item.CFrame
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    end)

    -- 2. Auto Rebirth
    createToggle("Авто-Перерождение", function(state)
        Config.AutoRebirth = state
    end)
    
    task.spawn(function()
        while true do
            task.wait(1)
            if Config.AutoRebirth then
                local RebirthEvent = game:GetService("ReplicatedStorage"):FindFirstChild("Rebirth") 
                    or game:GetService("ReplicatedStorage"):FindFirstChild("RebirthRequest")
                if RebirthEvent and RebirthEvent:IsA("RemoteEvent") then
                    RebirthEvent:FireServer()
                end
            end
        end
    end)

    -- 3. ИСПРАВЛЕННЫЙ АВТО-ВИН (С ФИКС СИСТЕМОЙ КУБКОВ)
    createToggle("Авто-Выигрыш Мир 1 (Кубки)", function(state)
        Config.AutoWinWorld1 = state
    end)

    task.spawn(function()
        while true do
            task.wait(1) -- Задержка чуть больше, чтобы сервер успевал выдать награду
            if Config.AutoWinWorld1 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = LocalPlayer.Character.HumanoidRootPart
                
                -- Ищем финишную плиту
                local FinishPart = nil
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name:lower() == "finish" or obj.Name:lower() == "winpad" or obj.Name:lower() == "win") and obj:IsA("BasePart") then
                        FinishPart = obj
                        break
                    end
                end
                
                if FinishPart then
                    -- Способ 1: Прямая телепортация чуть выше плиты, чтобы упасть на неё
                    HRP.CFrame = FinishPart.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.2)
                    
                    -- Способ 2 (Надежный): Принудительная симуляция физического касания ног к финишу
                    if firetouchinterest then
                        firetouchinterest(HRP, FinishPart, 0) -- Касание началось
                        task.wait(0.1)
                        firetouchinterest(HRP, FinishPart, 1) -- Касание завершилось
                    end
                end
            end
        end
    end)

    -- 4. Скорость Fly
    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Size = UDim2.new(1, 0, 0, 40)
    SpeedInput.PlaceholderText = "Скорость полета (например: 100)"
    SpeedInput.Text = "50"
    SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedInput.Parent = Container
    
    SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(SpeedInput.Text)
        if num then FlySpeed = num end
    end)

    -- 5. Кнопка Fly
    createToggle("Режим Полета (Fly)", function(state)
        Flying = state
        if Flying then
            local Character = LocalPlayer.Character
            local Humanoid = Character:FindFirstChildOfClass("Humanoid")
            local HRP = Character:FindFirstChild("HumanoidRootPart")
            
            if not HRP or not Humanoid then return end
            
            local BodyVelocity = Instance.new("BodyVelocity")
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            BodyVelocity.Parent = HRP
            
            local Camera = workspace.CurrentCamera
            
            task.spawn(function()
                while Flying and HRP and Character.Parent do
                    task.wait()
                    local moveDirection = Humanoid.MoveDirection
                    if moveDirection.Magnitude > 0 then
                        BodyVelocity.Velocity = Camera.CFrame.LookVector * FlySpeed
                    else
                        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    end
                end
                BodyVelocity:Destroy()
            end)
        end
    end)
end

CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "Lordikhhh" then
        StartMainCheat()
    else
        Title.Text = "НЕВЕРНЫЙ КЛЮЧ!"
        Title.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        Title.Text = "Введите Ключ"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
