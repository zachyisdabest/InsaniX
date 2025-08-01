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
if pcall(function() return readfile(keySaveFile) end) then
	savedKey = readfile(keySaveFile)
end

if savedKey ~= "" and validateKey(savedKey) then
	-- Valid key found: load main script and exit
	loadstring(game:HttpGet(scriptURL))()
	return
end

--==[ GUI SETUP - ONLY LICENSE KEY INPUT ]==--
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaniXLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (game:FindFirstChild("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 460, 0, 160)
Frame.Position = UDim2.new(0.5, -230, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Title Label
local Label = Instance.new("TextLabel")
Label.Text = "Enter License Key"
Label.Size = UDim2.new(1, -40, 0, 40)
Label.Position = UDim2.new(0, 20, 0, 20)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamSemibold
Label.TextSize = 24
Label.TextXAlignment = Enum.TextXAlignment.Left
Label.Parent = Frame

-- Key Input Box
local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Your license key..."
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 70)
KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = Frame

-- Key validation on Enter or focus lost
KeyBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local enteredKey = KeyBox.Text
		if validateKey(enteredKey) then
			pcall(function()
				writefile(keySaveFile, enteredKey)
			end)
			ScreenGui:Destroy()
			loadstring(game:HttpGet(scriptURL))()
		else
			KeyBox.Text = ""
			KeyBox.PlaceholderText = "❌ Invalid key!"
		end
	end
end)
