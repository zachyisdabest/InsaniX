local httpService = game:GetService("HttpService")

-- Settings
local keyURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/keys.lua"
local scriptURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"
local keySaveFile = "InsaniX_key.txt"

-- Load saved key if exists
local savedKey = ""
if pcall(function() return readfile(keySaveFile) end) then
	savedKey = readfile(keySaveFile)
end

-- Validate a key
local function validateKey(key)
	local success, keys = pcall(function()
		return loadstring(game:HttpGet(keyURL))()
	end)
	return success and table.find(keys, key)
end

-- Function to launch script
local function launchHub()
	loadstring(game:HttpGet(scriptURL))()
end

-- Check if saved key is valid
if savedKey ~= "" and validateKey(savedKey) then
	launchHub()
	return
end

-- Show GUI if no valid key
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (game:FindFirstChild("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 500, 0, 300)
Frame.Position = UDim2.new(0.5, -250, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

-- Sidebar Buttons
local buttonNames = {"Main", "ESP", "Stealer", "Extra"}
for i, name in ipairs(buttonNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 10 + (i - 1) * 45)
	btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = name
	btn.Parent = Sidebar

	-- Optional: Click response
	btn.MouseButton1Click:Connect(function()
		print("Clicked:", name)
	end)
end

-- Title Label
local Label = Instance.new("TextLabel")
Label.Text = "Enter License Key"
Label.Size = UDim2.new(0, 360, 0, 40)
Label.Position = UDim2.new(0, 130, 0, 30)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamSemibold
Label.TextSize = 20
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = Frame

-- Key Input Box
local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Your license key..."
KeyBox.Size = UDim2.new(0, 300, 0, 40)
KeyBox.Position = UDim2.new(0, 130, 0, 80)
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 16
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Frame

-- License Key Validation
KeyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local enteredKey = KeyBox.Text

		if validateKey(enteredKey) then
			pcall(function()
				writefile(keySaveFile, enteredKey)
				ScreenGui:Destroy()
				launchHub()
			end)
		else
			KeyBox.Text = ""
			KeyBox.PlaceholderText = "❌ Invalid key!"
		end
	end
end)
