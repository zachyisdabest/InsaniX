-- loader.lua (LocalScript)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KeyLoader"
gui.Parent = player:WaitForChild("PlayerGui")

-- Create TextBox
local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0, 200, 0, 50)
textbox.Position = UDim2.new(0.5, -100, 0.4, 0)
textbox.PlaceholderText = "Enter Key"
textbox.TextScaled = true
textbox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
textbox.Parent = gui

-- Create Submit Button
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, 0)
button.Text = "Submit Key"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = gui

-- Handle Button Click
button.MouseButton1Click:Connect(function()
    local inputKey = textbox.Text
    local keyList = game:HttpGet("https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/keys.txt")

    for key in string.gmatch(keyList, "[^\r\n]+") do
        if inputKey == key then
            gui:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/zacyisdabest/InsaniX/main/mainhub.lua"))()
            return
        end
    end

    button.Text = "Invalid Key"
    wait(1.5)
    button.Text = "Submit Key"
end)
