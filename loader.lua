--// InsaniX Loader.lua (with Cloudflare Worker verification)

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

-- Config
local savedKeyFile = "insanix_key.txt"
-- Product ID is not used client-side anymore (handled by your Worker), but kept for reference
local productId = "395185"
local mainHubURL = "https://raw.githubusercontent.com/zachyisdabest/InsaniX/main/mainhub.lua"

-- Proxy (Cloudflare Worker)
local workerURL = "https://insanix-verify.friendlycripp.workers.dev"
local workerToken = "InsaniXequalfadi"

-- File helpers
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

-- Key verification via Cloudflare Worker (proxies to Sellauth)
local function verifyKey(key)
    key = tostring(key or ""):gsub("%s+", "") -- trim whitespace/newlines
    if key == "" then return false end

    local url = ("%s?key=%s&hwid=%s&token=%s")
        :format(
            workerURL,
            HttpService:UrlEncode(key),
            HttpService:UrlEncode(hwid),
            HttpService:UrlEncode(workerToken)
        )

    local okHttp, body = pcall(function()
        return game:HttpGet(url) -- executors generally allow this; Roblox blocks sellauth.gg directly
    end)
    if not okHttp then
        warn("[InsaniX] HTTP error via proxy:", body)
        return false
    end

    -- Debug
    print("[InsaniX] Proxy response:", body)

    local okJson, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not okJson then
        warn("[InsaniX] JSON decode failed")
        return false
    end

    -- Accept common success shapes from Sellauth
    if data.success == true or data.valid == true or data.status == "success" then
        return true
    end

    if data.message then warn("[InsaniX] Verify failed:", data.message) end
    if data.reason then warn("[InsaniX] Reason:", data.reason) end
    return false
end

-- Load the main hub
local function startLoadAndOpenHub(screenGuiToDestroy, loadingBar)
    if loadingBar then
        local tween = TweenService:Create(loadingBar, TweenInfo.new(5), { Size = UDim2.new(1, 0, 0, 5) })
        loadingBar.Visible = true
        tween:Play()
        tween.Completed:Wait()
    end
    if screenGuiToDestroy and screenGuiToDestroy.Parent then
        screenGuiToDestroy:Destroy()
    end
    _G.InsaniXLoaded = true
    loadstring(game:HttpGet(mainHubURL))()
end

-- UI (shown only if no valid saved key)
local function showLoaderUI()
    local parentGui = (gethui and gethui()) or game.CoreGui

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "InsaniXLoader"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = parentGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 180)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8) -- smooth corners

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "InsaniX Loader"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.Parent = Frame

    local KeyBox = Instance.new("TextBox")
    KeyBox.PlaceholderText = "Enter License Key"
    KeyBox.Size = UDim2.new(0.9, 0, 0, 30)
    KeyBox.Position = UDim2.new(0.05, 0, 0, 60)
    KeyBox.Text = ""
    KeyBox.Font = Enum.Font.Gotham
    KeyBox.TextSize = 16
    KeyBox.TextColor3 = Color3.fromRGB(0, 0, 0)
    KeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.BorderSizePixel = 0
    KeyBox.Parent = Frame
    Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6) -- smooth corners

    local Status = Instance.new("TextLabel")
    Status.Position = UDim2.new(0.05, 0, 0, 100)
    Status.Size = UDim2.new(0.9, 0, 0, 20)
    Status.Text = ""
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14
    Status.Parent = Frame

    local LoadButton = Instance.new("TextButton")
    LoadButton.Text = "Verify Key"
    LoadButton.Size = UDim2.new(0.9, 0, 0, 30)
    LoadButton.Position = UDim2.new(0.05, 0, 0, 130)
    LoadButton.BackgroundColor3 = Color3.fromRGB(30, 150, 255)
    LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadButton.Font = Enum.Font.GothamBold
    LoadButton.TextSize = 16
    LoadButton.BorderSizePixel = 0
    LoadButton.Parent = Frame
    Instance.new("UICorner", LoadButton).CornerRadius = UDim.new(0, 6) -- smooth corners

    local LoadingBar = Instance.new("Frame")
    LoadingBar.Size = UDim2.new(0, 0, 0, 5)
    LoadingBar.Position = UDim2.new(0, 0, 1, -5)
    LoadingBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Visible = false
    LoadingBar.Parent = Frame

    local debounce = false
    LoadButton.MouseButton1Click:Connect(function()
        if debounce then return end
        debounce = true
        local key = KeyBox.Text
        Status.Text = "Verifying..."
        if verifyKey(key) then
            Status.Text = "Key valid. Loading..."
            saveKey(key)
            startLoadAndOpenHub(ScreenGui, LoadingBar)
        else
            Status.Text = "Invalid key. Try again."
            task.delay(0.5, function() debounce = false end)
        end
    end)
end

-- AUTO PATH: try saved key first (no UI if valid)
local existing = readSavedKey()
if existing and verifyKey(existing) then
    print("[InsaniX] Saved key found, loading main hub...")
    _G.InsaniXLoaded = true
    loadstring(game:HttpGet(mainHubURL))()
else
    print("[InsaniX] No saved key or invalid key, showing loader UI...")
    showLoaderUI()
end
