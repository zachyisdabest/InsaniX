-- Loader GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Fetch valid keys from remote
local validKeys = {}
local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/keys.txt")
end)

if success then
    for key in string.gmatch(result, "[^\r\n]+") do
        validKeys[key] = true
    end
else
    warn("Failed to fetch keys.txt from server")
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "InsaniXLoader"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.5, -150, 0.5, -85)
frame.Size = UDim2.new(0, 300, 0, 170)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "InsaniX Key System"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Key Input
local box = Instance.new("TextBox", frame)
box.Position = UDim2.new(0.1, 0, 0.3, 0)
box.Size = UDim2.new(0.8, 0, 0, 30)
box.PlaceholderText = "InsaniX, Best SAB Script!"
box.Text = ""
box.ClearTextOnFocus = true
box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
box.TextColor3 = Color3.fromRGB(255, 255, 255)
box.Font = Enum.Font.Gotham
box.TextSize = 14
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

-- Submit Button
local button = Instance.new("TextButton", frame)
button.Position = UDim2.new(0.1, 0, 0.55, 0)
button.Size = UDim2.new(0.8, 0, 0, 30)
button.Text = "Submit"
button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

-- Loading Bar Background
local barBG = Instance.new("Frame", frame)
barBG.Position = UDim2.new(0.1, 0, 0.8, 0)
barBG.Size = UDim2.new(0.8, 0, 0, 20)
barBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBG.Visible = false
Instance.new("UICorner", barBG).CornerRadius = UDim.new(0, 6)

-- Loading Bar Fill
local barFill = Instance.new("Frame", barBG)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 6)

-- Click Event
button.MouseButton1Click:Connect(function()
    local key = box.Text
    if validKeys[key] then
        writefile("InsaniX_key.txt", key)
        title.Text = "Welcome to InsaniX"
        button.Visible = false
        box.Visible = false
        barBG.Visible = true

        -- Animate the bar fill over 5 seconds
        for i = 1, 100 do
            barFill.Size = UDim2.new(i / 100, 0, 1, 0)
            wait(0.05) -- 100 * 0.05 = 5 seconds
        end

        gui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"))()
    else
        title.Text = "Invalid Key!"
    end
end)
