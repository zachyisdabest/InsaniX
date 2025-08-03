# Load the base UI script and apply the requested fixes:
# 1. Improve the Fly functionality (make it smoother)
# 2. Add a "Coming Soon" button to the sidebar that shows a blank panel or hides others

updated_script = '''
--// InsaniX GUI Script (Improved Fly + Coming Soon Tab)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Destroy existing UI
if game.CoreGui:FindFirstChild("InsaniX_UI") then
    game.CoreGui.InsaniX_UI:Destroy()
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InsaniX_UI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.25
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = false

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Top bar (drag handle)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TopBar.BorderSizePixel = 0
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner", TopBar)
TopBarCorner.CornerRadius = UDim.new(0, 10)

-- Drag functionality
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

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

-- Content Frames
local PlayerFrame = Instance.new("Frame")
PlayerFrame.Size = UDim2.new(1, -130, 1, -40)
PlayerFrame.Position = UDim2.new(0, 130, 0, 35)
PlayerFrame.BackgroundTransparency = 1
PlayerFrame.Visible = false
PlayerFrame.Name = "PlayerFrame"
PlayerFrame.Parent = MainFrame

local ComingSoonFrame = Instance.new("Frame")
ComingSoonFrame.Size = PlayerFrame.Size
ComingSoonFrame.Position = PlayerFrame.Position
ComingSoonFrame.BackgroundTransparency = 1
ComingSoonFrame.Visible = false
ComingSoonFrame.Name = "ComingSoonFrame"
ComingSoonFrame.Parent = MainFrame

-- Placeholder Text
local ComingSoonLabel = Instance.new("TextLabel", ComingSoonFrame)
ComingSoonLabel.Size = UDim2.new(1, 0, 1, 0)
ComingSoonLabel.Text = "Coming Soon..."
ComingSoonLabel.Font = Enum.Font.Gotham
ComingSoonLabel.TextSize = 24
ComingSoonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ComingSoonLabel.BackgroundTransparency = 1

-- Function to make toggle buttons
local function createSidebarButton(name, order, frameToShow)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + (order * 35))
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        for _, frame in pairs({PlayerFrame, ComingSoonFrame}) do
            frame.Visible = false
        end
        if frameToShow then
            frameToShow.Visible = true
        end
    end)
end

-- Add Sidebar Buttons
createSidebarButton("Player", 0, PlayerFrame)
createSidebarButton("Coming Soon", 1, ComingSoonFrame)

-- Player Toggles
local function createToggleButton(name, yPos, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 180, 0, 35)
    toggle.Position = UDim2.new(0, 10, 0, yPos)
    toggle.Text = name .. ": OFF"
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 14
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    toggle.BorderSizePixel = 0
    toggle.Parent = PlayerFrame

    local corner = Instance.new("UICorner", toggle)
    corner.CornerRadius = UDim.new(0, 6)

    local state = false
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.Text = name .. ": " .. (state and "ON" or "OFF")
        if callback then callback(state) end
    end)
end

-- ESP Toggle (Placeholder)
createToggleButton("Player ESP", 10, function(state)
    -- ESP logic placeholder
end)

-- Infinite Jump
local infiniteJumpEnabled = false
createToggleButton("Infinite Jump", 50, function(state)
    infiniteJumpEnabled = state
end)

-- Speed (Simple WalkSpeed)
createToggleButton("Speed", 90, function(state)
    LocalPlayer.Character.Humanoid.WalkSpeed = state and 50 or 16
end)

-- Smooth Fly
local flying = false
createToggleButton("Fly", 130, function(state)
    flying = state
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local bv = hrp and hrp:FindFirstChild("InsaniX_Fly")
    if bv then bv:Destroy() end
    if not state then return end

    bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "InsaniX_Fly"
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero

    RunService.RenderStepped:Connect(function()
        if not flying or not bv or not hrp then return end
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
        bv.Velocity = dir.Unit * 60
    end)
end)

-- Alt Hide/Show
local hidden = false
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        hidden = not hidden
        MainFrame.Visible = not hidden
    end
end)

-- Infinite Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
'''

updated_script[:1200]  # Truncated preview; full script is returned below.
