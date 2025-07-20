-- 🌐 Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 🌈 Mutation Data
local Mutations = {
	Mega = {color = Color3.fromRGB(255, 85, 0), emoji = "💥"},
	Radiant = {color = Color3.fromRGB(255, 255, 102), emoji = "✨"},
	Rainbow = {color = Color3.fromRGB(255, 0, 255), emoji = "🌈"},
	Ascended = {color = Color3.fromRGB(0, 255, 255), emoji = "🌟"},
	Tranquil = {color = Color3.fromRGB(0, 255, 127), emoji = "🍃"},
	Shocked = {color = Color3.fromRGB(255, 255, 0), emoji = "⚡"},
	Tiny = {color = Color3.fromRGB(255, 192, 203), emoji = "🐭"},
	Windy = {color = Color3.fromRGB(135, 206, 250), emoji = "🌬️"},
	Inverted = {color = Color3.fromRGB(128, 0, 128), emoji = "🔁"},
	Frozen = {color = Color3.fromRGB(173, 216, 230), emoji = "❄️"},
	Shiny = {color = Color3.fromRGB(255, 255, 255), emoji = "💎"},
	Golden = {color = Color3.fromRGB(255, 215, 0), emoji = "🏅"}
}

-- 🎵 Sounds
local function playSound(id)
	local sound = Instance.new("Sound", SoundService)
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = 3
	sound:Play()
	Debris:AddItem(sound, 5)
end

-- 🌟 UI Creation
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "MutationFinder"
gui.ResetOnSpawn = false

-- 🔲 Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- 🌈 Rainbow Outline
local function applyRainbowOutline()
	local stroke = Instance.new("UIStroke", frame)
	stroke.Thickness = 2
	stroke.LineJoinMode = Enum.LineJoinMode.Round

	coroutine.wrap(function()
		while gui and gui.Parent do
			for hue = 0, 1, 0.01 do
				stroke.Color = Color3.fromHSV(hue, 1, 1)
				task.wait(0.03)
			end
		end
	end)()
end
applyRainbowOutline()

-- 🧬 Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🌱 Mutation Finder"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- 🎲 Reroll Button
local rerollBtn = Instance.new("TextButton", frame)
rerollBtn.Size = UDim2.new(1, -20, 0, 40)
rerollBtn.Position = UDim2.new(0, 10, 0, 50)
rerollBtn.Text = "🔁 Reroll Mutation"
rerollBtn.Font = Enum.Font.GothamBold
rerollBtn.TextSize = 16
rerollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
rerollBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rerollBtn.BorderSizePixel = 0

-- 💬 Result Label
local result = Instance.new("TextLabel", frame)
result.Size = UDim2.new(1, -20, 0, 60)
result.Position = UDim2.new(0, 10, 0, 110)
result.Text = ""
result.TextColor3 = Color3.fromRGB(255, 255, 255)
result.TextWrapped = true
result.Font = Enum.Font.GothamBold
result.TextSize = 22
result.BackgroundTransparency = 1

-- 🔄 Reroll Logic
local function rerollMutation()
	local chosen, display = nil, nil

	-- 🎰 Weighted Mutation Selection
	local pool = {}
	for mut, _ in pairs(Mutations) do
		local weight = 1
		if mut == "Shiny" or mut == "Windy" or mut == "Tiny" then
			weight = 3
		elseif mut == "Mega" or mut == "Rainbow" or mut == "Radiant" or mut == "Ascended" or mut == "Shocked" then
			weight = 1
		elseif mut == "Tranquil" then
			weight = 0.5
		end
		for i = 1, weight * 10 do table.insert(pool, mut) end
	end
	chosen = pool[math.random(1, #pool)]
	local data = Mutations[chosen]
	display = data.emoji .. " " .. chosen
	result.Text = display
	result.TextColor3 = data.color

	playSound(9118823102)
end

-- 🎬 Loading Screen
local function showLoadingScreen(callback)
	local blur = Instance.new("BlurEffect", Lighting)
	blur.Size = 20

	local loadingGui = Instance.new("ScreenGui", player.PlayerGui)
	loadingGui.Name = "LoadingScreen"

	local bg = Instance.new("Frame", loadingGui)
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BackgroundTransparency = 0.2

	local avatar = Instance.new("ImageLabel", bg)
	avatar.Size = UDim2.new(0, 100, 0, 100)
	avatar.Position = UDim2.new(0.5, -50, 0.5, -100)
	avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
	avatar.BackgroundTransparency = 1

	local stroke = Instance.new("UIStroke", avatar)
	stroke.Thickness = 3
	coroutine.wrap(function()
		while avatar and avatar.Parent do
			for hue = 0, 1, 0.01 do
				stroke.Color = Color3.fromHSV(hue, 1, 1)
				task.wait(0.03)
			end
		end
	end)()

	local loadingText = Instance.new("TextLabel", bg)
	loadingText.Size = UDim2.new(1, 0, 0, 50)
	loadingText.Position = UDim2.new(0, 0, 0.5, 20)
	loadingText.BackgroundTransparency = 1
	loadingText.Font = Enum.Font.GothamBold
	loadingText.TextSize = 28
	loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)

	coroutine.wrap(function()
		local dots = 0
		while loadingText and loadingText.Parent do
			loadingText.Text = "🔁 Rerolling Mutation" .. string.rep(".", dots)
			dots = (dots + 1) % 4
			task.wait(0.5)
		end
	end)()

	wait(2.5)
	loadingGui:Destroy()
	blur:Destroy()
	callback()
end

-- 📦 Toggle UI
local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 130, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.Text = "📂 Toggle UI"
toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- 🧪 Connect Button
rerollBtn.MouseButton1Click:Connect(function()
	showLoadingScreen(rerollMutation)
end)
