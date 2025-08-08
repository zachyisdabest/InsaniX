--// Loader.lua - InsaniX
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

local savedKeyFile = "insanix_key.txt"
local replitBaseURL = "https://03df6bdd-28f6-44f5-b766-5bf63d614ed5-00-22hauxpzzfxdx.janeway.replit.dev"
local mainHubURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

--// Read saved key
local function readSavedKey()
    if isfile and isfile(savedKeyFile) then
        return readfile(savedKeyFile)
    end
    return nil
end

--// Save key
local function saveKey(key)
    if writefile then
        writefile(savedKeyFile, key)
    end
end

--// Verify key via Replit API
local function verifyKey(key)
    local url = string.format("%s/check?key=%s&hwid=%s", replitBaseURL, key, hwid)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        warn("[InsaniX] HTTP Request Failed:", result)
        return false
    end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(result)
    end)
    if not ok then
        warn("[InsaniX] JSON Decode Failed:", data)
        return false
    end
    return data.success == true
end

--// Load MainHub
local function loadMainHub()
    loadstring(game:HttpGet(mainHubURL))()
end

--// UI for entering key
local function showKeyUI()
    local gui = Instance.new("ScreenGui", gethui and gethui() or game.CoreGui)
    gui.Name = "InsaniXLoader"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 180)
    frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.Active = true
    frame.Draggable = true

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "InsaniX Loader"
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22

    local keyBox = Instance.new("TextBox", frame)
    keyBox.PlaceholderText = "Enter License Key"
    keyBox.Size = UDim2.new(0.9, 0, 0, 30)
    keyBox.Position = UDim2.new(0.05, 0, 0, 60)
    keyBox.Text = ""
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 16
    keyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    keyBox.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

    local status = Instance.new("TextLabel", frame)
    status.Position = UDim2.new(0.05, 0, 0, 100)
    status.Size = UDim2.new(0.9, 0, 0, 20)
    status.Text = ""
    status.TextColor3 = Color3.fromRGB(0, 0, 0)
    status.BackgroundTransparency = 1
    status.Font = Enum.Font.Gotham
    status.TextSize = 14

    local loadBtn = Instance.new("TextButton", frame)
    loadBtn.Text = "Verify Key"
    loadBtn.Size = UDim2.new(0.9, 0, 0, 30)
    loadBtn.Position = UDim2.new(0.05, 0, 0, 130)
    loadBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    loadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadBtn.Font = Enum.Font.GothamBold
    loadBtn.TextSize = 16
    Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 6)

    loadBtn.MouseButton1Click:Connect(function()
        local key = keyBox.Text
        if verifyKey(key) then
            status.Text = "Key valid. Loading..."
            saveKey(key)
            gui:Destroy()
            loadMainHub()
        else
            status.Text = "Invalid key."
        end
    end)
end

--// Main check
local existingKey = readSavedKey()
if existingKey and verifyKey(existingKey) then
    loadMainHub()
else
    showKeyUI()
end
