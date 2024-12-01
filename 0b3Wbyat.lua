local startTime = tick()
wait(0.000000000000000001) -- fixes the bug where it only shows 0 seconds in load time
-- the IYR's loadstring/source should be here to get the loading time correctly

local endTime = tick()
local elapsedTime = endTime - startTime

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "ImageFadeGui"
screenGui.DisplayOrder = 10^6
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local sound = Instance.new("Sound")
sound.Parent = screenGui
sound.SoundId = "rbxassetid://8795831946"
sound.Volume = 1
sound.Looped = false
sound:Play()

local imageIDs = { "rbxassetid://117147401866447" }
local credits = { "by flx" }
local loadTimeMessage = "niggasense" .. string.format("%.20f", elapsedTime) .. " SECONDS"

local imageLabels = {}
local positions = {
	UDim2.new(0.5, -563 / 2, 0.1, -563 / 2), -- top
	UDim2.new(0.5, -563 / 2, 0.9, -563 / 2), -- bottom
	UDim2.new(0.1, -563 / 2, 0.5, -563 / 2), -- left
	UDim2.new(0.9, -563 / 2, 0.5, -563 / 2)  -- right
}
local moveGoals = {
	UDim2.new(0.5, -563 / 2, 0.5, -563 / 2), -- to center from top
	UDim2.new(0.5, -563 / 2, 0.5, -563 / 2), -- to center from bottom
	UDim2.new(0.5, -563 / 2, 0.5, -563 / 2), -- to center from left
	UDim2.new(0.5, -563 / 2, 0.5, -563 / 2)  -- to center from right
}

