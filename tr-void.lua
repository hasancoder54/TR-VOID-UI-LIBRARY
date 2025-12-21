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
    Border = Color3.fromRGB(80, 80, 85) -- Gri ve belirgin border
}

-- [1. BİLDİRİM SİSTEMİ]
function Library:Notify(title, text, duration)
    local NotifyGui = CoreGui:FindFirstChild("TR_VOID_NOTIFY") or Instance.new("ScreenGui", CoreGui)
    NotifyGui.Name = "TR_VOID_NOTIFY"

    local Notif = Instance.new("Frame")
    Notif.Name = "Notification"
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

    -- Dış Border ve Gölge Frame'i
    local OuterFrame = Instance.new("Frame", KeyGui)
    OuterFrame.Size = UDim2.new(0, 354, 0, 224)
    OuterFrame.Position = UDim2.new(0.5, -177, 0.5, -112)
    OuterFrame.BackgroundColor3 = Theme.Border
    Instance.new("UICorner", OuterFrame).CornerRadius = UDim.new(0, 12)

    -- Gölge (Shadow)
    local Shadow = Instance.new("ImageLabel", OuterFrame)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.Position = UDim2.new(0, -20, 0, -20)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ZIndex = 0

    local KeyFrame = Instance.new("Frame", OuterFrame)
    KeyFrame.Size = UDim2.new(1, -4, 1, -4)
    KeyFrame.Position = UDim2.new(0, 2, 0, 2)
    KeyFrame.BackgroundColor3 = Theme.Main
    KeyFrame.ClipsDescendants = true
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)

    -- Arkaplan Asset veya Animasyon
    local BgImage = Instance.new("ImageLabel", KeyFrame)
    BgImage.Size = UDim2.new(1, 0, 1, 0)
    BgImage.BackgroundTransparency = 1
    BgImage.ZIndex = 1
    
    if CustomBg and CustomBg ~= "" then
        BgImage.Image = "rbxassetid://" .. CustomBg
        BgImage.ImageTransparency = 0.6
    else
        task.spawn(function()
            while KeyGui.Parent do
                TweenService:Create(BgImage, TweenInfo.new(2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40), BackgroundTransparency = 0.8}):Play()
                task.wait(2)
                TweenService:Create(BgImage, TweenInfo.new(2), {BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 1}):Play()
                task.wait(2)
            end
        end)
    end

    local UIContent = Instance.new("Frame", KeyFrame)
    UIContent.Size = UDim2.new(1, 0, 1, 0)
    UIContent.BackgroundTransparency = 1
    UIContent.ZIndex = 2

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
        Library:Notify("System", "Key link copied to clipboard!", 3)
    end)

    VerifyBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text == CorrectKey then
            InpStroke.Color = Theme.Success
            VerifyBtn.Text = "Access Granted!"
            local tween = TweenService:Create(OuterFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -177, 1, 50)})
            tween:Play()
            task.wait(0.5)
            KeyGui:Destroy()
            Callback()
        else
            InpStroke.Color = Theme.Error
            KeyInput.Text = ""
            KeyInput.PlaceholderText = "Invalid Key! Try again."
            task.wait(1.5)
            InpStroke.Color = Color3.fromRGB(50, 50, 55)
            KeyInput.PlaceholderText = "Enter the key..."
        end
    end)
end

