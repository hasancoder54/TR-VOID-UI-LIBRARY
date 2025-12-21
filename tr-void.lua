local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

-- Renk Paleti (Dark Blue Theme)
local Theme = {
    Main = Color3.fromRGB(15, 15, 18),
    TopBar = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(0, 160, 255),
    Element = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(180, 180, 190),
    Success = Color3.fromRGB(0, 230, 118),
    Error = Color3.fromRGB(255, 60, 60),
    Border = Color3.fromRGB(80, 80, 85)
}

-- [1. BİLDİRİM SİSTEMİ]
function Library:Notify(title, text, duration)
    local NotifyGui = CoreGui:FindFirstChild("TR_VOID_NOTIFY") or Instance.new("ScreenGui", CoreGui)
    NotifyGui.Name = "TR_VOID_NOTIFY"

    local Notif = Instance.new("Frame")
    Notif.Parent = NotifyGui
    Notif.Size = UDim2.new(0, 240, 0, 65)
    Notif.Position = UDim2.new(1, 20, 1, -100)
    Notif.BackgroundColor3 = Theme.Main
    
    Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Notif)
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1.5

    local TitleLabel = Instance.new("TextLabel", Notif)
    TitleLabel.Size = UDim2.new(1, 0, 0, 25)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "  " .. title
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ContentLabel = Instance.new("TextLabel", Notif)
    ContentLabel.Position = UDim2.new(0, 0, 0, 25)
    ContentLabel.Size = UDim2.new(1, -10, 1, -25)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = "  " .. text
    ContentLabel.TextColor3 = Theme.SecondaryText
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 12
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left

    Notif:TweenPosition(UDim2.new(1, -250, 1, -100), "Out", "Quart", 0.5, true)
    
    task.delay(duration or 3, function()
        Notif:TweenPosition(UDim2.new(1, 20, 1, -100), "In", "Quart", 0.5, true)
        task.wait(0.5)
        Notif:Destroy()
    end)
end

-- [2. KEY SİSTEMİ]
function Library:InitKeySystem(cfg)
    local CorrectKey = cfg.Key or "key"
    local KeyLink = cfg.Link or "link"
    local CustomBg = cfg.BackgroundId or "99502520832764"
    local Callback = cfg.Callback

    local KeyGui = Instance.new("ScreenGui", CoreGui)
    KeyGui.Name = "TR_VOID_KEYSYS"

    local OuterFrame = Instance.new("Frame", KeyGui)
    OuterFrame.Size = UDim2.new(0, 354, 0, 224)
    OuterFrame.Position = UDim2.new(0.5, -177, 0.5, -112)
    OuterFrame.BackgroundColor3 = Theme.Border
    Instance.new("UICorner", OuterFrame).CornerRadius = UDim.new(0, 12)

    local KeyFrame = Instance.new("Frame", OuterFrame)
    KeyFrame.Size = UDim2.new(1, -4, 1, -4)
    KeyFrame.Position = UDim2.new(0, 2, 0, 2)
    KeyFrame.BackgroundColor3 = Theme.Main
    KeyFrame.ClipsDescendants = true
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)

    -- RESİM BURADA (ZIndex 0 yapıldı ki en arkada kalsın)
    local BgImage = Instance.new("ImageLabel", KeyFrame)
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.ZIndex = 0
    BgImage.Image = "rbxassetid://" .. CustomBg
    BgImage.ImageTransparency = 0.5 -- Görünmesi için 0.5 yapıldı
    BgImage.ScaleType = Enum.ScaleType.Fill

    local UIContent = Instance.new("Frame", KeyFrame)
    UIContent.Size = UDim2.new(1, 0, 1, 0)
    UIContent.BackgroundTransparency = 1
    UIContent.ZIndex = 5 -- Objeler resmin üstünde dursun

    local Title = Instance.new("TextLabel", UIContent)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    Title.Text = "TR-VOID | KEY SYSTEM"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20

    local KeyInput = Instance.new("TextBox", UIContent)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.BackgroundColor3 = Theme.Element
    KeyInput.PlaceholderText = "Enter the key..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Theme.Text
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.TextSize = 15
    Instance.new("UICorner", KeyInput)
    local InpStroke = Instance.new("UIStroke", KeyInput)
    InpStroke.Color = Color3.fromRGB(50, 50, 55)

    local VerifyBtn = Instance.new("TextButton", UIContent)
    VerifyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
    VerifyBtn.BackgroundColor3 = Theme.Accent
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Theme.Text
    VerifyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", VerifyBtn)

    local GetBtn = Instance.new("TextButton", UIContent)
    GetBtn.Size = UDim2.new(0.4, 0, 0, 40)
    GetBtn.Position = UDim2.new(0.525, 0, 0.7, 0)
    GetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    GetBtn.Text = "Get Key"
    GetBtn.TextColor3 = Theme.Text
    GetBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", GetBtn)

    GetBtn.MouseButton1Click:Connect(function()
        setclipboard(KeyLink)
        Library:Notify("System", "Link copied!", 3)
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CorrectKey then
            KeyGui:Destroy()
            Callback()
        else
            InpStroke.Color = Theme.Error
            task.wait(1)
            InpStroke.Color = Color3.fromRGB(50, 50, 55)
        end
    end)
