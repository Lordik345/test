-- =======================================================================
-- НАСТРОЙКА КЛЮЧ-СИСТЕМЫ И ИНИЦИАЛИЗАЦИЯ
-- =======================================================================
local CorrectKey = "Lordikhhh"

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Lordikhhh Hub | MM2 Extended",
   LoadingTitle = "Загрузка чит-системы...",
   LoadingSubtitle = "by Lordikhhh",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true, 
   KeySettings = {
      Title = "Ключ-Система | Lordikhhh",
      Subtitle = "Введите ключ доступа",
      Note = "Правильный ключ: Lordikhhh",
      FileName = "LordikhhhKeyConfig",
      SaveKey = true, 
      GrabKeyFromUrl = false,
      Key = {CorrectKey}
   }
})

-- Переменные
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local EspEnabled = false
local CoinEspEnabled = false
local InfiniteJump = false

-- =======================================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ (ЛОГИКА)
-- =======================================================================

-- Определение роли игрока
local function GetPlayerRole(player)
    if player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife")) then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or (player.Character and player.Character:FindFirstChild("Gun")) then
        return "Sheriff"
    else
        return "Innocent"
    end
end

-- Поиск выпавшего пистолета на карте
local function GetDroppedGun()
    -- В ММ2 выпавший пистолет обычно респивнится как объект GunDrop в Workspace
    return Workspace:FindFirstChild("GunDrop")
end

-- Телепортация (безопасный метод с проверкой на наличие персонажа)
local function TeleportTo(cframe)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    else
        Rayfield:Notify({Title = "Ошибка", Content = "Твой персонаж еще не загрузился!", Duration = 3})
    end
end

-- Цикл для ESP (Только Убийца и Шериф)
RunService.RenderStepped:Connect(function()
    if not EspEnabled then 
        for _, pl in pairs(Players:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("Highlight") then
                pl.Character.Highlight:Destroy()
            end
        end
        return 
    end

    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetPlayerRole(pl)
            local highlight = pl.Character:FindFirstChild("Highlight")
            
            -- Если игрок не Убийца и не Шериф, удаляем подсветку (если она была)
            if role ~= "Murderer" and role ~= "Sheriff" then
                if highlight then highlight:Destroy() end
            else
                -- Если это Убийца или Шериф, создаем/обновляем подсветку
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Parent = pl.Character
                    highlight.FillOpacity = 0.4
                    highlight.OutlineOpacity = 1
                end

                if role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Красный для убийцы
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Синий для шерифа
                    highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                end
            end
        end
    end
end)

-- Цикл для Coin ESP
RunService.RenderStepped:Connect(function()
    local container = Workspace:FindFirstChild("Normal") and Workspace.Normal:FindFirstChild("CoinContainer")
    if not container or not CoinEspEnabled then 
        if container then
            for _, coin in pairs(container:GetChildren()) do
                if coin:FindFirstChild("BoxHandleAdornment") then coin.BoxHandleAdornment:Destroy() end
            end
        end
        return 
    end

    for _, coin in pairs(container:GetChildren()) do
        if coin:IsA("BasePart") and not coin:FindFirstChild("BoxHandleAdornment") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = coin.Size
            box.Color3 = Color3.fromRGB(255, 215, 0)
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Adornee = coin
            box.Transparency = 0.4
            box.Parent = coin
        end
    end
end)

-- Бесконечный прыжок
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)


-- =======================================================================
-- СОЗДАНИЕ ИНТЕРФЕЙСА (МЕНЮ)
-- =======================================================================

-- Вкладка "Визуалы"
local VisualsTab = Window:CreateTab("Визуалы", 4483362458)

VisualsTab:CreateToggle({
   Name = "ESP (Только Убийца и Шериф)",
   CurrentValue = false,
   Flag = "esp_roles",
   Callback = function(Value)
      EspEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Подсветка Монет (Coin ESP)",
   CurrentValue = false,
   Flag = "esp_coins",
   Callback = function(Value)
      CoinEspEnabled = Value
   end,
})

-- Вкладка "Телепорты"
local TeleportTab = Window:CreateTab("Телепорты", 4483362458)

TeleportTab:CreateButton({
   Name = "Телепорт к Убийце",
   Callback = function()
       local targetFound = false
       for _, pl in pairs(Players:GetPlayers()) do
           if pl ~= LocalPlayer and GetPlayerRole(pl) == "Murderer" then
               if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                   -- Телепортируем чуть выше игрока (на 3 студа), чтобы не застрять в текстурах
                   TeleportTo(pl.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0))
                   targetFound = true
                   Rayfield:Notify({Title = "Успех", Content = "Вы телепортировались к Убийце!", Duration = 3})
                   break
               end
           end
       end
       if not targetFound then
           Rayfield:Notify({Title = "Внимание", Content = "Убийца еще не определен или мертв.", Duration = 3})
       end
   end,
})

TeleportTab:CreateButton({
   Name = "Телепорт к Пистолету Шерифа",
   Callback = function()
       local gun = GetDroppedGun()
       if gun and gun:IsA("BasePart") then
           TeleportTo(gun.CFrame * CFrame.new(0, 2, 0))
           Rayfield:Notify({Title = "Успех", Content = "Вы телепортировались к пистолету!", Duration = 3})
       else
           Rayfield:Notify({Title = "Внимание", Content = "Выпавший пистолет на карте не найден (Шериф еще жив или пистолет никто не подобрал).", Duration = 3})
       end
   end,
})

-- Вкладка "Персонаж"
local PlayerTab = Window:CreateTab("Персонаж", 4483362458)

PlayerTab:CreateSlider({
   Name = "Скорость (WalkSpeed)",
   Range = {16, 120},
   Increment = 1,
   Suffix = "скорость",
   CurrentValue = 16,
   Flag = "speed_slider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
          LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateToggle({
   Name = "Бесконечный Прыжок",
   CurrentValue = false,
   Flag = "inf_jump",
   Callback = function(Value)
      InfiniteJump = Value
   end,
})

-- Уведомление о старте
Rayfield:Notify({
   Title = "Lordikhhh Hub",
   Content = "Скрипт готов к использованию!",
   Duration = 4,
   Image = 4483362458,
})
