-- [[ TSB ULTIMATE HUB: Auto Farm, Combo, Aim, Fly - Delta Edition ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- НАСТРОЙКИ
local CORRECT_KEY = "TSB2026"
local Settings = {
    AutoFight = false, AutoCombo = false, AutoFarm = false, -- Добавлен AutoFarm
    ComboMode = "Genos", AutoBlock = false, AntiRagdoll = false,
    FlyEnabled = false, FlySpeed = 60,
    Aimbot = false, ShowFOV = false, FOVRadius = 150,
    AttackRange = 25
}

-- === 1. ИНТЕРФЕЙС ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TSB_Ultimate_Hub"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = Settings.FOVRadius
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 540) -- Немного увеличил размер
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenBtn.Text = "TSB"; OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

local HackFrame = Instance.new("Frame", MainFrame)
HackFrame.Size = UDim2.new(1, 0, 1, -40); HackFrame.Position = UDim2.new(0, 0, 0, 40)
HackFrame.BackgroundTransparency = 1; HackFrame.Visible = false

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function createBtn(yPos, text)
    local btn = Instance.new("TextButton", HackFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 35); btn.Position = UDim2.new(0.1, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 85, 85)
    return btn
end

-- Создаем кнопки (позиции распределены равномерно)
local AutoFightBtn = createBtn(0.02, "Auto Fight: OFF")
local AutoComboBtn = createBtn(0.11, "Auto Combo: OFF")
local AutoFarmBtn  = createBtn(0.20, "Auto Farm: OFF") -- Новая кнопка
local ModeBtn      = createBtn(0.29, "Mode: GENOS")
local AutoBlockBtn = createBtn(0.38, "Auto Block: OFF")
local AntiRagBtn   = createBtn(0.47, "Anti-Ragdoll: OFF")
local FlyBtn       = createBtn(0.56, "Fly: OFF")
local AimBtn       = createBtn(0.65, "Aimbot: OFF")
local FOVBtn       = createBtn(0.74, "Show FOV: OFF")

-- === 2. ЛОГИКА ===
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Переключение состояний
local function toggle(settingName, btn, text)
    Settings[settingName] = not Settings[settingName]
    btn.Text = text .. (Settings[settingName] and ": ON" or ": OFF")
    btn.TextColor3 = Settings[settingName] and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)
end

AutoFightBtn.MouseButton1Click:Connect(function() toggle("AutoFight", AutoFightBtn, "Auto Fight") end)
AutoComboBtn.MouseButton1Click:Connect(function() toggle("AutoCombo", AutoComboBtn, "Auto Combo") end)
AutoFarmBtn.MouseButton1Click:Connect(function() toggle("AutoFarm", AutoFarmBtn, "Auto Farm") end) -- Логика ферма
AutoBlockBtn.MouseButton1Click:Connect(function() toggle("AutoBlock", AutoBlockBtn, "Auto Block") end)
AntiRagBtn.MouseButton1Click:Connect(function() toggle("AntiRagdoll", AntiRagBtn, "Anti-Ragdoll") end)
FlyBtn.MouseButton1Click:Connect(function() toggle("FlyEnabled", FlyBtn, "Fly") end)
AimBtn.MouseButton1Click:Connect(function() toggle("Aimbot", AimBtn, "Aimbot") end)
FOVBtn.MouseButton1Click:Connect(function() toggle("ShowFOV", FOVBtn, "Show FOV") end)

ModeBtn.MouseButton1Click:Connect(function() 
    Settings.ComboMode = (Settings.ComboMode == "Genos" and "Sonic" or "Genos")
    ModeBtn.Text = "Mode: " .. string.upper(Settings.ComboMode) 
end)

-- Авторизация
local KeyInput = Instance.new("TextBox", MainFrame); KeyInput.Size = UDim2.new(0.8, 0, 0, 40); KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0); KeyInput.PlaceholderText = "Введите ключ..."
local KeyBtn = Instance.new("TextButton", MainFrame); KeyBtn.Size = UDim2.new(0.8, 0, 0, 40); KeyBtn.Position = UDim2.new(0.1, 0, 0.5, 0); KeyBtn.Text = "Войти"
KeyBtn.MouseButton1Click:Connect(function() if KeyInput.Text == CORRECT_KEY then HackFrame.Visible = true; KeyInput.Visible = false; KeyBtn.Visible = false end end)

-- Вспомогательные
local function doClick()
    if mouse1click then mouse1click() else game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), Camera.CFrame); task.wait(0.01); game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0), Camera.CFrame) end
end

local function useSkill(keyName)
    local key = Enum.KeyCode[keyName] or Enum.KeyCode["Button" .. keyName]
    VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.05); VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function getClosestEnemy()
    local closest, minDist = nil, Settings.AttackRange
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then minDist = dist; closest = p.Character end
        end
    end
    return closest
end

-- === 3. ЦИКЛЫ ОБНОВЛЕНИЯ ===
RunService.RenderStepped:Connect(function()
    -- Aim & FOV
    fovCircle.Visible = Settings.ShowFOV; fovCircle.Radius = Settings.FOVRadius; fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if Settings.Aimbot then
        local closest = nil; local dist = Settings.FOVRadius
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if onScreen and mag < dist then closest = p.Character.HumanoidRootPart; dist = mag end
            end
        end
        if closest then Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position) end
    end
end)

-- Боевой цикл (Auto Farm, Fight, Combo)
task.spawn(function()
    while task.wait(0.15) do
        local enemy = getClosestEnemy()
        
        -- Auto Farm / Fight Logic
        if (Settings.AutoFarm or Settings.AutoFight or Settings.AutoCombo) and enemy then
            local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myHrp then
                myHrp.CFrame = CFrame.new(enemy.HumanoidRootPart.Position - (enemy.HumanoidRootPart.CFrame.LookVector * 2.5), enemy.HumanoidRootPart.Position)
                
                if Settings.AutoFarm or Settings.AutoCombo then
                    for i = 1, 4 do doClick(); task.wait(0.2) end
                    useSkill(Settings.ComboMode == "Genos" and "One" or "Three")
                else
                    doClick()
                end
            end
        end
        
        -- Anti-Ragdoll
        if Settings.AntiRagdoll and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid:GetState() == Enum.HumanoidStateType.Ragdoll then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

print("TSB Ultimate Hub Loaded Successfully!")
