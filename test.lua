-- [[ НАСТРОЙКИ АИМБОТА ]]
local Smoothness = 0.2 -- Плавность: чем меньше, тем быстрее наводка (0.1 - жестко, 0.4 - плавно)
local AimPart = "Head"  -- Куда целиться: "Head" (голова) или "HumanoidRootPart" (тело)

local function isPlayerVisible(targetChar)
    if not targetChar or not targetChar:FindFirstChild(AimPart) then return false end
    local castPoints = {Camera.CFrame.Position, targetChar[AimPart].Position}
    local ignoreList = {LocalPlayer.Character, targetChar}
    local parts = Camera:GetPartsObscuringTarget(castPoints, ignoreList)
    return #parts == 0 -- Если между нами и целью нет стен, вернет true
end

local function getClosestPlayerToCenter()
    local closestTarget, shortestDistance = nil, math.huge
    local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            
            -- Проверка на команду (как в ESP)
            local isTeammate = false
            if LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then isTeammate = true
            elseif LocalPlayer.TeamColor and player.TeamColor and LocalPlayer.TeamColor == player.TeamColor then isTeammate = true end
            
            if not isTeammate then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
                if onScreen then
                    local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                    
                    -- Проверяем, входит ли враг в круг FOV и ближе ли он остальных
                    if distanceToCenter <= states.Aim_FOV and distanceToCenter < shortestDistance then
                        -- Дополнительно проверяем видимость за стеной
                        if isPlayerVisible(player.Character) then
                            shortestDistance = distanceToCenter
                            closestTarget = player.Character[AimPart]
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

-- Основной цикл обновления аимбота и круга FOV
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = states.Aim_FOV
    FOVCircle.Visible = states.Aimbot
    
    if states.Aimbot then
        local target = getClosestPlayerToCenter()
        if target then
            -- Вычисляем нужное направление камеры
            local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            -- Используем Lerp для плавной интерполяции, чтобы камеру не срывало
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Smoothness)
        end
    end
end)
