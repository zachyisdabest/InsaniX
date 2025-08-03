--// MainHub.lua for InsaniX - ESP GUI with Sidebar and Player Features

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Destroy existing UI
if game.CoreGui:FindFirstChild("InsaniX_UI") then
    game.CoreGui:FindFirstChild("InsaniX_UI"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InsaniX_UI"
ScreenGui.ResetOnSpawn = false

-- Main UI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

-- Draggable top bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 10)

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BorderSizePixel = 0
Sidebar.Name = "Sidebar"
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = MainFrame
local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

local function createSidebarButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.Parent = Sidebar
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)
    return btn
end

-- Feature Frame
local FeatureFrame = Instance.new("Frame")
FeatureFrame.Position = UDim2.new(0, 130, 0, 40)
FeatureFrame.Size = UDim2.new(1, -140, 1, -50)
FeatureFrame.BackgroundTransparency = 1
FeatureFrame.Name = "FeatureFrame"
FeatureFrame.Parent = MainFrame

local function createToggle(name, positionY)
    local toggle = Instance.new("TextButton")
    toggle.Name = name .. "Toggle"
    toggle.Text = name .. " [OFF]"
    toggle.Position = UDim2.new(0, 10, 0, positionY)
    toggle.Size = UDim2.new(0, 200, 0, 30)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.BorderSizePixel = 0
    toggle.Parent = FeatureFrame
    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 6)
    return toggle
end

local espEnabled = false
local infiniteJumpEnabled = false
local flyEnabled = false

local function updateToggleState(button, state)
    button.Text = button.Name:gsub("Toggle", "") .. (state and " [ON]" or " [OFF]")
end

local EspToggle = createToggle("ESP", 10)
EspToggle.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateToggleState(EspToggle, espEnabled)
end)

local JumpToggle = createToggle("InfiniteJump", 50)
JumpToggle.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    updateToggleState(JumpToggle, infiniteJumpEnabled)
end)

local FlyToggle = createToggle("Fly", 90)
FlyToggle.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    updateToggleState(FlyToggle, flyEnabled)
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- Basic Fly (improved feel)
local BodyGyro, BodyVelocity
UserInputService.InputBegan:Connect(function(input, gpe)
    if flyEnabled and not gpe and input.KeyCode == Enum.KeyCode.Space then
        local char = LocalPlayer.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                BodyGyro = Instance.new("BodyGyro", root)
                BodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
                BodyGyro.P = 10000
                BodyGyro.CFrame = root.CFrame

                BodyVelocity = Instance.new("BodyVelocity", root)
                BodyVelocity.Velocity = Vector3.new(0, 40, 0)
                BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
                wait(0.2)
                BodyVelocity:Destroy()
                BodyGyro:Destroy()
            end
        end
    end
end)

-- ALT Key to toggle visibility
UserInputService.InputBegan:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.LeftAlt and not gpe then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "Close"
CloseBtn.Size = UDim2.new(0, 60, 0, 25)
CloseBtn.Position = UDim2.new(1, -70, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.Parent = TopBar
local closeCorner = Instance.new("UICorner", CloseBtn)
closeCorner.CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar Button for Player tab
local PlayerTabBtn = createSidebarButton("Player")
PlayerTabBtn.MouseButton1Click:Connect(function()
    FeatureFrame.Visible = true
end)
