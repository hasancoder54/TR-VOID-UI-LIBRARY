--// TR-VOID UI LIBRARY (FULL)
local Library = {}

--// Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

--// THEMES
local Themes = {
    Dark = {
        Main = Color3.fromRGB(15,15,18),
        TopBar = Color3.fromRGB(22,22,26),
        Accent = Color3.fromRGB(0,160,255),
        Element = Color3.fromRGB(28,28,32),
        Text = Color3.fromRGB(255,255,255),
        SecondaryText = Color3.fromRGB(180,180,190),
        Success = Color3.fromRGB(0,230,118),
        Error = Color3.fromRGB(255,60,60)
    },
    Purple = {
        Main = Color3.fromRGB(20,18,30),
        TopBar = Color3.fromRGB(30,25,45),
        Accent = Color3.fromRGB(170,0,255),
        Element = Color3.fromRGB(40,35,60),
        Text = Color3.fromRGB(255,255,255),
        SecondaryText = Color3.fromRGB(200,180,210),
        Success = Color3.fromRGB(0,200,120),
        Error = Color3.fromRGB(255,80,80)
    }
}

local Theme = Themes.Dark

function Library:SetTheme(name)
    if Themes[name] then
        Theme = Themes[name]
    end
end

--// NOTIFY
function Library:Notify(title, text, dur)
    local gui = CoreGui:FindFirstChild("TR_VOID_NOTIFY") or Instance.new("ScreenGui", CoreGui)
    gui.Name = "TR_VOID_NOTIFY"

    local f = Instance.new("Frame", gui)
    f.Size = UDim2.new(0,240,0,65)
    f.Position = UDim2.new(1,20,1,-100)
    f.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", f).Color = Theme.Accent

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1,0,0,25)
    t.BackgroundTransparency = 1
    t.Text = "  "..title
    t.TextColor3 = Theme.Accent
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.TextXAlignment = Enum.TextXAlignment.Left

    local c = Instance.new("TextLabel", f)
    c.Position = UDim2.new(0,0,0,25)
    c.Size = UDim2.new(1,-10,1,-25)
    c.BackgroundTransparency = 1
    c.Text = "  "..text
    c.TextWrapped = true
    c.TextColor3 = Theme.SecondaryText
    c.Font = Enum.Font.Gotham
    c.TextSize = 12
    c.TextXAlignment = Enum.TextXAlignment.Left

    f:TweenPosition(UDim2.new(1,-250,1,-100),"Out","Quart",0.4,true)
    task.delay(dur or 3,function()
        f:TweenPosition(UDim2.new(1,20,1,-100),"In","Quart",0.4,true)
        task.wait(.4)
        f:Destroy()
    end)
end

--// KEY SYSTEM (IMAGE SUPPORT)
function Library:InitKeySystem(cfg)
    local CorrectKey = cfg.Key or "key"
    local Callback = cfg.Callback or function() end
    local ImageId = cfg.ImageId -- rbxassetid://

    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.Name = "TR_VOID_KEY"

    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.new(0,360,0,240)
    Main.Position = UDim2.new(0.5,-180,0.5,-120)
    Main.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

    -- IMAGE AREA
    local ImageArea = Instance.new("ImageLabel", Main)
    ImageArea.Size = UDim2.new(1,0,0,80)
    ImageArea.BackgroundTransparency = 1
    ImageArea.ScaleType = Enum.ScaleType.Crop

    if ImageId then
        ImageArea.Image = ImageId
    else
        ImageArea.BackgroundColor3 = Theme.TopBar
        ImageArea.BackgroundTransparency = 0
    end

    Instance.new("UICorner", ImageArea).CornerRadius = UDim.new(0,12)

    -- TITLE
    local Title = Instance.new("TextLabel", Main)
    Title.Position = UDim2.new(0,0,0,80)
    Title.Size = UDim2.new(1,0,0,30)
    Title.BackgroundTransparency = 1
    Title.Text = "TR-VOID | KEY SYSTEM"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    -- INPUT
    local Box = Instance.new("TextBox", Main)
    Box.Size = UDim2.new(0.85,0,0,40)
    Box.Position = UDim2.new(0.075,0,0.55,0)
    Box.BackgroundColor3 = Theme.Element
    Box.PlaceholderText = "Enter Key..."
    Box.Text = ""
    Box.TextColor3 = Theme.Text
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 14
    Instance.new("UICorner", Box)

    -- BUTTON
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0.5,0,0,36)
    Btn.Position = UDim2.new(0.25,0,0.78,0)
    Btn.Text = "Verify"
    Btn.BackgroundColor3 = Theme.Accent
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn)

    Btn.MouseButton1Click:Connect(function()
        if Box.Text == CorrectKey then
            Gui:Destroy()
            Callback()
        else
            Box.Text = ""
            Box.PlaceholderText = "Wrong Key!"
        end
    end)
