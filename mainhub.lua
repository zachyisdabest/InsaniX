-- Gui Library (Synapse compatible)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Destroy existing UI if reloaded
if game.CoreGui:FindFirstChild("InsaniX_UI") then
    game.CoreGui:FindFirstChild("InsaniX_UI"):Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "InsaniX_UI"
gui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Draggable = false

-- Top bar for dragging
local topBar = Instance.new("Frame", mainFrame)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BorderSizePixel = 0

local dragging, dragInput, dragStart, startPos

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title
local title = Instance.new("TextLabel", topBar)
title.Text = "Insani X - Steal A Brainrot"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14

-- Sidebar
local sidebar = Instance.new("Frame", mainFrame)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sidebar.Size = UDim2.new(0, 150, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)

local function addSidebarButton(name, callback)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
end

-- Feature Panel
local featurePanel = Instance.new("Frame", mainFrame)
featurePanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
featurePanel.Size = UDim2.new(1, -150, 1, -30)
featurePanel.Position = UDim2.new(0, 150, 0, 30)
featurePanel.Visible = true

local UIListLayout = Instance.new("UIListLayout", featurePanel)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Toggle function
local function createToggle(name, action)
    local container = Instance.new("Frame", featurePanel)
    container.Size = UDim2.new(1, -10, 0, 30)
    container.BackgroundTransparency = 1

    local toggle = Instance.new("TextButton", container)
    toggle.Size = UDim2.new(0, 100, 1, 0)
    toggle.Position = UDim2.new(1, -110, 0, 0)
    toggle.Text = "OFF"
    toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12

    local label = Instance.new("TextLabel", container)
    label.Text = name
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = enabled and "ON" or "OFF"
        toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
        action(enabled)
    end)
end

-- Example Features
createToggle("Infinite Jump", function(on)
    if on then
        _G.infjump = true
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.infjump then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    else
        _G.infjump = false
    end
end)

createToggle("Speed", function(on)
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = on and 80 or 16
    end
end)

createToggle("Fly", function(on)
    local flying = false
    local bodyGyro, bodyVelocity

    local function startFly()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end

        flying = true
        bodyGyro = Instance.new("BodyGyro", char.HumanoidRootPart)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = char.HumanoidRootPart.CFrame

        bodyVelocity = Instance.new("BodyVelocity", char.HumanoidRootPart)
        bodyVelocity.Velocity = Vector3.zero
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        game:GetService("RunService").Heartbeat:Connect(function()
            if not flying then return end
            local cam = workspace.CurrentCamera
            bodyGyro.CFrame = cam.CFrame
            bodyVelocity.Velocity = cam.CFrame.LookVector * 80
        end)
    end

    local function stopFly()
        flying = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end

    if on then startFly() else stopFly() end
end)

createToggle("ESP", function(on)
    -- ESP logic placeholder
end)

-- Sidebar buttons
addSidebarButton("Player", function()
    featurePanel.Visible = true
end)

addSidebarButton("Coming Soon", function()
    featurePanel.Visible = false
end)

-- Close Button
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Alt key toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        gui.Enabled = not gui.Enabled
    end
end)
