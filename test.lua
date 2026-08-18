-- Упрощенный вариант (без Rayfield)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Простая кнопка для теста
local ScreenGui = Instance.new("ScreenGui", (gethui and gethui()) or game.CoreGui)
local Button = Instance.new("TextButton", ScreenGui)
Button.Size = UDim2.new(0, 100, 0, 50)
Button.Position = UDim2.new(0, 0, 0.5, 0)
Button.Text = "AutoFarm (Simple)"
Button.MouseButton1Click:Connect(function()
    _G.Farm = not _G.Farm
    Button.Text = _G.Farm and "Farm: ON" or "Farm: OFF"
end)

-- Легкий цикл
game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Farm and LocalPlayer.Character then
        local enemy = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
        if enemy and enemy ~= LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            task.wait(0.1)
            game:GetService("VirtualUser"):Button1Up(Vector2.new(0,0))
        end
    end
end)
