--[[
    TR-VOID UI LIBRARY (v3.5)
    Developer: Hasan (hasancoder54)
    Updates: Bigger Fonts, Fixed Tab Labels, Added Input, Fixed Dropdown
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

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

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 480
    local WindowHeight = cfg.Height or 380
    local MainFontSize = cfg.FontSize or 16 -- Yazı boyutu ayarı

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [OPEN BUTTON]
    local OpenButton = Instance.new("Frame")
    OpenButton.Parent = ScreenGui
    OpenButton.BackgroundColor3 = Theme.Main
    OpenButton.Position = UDim2.new(0, 10, 0, 25) -- Çok yukarda (Logo altı)
    OpenButton.Size = UDim2.new(0, 80, 0, 35)
    OpenButton.Visible = false
    Instance.new("UICorner", OpenButton).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", OpenButton).Color = Theme.Accent

    local OpenBtn = Instance.new("TextButton")
    OpenBtn.Parent = OpenButton
    OpenBtn.Size = UDim2.new(1, 0, 1, 0)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Text = "OPEN"
    OpenBtn.TextColor3 = Theme.Text
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Theme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 50)

    -- Drag
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Text = "  " .. WindowName
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Theme.Accent
    Title.TextSize = 18
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton")
    Close.Parent = TopBar
    Close.Position = UDim2.new(1, -35, 0, 7)
    Close.Size = UDim2.new(0, 26, 0, 26)
    Close.BackgroundColor3 = Theme.Error
    Close.Text = "X"
    Close.TextColor3 = Theme.Text
    Instance.new("UICorner", Close)

    Close.MouseButton1Click:Connect(function() Main.Visible = false; OpenButton.Visible = true end)
    OpenBtn.MouseButton1Click:Connect(function() OpenButton.Visible = false; Main.Visible = true end)

    -- [TAB BAR]
    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Parent = Main
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Parent = Main
    ContainerHolder.Position = UDim2.new(0, 10, 0, 95)
    ContainerHolder.Size = UDim2.new(1, -20, 1, -105)
    ContainerHolder.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(tabName)
        if not tabName or tabName == "" then tabName = "Tab" end

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabBar
        TabBtn.BackgroundColor3 = Theme.Element
        TabBtn.Text = tabName -- BURADA İSİM YAZIYOR ARTIK
        TabBtn.TextColor3 = Theme.SecondaryText
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 15
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local tSize = TextService:GetTextSize(tabName, 15, Enum.Font.GothamBold, Vector2.new(1000, 40))
        TabBtn.Size = UDim2.new(0, tSize.X + 30, 0, 35)

        local Container = Instance.new("ScrollingFrame")
        Container.Parent = ContainerHolder
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 4
        Container.ScrollBarImageColor3 = Theme.Accent
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Container
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)

        if FirstTab then TabBtn.TextColor3 = Theme.Accent end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Theme.SecondaryText end end
            Container.Visible = true
            TabBtn.TextColor3 = Theme.Accent
        end)

        FirstTab = false
        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Container
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

        -- TOGGLE
        function Elements:CreateToggle(text, callback)
            local state = false
            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Container
            Toggle.BackgroundColor3 = Theme.Element
            Toggle.Size = UDim2.new(0.96, 0, 0, 45)
            Toggle.Text = "  " .. text
            Toggle.TextColor3 = Theme.Text
            Toggle.Font = Enum.Font.GothamSemibold
            Toggle.TextSize = MainFontSize
            Toggle.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Toggle)

            local Bg = Instance.new("Frame")
            Bg.Parent = Toggle
            Bg.Position = UDim2.new(1, -55, 0.5, -12)
            Bg.Size = UDim2.new(0, 45, 0, 24)
            Bg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 12)

            local Circle = Instance.new("Frame")
            Circle.Parent = Bg
            Circle.Position = UDim2.new(0, 4, 0.5, -9)
            Circle.Size = UDim2.new(0, 18, 0, 18)
            Circle.BackgroundColor3 = Theme.Text
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = state and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)}):Play()
                TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Success or Color3.fromRGB(50, 50, 60)}):Play()
            end)
        end

        -- [NEW] INPUT
        function Elements:CreateInput(text, placeholder, callback)
            local InputFrame = Instance.new("Frame")
            InputFrame.Parent = Container
            InputFrame.BackgroundColor3 = Theme.Element
            InputFrame.Size = UDim2.new(0.96, 0, 0, 50)
            Instance.new("UICorner", InputFrame)

            local Title = Instance.new("TextLabel")
            Title.Parent = InputFrame
            Title.Size = UDim2.new(1, 0, 0, 20)
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.BackgroundTransparency = 1
            Title.Text = text
            Title.TextColor3 = Theme.SecondaryText
            Title.Font = Enum.Font.Gotham
            Title.TextSize = 12
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox")
            Box.Parent = InputFrame
            Box.Size = UDim2.new(1, -20, 0, 25)
            Box.Position = UDim2.new(0, 10, 0, 22)
            Box.BackgroundColor3 = Theme.Main
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Theme.Text
            Box.Font = Enum.Font.Gotham
            Box.TextSize = MainFontSize
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)
            
            Box.FocusLost:Connect(function(enter)
                if enter then callback(Box.Text) end
            end)
        end

        -- [NEW] DROPDOWN
        function Elements:CreateDropdown(text, list, callback)
            local open = false
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Container
            DropFrame.BackgroundColor3 = Theme.Element
            DropFrame.Size = UDim2.new(0.96, 0, 0, 45)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame)

            local Btn = Instance.new("TextButton")
            Btn.Parent = DropFrame
            Btn.Size = UDim2.new(1, 0, 0, 45)
            Btn.BackgroundTransparency = 1
            Btn.Text = "  " .. text .. " (Select...)"
            Btn.TextColor3 = Theme.Text
            Btn.Font = Enum.Font.GothamSemibold
            Btn.TextSize = MainFontSize
            Btn.TextXAlignment = Enum.TextXAlignment.Left

            local OptHolder = Instance.new("Frame")
            OptHolder.Parent = DropFrame
            OptHolder.Position = UDim2.new(0, 0, 0, 45)
            OptHolder.Size = UDim2.new(1, 0, 0, #list * 35)
            OptHolder.BackgroundTransparency = 1

            for i, v in pairs(list) do
                local O = Instance.new("TextButton")
                O.Parent = OptHolder
                O.Size = UDim2.new(1, -20, 0, 30)
                O.Position = UDim2.new(0, 10, 0, (i-1)*35)
                O.BackgroundColor3 = Theme.Main
                O.Text = tostring(v)
                O.TextColor3 = Theme.SecondaryText
                O.Font = Enum.Font.Gotham
                O.TextSize = MainFontSize
                Instance.new("UICorner", O)
                
                O.MouseButton1Click:Connect(function()
                    callback(v)
                    Btn.Text = "  " .. text .. ": " .. tostring(v)
                    open = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.96, 0, 0, 45)}):Play()
                end)
            end

            Btn.MouseButton1Click:Connect(function()
                open = not open
                TweenService:Create(DropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = open and UDim2.new(0.96, 0, 0, 45 + (#list * 35) + 5) or UDim2.new(0.96, 0, 0, 45)}):Play()
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(text, min, max, def, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Container
            SliderFrame.BackgroundColor3 = Theme.Element
            SliderFrame.Size = UDim2.new(0.96, 0, 0, 55)
            Instance.new("UICorner", SliderFrame)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.Text = "  " .. text .. ": " .. def
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.TextColor3 = Theme.Text
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = MainFontSize

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.Position = UDim2.new(0, 15, 1, -18)
            Bar.Size = UDim2.new(1, -30, 0, 6)
            Bar.BackgroundColor3 = Theme.Main
            Instance.new("UICorner", Bar)

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", Fill)

            local function move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max-min)*pos)
                Label.Text = "  " .. text .. ": " .. val
                callback(val)
            end

            local sliding = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; move(input) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then move(input) end
            end)
            UserInputService.InputEnded:Connect(function() sliding = false end)
        end

        return Elements
    end
    return Tabs
end

return Library
