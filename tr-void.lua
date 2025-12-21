--[[
    TR-VOID UI LIBRARY (v3.3)
    Developer: Hasan (hasancoder54)
    Rayfield Inspired - English UI
    Updates: Mandatory Tab Names, Dropdown Added, Animated Switches
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
        SecondaryText = Color3.fromRGB(160, 160, 160),
        Success = Color3.fromRGB(46, 204, 113),
        Error = Color3.fromRGB(231, 76, 60)
    }
}

local CurrentTheme = Library.Themes["Void"]

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 450
    local WindowHeight = cfg.Height or 350
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui

    -- [OPEN BUTTON]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = CurrentTheme.Main
    OpenButtonFrame.Position = UDim2.new(0, 10, 0, 30)
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

    -- Drag System
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
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

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

    CloseButton.MouseButton1Click:Connect(function() Main.Visible = false; OpenButtonFrame.Visible = true end)
    OpenText.MouseButton1Click:Connect(function() OpenButtonFrame.Visible = false; Main.Visible = true end)

    local Tabs = {}
    local FirstTab = true

    function Tabs:CreateTab(tabName)
        -- MANDATORY NAME CHECK
        if not tabName or tabName == "" then 
            error("TR-VOID: Tab name is required!") 
            return 
        end

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabBar
        TabButton.BackgroundColor3 = CurrentTheme.Element
        TabButton.Text = tabName
        TabButton.TextColor3 = CurrentTheme.SecondaryText
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
            for _, v in pairs(TabBar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = CurrentTheme.SecondaryText end end
            Container.Visible = true
            TabButton.TextColor3 = CurrentTheme.Text
        end)

        FirstTab = false
        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Container
            Button.BackgroundColor3 = CurrentTheme.Element
            Button.Size = UDim2.new(1, -5, 0, 38)
            Button.Text = "  " .. name
            Button.TextColor3 = CurrentTheme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 13
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            Button.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE (Rayfield Style)
        function Elements:CreateToggle(name, callback)
            local state = false
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = Container
            ToggleFrame.BackgroundColor3 = CurrentTheme.Element
            ToggleFrame.Size = UDim2.new(1, -5, 0, 40)
            ToggleFrame.Text = "  " .. name
            ToggleFrame.TextColor3 = CurrentTheme.Text
            ToggleFrame.Font = Enum.Font.Gotham
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local Bg = Instance.new("Frame")
            Bg.Parent = ToggleFrame
            Bg.Position = UDim2.new(1, -45, 0.5, -10)
            Bg.Size = UDim2.new(0, 35, 0, 20)
            Bg.BackgroundColor3 = CurrentTheme.Error
            Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 10)

            local Circle = Instance.new("Frame")
            Circle.Parent = Bg
            Circle.Position = UDim2.new(0, 2, 0.5, -8)
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = state and CurrentTheme.Success or CurrentTheme.Error}):Play()
            end)
        end

        -- DROPDOWN (NEW)
        function Elements:CreateDropdown(name, options, callback)
            local expanded = false
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Container
            DropdownFrame.BackgroundColor3 = CurrentTheme.Element
            DropdownFrame.Size = UDim2.new(1, -5, 0, 40)
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

            local MainBtn = Instance.new("TextButton")
            MainBtn.Parent = DropdownFrame
            MainBtn.Size = UDim2.new(1, 0, 0, 40)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = "  " .. name .. " (Select...)"
            MainBtn.TextColor3 = CurrentTheme.Text
            MainBtn.Font = Enum.Font.Gotham
            MainBtn.TextXAlignment = Enum.TextXAlignment.Left

            local OptionContainer = Instance.new("Frame")
            OptionContainer.Parent = DropdownFrame
            OptionContainer.Position = UDim2.new(0, 0, 0, 40)
            OptionContainer.Size = UDim2.new(1, 0, 0, #options * 30)
            OptionContainer.BackgroundTransparency = 1

            for i, opt in pairs(options) do
                local OBtn = Instance.new("TextButton")
                OBtn.Parent = OptionContainer
                OBtn.Size = UDim2.new(1, -10, 0, 25)
                OBtn.Position = UDim2.new(0, 5, 0, (i-1)*30)
                OBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                OBtn.Text = opt
                OBtn.TextColor3 = CurrentTheme.SecondaryText
                OBtn.Font = Enum.Font.Gotham
                Instance.new("UICorner", OBtn).CornerRadius = UDim.new(0, 4)

                OBtn.MouseButton1Click:Connect(function()
                    callback(opt)
                    MainBtn.Text = "  " .. name .. ": " .. opt
                    expanded = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -5, 0, 40)}):Play()
                end)
            end

            MainBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = expanded and UDim2.new(1, -5, 0, 40 + (#options * 30) + 5) or UDim2.new(1, -5, 0, 40)}):Play()
            end)
        end

        -- SLIDER
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

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
            ValueLabel.Size = UDim2.new(0.5, -10, 0, 25)
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = CurrentTheme.Accent
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamBold

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.Position = UDim2.new(0, 10, 1, -12)
            Bar.Size = UDim2.new(1, -20, 0, 4)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            
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
