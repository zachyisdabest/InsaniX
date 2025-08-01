--==[ SETTINGS ]==--
local keyURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/keys.lua"
local scriptURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"
local keySaveFile = "InsaniX_key.txt"

--==[ VALIDATE KEY FUNCTION ]==--
local function validateKey(key)
	local success, keys = pcall(function()
		return loadstring(game:HttpGet(keyURL))()
	end)
	return success and table.find(keys, key)
end

--==[ AUTO-LOAD IF SAVED KEY IS VALID ]==--
local savedKey = ""
print("Checking for saved key...")
if pcall(function() return readfile(keySaveFile) end) then
	savedKey = readfile(keySaveFile)
	print("Found saved key:", savedKey)
else
	print("No saved key file found.")
end

if savedKey ~= "" and validateKey(savedKey) then
	print("✅ Saved key is valid. Launching hub...")
	loadstring(game:HttpGet(scriptURL))()
	return
else
	print("❌ No valid saved key. Showing GUI.")
end

--==[ GUI SETUP ]==--
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

--==[ SIDEBAR ]==--
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 120, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Frame

--==[ SIDEBAR BUTTONS ]==--
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

	btn.MouseButton1Click:Connect(function()
		print("🟦 Clicked:", name)
	end)
end

--==[ TITLE LABEL ]==--
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

--==[ KEY INPUT BOX ]==--
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

--==[ KEY VALIDATION ]==--
KeyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local enteredKey = KeyBox.Text
		print("🔍 Checking entered key:", enteredKey)

		if validateKey(enteredKey) then
			print("✅ Key is valid! Saving and launching.")
			pcall(function()
				writefile(keySaveFile, enteredKey)
			end)

			ScreenGui:Destroy()
			loadstring(game:HttpGet(scriptURL))()
		else
			print("❌ Invalid key entered.")
			KeyBox.Text = ""
			KeyBox.PlaceholderText = "❌ Invalid key!"
		end
	end
end)
