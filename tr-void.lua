local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local RunService = game:GetService("RunService")

-- Renk Paleti
local Theme = {
    Main = Color3.fromRGB(15, 15, 18),
    TopBar = Color3.fromRGB(22, 22, 26),
    Accent = Color3.fromRGB(0, 160, 255),
    Element = Color3.fromRGB(28, 28, 32),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(180, 180, 190),
    Success = Color3.fromRGB(0, 230, 118),
    Error = Color3.fromRGB(255, 60, 60)
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
    local CustomBg = cfg.CustomBackground -- Image ID veya nil/false
    local Callback = cfg.Callback

    local KeyGui = Instance.new("ScreenGui", CoreGui)
    KeyGui.Name = "TR_VOID_KEYSYS"

    local Shadow = Instance.new("Frame", KeyGui)
    Shadow.Size = UDim2.new(0, 356, 0, 226)
    Shadow.Position = UDim2.new(0.5, -178, 0.5, -113)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.5
    Instance.new("UICorner", Shadow).CornerRadius = UDim.new(0, 12)

    local KeyFrame = Instance.new("Frame", KeyGui)
    KeyFrame.Size = UDim2.new(0, 350, 0, 220)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    KeyFrame.BackgroundColor3 = Theme.Main
    KeyFrame.ClipsDescendants = true
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", KeyFrame)
    MainStroke.Color = Color3.fromRGB(45, 45, 50)

    -- Arka Plan Ayarı
    if CustomBg then
        local BgImage = Instance.new("ImageLabel", KeyFrame)
        BgImage.Size = UDim2.new(1, 0, 1, 0)
        BgImage.Image = "rbxassetid://" .. tostring(CustomBg)
        BgImage.ImageTransparency = 0.8
        BgImage.BackgroundTransparency = 1
        BgImage.ZIndex = 0
    else
        -- Gri Çizgi Animasyonu (Scanning Effect)
        local Line = Instance.new("Frame", KeyFrame)
        Line.Size = UDim2.new(0, 2, 1, 0)
        Line.Position = UDim2.new(-0.1, 0, 0, 0)
        Line.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        Line.BackgroundTransparency = 0.6
        Line.BorderSizePixel = 0
        Line.ZIndex = 1

        local function RunAnim()
            Line.Position = UDim2.new(-0.1, 0, 0, 0)
            local t = TweenService:Create(Line, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = UDim2.new(1.1, 0, 0, 0)})
            t:Play()
            t.Completed:Connect(function()
                task.wait(0.1)
                RunAnim()
            end)
        end
        RunAnim()
    end

    local Title = Instance.new("TextLabel", KeyFrame)
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    Title.Text = "TR-VOID | KEY SYSTEM"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.ZIndex = 5

    local KeyInput = Instance.new("TextBox", KeyFrame)
    KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
    KeyInput.Position = UDim2.new(0.075, 0, 0.35, 0)
    KeyInput.BackgroundColor3 = Theme.Element
    KeyInput.PlaceholderText = "Enter key..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Theme.Text
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.ZIndex = 5
    Instance.new("UICorner", KeyInput)
    local InpStroke = Instance.new("UIStroke", KeyInput)
    InpStroke.Color = Color3.fromRGB(50, 50, 55)

    local VerifyBtn = Instance.new("TextButton", KeyFrame)
    VerifyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
    VerifyBtn.BackgroundColor3 = Theme.Accent
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Theme.Text
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.ZIndex = 5
    Instance.new("UICorner", VerifyBtn)

    local GetBtn = Instance.new("TextButton", KeyFrame)
    GetBtn.Size = UDim2.new(0.4, 0, 0, 40)
    GetBtn.Position = UDim2.new(0.525, 0, 0.7, 0)
    GetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    GetBtn.Text = "Get Key"
    GetBtn.TextColor3 = Theme.Text
    GetBtn.Font = Enum.Font.GothamBold
    GetBtn.ZIndex = 5
    Instance.new("UICorner", GetBtn)

    GetBtn.MouseButton1Click:Connect(function()
        setclipboard(KeyLink)
        Library:Notify("System", "Key link copied!", 2)
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
    local MainFontSize = cfg.FontSize or 16

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TR_VOID_UI"

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Theme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(45, 45, 50)

    -- Dragging
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

    local TabBar = Instance.new("ScrollingFrame", Main)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)

    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local ContainerHolder = Instance.new("Frame", Main)
    ContainerHolder.Position = UDim2.new(0, 10, 0, 95)
    ContainerHolder.Size = UDim2.new(1, -20, 1, -105)
    ContainerHolder.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.BackgroundColor3 = Theme.Element
        TabBtn.Text = name
        TabBtn.TextColor3 = Theme.SecondaryText
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 14
        Instance.new("UICorner", TabBtn)
        local ts = TextService:GetTextSize(name, 14, Enum.Font.GothamBold, Vector2.new(1000, 32))
        TabBtn.Size = UDim2.new(0, ts.X + 25, 0, 30)

        local Container = Instance.new("ScrollingFrame", ContainerHolder)
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 2
        Container.ScrollBarImageColor3 = Theme.Accent
        
        local ContentLayout = Instance.new("UIListLayout", Container)
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Theme.SecondaryText end end
            Container.Visible = true
            TabBtn.TextColor3 = Theme.Accent
        end)

        if FirstTab then TabBtn.TextColor3 = Theme.Accent; FirstTab = false end

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
            Instance.new("UICorner", Button)
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

        function Elements:CreateDropdown(text, list, callback)
            local open = false
            local DropFrame = Instance.new("Frame", Container)
            DropFrame.BackgroundColor3 = Theme.Element
            DropFrame.Size = UDim2.new(0.96, 0, 0, 45)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame)

            local MainBtn = Instance.new("TextButton", DropFrame)
            MainBtn.Size = UDim2.new(1, 0, 0, 45)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. " (Select...)"
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
                Instance.new("UICorner", Option)
                
                Option.MouseButton1Click:Connect(function()
                    callback(v)
                    MainBtn.Text = "  " .. text .. ": " .. tostring(v)
                    open = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.96, 0, 0, 45)}):Play()
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                open = not open
                local targetH = open and (45 + (#list * 35) + 5) or 45
                TweenService:Create(DropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0.96, 0, 0, targetH)}):Play()
            end)
        end

        function Elements:CreateMultiDropdown(text, list, callback)
            local selected = {}
            local open = false
            local DropFrame = Instance.new("Frame", Container)
            DropFrame.BackgroundColor3 = Theme.Element
            DropFrame.Size = UDim2.new(0.96, 0, 0, 45)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame)

            local MainBtn = Instance.new("TextButton", DropFrame)
            MainBtn.Size = UDim2.new(1, 0, 0, 45)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. text .. " (Multi-Select)"
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
                Instance.new("UICorner", Option)
                
                Option.MouseButton1Click:Connect(function()
                    if table.find(selected, v) then
                        table.remove(selected, table.find(selected, v))
                        Option.TextColor3 = Theme.SecondaryText
                    else
                        table.insert(selected, v)
                        Option.TextColor3 = Theme.Accent
                    end
                    callback(selected)
                    MainBtn.Text = "  " .. text .. ": " .. table.concat(selected, ", ")
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                open = not open
                local targetH = open and (45 + (#list * 35) + 5) or 45
                TweenService:Create(DropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0.96, 0, 0, targetH)}):Play()
            end)
        end

        function Elements:AddStats()
            local StatLabel = Instance.new("TextLabel", Container)
            StatLabel.Size = UDim2.new(0.96, 0, 0, 70)
            StatLabel.BackgroundColor3 = Theme.Element
            StatLabel.TextColor3 = Theme.Text
            StatLabel.Font = Enum.Font.GothamSemibold
            StatLabel.TextSize = 14
            Instance.new("UICorner", StatLabel)

            local function GetExecutor()
                return (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
            end

            RunService.RenderStepped:Connect(function()
                local fps = math.floor(1/RunService.RenderStepped:Wait())
                local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                StatLabel.Text = string.format("FPS: %s\nPing: %s\nExploit: %s", fps, ping, GetExecutor())
            end)
        end

        return Elements
    end
    return Tabs
end

return Library
