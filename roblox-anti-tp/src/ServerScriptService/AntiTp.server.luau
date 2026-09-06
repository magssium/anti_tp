local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local TeleportConfig = require(ServerStorage:WaitForChild("TeleportConfig"))

local lastSafePositions = {}
local violationCounters = {}

RunService.Heartbeat:Connect(function(deltaTime)
	for _, player in pairs(Players:GetPlayers()) do
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local hrp = character.HumanoidRootPart
			local currentPos = hrp.Position

			if hrp.AssemblyLinearVelocity.Magnitude > 120 then
				continue
			end

			if not violationCounters[player] then
				violationCounters[player] = 0
			end

			local lastPos = lastSafePositions[player]
			if lastPos then
				local actualDistance = (currentPos - lastPos).Magnitude
				local maxAllowedDistance = (TeleportConfig.MAX_SPEED_LIMIT * deltaTime) + TeleportConfig.LATENCY_CUSHION

				if actualDistance > maxAllowedDistance then
					violationCounters[player] = violationCounters[player] + 1

					if violationCounters[player] >= TeleportConfig.MAX_VIOLATIONS then		
						if TeleportConfig.TELEPORT_BACK then
							hrp.CFrame = CFrame.new(lastPos)
						end
						
						violationCounters[player] = math.max(0, violationCounters[player] - 3)
					end
					continue
				else
					violationCounters[player] = math.max(0, violationCounters[player] - 0.1)
				end
			end

			lastSafePositions[player] = currentPos
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	lastSafePositions[player] = nil
	violationCounters[player] = nil
end)