-- [3. ANA PENCERE OLUŞTURMA]
function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 480
    local WindowHeight = cfg.Height or 380
    local MainFontSize = cfg.FontSize or 16
    local Exploit = identifyexecutor and identifyexecutor() or "Unknown"

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TR_VOID_UI"

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Theme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Theme.Border
    MainStroke.Thickness = 1.5

    -- [STAT TAB (FPS, MS, EXPLOIT)]
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
    StatText.TextSize = 12
    StatText.TextXAlignment = Enum.TextXAlignment.Left

    task.spawn(function()
        while task.wait(0.5) do
            local fps = math.floor(1/RunService.RenderStepped:Wait())
            local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            StatText.Text = "FPS: " .. fps .. " | MS: " .. ping .. " | Exploit: " .. Exploit
        end
    end)

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
    TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    TitleLabel.Text = "  " .. WindowName
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
    
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local TabBar = Instance.new("ScrollingFrame", Main)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    TabBar.ScrollingDirection = Enum.ScrollingDirection.X
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)

    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 10, 0, 0)
    end)

    local ContainerHolder = Instance.new("Frame", Main)
    ContainerHolder.Position = UDim2.new(0, 10, 0, 95)
    ContainerHolder.Size = UDim2.new(1, -20, 1, -140) -- StatBar için küçültüldü
    ContainerHolder.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.BackgroundColor3 = Theme.Element
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.SecondaryText
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 15
        Instance.new("UICorner", TabBtn)
        
        local textS = TextService:GetTextSize(name, 15, Enum.Font.GothamBold, Vector2.new(1000, 40))
        TabBtn.Size = UDim2.new(0, textS.X + 30, 0, 32)

        local Container = Instance.new("ScrollingFrame", ContainerHolder)
        Container.Name = name .. "_Container"
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 4
        Container.ScrollBarImageColor3 = Theme.Accent
        
        local ContentLayout = Instance.new("UIListLayout", Container)
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        if FirstTab then TabBtn.TextColor3 = Theme.Accent end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            for _, v in pairs(TabBar:GetChildren()) do
                if v:IsA("TextButton") then v.TextColor3 = Theme.SecondaryText end
            end
            Container.Visible = true
            TabBtn.TextColor3 = Theme.Accent
        end)

        FirstTab = false
        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Button = Instance.new("TextButton", Container)
            Button.BackgroundColor3 = Theme.Element
            Button.Size = UDim2.new(0.96, 0, 0, 45)
            Button.Text = "  " .. text
            Button.TextColor3 = Theme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = MainFontSize
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            Button.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateToggle(text, callback)
            local state = false
            local ToggleBtn = Instance.new("TextButton", Container)
            ToggleBtn.BackgroundColor3 = Theme.Element
            ToggleBtn.Size = UDim2.new(0.96, 0, 0, 45)
            ToggleBtn.Text = "  " .. text
            ToggleBtn.TextColor3 = Theme.Text
            ToggleBtn.Font = Enum.Font.GothamSemibold
            ToggleBtn.TextSize = MainFontSize
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ToggleBtn)

            local Tbg = Instance.new("Frame", ToggleBtn)
            Tbg.Position = UDim2.new(1, -55, 0.5, -12)
            Tbg.Size = UDim2.new(0, 45, 0, 24)
            Tbg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Instance.new("UICorner", Tbg).CornerRadius = UDim.new(0, 12)

            local Circle = Instance.new("Frame", Tbg)
            Circle.Position = UDim2.new(0, 4, 0.5, -9)
            Circle.Size = UDim2.new(0, 18, 0, 18)
            Circle.BackgroundColor3 = Theme.Text
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)}):Play()
                TweenService:Create(Tbg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Success or Color3.fromRGB(50, 50, 60)}):Play()
            end)
        end

        function Elements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", Container)
            SliderFrame.BackgroundColor3 = Theme.Element
            SliderFrame.Size = UDim2.new(0.96, 0, 0, 55)
            Instance.new("UICorner", SliderFrame)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = "  " .. text .. ": " .. default
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = MainFontSize
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Bar = Instance.new("Frame", SliderFrame)
            Bar.Position = UDim2.new(0, 15, 1, -18)
            Bar.Size = UDim2.new(1, -30, 0, 6)
            Bar.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", Fill)

            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local value = math.floor(min + (max-min)*pos)
                Label.Text = "  " .. text .. ": " .. value
                callback(value)
            end

            local sliding = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true; UpdateSlider(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function() sliding = false end)
        end

        -- [ÇOKLU SEÇİMLİ DROPDOWN]
        function Elements:CreateDropdown(text, list, multi, callback)
            local open = false
            local selected = {}
            local DropFrame = Instance.new("Frame", Container)
            DropFrame.BackgroundColor3 = Theme.Element
            DropFrame.Size = UDim2.new(0.96, 0, 0, 45)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame)

            local MainBtn = Instance.new("TextButton", DropFrame)
            MainBtn.Size = UDim2.new(1, 0, 0, 45)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. " (Seçiniz...)"
            MainBtn.TextColor3 = Theme.Text
            MainBtn.Font = Enum.Font.GothamSemibold
            MainBtn.TextSize = MainFontSize
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local Holder = Instance.new("Frame", DropFrame)
            Holder.Position = UDim2.new(0, 0, 0, 45)
            Holder.Size = UDim2.new(1, 0, 0, #list * 35)
            Holder.BackgroundTransparency = 1

            for i, v in pairs(list) do
                local Option = Instance.new("TextButton", Holder)
                Option.Size = UDim2.new(1, -20, 0, 30)
                Option.Position = UDim2.new(0, 10, 0, (i-1)*35)
                Option.BackgroundColor3 = Theme.Main
                Option.Text = tostring(v)
                Option.TextColor3 = Theme.SecondaryText
                Option.Font = Enum.Font.Gotham
                Option.TextSize = MainFontSize
                Instance.new("UICorner", Option)
                
                Option.MouseButton1Click:Connect(function()
                    if multi then
                        if table.find(selected, v) then
                            table.remove(selected, table.find(selected, v))
                            Option.TextColor3 = Theme.SecondaryText
                        else
                            table.insert(selected, v)
                            Option.TextColor3 = Theme.Accent
                        end
                        callback(selected)
                        MainBtn.Text = "  " .. text .. ": " .. table.concat(selected, ", ")
                    else
                        selected = {v}
                        callback(v)
                        MainBtn.Text = "  " .. text .. ": " .. tostring(v)
                        open = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.96, 0, 0, 45)}):Play()
                    end
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                open = not open
                local targetH = open and (45 + (#list * 35) + 5) or 45
                TweenService:Create(DropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0.96, 0, 0, targetH)}):Play()
            end)
        end

        function Elements:CreateInput(text, placeholder, callback)
            local InpFrame = Instance.new("Frame", Container)
            InpFrame.BackgroundColor3 = Theme.Element
            InpFrame.Size = UDim2.new(0.96, 0, 0, 55)
            Instance.new("UICorner", InpFrame)

            local InpTitle = Instance.new("TextLabel", InpFrame)
            InpTitle.Size = UDim2.new(1, 0, 0, 25)
            InpTitle.Position = UDim2.new(0, 10, 0, 2)
            InpTitle.BackgroundTransparency = 1
            InpTitle.Text = text
            InpTitle.TextColor3 = Theme.SecondaryText
            InpTitle.Font = Enum.Font.Gotham
            InpTitle.TextSize = 13
            InpTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox", InpFrame)
            Box.Size = UDim2.new(1, -20, 0, 25)
            Box.Position = UDim2.new(0, 10, 0, 25)
            Box.BackgroundColor3 = Theme.Main
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Theme.Text
            Box.Font = Enum.Font.Gotham
            Box.TextSize = MainFontSize
            Instance.new("UICorner", Box)
            
            Box.FocusLost:Connect(function(enter)
                if enter then callback(Box.Text) end
            end)
        end

        return Elements
    end
    return Tabs
end

return Library
