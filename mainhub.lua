-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Saved Key File Name
local KEY_FILE = "InsaniX_key.txt"

-- Your Valid Keys List (for demo, replace with actual server call if needed)
local VALID_KEYS = {
    ["your-test-key"] = true,
    ["another-valid-key"] = true,
}

-- Function to Validate Key
local function isValidKey(key)
    return VALID_KEYS[key] ~= nil
end

-- Try to read the saved key
local savedKey
pcall(function()
    if isfile(KEY_FILE) then
        savedKey = readfile(KEY_FILE)
    end
end)

-- If valid saved key exists, launch hub
if savedKey and isValidKey(savedKey) then
    print("Saved Key is valid, launching hub")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"))()
    return
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:FindFirstChild("CoreGui") or player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 200)
Frame.Position = UDim2.new(0.5, -250, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Title Label
local Label = Instance.new("TextLabel")
Label.Text = "Enter License Key"
Label.Size = UDim2.new(1, 0, 0, 40)
Label.Position = UDim2.new(0, 0, 0, 20)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamSemibold
Label.TextSize = 22
Label.Parent = Frame

-- Key Input Box
-- Key Input Box
local KeyBox = Instance.new("TextBox")
KeyBox.Text = "InsaniX, Best SAB Script!"
KeyBox.ClearTextOnFocus = true
KeyBox.Size = UDim2.new(0, 400, 0, 40)
KeyBox.Position = UDim2.new(0.5, -200, 0, 80)
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.Parent = Frame


-- Confirm Button
local ConfirmBtn = Instance.new("TextButton")
ConfirmBtn.Size = UDim2.new(0, 140, 0, 35)
ConfirmBtn.Position = UDim2.new(0.5, -70, 0, 140)
ConfirmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmBtn.Font = Enum.Font.GothamBold
ConfirmBtn.TextSize = 18
ConfirmBtn.Text = "Submit Key"
ConfirmBtn.Parent = Frame

ConfirmBtn.MouseButton1Click:Connect(function()
    local key = KeyBox.Text
    if isValidKey(key) then
        -- Save the key
        pcall(function()
            writefile(KEY_FILE, key)
        end)

        -- Clean up UI and launch
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"))()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "❌ Invalid key!"
    end
end)
