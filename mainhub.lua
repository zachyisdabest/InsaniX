-- mainhub.lua
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXMainHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 350)
Frame.Position = UDim2.new(0.5, -250, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

-- Sidebar Buttons
local buttonNames = {"Main", "ESP", "Stealer", "Extra"}
local buttons = {}
for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 10 + (i - 1) * 45)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = name
    btn.Parent = Sidebar
    buttons[name] = btn
end

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Welcome to InsaniX!"
TitleLabel.Size = UDim2.new(0, 360, 0, 40)
TitleLabel.Position = UDim2.new(0, 130, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamSemibold
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Frame

-- Content Frame (for page content)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(0, 360, 0, 250)
ContentFrame.Position = UDim2.new(0, 130, 0, 70)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = Frame

-- Content Label (shows which page)
local ContentLabel = Instance.new("TextLabel")
ContentLabel.Size = UDim2.new(1, -20, 1, -20)
ContentLabel.Position = UDim2.new(0, 10, 0, 10)
ContentLabel.BackgroundTransparency = 1
ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ContentLabel.Font = Enum.Font.Gotham
ContentLabel.TextSize = 20
ContentLabel.TextWrapped = true
ContentLabel.Text = "Select a tab from the sidebar."
ContentLabel.Parent = ContentFrame

-- Button Click Handlers to update content label text
buttons.Main.MouseButton1Click:Connect(function()
    ContentLabel.Text = "Main tab selected. Put your main script options here."
end)

buttons.ESP.MouseButton1Click:Connect(function()
    ContentLabel.Text = "ESP tab selected. Add your ESP features here."
end)

buttons.Stealer.MouseButton1Click:Connect(function()
    ContentLabel.Text = "Stealer tab selected. Add stealer options here."
end)

buttons.Extra.MouseButton1Click:Connect(function()
    ContentLabel.Text = "Extra tab selected. Add extra features here."
end)