end

-- [3. ANA PENCERE]
function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 480
    local WindowHeight = cfg.Height or 380
    local Exploit = identifyexecutor and identifyexecutor() or "Unknown"

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TR_VOID_UI"

    -- [OPEN BUTONU DÜZELTİLDİ]
    local OpenFrame = Instance.new("Frame", ScreenGui)
    OpenFrame.Size = UDim2.new(0, 80, 0, 30)
    OpenFrame.Position = UDim2.new(0, 10, 0, 10)
    OpenFrame.BackgroundColor3 = Theme.Main
    OpenFrame.Visible = false
    OpenFrame.ZIndex = 100
    Instance.new("UICorner", OpenFrame)
    Instance.new("UIStroke", OpenFrame).Color = Theme.Accent

    local OpenBtn = Instance.new("TextButton", OpenFrame)
    OpenBtn.Size = UDim2.new(1, 0, 1, 0)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Text = "OPEN"
    OpenBtn.TextColor3 = Theme.Text
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 13

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Theme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 2

    -- Sürükleme
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)

    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.TopBar
    Instance.new("UICorner", TopBar)

    local TitleLabel = Instance.new("TextLabel", TopBar)
    TitleLabel.Size = UDim2.new(1, -80, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Text = WindowName
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Position = UDim2.new(1, -35, 0, 7)
    CloseBtn.BackgroundColor3 = Theme.Error
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.Text
    Instance.new("UICorner", CloseBtn)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenFrame.Visible = true
    end)
    OpenBtn.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenFrame.Visible = false
    end)

    -- Status Bar
    local StatBar = Instance.new("Frame", Main)
    StatBar.Size = UDim2.new(1, -20, 0, 25)
    StatBar.Position = UDim2.new(0, 10, 1, -35)
    StatBar.BackgroundColor3 = Theme.TopBar
    Instance.new("UICorner", StatBar).CornerRadius = UDim.new(0, 6)
    
    local StatText = Instance.new("TextLabel", StatBar)
    StatText.Size = UDim2.new(1, -10, 1, 0)
    StatText.Position = UDim2.new(0, 10, 0, 0)
    StatText.BackgroundTransparency = 1
    StatText.TextColor3 = Theme.SecondaryText
    StatText.Font = Enum.Font.Code
    StatText.TextSize = 11
    StatText.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        while task.wait(0.5) do
            local fps = math.floor(1/RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            StatText.Text = "FPS: " .. fps .. " | PING: " .. ping .. "ms | " .. Exploit
        end
    end)

    local TabBar = Instance.new("ScrollingFrame", Main)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 0, 0)
    end)

    local ContainerHolder = Instance.new("Frame", Main)
    ContainerHolder.Position = UDim2.new(0, 10, 0, 90)
    ContainerHolder.Size = UDim2.new(1, -20, 1, -135)
    ContainerHolder.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.BackgroundColor3 = Theme.Element
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.SecondaryText
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        Instance.new("UICorner", TabBtn)

        local Container = Instance.new("ScrollingFrame", ContainerHolder)
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 2
        local ContentLayout = Instance.new("UIListLayout", Container)
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        if FirstTab then TabBtn.TextColor3 = Theme.Accent end
        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Theme.SecondaryText end end
            Container.Visible = true
            TabBtn.TextColor3 = Theme.Accent
        end)

        FirstTab = false
        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Button = Instance.new("TextButton", Container)
            Button.BackgroundColor3 = Theme.Element
            Button.Size = UDim2.new(0.96, 0, 0, 38)
            Button.Text = "  " .. text
            Button.TextColor3 = Theme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 14
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button)
            Button.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateToggle(text, callback)
            local state = false
            local ToggleBtn = Instance.new("TextButton", Container)
            ToggleBtn.BackgroundColor3 = Theme.Element
            ToggleBtn.Size = UDim2.new(0.96, 0, 0, 38)
            ToggleBtn.Text = "  " .. text
            ToggleBtn.TextColor3 = Theme.Text
            ToggleBtn.Font = Enum.Font.GothamSemibold
            ToggleBtn.TextSize = 14
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ToggleBtn)

            local Tbg = Instance.new("Frame", ToggleBtn)
            Tbg.Position = UDim2.new(1, -45, 0.5, -10)
            Tbg.Size = UDim2.new(0, 35, 0, 20)
            Tbg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Instance.new("UICorner", Tbg).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame", Tbg)
            Circle.Position = UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.BackgroundColor3 = Theme.Text
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                Circle:TweenPosition(state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), "Out", "Quart", 0.2, true)
                Tbg.BackgroundColor3 = state and Theme.Success or Color3.fromRGB(50, 50, 60)
            end)
        end

        function Elements:CreateDropdown(text, list, multi, callback)
            local open = false
            local selected = {}
            local DropFrame = Instance.new("Frame", Container)
            DropFrame.BackgroundColor3 = Theme.Element
            DropFrame.Size = UDim2.new(0.96, 0, 0, 38)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame)

            local MainBtn = Instance.new("TextButton", DropFrame)
            MainBtn.Size = UDim2.new(1, 0, 0, 38)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text
            MainBtn.TextColor3 = Theme.Text
            MainBtn.Font = Enum.Font.GothamSemibold
            MainBtn.TextSize = 14
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Holder = Instance.new("Frame", DropFrame)
            Holder.Position = UDim2.new(0, 0, 0, 38)
            Holder.Size = UDim2.new(1, 0, 0, #list * 32)
            Holder.BackgroundTransparency = 1

            for i, v in pairs(list) do
                local Option = Instance.new("TextButton", Holder)
                Option.Size = UDim2.new(1, 0, 0, 30)
                Option.Position = UDim2.new(0, 0, 0, (i-1)*30)
                Option.BackgroundTransparency = 1
                Option.Text = tostring(v)
                Option.TextColor3 = Theme.SecondaryText
                Option.Font = Enum.Font.Gotham
                Option.TextSize = 13
                
                Option.MouseButton1Click:Connect(function()
                    if multi then
                        if table.find(selected, v) then table.remove(selected, table.find(selected, v)) else table.insert(selected, v) end
                        callback(selected)
                        MainBtn.Text = "  " .. text .. " (" .. #selected .. ")"
                    else
                        callback(v)
                        MainBtn.Text = "  " .. text .. ": " .. tostring(v)
                        open = false
                        DropFrame.Size = UDim2.new(0.96, 0, 0, 38)
                    end
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                open = not open
                DropFrame.Size = UDim2.new(0.96, 0, 0, open and (38 + (#list * 32)) or 38)
            end)
        end

        function Elements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", Container)
            SliderFrame.BackgroundColor3 = Theme.Element
            SliderFrame.Size = UDim2.new(0.96, 0, 0, 50)
            Instance.new("UICorner", SliderFrame)
            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = "  " .. text .. ": " .. default
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            local Bar = Instance.new("Frame", SliderFrame)
            Bar.Position = UDim2.new(0, 10, 1, -15)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            Bar.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", Bar)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", Fill)
            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max-min)*pos)
                Label.Text = "  " .. text .. ": " .. val
                callback(val)
            end
            local dragging_s = false
            SliderFrame.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging_s = true; Update(i) end end)
            UserInputService.InputChanged:Connect(function(i) if dragging_s and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging_s = false end end)
        end

        function Elements:CreateInput(text, placeholder, callback)
            local InpFrame = Instance.new("Frame", Container)
            InpFrame.BackgroundColor3 = Theme.Element
            InpFrame.Size = UDim2.new(0.96, 0, 0, 50)
            Instance.new("UICorner", InpFrame)
            local Box = Instance.new("TextBox", InpFrame)
            Box.Size = UDim2.new(1, -20, 0, 25)
            Box.Position = UDim2.new(0, 10, 0, 12)
            Box.BackgroundColor3 = Theme.Main
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Theme.Text
            Box.Font = Enum.Font.Gotham
            Box.TextSize = 14
            Instance.new("UICorner", Box)
            Box.FocusLost:Connect(function(e) if e then callback(Box.Text) end end)
        end

        return Elements
    end
    return Tabs
end

return Library
