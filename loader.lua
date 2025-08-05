-- put near your other config
local workerURL = "https://insanix-verify.yourname.workers.dev"  -- <-- your worker
local workerToken = "insanix-SECRET-123"                         -- <-- same TOKEN you set in CF

local function verifyKey(key)
    key = tostring(key or ""):gsub("%s+", "") -- trim spaces/newlines
    local url = ("%s?key=%s&hwid=%s&token=%s")
        :format(workerURL,
                HttpService:UrlEncode(key),
                HttpService:UrlEncode(hwid),
                HttpService:UrlEncode(workerToken))

    -- Use HttpGet; executors generally allow this. If yours supports RequestAsync, that’s fine too.
    local okHttp, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not okHttp then
        warn("[InsaniX] HTTP error via proxy:", body)
        return false
    end

    -- Debug: see what the proxy (and Sellauth) returned
    print("[InsaniX] Proxy response:", body)

    local okJson, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not okJson then
        warn("[InsaniX] JSON decode failed")
        return false
    end

    -- Accept common success shapes (adjust if your API returns different fields)
    if data.success == true or data.valid == true or data.status == "success" then
        return true
    end

    if data.message then warn("[InsaniX] Verify failed:", data.message) end
    if data.reason  then warn("[InsaniX] Reason:", data.reason) end
    return false
end
