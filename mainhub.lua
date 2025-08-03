-- mainhub.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Main GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "InsaniXMainHub"
screenGui.ResetOnSpawn = false

-- Toggle visibility with ALT
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftAlt then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Top Panel (Drag from here)
local topPanel = Instance.new("Frame", mainFrame)
topPanel.Size = UDim2.new(1, 0, 0, 30)
topPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topPanel.BorderSizePixel = 0
topPanel.Name = "TopPanel"

local dragging, dragInput, dragStart, startPos

topPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

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
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 120, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 6)

-- Main content frame
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -120, 1, -30)
contentFrame.Position = UDim2.new(0, 120, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(240, 245, 255) -- sky blue white blend
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 6)

-- Button Factory
local function createSidebarButton(name, order)
    local btn = Instance.new("TextButton", sidebar)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + ((order - 1) * 35))
    btn.BackgroundColor3 = Color3.fromRGB(100, 170, 255) -- soft sky blue
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(130, 200, 255) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(100, 170, 255) end)

    btn.MouseButton1Click:Connect(function()
        contentFrame:ClearAllChildren()
        local label = Instance.new("TextLabel", contentFrame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 0, 0)
        label.TextSize = 20
        label.Font = Enum.Font.GothamBold
        label.Text = name .. " Panel (Coming Soon)"
    end)
end

-- Add all buttons
local buttonNames = { "Main", "Stealer", "Player", "Troll", "Server Finder", "Extra" }
for i, name in ipairs(buttonNames) do
    createSidebarButton(name, i)
end
