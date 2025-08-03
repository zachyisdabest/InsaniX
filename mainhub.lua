-- mainhub.lua (LocalScript after key is valid)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MainHub"
gui.Parent = PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = gui

local sideBar = Instance.new("Frame")
sideBar.Size = UDim2.new(0, 100, 1, 0)
sideBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
sideBar.Parent = mainFrame

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -100, 1, 0)
content.Position = UDim2.new(0, 100, 0, 0)
content.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
content.Parent = mainFrame

-- Toggle utility
local function createToggle(name, parent, onToggle)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, 0, 0, 40)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.TextColor3 = Color3.new(1, 1, 1)
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 18
    toggle.Parent = parent

    local isOn = false

    local function updateVisual()
        toggle.Text = name .. ": " .. (isOn and "ON" or "OFF")
        toggle.BackgroundColor3 = isOn and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
    end

    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateVisual()
        onToggle(isOn)
    end)

    updateVisual()
    return toggle
end

-- Sidebar Button utility
local function createButton(name, parent, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = name
    btn.Parent = parent

    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- ESP Panel
local function showESP()
    content:ClearAllChildren()
    createToggle("Player ESP", content, function(state)
        if state then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/esp/playeresp.lua"))()
        else
            if getgenv().RemoveESP then
                getgenv().RemoveESP()
            end
        end
    end)
end

-- Stealer Panel (placeholder)
local function showStealer()
    content:ClearAllChildren()
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = "Coming Soon!"
    txt.TextScaled = true
    txt.BackgroundTransparency = 1
    txt.TextColor3 = Color3.new(1, 1, 1)
    txt.Parent = content
end

-- Add Sidebar Buttons
createButton("ESP", sideBar, showESP)
createButton("Stealer", sideBar, showStealer)
