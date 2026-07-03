local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:FindFirstChild("PlayerGui") or Player:WaitForChild("PlayerGui")

-- Создаем GUI в PlayerGui для гарантированной видимости
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LordikhhhMenuUltimate"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

-- Постоянная кнопка открытия/закрытия меню слева на экране
local OpenMenuBtn = Instance.new("TextButton")
OpenMenuBtn.Name = "OpenMenuBtn"
OpenMenuBtn.Parent = ScreenGui
OpenMenuBtn.Size = UDim2.new(0, 110, 0, 40)
OpenMenuBtn.Position = UDim2.new(0, 10, 0.45, 0)
OpenMenuBtn.Text = "Меню [X]"
OpenMenuBtn.TextSize = 16
OpenMenuBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
OpenMenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenMenuBtn.ZIndex = 10

-- Скругление углов для кнопки
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = OpenMenuBtn

-- Окно ввода ключа
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Parent = ScreenGui
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
KeyFrame.Size = UDim2.new(0, 300, 0, 160)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.ZIndex = 5

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 10)
KeyCorner.Parent = KeyFrame

local Title = Instance.new("TextLabel")
Title.Parent = KeyFrame
Title.Size = UDim2.new(1, 0, 0.3, 0)
Title.Text = "Введите Ключ"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.TextSize = 18

local KeyInput = Instance.new("TextBox")
KeyInput.Parent = KeyFrame
KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
KeyInput.Size = UDim2.new(0.8, 0, 0.25, 0)
KeyInput.PlaceholderText = "Ключ тут..."
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 14

local CheckKeyBtn = Instance.new("TextButton")
CheckKeyBtn.Parent = KeyFrame
CheckKeyBtn.Position = UDim2.new(0.2, 0, 0.7, 0)
CheckKeyBtn.Size = UDim2.new(0.6, 0, 0.22, 0)
CheckKeyBtn.Text = "Проверить"
CheckKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
CheckKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckKeyBtn.TextSize = 14

local MainFrame
local FlySpeed = 50
local Flying = false
local KeyVerified = false

-- Логика кнопки открытия (работает только ПОСЛЕ ввода правильного ключа)
OpenMenuBtn.MouseButton1Click:Connect(function()
    if KeyVerified and MainFrame then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

local function StartMainCheat()
    KeyVerified = true
    KeyFrame:Destroy()
    
    -- Главное Меню
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
    MainFrame.Size = UDim2.new(0, 360, 0, 340)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local MainTitle = Instance.new("TextLabel")
    MainTitle.Parent = MainFrame
    MainTitle.Size = UDim2.new(1, 0, 0.12, 0)
    MainTitle.Text = "  +1 Speed Keyboard Escape Menu"
    MainTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
    MainTitle.BackgroundTransparency = 1
    MainTitle.TextSize = 16
    MainTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Контейнер для функций
    local Container = Instance.new("ScrollingFrame")
    Container.Parent = MainFrame
    Container.Position = UDim2.new(0.05, 0, 0.15, 0)
    Container.Size = UDim2.new(0.9, 0, 0.8, 0)
    Container.BackgroundTransparency = 1
    Container.CanvasSize = UDim2.new(0, 0, 1.4, 0)
    Container.ScrollBarThickness = 4
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Container
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    -- Функция создания кнопок переключения (Toggle)
    local function createToggle(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.Text = name .. " [ВЫКЛ]"
        btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Parent = Container
        
        local btnC = Instance.new("UICorner")
        btnC.CornerRadius = UDim.new(0, 6)
        btnC.Parent = btn
        
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
    -- ХАКИ И АВТО-ФУНКЦИИ
    -- =============================================================================
    local Config = {AutoFarm = false, AutoRebirth = false, AutoWinWorld1 = false}
    
    -- 1. Авто-фарм скорости
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

    -- 3. Авто-Вин Мир 1 (С исправленным зачислением кубков)
    createToggle("Авто-Выигрыш Мир 1 (Кубки)", function(state)
        Config.AutoWinWorld1 = state
    end)

    task.spawn(function()
        while true do
            task.wait(1.5) -- Оптимальная задержка, чтобы сервер регистрировал победы
            if Config.AutoWinWorld1 and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local HRP = Player.Character.HumanoidRootPart
                local FinishPart = nil
                
                -- Ищем плиту финиша первого мира
                for _, obj in pairs(workspace:GetDescendants()) do
                    if (obj.Name:lower() == "finish" or obj.Name:lower() == "winpad" or obj.Name:lower() == "win") and obj:IsA("BasePart") then
                        FinishPart = obj
                        break
                    end
                end
                
                if FinishPart then
                    -- Мягкий перенос на финиш
                    HRP.CFrame = FinishPart.CFrame * CFrame.new(0, 3, 0)
                    task.wait(0.1)
                    
                    -- Симуляция физического наступания на плиту через Touch-событие движка
                    if firetouchinterest then
                        firetouchinterest(HRP, FinishPart, 0) -- Наступил
                        task.wait(0.1)
                        firetouchinterest(HRP, FinishPart, 1) -- Убрал ногу
                    end
                end
            end
        end
    end)

    -- 4. Текстовое поле для настройки Скорости Полета (Fly Speed)
    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Size = UDim2.new(1, 0, 0, 38)
    SpeedInput.PlaceholderText = "Скорость полета (Обычная: 50)"
    SpeedInput.Text = "50"
    SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedInput.TextSize = 14
    SpeedInput.Parent = Container
    
    local SpeedCorner = Instance.new("UICorner")
    SpeedCorner.CornerRadius = UDim.new(0, 6)
    SpeedCorner.Parent = SpeedInput
    
    SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(SpeedInput.Text)
        if num then FlySpeed = num end
    end)

    -- 5. Кнопка Полета (Fly)
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

-- Проверка правильности ключа
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
