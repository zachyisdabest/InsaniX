-- CONFIG
local keySaveFile = "InsaniX_key.txt"
local scriptURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

-- KEY VALIDATION FUNCTION (replace with your own logic if needed)
local function validateKey(key)
	return string.sub(key, 1, 3) == "IX_"
end

-- Load saved key
local savedKey = ""
if pcall(function() return readfile(keySaveFile) end) then
	savedKey = readfile(keySaveFile)
end

-- Auto-run if key is already saved and valid
if savedKey ~= "" and validateKey(savedKey) then
    print("Saved Key is valid, launching hub")
    loadstring(game:HttpGet(scriptURL))()
    return
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniX_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 160)
Frame.Position = UDim2.new(0.5, -150, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔑 Enter Your InsaniX Key"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.PlaceholderText = "Enter key here (starts with IX_)"
TextBox.Size = UDim2.new(0.9, 0, 0, 35)
TextBox.Position = UDim2.new(0.05, 0, 0, 55)
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BorderSizePixel = 0
TextBox.Font = Enum.Font.SourceSans
TextBox.TextSize = 20
TextBox.Parent = Frame

local Submit = Instance.new("TextButton")
Submit.Text = "Submit Key"
Submit.Size = UDim2.new(0.9, 0, 0, 35)
Submit.Position = UDim2.new(0.05, 0, 0, 100)
Submit.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Submit.TextColor3 = Color3.fromRGB(255, 255, 255)
Submit.BorderSizePixel = 0
Submit.Font = Enum.Font.SourceSansBold
Submit.TextSize = 20
Submit.Parent = Frame

local Message = Instance.new("TextLabel")
Message.Size = UDim2.new(1, 0, 0, 20)
Message.Position = UDim2.new(0, 0, 1, -20)
Message.Text = ""
Message.TextColor3 = Color3.fromRGB(255, 255, 255)
Message.TextTransparency = 0.2
Message.BackgroundTransparency = 1
Message.Font = Enum.Font.SourceSans
Message.TextSize = 18
Message.Parent = Frame

-- Submit button behavior
Submit.MouseButton1Click:Connect(function()
	local key = TextBox.Text
	if validateKey(key) then
		writefile(keySaveFile, key)
		Message.Text = "✅ Key accepted! Loading..."
		wait(1)
		ScreenGui:Destroy()
		loadstring(game:HttpGet(scriptURL))()
	else
		Message.Text = "❌ Invalid key. Try again."
	end
end)
