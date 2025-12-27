local Library = {}

-- SERVICES
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- THEME
local Theme = {
    Main = Color3.fromRGB(15, 15, 18),
    Accent = Color3.fromRGB(0, 160, 255),
    Element = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(180, 180, 190)
}

-- =========================
-- NOTIFY
-- =========================
function Library:Notify(title, text, duration)
    local NotifyGui = CoreGui:FindFirstChild("TR_VOID_NOTIFY") or Instance.new("ScreenGui", CoreGui)
    NotifyGui.Name = "TR_VOID_NOTIFY"

    local Notif = Instance.new("Frame", NotifyGui)
    Notif.Size = UDim2.new(0, 220, 0, 60)
    Notif.Position = UDim2.new(1, 20, 1, -100)
    Notif.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", Notif)
    Instance.new("UIStroke", Notif).Color = Theme.Accent

    local tl = Instance.new("TextLabel", Notif)
    tl.Size = UDim2.new(1, 0, 0, 25)
    tl.BackgroundTransparency = 1
    tl.Text = "  "..title
    tl.TextColor3 = Theme.Accent
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.Font = Enum.Font.GothamBold

    local cl = Instance.new("TextLabel", Notif)
    cl.Position = UDim2.new(0, 0, 0, 25)
    cl.Size = UDim2.new(1, 0, 1, -25)
    cl.BackgroundTransparency = 1
    cl.Text = "  "..text
    cl.TextColor3 = Theme.Text
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextSize = 12

    Notif:TweenPosition(UDim2.new(1, -230, 1, -100), "Out", "Quart", 0.4, true)
    task.delay(duration or 3, function()
        Notif:TweenPosition(UDim2.new(1, 20, 1, -100), "In", "Quart", 0.4, true)
        task.wait(0.4)
        Notif:Destroy()
    end)
end

-- =========================
-- KEY SYSTEM (FULL BG FIX)
-- =========================
function Library:InitKeySystem(cfg)
    local CorrectKey = cfg.Key or "key"
    local CustomImage = cfg.Image
    local Callback = cfg.Callback

    local KeyGui = Instance.new("ScreenGui", CoreGui)
    KeyGui.Name = "TR_VOID_KEY"

    local KeyFrame = Instance.new("Frame", KeyGui)
    KeyFrame.Size = UDim2.new(0, 420, 0, 260)
    KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
    KeyFrame.BackgroundTransparency = 1
    KeyFrame.ClipsDescendants = true
    Instance.new("UICorner", KeyFrame)
    Instance.new("UIStroke", KeyFrame).Color = Theme.Accent

    -- 🔥 FULL BACKGROUND IMAGE
    if CustomImage then
        local img = Instance.new("ImageLabel", KeyFrame)
        img.Name = "BG_Image"
        img.Size = UDim2.fromScale(1, 1)
        img.Position = UDim2.fromScale(0, 0)
        img.BackgroundTransparency = 1
        img.BorderSizePixel = 0
        img.Image = CustomImage
        img.ImageTransparency = 0.25
        img.ScaleType = Enum.ScaleType.Stretch -- %100 DOLDURUR
        img.ZIndex = 0
        Instance.new("UICorner", img)

        task.spawn(function()
            pcall(function()
                ContentProvider:PreloadAsync({CustomImage})
            end)
        end)

        -- overlay (okunurluk)
        local overlay = Instance.new("Frame", KeyFrame)
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.35
        overlay.ZIndex = 1
        Instance.new("UICorner", overlay)
    end

    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, 0, 0, 55)
    Title.BackgroundTransparency = 1
    Title.Text = "TR-VOID | KEY SYSTEM"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.ZIndex = 2

    local input = Instance.new("TextBox", KeyFrame)
    input.Size = UDim2.new(0.8, 0, 0, 45)
    input.Position = UDim2.new(0.1, 0, 0.42, 0)
    input.PlaceholderText = "Key Gir..."
    input.BackgroundColor3 = Theme.Element
    input.TextColor3 = Theme.Text
    input.ZIndex = 3
    Instance.new("UICorner", input)

    local btn = Instance.new("TextButton", KeyFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = UDim2.new(0.1, 0, 0.7, 0)
    btn.Text = "Verify"
    btn.BackgroundColor3 = Theme.Accent
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 3
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if input.Text == CorrectKey then
            KeyGui:Destroy()
            if Callback then Callback() end
        else
            Library:Notify("Hata", "Yanlış Key", 2)
        end
    end)
end

-- =========================
-- WINDOW
-- =========================
function Library:CreateWindow(cfg)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 450, 0, 350)
    Main.Position = UDim2.new(0.5, -225, 0.5, -175)
    Main.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Theme.Accent

    -- DRAG
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function()
        dragging = false
    end)

    local Container = Instance.new("ScrollingFrame", Main)
    Container.Size = UDim2.new(1, -20, 1, -60)
    Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 2
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

    local Tabs = {}
    function Tabs:CreateTab()
        local Elements = {}

        function Elements:CreateLabel(text)
            local l = Instance.new("TextLabel", Container)
            l.Size = UDim2.new(0.95, 0, 0, 30)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = Theme.Accent
            l.Font = Enum.Font.GothamBold
            return {Update = function(t) l.Text = t end}
        end

        function Elements:CreateToggle(text, cb)
            local state = false
            local t = Instance.new("TextButton", Container)
            t.Size = UDim2.new(0.95, 0, 0, 35)
            t.BackgroundColor3 = Theme.Element
            t.Text = "  "..text
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.TextColor3 = Theme.Text
            Instance.new("UICorner", t)

            local s = Instance.new("Frame", t)
            s.Size = UDim2.new(0, 24, 0, 24)
            s.Position = UDim2.new(1, -30, 0.5, -12)
            s.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", s)

            t.MouseButton1Click:Connect(function()
                state = not state
                s.BackgroundColor3 = state and Theme.Accent or Theme.Main
                cb(state)
            end)
        end

        return Elements
    end

    return Tabs
end

return Library