local moveDuration = 3.5
local fadeDuration = 2.5
local moveTweenInfo = TweenInfo.new(moveDuration, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local fadeTweenInfo = TweenInfo.new(fadeDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

for i = 1, 4 do
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Parent = screenGui
	imageLabel.Name = "flx" .. i
	imageLabel.Size = UDim2.new(0, 563, 0, 563)
	imageLabel.Position = positions[i]
	imageLabel.Image = imageIDs[1]
	imageLabel.BackgroundTransparency = 1
	imageLabel.ImageTransparency = 1
	imageLabel.ScaleType = Enum.ScaleType.Stretch
	imageLabel.ZIndex = 10^6

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Credits"
	textLabel.Parent = screenGui
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Size = UDim2.new(0, 560, 0, -40)
	textLabel.Font = Enum.Font.Code
	textLabel.FontSize = Enum.FontSize.Size18
	textLabel.Text = credits[1]
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextTransparency = 1
	textLabel.ZIndex = 10^6 + 1

	textLabel.Position = UDim2.new(imageLabel.Position.X.Scale, imageLabel.Position.X.Offset, imageLabel.Position.Y.Scale + 563 / screenGui.AbsoluteSize.Y, imageLabel.Position.Y.Offset + imageLabel.Size.Y.Offset + 10)

	local moveGoal = { Position = moveGoals[i] }
	local moveTween = TweenService:Create(imageLabel, moveTweenInfo, moveGoal)

	local moveTextGoal = {
		Position = UDim2.new(
			moveGoals[i].X.Scale,
			moveGoals[i].X.Offset,
			moveGoals[i].Y.Scale + 563 / screenGui.AbsoluteSize.Y,
			moveGoals[i].Y.Offset + 10
		)
	}
	local moveTextTween = TweenService:Create(textLabel, moveTweenInfo, moveTextGoal)

	local fadeInGoal = { ImageTransparency = 0 }
	local fadeOutGoal = { ImageTransparency = 1 }

	local fadeInTween = TweenService:Create(imageLabel, fadeTweenInfo, fadeInGoal)
	local fadeInTextTween = TweenService:Create(textLabel, fadeTweenInfo, { TextTransparency = 0 })
	local fadeOutTween = TweenService:Create(imageLabel, fadeTweenInfo, fadeOutGoal)
	local fadeOutTextTween = TweenService:Create(textLabel, fadeTweenInfo, { TextTransparency = 1 })

	table.insert(imageLabels, {imageLabel, textLabel, moveTween, moveTextTween, fadeInTween, fadeInTextTween, fadeOutTween, fadeOutTextTween})
end

local function fadeInAndMove()
	for _, labelData in ipairs(imageLabels) do
		local imageLabel, textLabel, moveTween, moveTextTween, fadeInTween, fadeInTextTween, fadeOutTween, fadeOutTextTween = unpack(labelData)
		fadeInTween:Play()
		fadeInTextTween:Play()
		moveTween:Play()
		moveTextTween:Play()
		moveTween.Completed:Connect(
			function()
				wait(1)
				textLabel.Text = loadTimeMessage
				fadeOutTween:Play()
				fadeOutTextTween:Play()
				fadeOutTween.Completed:Connect(
					function()
						screenGui:Destroy()
					end
				)
			end
		)
	end
end

fadeInAndMove()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local players = game:GetService("Players")
local wrk = game:GetService("Workspace")
local plr = players.LocalPlayer
local hrp = plr.Character:WaitForChild("HumanoidRootPart")
local humanoid = plr.Character:WaitForChild("Humanoid")
local camera = wrk.CurrentCamera
local mouse = plr:GetMouse()

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local hue = 0
local rainbowFov = false
local rainbowSpeed = 0.005

local aimFov = 100
local aimParts = {"Head"}
local aiming = false
local predictionStrength = 0.065
local smoothing = 0.05

local aimbotEnabled = false
local wallCheck = true
local stickyAimEnabled = false
local teamCheck = false
local healthCheck = false
local minHealth = 0

local antiAim = false

local antiAimAmountX = 0
local antiAimAmountY = -100
local antiAimAmountZ = 0

local antiAimMethod = "Reset Velo"

local randomVeloRange = 100

local spinBot = false
local spinBotSpeed = 20

local circleColor = Color3.fromRGB(255, 0, 0)
local targetedCircleColor = Color3.fromRGB(0, 255, 0)

local aimViewerEnabled = false
local ignoreSelf = true

local Window = Rayfield:CreateWindow({
    Name = "▶ Niggasense V2 ◀",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by flx",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "",
        FileName = ""
    },
    KeySystem = true,
    KeySettings = {
       Title = "niggasense.uwu | flx",
       Subtitle = "niggasense.uwu",
       Note = "enter key",
       FileName = "Key",
       SaveKey = false,
       GrabKeyFromSite = true,
       Key = {"https://pastebin.com/raw/4aQ1dK9s"}
	}
})

local Aimbot = Window:CreateTab("Aimbot 🎯")
local AntiAim = Window:CreateTab("Anti-Aim 😡")
local Misc = Window:CreateTab("Misc 🤷‍♂️")
local Visuals = Window:CreateTab("Visuals")

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = aimFov
fovCircle.Filled = false
fovCircle.Color = circleColor
fovCircle.Visible = false

local currentTarget = nil

local function checkTeam(player)
    if teamCheck and player.Team == plr.Team then
        return true
    end
    return false
end

local function checkWall(targetCharacter)
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return true end

    local origin = camera.CFrame.Position
    local direction = (targetHead.Position - origin).unit * (targetHead.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {plr.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = wrk:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function getClosestPart(character)
    local closestPart = nil
    local shortestCursorDistance = aimFov
    local cameraPos = camera.CFrame.Position

    for _, partName in ipairs(aimParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local partPos = camera:WorldToViewportPoint(part.Position)
            local screenPos = Vector2.new(partPos.X, partPos.Y)
            local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

            if cursorDistance < shortestCursorDistance and partPos.Z > 0 then
                shortestCursorDistance = cursorDistance
                closestPart = part
            end
        end
    end

    return closestPart
end

local function getTarget()
    local nearestPlayer = nil
    local closestPart = nil
    local shortestCursorDistance = aimFov

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= plr and player.Character and not checkTeam(player) then
            if player.Character.Humanoid.Health >= minHealth or not healthCheck then
                local targetPart = getClosestPart(player.Character)
                if targetPart then
                    local screenPos = camera:WorldToViewportPoint(targetPart.Position)
                    local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                    if cursorDistance < shortestCursorDistance then
                        if not checkWall(player.Character) or not wallCheck then
                            shortestCursorDistance = cursorDistance
                            nearestPlayer = player
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end

    return nearestPlayer, closestPart
end

local function predict(player, part)
    if player and part then
        local velocity = player.Character.HumanoidRootPart.Velocity
        local predictedPosition = part.Position + (velocity * predictionStrength)
        return predictedPosition
    end
    return nil
end

local function smooth(from, to)
    return from:Lerp(to, smoothing)
end

local function aimAt(player, part)
    local predictedPosition = predict(player, part)
    if predictedPosition then
        if player.Character.Humanoid.Health >= minHealth or not healthCheck then
            local targetCFrame = CFrame.new(camera.CFrame.Position, predictedPosition)
            camera.CFrame = smooth(camera.CFrame, targetCFrame)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local offset = 50
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + offset)

        if rainbowFov then
            hue = hue + rainbowSpeed
            if hue > 1 then hue = 0 end
            fovCircle.Color = Color3.fromHSV(hue, 1, 1)
        else
            if aiming and currentTarget then
                fovCircle.Color = targetedCircleColor
            else
                fovCircle.Color = circleColor
            end
        end

        if aiming then
            if stickyAimEnabled and currentTarget then
                local headPos = camera:WorldToViewportPoint(currentTarget.Character.Head.Position)
                local screenPos = Vector2.new(headPos.X, headPos.Y)
                local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if cursorDistance > aimFov or (wallCheck and checkWall(currentTarget.Character)) or checkTeam(currentTarget) then
                    currentTarget = nil
                end
            end

            if not stickyAimEnabled or not currentTarget then
                local target, targetPart = getTarget()
                currentTarget = target
                currentTargetPart = targetPart
            end

            if currentTarget and currentTargetPart then
                aimAt(currentTarget, currentTargetPart)
            end
        else
            currentTarget = nil
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if antiAim then
        if antiAimMethod == "Reset Velo" then
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(antiAimAmountX, antiAimAmountY, antiAimAmountZ)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        elseif antiAimMethod == "Reset Pos [BROKEN]" then
            local pos = hrp.CFrame
            hrp.Velocity = Vector3.new(antiAimAmountX, antiAimAmountY, antiAimAmountZ)
            RunService.RenderStepped:Wait()
            hrp.CFrame = pos
        elseif antiAimMethod == "Random Velo" then
            local vel = hrp.Velocity
            local a = math.random(-randomVeloRange,randomVeloRange)
            local s = math.random(-randomVeloRange,randomVeloRange)
            local d = math.random(-randomVeloRange,randomVeloRange)
            hrp.Velocity = Vector3.new(a,s,d)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        end
    end
end)

mouse.Button2Down:Connect(function()
    if aimbotEnabled then
        aiming = true
    end
end)

mouse.Button2Up:Connect(function()
    if aimbotEnabled then
        aiming = false
    end
end)

local aimbot = Aimbot:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimbotEnabled = Value
        fovCircle.Visible = Value
    end
})

