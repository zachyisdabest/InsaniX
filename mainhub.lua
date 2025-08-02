
-- Key check
if not isfile or not readfile or not isfile("InsaniX_key.txt") then
    warn("Unauthorized access. Please use the official loader.")
    return
end

local key = readfile("InsaniX_key.txt")
if not key or key == "" then
    warn("No valid key found. Please run the loader first.")
    return
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Features = Instance.new("TextLabel")

ScreenGui.Name = "InsaniXMainGUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Position = UDim2.new(0.3, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.BackgroundTransparency = 0.2

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

Title.Name = "Title"
Title.Parent = Frame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "InsaniX Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 28.000
Title.TextStrokeTransparency = 0.800

Features.Name = "Features"
Features.Parent = Frame
Features.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Features.BackgroundTransparency = 1.000
Features.Position = UDim2.new(0, 20, 0, 60)
Features.Size = UDim2.new(1, -40, 1, -70)
Features.Font = Enum.Font.Gotham
Features.Text = "• ESP features here\n• Stealer feature here\n• More features soon..."
Features.TextColor3 = Color3.fromRGB(200, 200, 200)
Features.TextSize = 18.000
Features.TextWrapped = true
Features.TextXAlignment = Enum.TextXAlignment.Left
Features.TextYAlignment = Enum.TextYAlignment.Top
