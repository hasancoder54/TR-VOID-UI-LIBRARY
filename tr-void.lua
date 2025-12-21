--[[
    TR-VOID UI LIBRARY (RAYFIELD STYLE)
    Developer: Hasan (hasancoder54)
    Version: 3.2
    Updates: 
    - Rayfield Style Toggles (Animated Switch)
    - Smooth Tween Animations
    - Better Sliders & Dropdowns
    - Open Button Aligned (Higher)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

Library.Themes = {
    ["Void"] = {
        Main = Color3.fromRGB(15, 15, 15),
        TopBar = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 120, 255),
        Element = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(150, 150, 150),
        Success = Color3.fromRGB(46, 204, 113),
        Error = Color3.fromRGB(231, 76, 60)
    }
}

local CurrentTheme = Library.Themes["Void"]

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 450
    local WindowHeight = cfg.Height or 350
    local GlobalTextSize = cfg.TextSize or 14
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui

    -- [OPEN BUTTON]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = CurrentTheme.Main
    OpenButtonFrame.Position = UDim2.new(0, 10, 0, 30) -- Higher position
    OpenButtonFrame.Size = UDim2.new(0, 70, 0, 30)
    OpenButtonFrame.Visible = false
    Instance.new("UICorner", OpenButtonFrame).CornerRadius = UDim.new(0, 8)

    local OpenText = Instance.new("TextButton")
    OpenText.Parent = OpenButtonFrame
    OpenText.BackgroundTransparency = 1
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Font = Enum.Font.GothamBold
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = CurrentTheme.Accent
    OpenText.TextSize = 12

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    -- Drag System
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Main.Position end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Text = "  " .. WindowName
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 14
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = CurrentTheme.Error
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Parent = Main
    TabBar.Position = UDim2.new(0, 5, 0, 40)
    TabBar.Size = UDim2.new(1, -10, 0, 30)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabBar
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 5)

    local ContainerHolder = Instance.new("Frame")
    ContainerHolder.Parent = Main
    ContainerHolder.Position = UDim2.new(0, 5, 0, 75)
    ContainerHolder.Size = UDim2.new(1, -10, 1, -80)
    ContainerHolder.BackgroundTransparency = 1

    CloseButton.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenButtonFrame.Visible = true
    end)
    OpenText.MouseButton1Click:Connect(function()
        OpenButtonFrame.Visible = false
        Main.Visible = true
    end)

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabBar
        TabButton.BackgroundColor3 = CurrentTheme.Element
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(150,150,150)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 12
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
        
        local tSize = TextService:GetTextSize(tabName, 12, Enum.Font.GothamBold, Vector2.new(1000, 30))
        TabButton.Size = UDim2.new(0, tSize.X + 20, 1, 0)

        local Container = Instance.new("ScrollingFrame")
        Container.Parent = ContainerHolder
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 0
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Container
        ContentLayout.Padding = UDim.new(0, 5)
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 5)
        end)

        if FirstTab then TabButton.TextColor3 = CurrentTheme.Text end

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(150,150,150) end end
            Container.Visible = true
            TabButton.TextColor3 = CurrentTheme.Text
        end)

        FirstTab = false
        local Elements = {}

        -- [RAYFIELD STYLE TOGGLE]
        function Elements:CreateToggle(name, callback)
            local state = false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = Container
            ToggleFrame.BackgroundColor3 = CurrentTheme.Element
            ToggleFrame.Size = UDim2.new(1, -5, 0, 40)
            ToggleFrame.Text = "  " .. name
            ToggleFrame.TextColor3 = CurrentTheme.Text
            ToggleFrame.Font = Enum.Font.Gotham
            ToggleFrame.TextSize = GlobalTextSize
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Bg = Instance.new("Frame")
            Bg.Name = "Bg"
            Bg.Parent = ToggleFrame
            Bg.Position = UDim2.new(1, -45, 0.5, -10)
            Bg.Size = UDim2.new(0, 35, 0, 20)
            Bg.BackgroundColor3 = CurrentTheme.Error
            Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 10)

            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Parent = Bg
            Circle.Position = UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetColor = state and CurrentTheme.Success or CurrentTheme.Error
                
                TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
                TweenService:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = targetColor}):Play()
            end)
        end

        -- [RAYFIELD STYLE SLIDER]
        function Elements:CreateSlider(name, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Container
            SliderFrame.BackgroundColor3 = CurrentTheme.Element
            SliderFrame.Size = UDim2.new(1, -5, 0, 45)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.Text = "  " .. name
            Label.Size = UDim2.new(0.5, 0, 0, 25)
            Label.TextColor3 = CurrentTheme.Text
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham
            Label.TextSize = GlobalTextSize

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            ValueLabel.Size = UDim2.new(0.5, -10, 0, 25)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = CurrentTheme.Accent
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = GlobalTextSize

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.Position = UDim2.new(0, 10, 1, -12)
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Instance.new("UICorner", Bar)
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Accent
            Instance.new("UICorner", Fill)

            local function move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max-min)*pos)
                TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            local sliding = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true; move(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    move(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input) sliding = false end)
        end

        function Elements:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Container
            Button.BackgroundColor3 = CurrentTheme.Element
            Button.Size = UDim2.new(1, -5, 0, 35)
            Button.Text = "  " .. name
            Button.TextColor3 = CurrentTheme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = GlobalTextSize
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.Element}):Play()
                callback()
            end)
        end

        return Elements
    end
    return Tabs
end

return Library