local aimpart = Aimbot:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head","HumanoidRootPart","Left Arm","Right Arm","Torso","Left Leg","Right Leg"},
    CurrentOption = {"Head"},
    MultipleOptions = true,
    Flag = "AimPart",
    Callback = function(Options)
        aimParts = Options
    end,
 })

local smoothingslider = Aimbot:CreateSlider({
    Name = "Smoothing",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 5,
    Flag = "Smoothing",
    Callback = function(Value)
        smoothing = 1 - (Value / 100)
    end,
})

local predictionstrength = Aimbot:CreateSlider({
    Name = "Prediction Strength",
    Range = {0, 0.2},
    Increment = 0.001,
    CurrentValue = 0.065,
    Flag = "PredictionStrength",
    Callback = function(Value)
        predictionStrength = Value
    end,
})

local fovvisibility = Aimbot:CreateToggle({
    Name = "Fov Visibility",
    CurrentValue = true,
    Flag = "FovVisibility",
    Callback = function(Value)
        fovCircle.Visible = Value
    end
})

local aimbotfov = Aimbot:CreateSlider({
    Name = "Aimbot Fov",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 100,
    Flag = "AimbotFov",
    Callback = function(Value)
        aimFov = Value
        fovCircle.Radius = aimFov
    end,
})

local wallcheck = Aimbot:CreateToggle({
    Name = "Wall Check",
    CurrentValue = true,
    Flag = "WallCheck",
    Callback = function(Value)
        wallCheck = Value
    end
})

