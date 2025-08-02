local scriptURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"
local keySaveFile = "InsaniX_key.txt"
local validKeys = {
    "IX_TEST123",
    "IX_ABC456",
    -- Add more keys here
}

-- Function to validate the key
local function validateKey(key)
    for _, v in ipairs(validKeys) do
        if v == key then
            return true
        end
    end
    return false
end

-- Check if key already saved
local savedKey = ""
if pcall(function() return readfile(keySaveFile) end) then
    savedKey = readfile(keySaveFile)
end

if savedKey ~= "" and validateKey(savedKey) then
    print("Saved Key is valid, launching hub")
    
    -- Show Main GUI after valid key
    local hubGui = Instance.new("ScreenGui", game.CoreGui)
    hubGui.Name = "InsaniXHub"

    local hubFrame = Instance.new("Frame", hubGui)
    hubFrame.Size = UDim2.new(0, 300, 0, 200)
    hubFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    hubFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    hubFrame.BorderSizePixel = 0

    local label = Instance.new("TextLabel", hubFrame)
    label.Text = "Welcome to InsaniX!"
    label.Size = UDim2.new(1, 0, 0.3, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 22

    return -- Stop script here
end

-- GUI for Key Input
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "InsaniX_KeyGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 200)
frame.Position = UDim2.new(0.5, -250, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "Enter Your InsaniX License Key"
title.Size = UDim2.new(1, 0, 0.3, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local keyBox = Instance.new("TextBox", frame)
keyBox.Text = "InsaniX, Best SAB Script!"
keyBox.ClearTextOnFocus = true
keyBox.Size = UDim2.new(0, 400, 0, 40)
keyBox.Position = UDim2.new(0.5, -200, 0, 80)
keyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 18

local submit = Instance.new("TextButton", frame)
submit.Text = "Submit"
submit.Size = UDim2.new(0, 120, 0, 40)
submit.Position = UDim2.new(0.5, -60, 0, 140)
submit.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
submit.TextColor3 = Color3.fromRGB(0, 0, 0)
submit.Font = Enum.Font.GothamBold
submit.TextSize = 18

submit.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    if validateKey(enteredKey) then
        writefile(keySaveFile, enteredKey)
        gui:Destroy()

        -- Show Main GUI after validation
        local hubGui = Instance.new("ScreenGui", game.CoreGui)
        hubGui.Name = "InsaniXHub"

        local hubFrame = Instance.new("Frame", hubGui)
        hubFrame.Size = UDim2.new(0, 300, 0, 200)
        hubFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
        hubFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        hubFrame.BorderSizePixel = 0

        local label = Instance.new("TextLabel", hubFrame)
        label.Text = "Welcome to InsaniX!"
        label.Size = UDim2.new(1, 0, 0.3, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 22
    else
        submit.Text = "Invalid Key!"
        wait(1)
        submit.Text = "Submit"
    end
end)
