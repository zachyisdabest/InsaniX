-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- ESP Function
local espEnabled = false
local espObjects = {}

function createESP(player)
    if player == LocalPlayer then return end

    local box = Instance.new("BillboardGui")
    box.Name = "ESP"
    box.Size = UDim2.new(0, 100, 0, 40)
    box.Adornee = player.Character:FindFirstChild("Head")
    box.AlwaysOnTop = true

    local nameLabel = Instance.new("TextLabel", box)
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.Text = player.Name
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    nameLabel.TextStrokeTransparency = 0.5

    box.Parent = player.Character:FindFirstChild("Head")
    espObjects[player] = box
end

function removeESP(player)
    if espObjects[player] and espObjects[player].Parent then
        espObjects[player]:Destroy()
    end
    espObjects[player] = nil
end

function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Head") then
                createESP(p)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if espEnabled then
                    wait(1)
                    createESP(p)
                end
            end)
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
            removeESP(p)
        end
    end
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "InsaniXHub"

-- Sidebar
local sidebar = Instance.new("Frame", ScreenGui)
sidebar.Size = UDim2.new(0, 150, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sidebar.BorderSizePixel = 0

local espTabButton = Instance.new("TextButton", sidebar)
espTabButton.Size = UDim2.new(1, 0, 0, 50)
espTabButton.Position = UDim2.new(0, 0, 0, 100)
espTabButton.Text = "ESP Tab"
espTabButton.TextColor3 = Color3.new(1, 1, 1)
espTabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Main Panel
local mainPanel = Instance.new("Frame", ScreenGui)
mainPanel.Size = UDim2.new(1, -150, 1, 0)
mainPanel.Position = UDim2.new(0, 150, 0, 0)
mainPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainPanel.BorderSizePixel = 0

local espToggle = Instance.new("TextButton", mainPanel)
espToggle.Size = UDim2.new(0, 200, 0, 50)
espToggle.Position = UDim2.new(0, 20, 0, 20)
espToggle.Text = "Player ESP: OFF"
espToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
espToggle.TextColor3 = Color3.new(1, 1, 1)

espToggle.MouseButton1Click:Connect(function()
    toggleESP()
    espToggle.Text = "Player ESP: " .. (espEnabled and "ON" or "OFF")
end)