local stickyaim = Aimbot:CreateToggle({
    Name = "Sticky Aim",
    CurrentValue = false,
    Flag = "StickyAim",
    Callback = function(Value)
        stickyAimEnabled = Value
    end
})

local teamchecktoggle = Aimbot:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(Value)
        teamCheck = Value
    end
})

local healthchecktoggle = Aimbot:CreateToggle({
    Name = "Health Check",
    CurrentValue = false,
    Flag = "HealthCheck",
    Callback = function(Value)
        healthCheck = Value
    end
})

local minhealth = Aimbot:CreateSlider({
    Name = "Min Health",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "MinHealth",
    Callback = function(Value)
        minHealth = Value
    end,
})

local circlecolor = Aimbot:CreateColorPicker({
    Name = "Fov Color",
    Color = circleColor,
    Callback = function(Color)
        circleColor = Color
        fovCircle.Color = Color
    end
})

local targetedcirclecolor = Aimbot:CreateColorPicker({
    Name = "Targeted Fov Color",
    Color = targetedCircleColor,
    Callback = function(Color)
        targetedCircleColor = Color
    end
})

local circlerainbow = Aimbot:CreateToggle({
    Name = "Rainbow Fov",
    CurrentValue = false,
    Flag = "RainbowFov",
    Callback = function(Value)
        rainbowFov = Value
    end
})

