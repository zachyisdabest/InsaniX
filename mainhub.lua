--// MainHub.lua for InsaniX - Enhanced with Toggles and Draggable TitleBar

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Remove old UI if exists
if game.CoreGui:FindFirstChild("InsaniX_UI") then
    game.CoreGui:FindFirstChild("InsaniX_UI"):Destroy()
end

-- Screen GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InsaniX_UI"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 270)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Title Bar (Draggable only here)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

-- Dragging (TopBar only)
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local dragging
local dragInput
local dragStart
local startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

RunService.RenderStepped:Connect(function()
	if dragging and dragInput then
		local delta = dragInput.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)


-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Player Button
local PlayerButton = Instance.new("TextButton")
PlayerButton.Size = UDim2.new(1, -20, 0, 30)
PlayerButton.Position = UDim2.new(0, 10, 0, 40)
PlayerButton.Text = "👤 Player"
PlayerButton.Font = Enum.Font.GothamBold
PlayerButton.TextSize = 14
PlayerButton.TextColor3 = Color3.new(1, 1, 1)
PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerButton.BorderSizePixel = 0
PlayerButton.Parent = Sidebar
Instance.new("UICorner", PlayerButton).CornerRadius = UDim.new(0, 6)

-- Right Panel
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(1, -130, 1, -40)
RightPanel.Position = UDim2.new(0, 130, 0, 35)
RightPanel.BackgroundTransparency = 1
RightPanel.Visible = false
RightPanel.Parent = MainFrame

-- Toggle Builder
local function createToggle(labelText, yPosition, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 220, 0, 35)
    toggle.Position = UDim2.new(0, 10, 0, yPosition)
    toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    toggle.Text = "❌ " .. labelText
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = true
    toggle.Parent = RightPanel

    local on = false
    toggle.MouseButton1Click:Connect(function()
        on = not on
        toggle.Text = (on and "✅ " or "❌ ") .. labelText
        if callback then callback(on) end
    end)

    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
end

-- Features
createToggle("Player ESP", 0, function(state)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            if state then
                if not v.Character.Head:FindFirstChild("ESPTag") then
                    local bill = Instance.new("BillboardGui", v.Character.Head)
                    bill.Name = "ESPTag"
                    bill.Adornee = v.Character.Head
                    bill.Size = UDim2.new(0, 100, 0, 40)
                    bill.StudsOffset = Vector3.new(0, 2, 0)
                    bill.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", bill)
                    label.Text = v.Name
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                end
            else
                if v.Character.Head:FindFirstChild("ESPTag") then
                    v.Character.Head.ESPTag:Destroy()
                end
            end
        end
    end
end)

createToggle("Infinite Jump", 40, function(state)
    if state then
        _G.InfJump = true
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    else
        _G.InfJump = false
    end
end)

createToggle("Fly", 80, function(state)
    _G.FLYING = state
    local char = LocalPlayer.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(99999, 99999, 99999)
    bv.Velocity = Vector3.new(0, 0, 0)

    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        if not _G.FLYING then
            bv:Destroy()
            conn:Disconnect()
            return
        end
        bv.Velocity = LocalPlayer:GetMouse().Hit.LookVector * 50
    end)
end)

createToggle("Speed", 120, function(state)
    if state then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "✖"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Mobile Hide on Drag to Corner
if UserInputService.TouchEnabled then
    local function isNearEdge()
        local pos = MainFrame.Position
        return pos.X.Offset < 20 or pos.Y.Offset < 20
    end
    MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        if isNearEdge() then
            MainFrame.Visible = false
        end
    end)
end

-- Keyboard ALT to Hide UI
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Player Button logic
PlayerButton.MouseButton1Click:Connect(function()
    RightPanel.Visible = not RightPanel.Visible
end)
