local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui")

-- Удаляем старое меню, если оно осталось в памяти
if PlayerGui:FindFirstChild("LordikhhhUltimate") then
    PlayerGui["LordikhhhUltimate"]:Destroy()
end

-- Создаем новый чистый GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LordikhhhUltimate"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- КНОПКА ОТКРЫТИЯ (Вверху экрана по центру)
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Name = "OpenMenuBtn"
OpenMenuBtn.Parent = ScreenGui
OpenMenuBtn.Size = UDim2.new(0, 140, 0, 35)
OpenMenuBtn.Position = UDim2.new(0.5, -70, 0, 10) -- Ровно по центру вверху
OpenMenuBtn.Text = "ОТКРЫТЬ МЕНЮ"
OpenMenuBtn.TextSize = 14
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenMenuBtn.ZIndex = 100
Instance.new("UICorner", OpenMenuBtn).CornerRadius = UDim.new(0, 6)

-- ОКНО ВВОДА КЛЮЧА
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
KeyFrame.Position = UDim2.new(0.5, -150, 0.4, -75)
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.ZIndex = 50
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "Введите Ключ"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0.25, 0)
KeyInput.PlaceholderText = "Ключ..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)

local CheckKeyBtn = Instance.new("TextButton", KeyFrame)
CheckKeyBtn.Position = UDim2.new(0.2, 0, 0.7, 0)
CheckKeyBtn.Size = UDim2.new(0.6, 0, 0.22, 0)
CheckKeyBtn.Text = "Проверить"
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Переменные функционала
local MainFrame = nil
local FlySpeed = 50
local Flying = false
local KeyVerified = false

-- Создание главного меню (вызывается только после ввода ключа)
local function CreateMainFrame()
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0.5, -175, 0.3, -150)
    MainFrame.Size = UDim2.new(0, 350, 0, 320)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ZIndex = 10
    MainFrame.Visible = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local MainTitle = Instance.new("TextLabel", MainFrame)
    MainTitle.Size = UDim2.new(1, 0, 0.12, 0)
    MainTitle.Text = " +1 Speed Keyboard Escape Menu"
    MainTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.TextSize = 16
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Position = UDim2.new(0.05, 0, 0.15, 0)
    Container.Size = UDim2.new(0.9, 0, 0.8, 0)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 1.3, 0)
    Container.ScrollBarThickness = 4
    
    local UIListLayout = Instance.new("UIListLayout", Container)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    -- Конструктор кнопок
    local function createToggle(name, callback)
        local btn = Instance.new("TextButton", Container)
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.Text = name .. " [ВЫКЛ]"
        btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
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
    -- СКРИПТЫ СИМУЛЯТОРА
    -- =============================================================================
    local Config = {AutoFarm = false, AutoRebirth = false, AutoWinWorld1 = false}
    
    -- 1. Авто-Фарм
    createToggle("Авто-Сбор Скорости", function(state)
        Config.AutoFarm = state
    end)
    
    task.spawn(function()
        while true do
            task.wait(0.1)
            if Config.AutoFarm and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = Player.Character.HumanoidRootPart
                local Pickups = workspace:FindFirstChild("Pickups") or workspace:FindFirstChild("Spawns") or workspace:FindFirstChild("Orbs")
                if Pickups then
                    for _, item in pairs(Pickups:GetChildren()) do
                        if item:IsA("BasePart") then
                            HRP.CFrame = item.CFrame
                            task.wait(0.04)
                        end
                    end
                end
            end
        end
    end)

    -- 2. Авто-Ребёрф
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

    -- 3. Авто-Вин (Фикс кубков)
    createToggle("Авто-Выигрыш Мир 1 (Кубки)", function(state)
        Config.AutoWinWorld1 = state
    end)

    task.spawn(function()
        while true do
            task.wait(1.5)
            if Config.AutoWinWorld1 and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = Player.Character.HumanoidRootPart
                local FinishPart = nil
                
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name:lower() == "finish" or obj.Name:lower() == "winpad" or obj.Name:lower() == "win") and obj:IsA("BasePart") then
                        FinishPart = obj
                        break
                    end
                end
                
                if FinishPart then
                    HRP.CFrame = FinishPart.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.1)
                    if firetouchinterest then
                        firetouchinterest(HRP, FinishPart, 0)
                        task.wait(0.1)
                        firetouchinterest(HRP, FinishPart, 1)
                    end
                end
            end
        end
    end)

    -- 4. Ввод скорости Fly
    local SpeedInput = Instance.new("TextBox", Container)
    SpeedInput.Size = UDim2.new(1, 0, 0, 38)
    SpeedInput.PlaceholderText = "Скорость полета (Обычная: 50)"
    SpeedInput.Text = "50"
    SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedInput.TextSize = 14
    Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 6)
    
    SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(SpeedInput.Text)
        if num then FlySpeed = num end
    end)

    -- 5. Флай
    createToggle("Режим Полета (Fly)", function(state)
        Flying = state
        if Flying then
            local Character = Player.Character
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
                    if Humanoid.MoveDirection.Magnitude > 0 then
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

-- Логика верхней синей кнопки открытия/скрытия
OpenMenuBtn.MouseButton1Click:Connect(function()
    if KeyVerified and MainFrame then
        MainFrame.Visible = not MainFrame.Visible
        OpenMenuBtn.Text = MainFrame.Visible and "ЗАКРЫТЬ МЕНЮ" or "ОТКРЫТЬ МЕНЮ"
    end
end)

-- Проверка ключа
CheckKeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "Lordikhhh" then
        KeyVerified = true
        KeyFrame:Destroy() -- Удаляем окно ключа навсегда
        CreateMainFrame()  -- Создаем меню читов
        OpenMenuBtn.Text = "ЗАКРЫТЬ МЕНЮ"
    else
        Title.Text = "НЕВЕРНЫЙ КЛЮЧ!"
        Title.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        Title.Text = "Введите Ключ"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)