local antiaimtoggle = AntiAim:CreateToggle({
    Name = "Anti-Aim",
    CurrentValue = false,
    Flag = "AntiAim",
    Callback = function(Value)
        antiAim = Value
        if Value then
            Rayfield:Notify({Title = "Anti-Aim", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            Rayfield:Notify({Title = "Anti-Aim", Content = "Disabled!", Duration = 1, Image = 4483362458,})
        end
    end
})

local antiaimmethod = AntiAim:CreateDropdown({
    Name = "Anti-Aim Method",
    Options = {"Reset Velo","Random Velo","Reset Pos [BROKEN]"},
    CurrentOption = "Reset Velo",
    Flag = "AntiAimMethod",
    Callback = function(Option)
        antiAimMethod = type(Option) == "table" and Option[1] or Option
        if antiAimMethod == "Reset Velo" then
            Rayfield:Notify({Title = "Reset Velocity", Content = "Nobody will see it, but exploiters will aim in the wrong place.", Duration = 5, Image = 4483362458,})
        elseif antiAimMethod == "Reset Pos [BROKEN]" then
            Rayfield:Notify({Title = "Reset Pos [BROKEN]", Content = "This is a bit buggy right now, so idk if it works that well", Duration = 5, Image = 4483362458,})
        elseif antiAimMethod == "Random Velo" then
            Rayfield:Notify({Title = "Random Velocity", Content = "Depending on ping some peoplev will see u 'teleporting' around but you are actually in the same spot the entire time.", Duration = 5, Image = 4483362458,})
        end
    end,
})

local antiaimamountx = AntiAim:CreateSlider({
    Name = "Anti-Aim Amount X",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = 0,
    Flag = "AntiAimAmountX",
    Callback = function(Value)
        antiAimAmountX = Value
    end,
})

local antiaimamounty = AntiAim:CreateSlider({
    Name = "Anti-Aim Amount Y",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = -100,
    Flag = "AntiAimAmountY",
    Callback = function(Value)
        antiAimAmountY = Value
    end,
})

local antiaimamountz = AntiAim:CreateSlider({
    Name = "Anti-Aim Amount Z",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = 0,
    Flag = "AntiAimAmountZ",
    Callback = function(Value)
        antiAimAmountZ = Value
    end,
})

local randomvelorange = AntiAim:CreateSlider({
    Name = "Random Velo Range",
    Range = {0, 1000},
    Increment = 10,
    CurrentValue = 100,
    Flag = "RandomVeloRange",
    Callback = function(Value)
        randomVeloRange = Value
    end,
})

-- [< Misc >]

local spinbottoggle = Misc:CreateToggle({
    Name = "Spin-Bot",
    CurrentValue = false,
    Flag = "SpinBot",
    Callback = function(Value)
        spinBot = Value
        if Value then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = false
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,spinBotSpeed,0)
            Rayfield:Notify({Title = "Spin Bot", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = true
            Rayfield:Notify({Title = "Spin Bot", Content = "Disabled!", Duration = 1, Image = 4483362458,})
        end
    end
})

local spinbotspeed = Misc:CreateSlider({
    Name = "Spin-Bot Speed",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 20,
    Flag = "SpinBotSpeed",
    Callback = function(Value)
        spinBotSpeed = Value
        if spinBot then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,Value,0)
        end
    end,
})

local ServerHop = Misc:CreateButton({
	Name = "Server Hop",
	Callback = function()
		if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
            local body = HttpService:JSONDecode(req.Body)
        
            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
        
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
            else
                Rayfield:Notify({Title = "Server Hop", Content = "Couldn't find a valid server!!!", Duration = 1, Image = 4483362458,})
            end
        else
            Rayfield:Notify({Title = "Server Hop", Content = "Your executor is ass!", Duration = 1, Image = 4483362458,})
        end
	end,
})

Misc:CreateSlider({
    Name = "Walkspeed Slider",
    Range = {0, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
    end,
 })
 
 
 local player = game:GetService("Players").LocalPlayer
 local camera = game:GetService("Workspace").CurrentCamera
 local mouse = player:GetMouse()
 
 -- Function to create the visual elements for ESP (Box, Health Bar)
 local function NewQuad(thickness, color)
     local quad = Drawing.new("Quad")
     quad.Visible = false
     quad.PointA = Vector2.new(0,0)
     quad.PointB = Vector2.new(0,0)
     quad.PointC = Vector2.new(0,0)
     quad.PointD = Vector2.new(0,0)
     quad.Color = color
     quad.Filled = false
     quad.Thickness = thickness
     quad.Transparency = 1
     return quad
 end
 
 local function NewLine(thickness, color)
     local line = Drawing.new("Line")
     line.Visible = false
     line.From = Vector2.new(0, 0)
     line.To = Vector2.new(0, 0)
     line.Color = color 
     line.Thickness = thickness
     line.Transparency = 1
     return line
 end
 
 local ESPEnabled = false -- Variable to track if ESP is enabled or not
 
 -- Function to update ESP for a specific player
 local function UpdateESP(plr)
     local library = {
         box = NewQuad(2, Color3.fromRGB(255, 0, 0)),
         healthBar = NewLine(2, Color3.fromRGB(0, 255, 0))
     }
 
     local function Update()
         local connection
         connection = game:GetService("RunService").RenderStepped:Connect(function()
             if ESPEnabled then  -- Check if ESP is enabled before drawing
                 if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                     local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                     if OnScreen then
                         local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                         local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)
 
                         -- Box ESP
                         library.box.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY*2)
                         library.box.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2)
                         library.box.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)
                         library.box.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY*2)
 
                         -- Health Bar ESP
                         local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY*2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY*2)).magnitude 
                         local healthoffset = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * d
                         library.healthBar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2)
                         library.healthBar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY*2 - healthoffset)
 
                         -- Update visibility
                         library.box.Visible = true
                         library.healthBar.Visible = true
                     else
                         library.box.Visible = false
                         library.healthBar.Visible = false
                     end
                 else
                     library.box.Visible = false
                     library.healthBar.Visible = false
                 end
             else
                 library.box.Visible = false
                 library.healthBar.Visible = false
             end
         end)
     end
 
     coroutine.wrap(Update)()
 end
 
 -- Loop through all players and create ESP
 for _, v in pairs(game:GetService("Players"):GetPlayers()) do
     if v.Name ~= player.Name then
         UpdateESP(v)
     end
 end
 
 game.Players.PlayerAdded:Connect(function(newPlr)
     if newPlr.Name ~= player.Name then
         UpdateESP(newPlr)
     end
 end)
 
 local Toggle = Visuals:CreateToggle({
    Name = "Enable ESP",   -- Name of the toggle button
    CurrentValue = false,  -- Default value (off)
    Flag = "ToggleESP",    -- Flag used to save/load the setting
    Callback = function(Value)
       ESPEnabled = Value  -- Update the ESPEnabled variable based on the toggle state
       print("ESP Enabled:", ESPEnabled)  -- Optionally print the status for debugging
    end,
 })
