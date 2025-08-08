--// Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

--// Config
local savedKeyFile = "insanix_key.txt"
local replitAPI = "https://03df6bdd-28f6-44f5-b766-5bf63d614ed5-00-22hauxpzzfxdx.janeway.replit.dev/check?key=%s&hwid=%s"
local mainHubURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

--// File Functions
local function readSavedKey()
    if isfile and isfile(savedKeyFile) then
        return readfile(savedKeyFile)
    end
    return nil
end

local function saveKey(key)
    if writefile then
        writefile(savedKeyFile, key)
    end
end

--// Key Verification
local function verifyKey(key)
    local url = string.format(replitAPI, key, hwid)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local data = HttpService:JSONDecode(result)
        return data.success == true
    end
    return false
end

--// Load Main Hub
local function loadMainHub()
    _G.InsaniXLoaded = true
    loadstring(game:HttpGet(mainHubURL))()
end

--// Check Existing Key
local existing = readSavedKey()
if existing and verifyKey(existing) then
    loadMainHub()
    return
end

--// Loader UI
local function showLoaderUI()
    local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or game.CoreGui)
    ScreenGui.Name = "InsaniXLoader"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 180)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "InsaniX Loader"
    Title.TextColor3 = Color3.fromRGB(0, 0, 0)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22

    local KeyBox = Instance.new("TextBox", Frame)
    KeyBox.PlaceholderText = "Enter License Key"
    KeyBox.Size = UDim2.new(0.9, 0, 0, 30)
    KeyBox.Position = UDim2.new(0.05, 0, 0, 60)
    KeyBox.Text = ""
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 16
    KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    KeyBox.BorderSizePixel = 0
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

    local Status = Instance.new("TextLabel", Frame)
    Status.Position = UDim2.new(0.05, 0, 0, 100)
    Status.Size = UDim2.new(0.9, 0, 0, 20)
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(0, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14

    local LoadButton = Instance.new("TextButton", Frame)
    LoadButton.Text = "Verify Key"
    LoadButton.Size = UDim2.new(0.9, 0, 0, 30)
    LoadButton.Position = UDim2.new(0.05, 0, 0, 130)
    LoadButton.BackgroundColor3 = Color3.fromRGB(30, 150, 255)
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.Font = Enum.Font.GothamBold
    LoadButton.TextSize = 16
    LoadButton.BorderSizePixel = 0
    Instance.new("UICorner", LoadButton).CornerRadius = UDim.new(0, 6)

    local debounce = false
    LoadButton.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        local key = KeyBox.Text
        Status.Text = "Verifying..."
        if verifyKey(key) then
            Status.Text = "Key valid. Loading..."
            saveKey(key)
            task.wait(1)
            ScreenGui:Destroy()
            loadMainHub()
        else
            Status.Text = "Invalid key. Try again."
            task.delay(0.5, function() debounce = false end)
        end
    end)
end

showLoaderUI()
