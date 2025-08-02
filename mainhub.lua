
-- mainhub.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "InsaniX_Hub"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "InsaniX Hub - Features"
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local list = {
    "Aimbot with Webslinger",
    "Anti Traps",
    "Anti Hit",
    "Speed Boost req(750 cash)",
    "Infinite Jump"
}

for i, text in ipairs(list) do
    local label = Instance.new("TextLabel", mainFrame)
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 50 + (i - 1) * 35)
    label.BackgroundTransparency = 0.1
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    label.Text = text .. " (coming soon)"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
end
