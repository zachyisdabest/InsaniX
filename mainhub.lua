local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local ESPEnabled = false
local ESPBoxes = {}

-- Create main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXMainHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "InsaniX Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.Parent = Sidebar

local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0.8, 0, 0, 40)
ESPToggle.Position = UDim2.new(0.1, 0, 0, 60)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
ESPToggle.TextColor3 = Color3.new(1,1,1)
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.TextSize = 18
ESPToggle.Text = "Toggle Player ESP"
ESPToggle.Parent = Sidebar
ESPToggle.AutoButtonColor = true
ESPToggle.TextWrapped = true

-- Function to create ESP box and name label
local function createESPForPlayer(player)
    if ESPBoxes[player] then return end -- Already created

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(60, 120, 255)
    box.Thickness = 2
    box.Filled = false

    local nameLabel = Drawing.new("Text")
    nameLabel.Visible = false
    nameLabel.Color = Color3.fromRGB(255, 255, 255)
    nameLabel.Text = player.Name
    nameLabel.Size = 14
    nameLabel.Center = true
    nameLabel.Outline = true

    ESPBoxes[player] = {
        Box = box,
        NameLabel = nameLabel,
    }
end

-- Remove ESP when player leaves
Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        ESPBoxes[player].Box:Remove()
        ESPBoxes[player].NameLabel:Remove()
        ESPBoxes[player] = nil
    end
end)

-- Create ESP for all players initially
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESPForPlayer(player)
    end
end

-- Also create ESP for new players
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESPForPlayer(player)
    end
end)

-- Update ESP every frame
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then
        for _, esp in pairs(ESPBoxes) do
            esp.Box.Visible = false
            esp.NameLabel.Visible = false
        end
        return
    end

    local camera = workspace.CurrentCamera
    for player, esp in pairs(ESPBoxes) do
        local character = player.Character
        local head = character and character:FindFirstChild("Head")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if head and humanoid and humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local size = Vector3.new(4, 6, 0) -- rough box size

                local bottomPos, bottomOnScreen = camera:WorldToViewportPoint(head.Position - Vector3.new(0, 3, 0))

                if bottomOnScreen then
                    local height = math.abs(pos.Y - bottomPos.Y)
                    local width = height / 2

                    esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                    esp.Box.Size = Vector2.new(width, height)
                    esp.Box.Visible = true

                    esp.NameLabel.Position = Vector2.new(pos.X, pos.Y - height / 2 - 15)
                    esp.NameLabel.Text = player.Name
                    esp.NameLabel.Visible = true
                else
                    esp.Box.Visible = false
                    esp.NameLabel.Visible = false
                end
            else
                esp.Box.Visible = false
                esp.NameLabel.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.NameLabel.Visible = false
        end
    end
end)

-- Toggle ESP on button click
ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = ESPEnabled and "Disable Player ESP" or "Enable Player ESP"
end)
