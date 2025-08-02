local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXMainHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Sidebar (Tabs)
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = ScreenGui

local UICornerSidebar = Instance.new("UICorner")
UICornerSidebar.CornerRadius = UDim.new(0, 6)
UICornerSidebar.Parent = Sidebar

local Tabs = {"Player Management", "Player Tab", "ESP Tab"}
local tabButtons = {}
local currentTab = nil

-- Content Frame (right side)
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -150, 1, 0)
ContentFrame.Position = UDim2.new(0, 150, 0, 0)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = ScreenGui

local UICornerContent = Instance.new("UICorner")
UICornerContent.CornerRadius = UDim.new(0, 6)
UICornerContent.Parent = ContentFrame

-- Helper function to create toggle buttons
local function createToggle(parent, text, position, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 40)
    toggleFrame.Position = position
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
    toggleButton.TextColor3 = Color3.new(1,1,1)
    toggleButton.Text = "Off"
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.Parent = toggleFrame
    toggleButton.AutoButtonColor = true

    local toggled = false
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleButton.Text = toggled and "On" or "Off"
        toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 120, 255)
        callback(toggled)
    end)
end

-- Create tabs buttons on sidebar
for i, tabName in ipairs(Tabs) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i-1)*50)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.Text = tabName
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.Parent = Sidebar
    button.AutoButtonColor = true

    button.MouseButton1Click:Connect(function()
        -- Clear content
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if not (child:IsA("UIListLayout") or child:IsA("UIPadding")) then
                child:Destroy()
            end
        end

        -- Highlight selected button
        for _, btn in pairs(tabButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end
        button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)

        -- Show content based on tab
        if tabName == "Player Management" then
            createToggle(ContentFrame, "Aimbot with Webslinger", UDim2.new(0, 10, 0, 10), function(state)
                print("Aimbot toggled", state)
                -- Implement your aimbot logic here
            end)

            createToggle(ContentFrame, "Anti Traps", UDim2.new(0, 10, 0, 60), function(state)
                print("Anti Traps toggled", state)
                -- Implement your anti traps logic here
            end)

        elseif tabName == "Player Tab" then
            createToggle(ContentFrame, "Anti Hit", UDim2.new(0, 10, 0, 10), function(state)
                print("Anti Hit toggled", state)
            end)

            createToggle(ContentFrame, "Speed Boost (req 750 cash)", UDim2.new(0, 10, 0, 60), function(state)
                print("Speed Boost toggled", state)
            end)

        elseif tabName == "ESP Tab" then
            createToggle(ContentFrame, "Player ESP", UDim2.new(0, 10, 0, 10), function(state)
                print("Player ESP toggled", state)
                -- Here you can link to your ESP code to enable/disable
            end)

            createToggle(ContentFrame, "Infinite Jump", UDim2.new(0, 10, 0, 60), function(state)
                print("Infinite Jump toggled", state)
            end)
        end
    end)

    table.insert(tabButtons, button)
end

-- Trigger first tab by default
tabButtons[1].MouseButton1Click:Wait()
