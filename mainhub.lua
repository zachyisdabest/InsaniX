--// MainHub.lua - InsaniX GUI (Modern Sidebar + Features)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Destroy any existing GUI
if game.CoreGui:FindFirstChild("InsaniX_UI") then
    game.CoreGui:FindFirstChild("InsaniX_UI"):Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InsaniX_UI"
ScreenGui.ResetOnSpawn = false

-- Create Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Make draggable
MainFrame.Active = true
MainFrame.Draggable = true

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.2
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -20)
ContentFrame.Position = UDim2.new(0, 120, 0, 10)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Player Section Title
local PlayerLabel = Instance.new("TextLabel")
PlayerLabel.Size = UDim2.new(1, -20, 0, 20)
PlayerLabel.Position = UDim2.new(0, 10, 0, 10)
PlayerLabel.Text = "👤 Player"
PlayerLabel.Font = Enum.Font.GothamBold
PlayerLabel.TextSize = 14
PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerLabel.BackgroundTransparency = 1
PlayerLabel.Parent = Sidebar

-- Toggle Creator
local toggleY = 40
local toggles = {}

local function createToggle(name, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -20, 0, 30)
    toggle.Position = UDim2.new(0, 10, 0, toggleY)
    toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.Gotham
    toggle.TextSize = 13
    toggle.Text = "❌ " .. name
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = true
    toggle.Parent = Sidebar

    Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.Text = (enabled and "✅ " or "❌ ") .. name
        callback(enabled)
    end)

    toggleY = toggleY + 35
    toggles[name] = toggle
end

-- Features
local function toggleESP(enabled)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local gui = head:FindFirstChild("NameLabel")
                if not gui and enabled then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "NameLabel"
                    billboard.Adornee = head
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = head

                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = player.Name
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                elseif gui then
                    gui.Enabled = enabled
                end
            end
        end
    end
end

local flyEnabled = false
local function toggleFly(enabled)
    flyEnabled = enabled
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local bodyVel = hrp and hrp:FindFirstChild("InsaniXFly")

    if enabled then
        if not bodyVel then
            bodyVel = Instance.new("BodyVelocity")
            bodyVel.Name = "InsaniXFly"
            bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bodyVel.Velocity = Vector3.zero
            bodyVel.Parent = hrp
        end

        local conn
        conn = game:GetService("RunService").Heartbeat:Connect(function()
            if not flyEnabled then conn:Disconnect() return end
            local direction = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction -= Vector3.new(0, 1, 0) end
            bodyVel.Velocity = direction * 50
        end)
    elseif bodyVel then
        bodyVel:Destroy()
    end
end

local function toggleSpeed(enabled)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = enabled and 50 or 16
    end
end

local infiniteJumpConn
local function toggleInfiniteJump(enabled)
    if enabled then
        infiniteJumpConn = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    elseif infiniteJumpConn then
        infiniteJumpConn:Disconnect()
        infiniteJumpConn = nil
    end
end

-- Create Feature Toggles
createToggle("Player ESP", toggleESP)
createToggle("Fly", toggleFly)
createToggle("Speed", toggleSpeed)
createToggle("Infinite Jump", toggleInfiniteJump)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "❌"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = MainFrame

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Alt Key Toggle (Desktop only)
local visible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        visible = not visible
        ScreenGui.Enabled = visible
    end
end)
