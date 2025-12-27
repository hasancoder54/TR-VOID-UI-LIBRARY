local Library = {}
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Theme = {
    Main = Color3.fromRGB(15, 15, 18),
    TopBar = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(0, 160, 255),
    Element = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(180, 180, 190)
}

-- [BİLDİRİM SİSTEMİ]
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
    tl.Size = UDim2.new(1, 0, 0, 25); tl.Text = "  " .. title; tl.TextColor3 = Theme.Accent; tl.BackgroundTransparency = 1; tl.TextXAlignment = 0; tl.Font = 3

    local cl = Instance.new("TextLabel", Notif)
    cl.Position = UDim2.new(0, 0, 0, 25); cl.Size = UDim2.new(1, 0, 1, -25)
    cl.Text = "  " .. text; cl.TextColor3 = Theme.Text; cl.BackgroundTransparency = 1; cl.TextXAlignment = 0; cl.TextSize = 12

    Notif:TweenPosition(UDim2.new(1, -230, 1, -100), "Out", "Quart", 0.5, true)
    task.delay(duration or 3, function()
        Notif:TweenPosition(UDim2.new(1, 20, 1, -100), "In", "Quart", 0.5, true)
        task.wait(0.5); Notif:Destroy()
    end)
end

-- [KEY SİSTEMİ]
function Library:InitKeySystem(cfg)
    local CorrectKey = cfg.Key or "key"
    local CustomImage = cfg.Image or ""
    local Callback = cfg.Callback

    local KeyGui = Instance.new("ScreenGui", CoreGui)
    local KeyFrame = Instance.new("Frame", KeyGui)
    KeyFrame.Size = UDim2.new(0, 350, 0, 220); KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    KeyFrame.BackgroundColor3 = Theme.Main; KeyFrame.ZIndex = 1
    Instance.new("UICorner", KeyFrame); Instance.new("UIStroke", KeyFrame).Color = Theme.Accent

    if CustomImage ~= "" then
        local img = Instance.new("ImageLabel", KeyFrame)
        img.Size = UDim2.fromScale(1, 1); img.BackgroundTransparency = 1; img.ScaleType = 2; img.ZIndex = 2; img.ImageTransparency = 0.3
        Instance.new("UICorner", img)
        task.spawn(function() pcall(function() ContentProvider:PreloadAsync({CustomImage}); img.Image = CustomImage end) end)
    end

    local input = Instance.new("TextBox", KeyFrame)
    input.Size = UDim2.new(0.8, 0, 0, 40); input.Position = UDim2.new(0.1, 0, 0.4, 0)
    input.BackgroundColor3 = Theme.Element; input.TextColor3 = Theme.Text; input.ZIndex = 3; input.PlaceholderText = "Key Gir..."
    Instance.new("UICorner", input)

    local btn = Instance.new("TextButton", KeyFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 40); btn.Position = UDim2.new(0.1, 0, 0.7, 0)
    btn.BackgroundColor3 = Theme.Accent; btn.Text = "Verify"; btn.ZIndex = 3; btn.TextColor3 = Theme.Text; btn.Font = 3
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        if input.Text == CorrectKey then KeyGui:Destroy(); Callback() end
    end)
end

-- [ANA PENCERE]
function Library:CreateWindow(cfg)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 450, 0, 350); Main.Position = UDim2.new(0.5, -225, 0.5, -175)
    Main.BackgroundColor3 = Theme.Main; Instance.new("UICorner", Main)
    Instance.new("UIStroke", Main).Color = Theme.Accent

    -- Sürükleme (Drag)
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    UserInputService.InputEnded:Connect(function() dragging = false end)

    local Container = Instance.new("ScrollingFrame", Main)
    Container.Size = UDim2.new(1, -20, 1, -60); Container.Position = UDim2.new(0, 10, 0, 50)
    Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
    Instance.new("UIListLayout", Container).Padding = UDim.new(0, 10)

    local Tabs = {}
    function Tabs:CreateTab(name)
        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(text, cb)
            local b = Instance.new("TextButton", Container)
            b.Size = UDim2.new(0.95, 0, 0, 35); b.BackgroundColor3 = Theme.Element; b.Text = text; b.TextColor3 = Theme.Text; Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(cb)
        end

        -- TOGGLE
        function Elements:CreateToggle(text, cb)
            local state = false
            local t = Instance.new("TextButton", Container)
            t.Size = UDim2.new(0.95, 0, 0, 35); t.BackgroundColor3 = Theme.Element; t.Text = "  " .. text; t.TextColor3 = Theme.Text; t.TextXAlignment = 0; Instance.new("UICorner", t)
            local s = Instance.new("Frame", t)
            s.Size = UDim2.new(0, 25, 0, 25); s.Position = UDim2.new(1, -30, 0, 5); s.BackgroundColor3 = Theme.Main; Instance.new("UICorner", s)
            t.MouseButton1Click:Connect(function() state = not state; s.BackgroundColor3 = state and Theme.Accent or Theme.Main; cb(state) end)
        end

        -- LABEL (GÜNCELLEME DESTEKLİ)
        function Elements:CreateLabel(text)
            local l = Instance.new("TextLabel", Container)
            l.Size = UDim2.new(0.95, 0, 0, 30); l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = Theme.Accent; l.Font = 3
            return {Update = function(new) l.Text = new end}
        end

        -- INPUT
        function Elements:CreateInput(text, placeholder, cb)
            local f = Instance.new("Frame", Container); f.Size = UDim2.new(0.95, 0, 0, 40); f.BackgroundColor3 = Theme.Element; Instance.new("UICorner", f)
            local t = Instance.new("TextBox", f); t.Size = UDim2.new(1, -10, 1, 0); t.BackgroundTransparency = 1; t.Text = ""; t.PlaceholderText = text; t.TextColor3 = Theme.Text
            t.FocusLost:Connect(function(e) if e then cb(t.Text) end end)
        end

        -- DROPDOWN (MULTI & SINGLE)
        function Elements:CreateDropdown(text, list, multi, cb)
            local open = false; local sel = {}
            local d = Instance.new("Frame", Container); d.Size = UDim2.new(0.95, 0, 0, 35); d.BackgroundColor3 = Theme.Element; d.ClipsDescendants = true; Instance.new("UICorner", d)
            local b = Instance.new("TextButton", d); b.Size = UDim2.new(1, 0, 0, 35); b.Text = text .. " ▼"; b.BackgroundColor3 = Theme.Element; b.TextColor3 = Theme.Text
            local h = Instance.new("Frame", d); h.Position = UDim2.new(0, 0, 0, 35); h.Size = UDim2.new(1, 0, 0, #list * 30)
            for i, v in pairs(list) do
                local o = Instance.new("TextButton", h); o.Size = UDim2.new(1, 0, 0, 30); o.Position = UDim2.new(0, 0, 0, (i-1)*30); o.Text = v; o.BackgroundColor3 = Theme.Main; o.TextColor3 = Theme.SecondaryText
                o.MouseButton1Click:Connect(function()
                    if multi then
                        if table.find(sel, v) then table.remove(sel, table.find(sel, v)); o.TextColor3 = Theme.SecondaryText
                        else table.insert(sel, v); o.TextColor3 = Theme.Accent end; cb(sel)
                    else cb(v); b.Text = v; d.Size = UDim2.new(0.95, 0, 0, 35); open = false end
                end)
            end
            b.MouseButton1Click:Connect(function() open = not open; d:TweenSize(UDim2.new(0.95, 0, 0, open and (35 + #list * 30) or 35), "Out", "Quart", 0.3, true) end)
        end

        return Elements
    end
    return Tabs
end

return Library
