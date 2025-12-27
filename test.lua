local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- Renk Paleti (Dark Blue Theme)
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
    Notif.Name = "Notification"
    Notif.Parent = NotifyGui
    Notif.Size = UDim2.new(0, 240, 0, 65)
    Notif.Position = UDim2.new(1, 20, 1, -100)
    Notif.BackgroundColor3 = Theme.Main
    local Corner = Instance.new("UICorner", Notif)
    Corner.CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Notif)
    Stroke.Color = Theme.Accent
    Stroke.Thickness = 1.5
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = Notif
    TitleLabel.Size = UDim2.new(1, 0, 0, 25)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = " " .. title
    TitleLabel.TextColor3 = Theme.Accent
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Parent = Notif
    ContentLabel.Position = UDim2.new(0, 0, 0, 25)
    ContentLabel.Size = UDim2.new(1, -10, 1, -25)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = " " .. text
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
    local Callback = cfg.Callback
    local KeyGui = Instance.new("ScreenGui", CoreGui)
    KeyGui.Name = "TR_VOID_KEYSYS"
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Parent = KeyGui
    KeyFrame.Size = UDim2.new(0, 350, 0, 220)
    KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
    KeyFrame.BackgroundColor3 = Theme.Main
    Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 12)
    local Stroke = Instance.new("UIStroke", KeyFrame)
    Stroke.Color = Color3.fromRGB(45, 45, 50)
    local Title = Instance.new("TextLabel")
    Title.Parent = KeyFrame
    Title.Size = UDim2.new(1, 0, 0, 60)
    Title.BackgroundTransparency = 1
    Title.Text = "TR-VOID | KEY SYSTEM"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    local KeyInput = Instance.new("TextBox")
    KeyInput.Parent = KeyFrame
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
    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Parent = KeyFrame
    VerifyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    VerifyBtn.Position = UDim2.new(0.075, 0, 0.7, 0)
    VerifyBtn.BackgroundColor3 = Theme.Accent
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.TextColor3 = Theme.Text
    VerifyBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", VerifyBtn)
    local GetBtn = Instance.new("TextButton")
    GetBtn.Parent = KeyFrame
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
            local tween = TweenService:Create(KeyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -175, 1, 50)})
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

