--[[
    TR-VOID UI LIBRARY (v3.4 FINAL)
    Developer: Hasan (hasancoder54)
    Features: Auto-Scrolling, Modern Colors, Fixed UI Size, Rayfield Style
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- [MODERN RENK PALETİ]
Library.Themes = {
    ["Void"] = {
        Main = Color3.fromRGB(13, 13, 15),
        TopBar = Color3.fromRGB(18, 18, 22),
        Accent = Color3.fromRGB(0, 150, 255), -- Parlak Mavi
        Element = Color3.fromRGB(24, 24, 28),
        Text = Color3.fromRGB(255, 255, 255),
        SecondaryText = Color3.fromRGB(140, 140, 150),
        Success = Color3.fromRGB(0, 230, 118), -- Canlı Yeşil
        Error = Color3.fromRGB(255, 61, 0)     -- Canlı Kırmızı
    }
}

local CurrentTheme = Library.Themes["Void"]

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 460
    local WindowHeight = cfg.Height or 360
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- [OPEN BUTTON]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = CurrentTheme.Main
    OpenButtonFrame.Position = UDim2.new(0, 10, 0, 30)
    OpenButtonFrame.Size = UDim2.new(0, 75, 0, 32)
    OpenButtonFrame.Visible = false
    Instance.new("UICorner", OpenButtonFrame).CornerRadius = UDim.new(0, 8)
    local UIStrokeOpen = Instance.new("UIStroke", OpenButtonFrame)
    UIStrokeOpen.Color = CurrentTheme.Accent
    UIStrokeOpen.Thickness = 1.2

    local OpenText = Instance.new("TextButton")
    OpenText.Parent = OpenButtonFrame
    OpenText.BackgroundTransparency = 1
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Font = Enum.Font.GothamBold
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = CurrentTheme.Text
    OpenText.TextSize = 12

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    
    local UIStrokeMain = Instance.new("UIStroke", Main)
    UIStrokeMain.Color = Color3.fromRGB(40, 40, 45)
    UIStrokeMain.Thickness = 1.5

    -- Dragging Logic
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
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Text = "  " .. WindowName
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = CurrentTheme.Accent
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = CurrentTheme.Error
    CloseButton.Position = UDim2.new(1, -32, 0, 6)
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Parent = Main
    TabBar.Position = UDim2.new(0, 10, 0, 45)
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 8)

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Parent = Main
    ContainerHolder.Position = UDim2.new(0, 10, 0, 85)
    ContainerHolder.Size = UDim2.new(1, -20, 1, -95)
    ContainerHolder.BackgroundTransparency = 1

    CloseButton.MouseButton1Click:Connect(function() Main.Visible = false; OpenButtonFrame.Visible = true end)
    OpenText.MouseButton1Click:Connect(function() OpenButtonFrame.Visible = false; Main.Visible = true end)

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(tabName)
        if not tabName or tabName == "" then error("TR-VOID: Tab name is required!") return end

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabBar
        TabButton.BackgroundColor3 = CurrentTheme.Element
        TabButton.Text = tabName
        TabButton.TextColor3 = CurrentTheme.SecondaryText
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 12
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
        
        local tSize = TextService:GetTextSize(tabName, 12, Enum.Font.GothamBold, Vector2.new(1000, 35))
        TabButton.Size = UDim2.new(0, tSize.X + 25, 1, -5)

        -- [CONTAINER WITH SCROLLBAR]
        local Container = Instance.new("ScrollingFrame")
        Container.Parent = ContainerHolder
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 3 -- Estetik ince çubuk
        Container.ScrollBarImageColor3 = CurrentTheme.Accent
        Container.CanvasSize = UDim2.new(0, 0, 0, 0) -- Başlangıç
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Container
        ContentLayout.Padding = UDim.new(0, 8)
        ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- Otomatik Canvas Boyutlandırma (Menü taşmasın diye)
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 15)
        end)

        if FirstTab then TabButton.TextColor3 = CurrentTheme.Accent end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = CurrentTheme.SecondaryText end end
            Container.Visible = true
            TabButton.TextColor3 = CurrentTheme.Accent
        end)

        FirstTab = false
        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Container
            Button.BackgroundColor3 = CurrentTheme.Element
            Button.Size = UDim2.new(0.98, 0, 0, 40)
            Button.Text = "  " .. name
            Button.TextColor3 = CurrentTheme.Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            
            Button.MouseButton1Click:Connect(callback)
            -- Click Effect
            Button.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,50)}):Play()
                end
            end)
            Button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Element}):Play()
                end
            end)
        end

        -- TOGGLE
        function Elements:CreateToggle(name, callback)
            local state = false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = Container
            ToggleFrame.BackgroundColor3 = CurrentTheme.Element
            ToggleFrame.Size = UDim2.new(0.98, 0, 0, 42)
            ToggleFrame.Text = "  " .. name
            ToggleFrame.TextColor3 = CurrentTheme.Text
            ToggleFrame.Font = Enum.Font.GothamSemibold
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

            local Bg = Instance.new("Frame")
            Bg.Parent = ToggleFrame
            Bg.Position = UDim2.new(1, -50, 0.5, -11)
            Bg.Size = UDim2.new(0, 38, 0, 22)
            Bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 11)

            local Circle = Instance.new("Frame")
            Circle.Parent = Bg
            Circle.Position = UDim2.new(0, 3, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)}):Play()
                TweenService:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = state and CurrentTheme.Success or Color3.fromRGB(50, 50, 55)}):Play()
            end)
        end

        -- DROPDOWN
        function Elements:CreateDropdown(name, options, callback)
            local expanded = false
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Container
            DropdownFrame.BackgroundColor3 = CurrentTheme.Element
            DropdownFrame.Size = UDim2.new(0.98, 0, 0, 40)
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)

            local MainBtn = Instance.new("TextButton")
            MainBtn.Parent = DropdownFrame
            MainBtn.Size = UDim2.new(1, 0, 0, 40)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. name .. " (Select...)"
            MainBtn.TextColor3 = CurrentTheme.Text
            MainBtn.Font = Enum.Font.GothamSemibold
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Parent = DropdownFrame
            OptionContainer.Position = UDim2.new(0, 0, 0, 40)
            OptionContainer.Size = UDim2.new(1, 0, 0, #options * 32)
            OptionContainer.BackgroundTransparency = 1

            for i, opt in pairs(options) do
                local OBtn = Instance.new("TextButton")
                OBtn.Parent = OptionContainer
                OBtn.Size = UDim2.new(1, -15, 0, 28)
                OBtn.Position = UDim2.new(0, 7, 0, (i-1)*32)
                OBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
                OBtn.Text = opt
                OBtn.TextColor3 = CurrentTheme.SecondaryText
                OBtn.Font = Enum.Font.Gotham
                Instance.new("UICorner", OBtn).CornerRadius = UDim.new(0, 6)

                OBtn.MouseButton1Click:Connect(function()
                    callback(opt)
                    MainBtn.Text = "  " .. name .. ": " .. opt
                    expanded = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.98, 0, 0, 40)}):Play()
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                TweenService:Create(DropdownFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = expanded and UDim2.new(0.98, 0, 0, 40 + (#options * 32) + 5) or UDim2.new(0.98, 0, 0, 40)}):Play()
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(name, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Container
            SliderFrame.BackgroundColor3 = CurrentTheme.Element
            SliderFrame.Size = UDim2.new(0.98, 0, 0, 50)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.Text = "  " .. name
            Label.Size = UDim2.new(0.5, 0, 0, 30)
            Label.TextColor3 = CurrentTheme.Text
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.GothamSemibold

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            ValueLabel.Size = UDim2.new(0.5, -15, 0, 30)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = CurrentTheme.Accent
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamBold

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.Position = UDim2.new(0, 15, 1, -15)
            Bar.Size = UDim2.new(1, -30, 0, 5)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
            Instance.new("UICorner", Bar)
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Accent
            Instance.new("UICorner", Fill)

            local function move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max-min)*pos)
                ValueLabel.Text = tostring(val)
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
