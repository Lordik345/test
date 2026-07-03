-- Загрузка библиотеки интерфейса
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- Твоя ссылка на Gist с ключом
local KeyURL = "https://gist.githubusercontent.com/Lordik345/bf1e13ea7bda70ce4c7bdad7b819a474/raw/f910cd6baa0f52cfeff527935b8dcbc729a01eff/gistfile1.txt"

local KeyWindow = Library.CreateLib("Key System | Lordikhhh", "DarkTheme")
local KeyTab = KeyWindow:NewTab("Авторизация")
local KeySection = KeyTab:NewSection("Введите ключ для доступа:")

local EnteredKey = ""

KeySection:NewTextBox("Ключ:", "Введите пароль", function(text)
    EnteredKey = text
end)

KeySection:NewButton("Проверить ключ", "Запустить Lordikhhh Hub", function()
    local success, response = pcall(function() return game:HttpGet(KeyURL) end)
    
    -- Очищаем ответ от лишних символов (пробелы, переносы строк)
    local remoteKey = success and response:gsub("%s+", "") or ""
    local userInput = EnteredKey:gsub("%s+", "")
    
    if success and remoteKey == userInput then
        -- Успешная проверка: удаляем окно ключа
        game:GetService("CoreGui"):FindFirstChild("Key System | Lordikhhh"):Destroy()
        
        -- ОСНОВНОЕ МЕНЮ
        local Window = Library.CreateLib("Lordikhhh Hub | Keyboard Escape", "DarkTheme")
        
        local MainTab = Window:NewTab("Главная")
        local MainSection = MainTab:NewSection("Фарм и Скорость")
        
        local _G.AutoFarm = false
        
        MainSection:NewToggle("Авто-Фарм Скорости", "Персонаж сам фармит скорость", function(state)
            _G.AutoFarm = state
            while _G.AutoFarm do
                task.wait(0.1)
                local player = game.Players.LocalPlayer
                if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 0.1)
                    task.wait(0.1)
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -0.1)
                end
            end
        end)
        
        MainSection:NewButton("Телепорт на Финиш", "Переносит к зоне победы", function()
            local player = game.Players.LocalPlayer
            local winPart = workspace:FindFirstChild("WinPart", true) or workspace:FindFirstChild("EndZone", true) or workspace:FindFirstChild("Finish", true)
            
            if winPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = winPart.CFrame + Vector3.new(0, 3, 0)
            else
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 5000)
            end
        end)
        
        local PlayerTab = Window:NewTab("Игрок")
        local PlayerSection = PlayerTab:NewSection("Модификации")
        
        PlayerSection:NewSlider("Добавить Скорость", "Меняет WalkSpeed", 500, 16, function(s)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
        end)
        
        PlayerSection:NewSlider("Высота Прыжка", "Меняет JumpPower", 300, 50, function(j)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = j
        end)
        
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Ошибка!",
            Text = "Неверный ключ или ошибка связи с GitHub.",
            Duration = 5
        })
    end
end)
