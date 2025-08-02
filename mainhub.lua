-- GUI + License System Script for InsaniX

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Key Settings
local savedKeyFile = "InsaniX_key.txt"
local validKeysURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/keys.txt"
local mainScriptURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

-- Check for Saved Key
local savedKey
if isfile and isfile(savedKeyFile) then
	savedKey = readfile(savedKeyFile)
end

-- Function to Validate Key
local function validateKey(key)
	local success, response = pcall(function()
		return game:HttpGet(validKeysURL)
	end)

	if success and response then
		for line in response:gmatch("[^\r\n]+") do
			if line == key then
				return true
			end
		end
	end
	return false
end

-- If key is valid, load main script
if savedKey and validateKey(savedKey) then
	print("✅ Saved Key is valid, launching hub")
	loadstring(game:HttpGet(mainScriptURL))()
	return
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (game:FindFirstChild("CoreGui") or player:WaitForChild("PlayerGui"))

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 200)
Frame.Position = UDim2.new(0.5, -250, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Label = Instance.new("TextLabel")
Label.Text = "Enter License Key"
Label.Size = UDim2.new(1, 0, 0, 40)
Label.Position = UDim2.new(0, 0, 0, 20)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamSemibold
Label.TextSize = 22
Label.Parent = Frame

local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Your license key..."
KeyBox.Size = UDim2.new(0, 300, 0, 40)
KeyBox.Position = UDim2.new(0.5, -150, 0, 70)
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Frame

-- Submit Button
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 100, 0, 40)
SubmitBtn.Position = UDim2.new(0.5, -50, 0, 120)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 18
SubmitBtn.Text = "Submit"
SubmitBtn.Parent = Frame

SubmitBtn.MouseButton1Click:Connect(function()
	local enteredKey = KeyBox.Text
	if enteredKey and validateKey(enteredKey) then
		writefile(savedKeyFile, enteredKey)
		print("✅ Key accepted. Loading hub...")
		ScreenGui:Destroy()
		loadstring(game:HttpGet(mainScriptURL))()
	else
		KeyBox.Text = ""
		KeyBox.PlaceholderText = "❌ Invalid key!"
	end
end)
