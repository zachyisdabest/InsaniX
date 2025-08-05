--// Loader.lua for InsaniX

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

-- Config
local savedKeyFile = "insanix_key.txt"
local productId = "565248" -- Your Sellauth product ID
local mainHubURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

-- File Functions
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

-- Key Validation
local function verifyKey(key)
    local url = ("https://sellauth.gg/api/verify?key=%s&product=%s&hwid=%s"):format(key, productId, hwid)
    local success, response = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    if success and response.success then
        return true
    else
        warn("[InsaniX] Key validation failed:", response and response.message or "Unknown error")
        return false
    end
end

-- Loader UI
local function showLoaderUI()
    local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or game.CoreGui)
    ScreenGui.Name = "InsaniXLoader"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 180)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", topPanel).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "InsaniX Loader"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.BorderSizePixel = 0
    Instance.new("UICorner", topPanel).CornerRadius = UDim.new(0, 10)

    local Status = Instance.new("TextLabel", Frame)
    Status.Position = UDim2.new(0.05, 0, 0, 100)
    Status.Size = UDim2.new(0.9, 0, 0, 20)
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    Instance.new("UICorner", topPanel).CornerRadius = UDim.new(0, 10)

    local LoadingBar = Instance.new("Frame", Frame)
    LoadingBar.Size = UDim2.new(0, 0, 0, 5)
    LoadingBar.Position = UDim2.new(0, 0, 1, -5)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Visible = false

    local function startLoad()
        local tween = TweenService:Create(LoadingBar, TweenInfo.new(5), { Size = UDim2.new(1, 0, 0, 5) })
        LoadingBar.Visible = true
        tween:Play()
        tween.Completed:Wait()
        ScreenGui:Destroy()
        _G.InsaniXLoaded = true
        loadstring(game:HttpGet(mainHubURL))()
    end

    local debounce = false
    LoadButton.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        local key = KeyBox.Text
        Status.Text = "Verifying..."
        if verifyKey(key) then
            Status.Text = "Key valid. Loading..."
            saveKey(key)
            startLoad()
        else
            Status.Text = "Invalid key. Try again."
            task.delay(0.5, function() debounce = false end)
        end
    end)
end

-- Auto path: try saved key first
local existing = readSavedKey()
if existing and verifyKey(existing) then
    print("[InsaniX] Saved key found, loading main hub...")
    _G.InsaniXLoaded = true
    loadstring(game:HttpGet(mainHubURL))()
else
    print("[InsaniX] No saved key or invalid key, showing loader UI...")
    showLoaderUI()
end