-- [3. ANA PENCERE]
function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 480
    local WindowHeight = cfg.Height or 380
    local MainFontSize = cfg.FontSize or 16
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TR_VOID_UI"
    local OpenFrame = Instance.new("Frame", ScreenGui)
    OpenFrame.Size = UDim2.new(0, 80, 0, 35)
    OpenFrame.Position = UDim2.new(0, 10, 0, 30)
    OpenFrame.BackgroundColor3 = Theme.Main
    OpenFrame.Visible = false
    Instance.new("UICorner", OpenFrame)
    Instance.new("UIStroke", OpenFrame).Color = Theme.Accent
    local OpenBtn = Instance.new("TextButton", OpenFrame)
    OpenBtn.Size = UDim2.new(1, 0, 1, 0)
    OpenBtn.BackgroundTransparency = 1
    OpenBtn.Text = "OPEN"
    OpenBtn.TextColor3 = Theme.Text
    OpenBtn.Font = Enum.Font.GothamBold
    OpenBtn.TextSize = 14
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Theme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(45, 45, 50)
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
    TitleLabel.Text = " " .. WindowName
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
    CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false OpenFrame.Visible = true end)
    OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true OpenFrame.Visible = false end)
    local TabBar = Instance.new("ScrollingFrame", Main)
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 2
    TabBar.ScrollBarImageColor3 = Theme.Accent
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
    ContainerHolder.Size = UDim2.new(1, -20, 1, -105)
    ContainerHolder.BackgroundTransparency = 1
    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(name)
        local TabBtn = Instance.new("TextButton", TabBar)
        TabBtn.Name = name .. "_Tab"
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
            for _, v in pairs(ContainerHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Theme.SecondaryText end end
            Container.Visible = true
            TabBtn.TextColor3 = Theme.Accent
        end)
        FirstTab = false
        local Elements = {}

        function Elements:CreateButton(text, callback)
            local Button = Instance.new("TextButton", Container)
            Button.BackgroundColor3 = Theme.Element
            Button.Size = UDim2.new(0.96, 0, 0, 45)
            Button.Text = " " .. text
            Button.TextColor3 = Theme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = MainFontSize
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            Button.MouseButton1Click:Connect(callback)
            
            local Utils = {}
            function Utils:SetText(newText) Button.Text = " " .. newText end
            return Utils
        end

        function Elements:CreateToggle(text, callback)
            local state = false
            local ToggleBtn = Instance.new("TextButton", Container)
            ToggleBtn.BackgroundColor3 = Theme.Element
            ToggleBtn.Size = UDim2.new(0.96, 0, 0, 45)
            ToggleBtn.Text = " " .. text
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
            
            local Utils = {}
            function Utils:SetText(newText) ToggleBtn.Text = " " .. newText end
            return Utils
        end

        function Elements:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame", Container)
            SliderFrame.BackgroundColor3 = Theme.Element
            SliderFrame.Size = UDim2.new(0.96, 0, 0, 55)
            Instance.new("UICorner", SliderFrame)
            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Text = " " .. text .. ": " .. default
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
                Label.Text = " " .. text .. ": " .. value
                callback(value)
            end
            local sliding = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; UpdateSlider(input) end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
            end)
            UserInputService.InputEnded:Connect(function() sliding = false end)
            
            local Utils = {}
            function Utils:SetText(newText) text = newText; Label.Text = " " .. text .. ": " .. math.floor(min + (max-min)*(Fill.Size.X.Scale)) end
            return Utils
        end

        function Elements:CreateDropdown(text, list, options, callback)
            local open = false
            local selected = {}
            local multi = (options and options.Multi) or false
            local maxSelections = (options and options.Max) or #list
            
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

            local Arrow = Instance.new("TextLabel", MainBtn)
            Arrow.Size = UDim2.new(0, 45, 1, 0)
            Arrow.Position = UDim2.new(1, -45, 0, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.Text = "▼"
            Arrow.TextColor3 = Theme.SecondaryText
            Arrow.TextSize = 12

            local Holder = Instance.new("Frame", DropFrame)
            Holder.Position = UDim2.new(0, 0, 0, 45)
            Holder.Size = UDim2.new(1, 0, 0, #list * 35)
            Holder.BackgroundTransparency = 1

            local function updateHeader()
                if multi then
                    MainBtn.Text = "  " .. text .. " (" .. #selected .. "/" .. maxSelections .. ")"
                end
            end

            for i, v in pairs(list) do
                local Option = Instance.new("TextButton", Holder)
                Option.Size = UDim2.new(1, -20, 0, 30)
                Option.Position = UDim2.new(0, 10, 0, (i-1)*35)
                Option.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Option.Text = tostring(v)
                Option.TextColor3 = Theme.SecondaryText
                Option.Font = Enum.Font.Gotham
                Option.TextSize = MainFontSize
                Instance.new("UICorner", Option)

                Option.MouseButton1Click:Connect(function()
                    if multi then
                        local found = table.find(selected, v)
                        if found then
                            table.remove(selected, found)
                            Option.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                            callback(selected)
                        elseif #selected < maxSelections then
                            table.insert(selected, v)
                            Option.BackgroundColor3 = Color3.fromRGB(80, 80, 85) -- Gri renk
                            callback(selected)
                        end
                        updateHeader()
                    else
                        callback(v)
                        MainBtn.Text = "  " .. text .. ": " .. tostring(v)
                        open = false
                        TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.96, 0, 0, 45)}):Play()
                        Arrow.Text = "▼"
                    end
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                open = not open
                local targetH = open and (45 + (#list * 35) + 10) or 45
                Arrow.Text = open and "▲" or "▼"
                TweenService:Create(DropFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0.96, 0, 0, targetH)}):Play()
            end)
            
            local Utils = {}
            function Utils:SetText(newText) text = newText; updateHeader() end
            return Utils
        end

        function Elements:CreateInput(text, placeholder, callback)
            local InpFrame = Instance.new("Frame", Container)
            InpFrame.BackgroundColor3 = Theme.Element
            InpFrame.Size = UDim2.new(0.96, 0, 0, 60)
            Instance.new("UICorner", InpFrame)

            local InpTitle = Instance.new("TextLabel", InpFrame)
            InpTitle.Size = UDim2.new(1, 0, 0, 25)
            InpTitle.Position = UDim2.new(0, 12, 0, 5)
            InpTitle.BackgroundTransparency = 1
            InpTitle.Text = text
            InpTitle.TextColor3 = Theme.SecondaryText
            InpTitle.Font = Enum.Font.Gotham
            InpTitle.TextSize = 13
            InpTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox", InpFrame)
            Box.Size = UDim2.new(1, -24, 0, 25)
            Box.Position = UDim2.new(0, 12, 0, 30)
            Box.BackgroundColor3 = Theme.Main
            Box.PlaceholderText = placeholder
            Box.Text = ""
            Box.TextColor3 = Theme.Text
            Box.Font = Enum.Font.Gotham
            Box.TextSize = MainFontSize
            Instance.new("UICorner", Box)
            
            local Stroke = Instance.new("UIStroke", Box)
            Stroke.Color = Color3.fromRGB(50, 50, 55)

            Box.Focused:Connect(function() TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Theme.Accent}):Play() end)
            Box.FocusLost:Connect(function(enter)
                TweenService:Create(Stroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(50, 50, 55)}):Play()
                callback(Box.Text)
            end)
            
            local Utils = {}
            function Utils:SetText(newText) InpTitle.Text = newText end
            return Utils
        end

        return Elements
    end
    return Tabs
end

return Library
