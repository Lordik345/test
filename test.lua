-- [[ TSB ALL-IN-ONE HUB: Delta Executor Edition ]] --
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
    AutoFight = false, AutoCombo = false, ComboMode = "Genos",
    AutoBlock = false, AntiRagdoll = false,
    FlyEnabled = false, FlySpeed = 60,
    Aimbot = false, ShowFOV = false, FOVRadius = 150,
    AttackRange = 25
}

-- === 1. ИНТЕРФЕЙС ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TSB_Delta_Ultimate"
ScreenGui.Parent = (gethui and gethui()) or CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- КРУГ FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Radius = Settings.FOVRadius
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

-- ГЛАВНОЕ ОКНО
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- ... (Кнопки и GUI элементы) ...
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50); OpenBtn.Position = UDim2.new(0.02, 0, 0.4, 0)
OpenBtn.Text = "TSB"; OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)

local HackFrame = Instance.new("Frame", MainFrame)
HackFrame.Size = UDim2.new(1, 0, 1, -40); HackFrame.Position = UDim2.new(0, 0, 0, 40)
HackFrame.BackgroundTransparency = 1; HackFrame.Visible = false

-- ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function createBtn(name, pos, text)
    local btn = Instance.new("TextButton", HackFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 40); btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); btn.Text = text; btn.TextColor3 = Color3.fromRGB(255, 85, 85)
    return btn
end

local AutoFightBtn = createBtn("AutoFight", UDim2.new(0.1, 0, 0.02, 0), "Auto Fight: OFF")
local AutoComboBtn = createBtn("AutoCombo", UDim2.new(0.1, 0, 0.12, 0), "Auto Combo: OFF")
local ModeBtn = createBtn("Mode", UDim2.new(0.1, 0, 0.22, 0), "Mode: GENOS")
local AutoBlockBtn = createBtn("AutoBlock", UDim2.new(0.1, 0, 0.32, 0), "Auto Block: OFF")
local AntiRagBtn = createBtn("AntiRag", UDim2.new(0.1, 0, 0.42, 0), "Anti-Ragdoll: OFF")
local FlyBtn = createBtn("Fly", UDim2.new(0.1, 0, 0.52, 0), "Fly: OFF")
local AimBtn = createBtn("Aim", UDim2.new(0.1, 0, 0.62, 0), "Aimbot: OFF")
local FOVBtn = createBtn("FOV", UDim2.new(0.1, 0, 0.72, 0), "Show FOV: OFF")

-- === 2. ЛОГИКА ===
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Переключение настроек
AutoFightBtn.MouseButton1Click:Connect(function() Settings.AutoFight = not Settings.AutoFight; AutoFightBtn.Text = "Auto Fight: " .. (Settings.AutoFight and "ON" or "OFF") end)
AutoComboBtn.MouseButton1Click:Connect(function() Settings.AutoCombo = not Settings.AutoCombo; AutoComboBtn.Text = "Auto Combo: " .. (Settings.AutoCombo and "ON" or "OFF") end)
ModeBtn.MouseButton1Click:Connect(function() Settings.ComboMode = (Settings.ComboMode == "Genos" and "Sonic" or "Genos"); ModeBtn.Text = "Mode: " .. string.upper(Settings.ComboMode) end)
AutoBlockBtn.MouseButton1Click:Connect(function() Settings.AutoBlock = not Settings.AutoBlock; AutoBlockBtn.Text = "Auto Block: " .. (Settings.AutoBlock and "ON" or "OFF") end)
AntiRagBtn.MouseButton1Click:Connect(function() Settings.AntiRagdoll = not Settings.AntiRagdoll; AntiRagBtn.Text = "Anti-Ragdoll: " .. (Settings.AntiRagdoll and "ON" or "OFF") end)
FlyBtn.MouseButton1Click:Connect(function() Settings.FlyEnabled = not Settings.FlyEnabled; FlyBtn.Text = "Fly: " .. (Settings.FlyEnabled and "ON" or "OFF") end)
AimBtn.MouseButton1Click:Connect(function() Settings.Aimbot = not Settings.Aimbot; AimBtn.Text = "Aimbot: " .. (Settings.Aimbot and "ON" or "OFF") end)
FOVBtn.MouseButton1Click:Connect(function() Settings.ShowFOV = not Settings.ShowFOV; FOVBtn.Text = "Show FOV: " .. (Settings.ShowFOV and "ON" or "OFF") end)

-- Авторизация (Key System)
local KeyInput = Instance.new("TextBox", MainFrame); KeyInput.Size = UDim2.new(0.8, 0, 0, 40); KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0); KeyInput.PlaceholderText = "Введите ключ..."
local KeyBtn = Instance.new("TextButton", MainFrame); KeyBtn.Size = UDim2.new(0.8, 0, 0, 40); KeyBtn.Position = UDim2.new(0.1, 0, 0.5, 0); KeyBtn.Text = "Войти"
KeyBtn.MouseButton1Click:Connect(function() if KeyInput.Text == CORRECT_KEY then HackFrame.Visible = true; KeyInput.Visible = false; KeyBtn.Visible = false end end)

-- === 3. ЦИКЛЫ ОБНОВЛЕНИЯ ===
RunService.RenderStepped:Connect(function()
    -- FOV и Aim
    fovCircle.Visible = Settings.ShowFOV
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
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

-- Основной цикл боя
task.spawn(function()
    while task.wait(0.1) do
        -- Auto Block & AntiRagdoll
        if Settings.AutoBlock or Settings.AntiRagdoll then
             local myChar = LocalPlayer.Character
             if myChar and myChar:FindFirstChild("Humanoid") then
                if Settings.AntiRagdoll and (myChar.Humanoid:GetState() == Enum.HumanoidStateType.Ragdoll) then myChar.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
                -- AutoBlock логика (из прошлых ответов) ...
             end
        end

        -- Combat Logic
        local enemy = nil -- (Логика поиска ближайшего врага из прошлых ответов)
        if (Settings.AutoFight or Settings.AutoCombo) and enemy then
            -- (Логика телепортации и doClick/useSkill)
        end
    end
end)

print("TSB Ultimate Hub Loaded!")
