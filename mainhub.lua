--// MainHub.lua for InsaniX - ESP GUI with Sidebar (Draggable, Smaller, Centered, Smooth UI)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Destroy any previous UI
if game.CoreGui:FindFirstChild("InsaniX_UI") then
    game.CoreGui:FindFirstChild("InsaniX_UI"):Destroy()
end

-- UI Elements
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InsaniX_UI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 100, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Sidebar.BackgroundTransparency = 0.2
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner", Sidebar)
SidebarCorner.CornerRadius = UDim.new(0, 8)

-- Tab Button Template
local function createTabButton(name, yPos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.Text = name
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Parent = Sidebar

    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 6)
    return button
end

-- ESP Tab Frame
local EspFrame = Instance.new("Frame")
EspFrame.Size = UDim2.new(1, -110, 1, -20)
EspFrame.Position = UDim2.new(0, 110, 0, 10)
EspFrame.BackgroundTransparency = 1
EspFrame.Visible = true
EspFrame.Parent = MainFrame

-- ESP Toggle Button
local EspToggle = Instance.new("TextButton")
EspToggle.Size = UDim2.new(0, 160, 0, 35)
EspToggle.Position = UDim2.new(0, 10, 0, 10)
EspToggle.Text = "🔍 Player ESP [OFF]"
EspToggle.Font = Enum.Font.GothamBold
EspToggle.TextSize = 14
EspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EspToggle.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
EspToggle.BorderSizePixel = 0
EspToggle.Parent = EspFrame

local toggleCorner = Instance.new("UICorner", EspToggle)
toggleCorner.CornerRadius = UDim.new(0, 8)

-- ESP Logic
local espEnabled = false
local espObjects = {}

local function toggleESP()
    espEnabled = not espEnabled
    EspToggle.Text = espEnabled and "🔍 Player ESP [ON]" or "🔍 Player ESP [OFF]"

    for _, v in pairs(espObjects) do
        if v and v:FindFirstChild("NameLabel") then
            v.NameLabel.Visible = espEnabled
        end
    end
end

local function addESP(player)
    if player == LocalPlayer then return end
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NameLabel"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14

    billboard.Parent = head
    table.insert(espObjects, billboard)
end

-- Connect ESP toggle
EspToggle.MouseButton1Click:Connect(toggleESP)

-- Setup ESP for all current and future players
for _, player in pairs(Players:GetPlayers()) do
    addESP(player)
end

Players.PlayerAdded:Connect(addESP)
