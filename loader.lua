local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local savedKeyFile = "insanix_key.txt"
local productId = "395185"
local mainHubURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

-- Your verifyKey function should be defined above this (using Sellauth or Worker URL method)
-- Example basic verifier (replace with your real one):
local function verifyKey(key)
    local url = "https://sellauth.gg/api/verify?key=" .. key .. "&product=" .. productId
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        local data = HttpService:JSONDecode(result)
        return data.success or data.valid
    end
    return false
end

local function saveKey(key)
    if writefile then
        writefile(savedKeyFile, key)
    end
end

local function readSavedKey()
    if isfile and isfile(savedKeyFile) then
        return readfile(savedKeyFile)
    end
    return nil
end

local function deleteSavedKey()
    if isfile and isfile(savedKeyFile) then
        delfile(savedKeyFile)
    end
end

local function loadMainHub()
    _G.InsaniXLoaded = true
    loadstring(game:HttpGet(mainHubURL))()
end

local function showLoaderUI()
    local gui = Instance.new("ScreenGui", gethui and gethui() or game.CoreGui)
    gui.Name = "InsaniXLoader"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 210)
    frame.Position = UDim2.new(0.5, -150, 0.5, -105)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.Active = true
    frame.Draggable = true
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "InsaniX Loader"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22

    local keyBox = Instance.new("TextBox", frame)
    keyBox.PlaceholderText = "Enter License Key"
    keyBox.Size = UDim2.new(0.9, 0, 0, 30)
    keyBox.Position = UDim2.new(0.05, 0, 0, 50)
    keyBox.Text = ""
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 16
    keyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.BorderSizePixel = 0
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

    local status = Instance.new("TextLabel", frame)
    status.Position = UDim2.new(0.05, 0, 0, 90)
    status.Size = UDim2.new(0.9, 0, 0, 20)
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14

    local loadButton = Instance.new("TextButton", frame)
    loadButton.Text = "Verify Key"
    loadButton.Size = UDim2.new(0.9, 0, 0, 30)
    loadButton.Position = UDim2.new(0.05, 0, 0, 120)
    loadButton.BackgroundColor3 = Color3.fromRGB(30, 150, 255)
    loadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadButton.Font = Enum.Font.GothamBold
    loadButton.TextSize = 16
    loadButton.BorderSizePixel = 0
    Instance.new("UICorner", loadButton).CornerRadius = UDim.new(0, 6)

    local resetButton = Instance.new("TextButton", frame)
    resetButton.Text = "Reset Key"
    resetButton.Size = UDim2.new(0.9, 0, 0, 25)
    resetButton.Position = UDim2.new(0.05, 0, 0, 160)
    resetButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetButton.Font = Enum.Font.GothamBold
    resetButton.TextSize = 14
    resetButton.BorderSizePixel = 0
    Instance.new("UICorner", resetButton).CornerRadius = UDim.new(0, 6)

    resetButton.MouseButton1Click:Connect(function()
        deleteSavedKey()
        status.Text = "Saved key deleted."
    end)

    local function startLoad()
        local bar = Instance.new("Frame", frame)
        bar.Position = UDim2.new(0, 0, 1, -5)
        bar.Size = UDim2.new(0, 0, 0, 5)
        bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        local tween = TweenService:Create(bar, TweenInfo.new(5), { Size = UDim2.new(1, 0, 0, 5) })
        tween:Play()
        tween.Completed:Wait()
        gui:Destroy()
        loadMainHub()
    end

    local debounce = false
    loadButton.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        local key = keyBox.Text
        status.Text = "Verifying..."
        if verifyKey(key) then
            status.Text = "Key valid. Loading..."
            saveKey(key)
            startLoad()
        else
            status.Text = "Invalid key. Try again."
            debounce = false
        end
    end)
end

-- AUTO LOAD with saved key
local savedKey = readSavedKey()
if savedKey and verifyKey(savedKey) then
    loadMainHub()
else
    showLoaderUI()
end