end

--// WINDOW
function Library:CreateWindow(cfg)
    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.Name = "TR_VOID_UI"

    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.new(0,cfg.Width or 500,0,cfg.Height or 400)
    Main.Position = UDim2.new(0.5,-Main.Size.X.Offset/2,0.5,-Main.Size.Y.Offset/2)
    Main.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

    local Tabs = {}
    local Holder = Instance.new("Frame", Main)
    Holder.Position = UDim2.new(0,0,0,45)
    Holder.Size = UDim2.new(1,0,1,-45)
    Holder.BackgroundTransparency = 1

    local TabBar = Instance.new("ScrollingFrame", Main)
    TabBar.Size = UDim2.new(1,-20,0,35)
    TabBar.Position = UDim2.new(0,10,0,5)
    TabBar.CanvasSize = UDim2.new(0,0,0,0)
    TabBar.ScrollBarThickness = 2
    local layout = Instance.new("UIListLayout", TabBar)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0,8)

    function Tabs:CreateTab(name)
        local Btn = Instance.new("TextButton", TabBar)
        Btn.Text = name
        Btn.BackgroundColor3 = Theme.Element
        Btn.TextColor3 = Theme.Text
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 14
        Btn.Size = UDim2.new(0,TextService:GetTextSize(name,14,Enum.Font.GothamBold,Vector2.new(500,40)).X+30,0,30)
        Instance.new("UICorner", Btn)

        local Cont = Instance.new("ScrollingFrame", Holder)
        Cont.Size = UDim2.new(1,0,1,0)
        Cont.Visible = false
        Cont.ScrollBarThickness = 4
        local lay = Instance.new("UIListLayout", Cont)
        lay.Padding = UDim.new(0,10)
        lay.HorizontalAlignment = Enum.HorizontalAlignment.Center

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(Holder:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Cont.Visible = true
        end)

        local Elements = {}

        function Elements:CreateButton(text, cb)
            local b = Instance.new("TextButton", Cont)
            b.Size = UDim2.new(0.96,0,0,45)
            b.Text = "  "..text
            b.BackgroundColor3 = Theme.Element
            b.TextColor3 = Theme.Text
            b.Font = Enum.Font.GothamSemibold
            b.TextSize = 14
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(cb)
        end

        function Elements:CreateKeybind(text, defaultKey, cb)
            local key = defaultKey
            local waiting = false

            local b = Instance.new("TextButton", Cont)
            b.Size = UDim2.new(0.96,0,0,45)
            b.Text = "  "..text.." ["..key.Name.."]"
            b.BackgroundColor3 = Theme.Element
            b.TextColor3 = Theme.Text
            Instance.new("UICorner", b)

            b.MouseButton1Click:Connect(function()
                waiting = true
                b.Text = "  Press a key..."
            end)

            UIS.InputBegan:Connect(function(i,g)
                if waiting and not g then
                    if i.KeyCode ~= Enum.KeyCode.Unknown then
                        key = i.KeyCode
                        b.Text = "  "..text.." ["..key.Name.."]"
                        waiting = false
                    end
                end
                if i.KeyCode == key then
                    cb()
                end
            end)
        end

        return Elements
    end

    return Tabs
end

--// IMPORTANT
return Library
