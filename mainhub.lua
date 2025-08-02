-- // InsaniX GUI - Preview Layout Based on Screenshot

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "InsaniX_GUI"
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 600, 0, 350)
main.Position = UDim2.new(0.5, -300, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BackgroundTransparency = 0.2
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Name = "MainFrame"
main.Active = true
main.Draggable = true
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.ZIndex = 1
main.AutoLocalize = false

-- Left Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0

local tabs = {
    "Steal Tab", "Buy Tab", "Server Hop Tab", "Webhook Tab",
    "Player Tab", "Esp Tab", "Window and File Configuration", "Job Id", "Window"
}

for i, name in ipairs(tabs) do
    local button = Instance.new("TextButton", sidebar)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 32)
    button.BackgroundTransparency = 1
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Text = name
end

-- Right Content Frame
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -160, 1, -20)
content.Position = UDim2.new(0, 160, 0, 10)
content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
content.BackgroundTransparency = 0.2
content.BorderSizePixel = 0

-- Function to create toggle entries
local function createFeature(text, desc, positionY)
    local item = Instance.new("Frame", content)
    item.Size = UDim2.new(1, -20, 0, 60)
    item.Position = UDim2.new(0, 10, 0, positionY)
    item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    item.BackgroundTransparency = 0.3
    item.BorderSizePixel = 0

    local title = Instance.new("TextLabel", item)
    title.Text = text
    title.Font = Enum.Font.GothamSemibold
    title.TextSize = 16
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Size = UDim2.new(1, -60, 0, 20)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local description = Instance.new("TextLabel", item)
    description.Text = desc or ""
    description.Font = Enum.Font.Gotham
    description.TextSize = 12
    description.TextColor3 = Color3.fromRGB(200, 200, 200)
    description.BackgroundTransparency = 1
    description.Position = UDim2.new(0, 10, 0, 25)
    description.Size = UDim2.new(1, -60, 0, 30)
    description.TextWrapped = true
    description.TextXAlignment = Enum.TextXAlignment.Left

    local toggle = Instance.new("TextButton", item)
    toggle.Text = "⚙️"
    toggle.Size = UDim2.new(0, 30, 0, 30)
    toggle.Position = UDim2.new(1, -40, 0.5, -15)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.BorderSizePixel = 0
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 18
    toggle.BackgroundTransparency = 0.2
end

-- Sample Feature List
createFeature("Aimbot with Webslinger", "", 0)
createFeature("Anti Traps", "", 65)
createFeature("Anti Hit", "Prevents hits using webslinger, medusa head can still affect you", 130)
createFeature("Speed Boost req(750 cash)", "", 195)
createFeature("Infinite Jump", "", 260)
