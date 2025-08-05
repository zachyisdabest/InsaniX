-- mainhub.lua (Protected GUI)

-- Protection check
if not _G.InsaniXLoaded then
    warn("Access denied: Please run through the loader.")
    return
end
_G.InsaniXLoaded = nil

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Theme settings
local themes = {
    ["Black + Sky Blue"] = {bg = Color3.fromRGB(15, 15, 15), accent = Color3.fromRGB(100, 170, 255), text = Color3.fromRGB(255, 255, 255)},
    ["White + Sky Blue"] = {bg = Color3.fromRGB(245, 245, 255), accent = Color3.fromRGB(100, 170, 255), text = Color3.fromRGB(0, 0, 0)},
    ["Full Black"] = {bg = Color3.fromRGB(0, 0, 0), accent = Color3.fromRGB(40, 40, 40), text = Color3.fromRGB(255, 255, 255)},
    ["Full White"] = {bg = Color3.fromRGB(255, 255, 255), accent = Color3.fromRGB(200, 200, 200), text = Color3.fromRGB(0, 0, 0)},
    ["Black + White"] = {bg = Color3.fromRGB(0, 0, 0), accent = Color3.fromRGB(255, 255, 255), text = Color3.fromRGB(0, 0, 0)},
    ["Peach + Sky Blue"] = {bg = Color3.fromRGB(255, 228, 210), accent = Color3.fromRGB(100, 170, 255), text = Color3.fromRGB(0, 0, 0)},
}

local currentTheme = themes["White + Sky Blue"]
local fontWeight = 16

-- GUI Container
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "InsaniXMainHub"
gui.ResetOnSpawn = false

-- Visibility toggle
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftAlt then
        gui.Enabled = not gui.Enabled
    end
end)

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 520, 0, 340)
frame.Position = UDim2.new(0.5, -260, 0.5, -170)
frame.BackgroundColor3 = currentTheme.bg
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Top Panel
local topPanel = Instance.new("Frame", frame)
topPanel.Size = UDim2.new(1, 0, 0, 30)
topPanel.BackgroundColor3 = currentTheme.accent
topPanel.Name = "TopPanel"
Instance.new("UICorner", topPanel).CornerRadius = UDim.new(0, 10)

-- Dragging
local dragging, dragInput, dragStart, startPos
topPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
topPanel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Header Label
local header = Instance.new("TextLabel", topPanel)
header.Size = UDim2.new(1, 0, 1, 0)
header.BackgroundTransparency = 1
header.Text = "InsaniX - Steal A Brainrot Script"
header.Font = Enum.Font.GothamBold
header.TextSize = fontWeight
header.TextColor3 = currentTheme.text
header.TextXAlignment = Enum.TextXAlignment.Left
header.Position = UDim2.new(0, 10, 0, 0)

-- Sidebar
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 130, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = currentTheme.accent
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 6)

-- Content Frame
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -130, 1, -60)
content.Position = UDim2.new(0, 130, 0, 30)
content.BackgroundColor3 = currentTheme.bg
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 6)

-- Font Thickness Slider
local slider = Instance.new("TextButton", frame)
slider.Size = UDim2.new(0, 140, 0, 20)
slider.Position = UDim2.new(0, 10, 1, -25)
slider.BackgroundColor3 = currentTheme.accent
slider.TextColor3 = currentTheme.text
slider.TextSize = 14
slider.Font = Enum.Font.Gotham
slider.Text = "Font Weight: " .. fontWeight
Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 6)

slider.MouseButton1Click:Connect(function()
    fontWeight = (fontWeight == 16) and 24 or 16
    slider.Text = "Font Weight: " .. fontWeight
    header.TextSize = fontWeight
end)

-- Theme Dropdown
local themeBtn = Instance.new("TextButton", sidebar)
themeBtn.Size = UDim2.new(1, -20, 0, 30)
themeBtn.Position = UDim2.new(0, 10, 0, 10)
themeBtn.Text = "Theme"
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 14
themeBtn.TextColor3 = currentTheme.text
themeBtn.BackgroundColor3 = currentTheme.bg
Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 6)

local dropdown = Instance.new("Frame", sidebar)
dropdown.Size = UDim2.new(1, -20, 0, #themes * 28)
dropdown.Position = UDim2.new(0, 10, 0, 45)
dropdown.BackgroundColor3 = currentTheme.bg
dropdown.Visible = false
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

themeBtn.MouseButton1Click:Connect(function()
    dropdown.Visible = not dropdown.Visible
end)

local index = 0
for name, colors in pairs(themes) do
    index += 1
    local t = Instance.new("TextButton", dropdown)
    t.Size = UDim2.new(1, 0, 0, 25)
    t.Position = UDim2.new(0, 0, 0, (index - 1) * 28)
    t.BackgroundColor3 = colors.accent
    t.Text = name
    t.TextColor3 = colors.text
    t.TextSize = 14
    t.Font = Enum.Font.Gotham
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 4)
    t.MouseButton1Click:Connect(function()
        currentTheme = colors
        frame.BackgroundColor3 = colors.bg
        topPanel.BackgroundColor3 = colors.accent
        sidebar.BackgroundColor3 = colors.accent
        content.BackgroundColor3 = colors.bg
        header.TextColor3 = colors.text
        themeBtn.TextColor3 = colors.text
        themeBtn.BackgroundColor3 = colors.bg
        dropdown.BackgroundColor3 = colors.bg
        slider.BackgroundColor3 = colors.accent
        slider.TextColor3 = colors.text
        t.TextColor3 = colors.text
    end)
end

-- Tab Buttons
local function createButton(name, order)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 50 + order * 35)
    btn.Text = name
    btn.TextColor3 = currentTheme.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BackgroundColor3 = currentTheme.bg
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        content:ClearAllChildren()
        local label = Instance.new("TextLabel", content)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = currentTheme.text
        label.TextSize = fontWeight
        label.Font = Enum.Font.GothamBold
        label.Text = name .. " - Coming Soon"
    end)
end

local tabNames = {"Main", "Stealer", "Player", "Troll", "Server Finder", "Extra"}
for i, tab in ipairs(tabNames) do
    createButton(tab, i)
end
