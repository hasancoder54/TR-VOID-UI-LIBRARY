--[[
    TR-VOID UI LIBRARY (FINAL VERSION)
    Developer: Hasan (hasancoder54)
    Version: 3.0
    Repo: https://github.com/hasancoder54/TR-VOID-UI-LIBRARY
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

-- [TEMA AYARLARI]
Library.Themes = {
    ["Void"] = {
        Main = Color3.fromRGB(15, 15, 15),
        TopBar = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 120, 255),
        Element = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(150, 150, 150)
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
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [OPEN BUTTON - ROBLOX LOGO ALTI]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = CurrentTheme.Main
    OpenButtonFrame.Position = UDim2.new(0, 10, 0, 45) -- Roblox logosunun hemen altı
    OpenButtonFrame.Size = UDim2.new(0, 60, 0, 30)
    OpenButtonFrame.Visible = false
    Instance.new("UICorner", OpenButtonFrame).CornerRadius = UDim.new(0, 8)

    local OpenText = Instance.new("TextButton")
    OpenText.Parent = OpenButtonFrame
    OpenText.BackgroundTransparency = 1
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Font = Enum.Font.GothamBold
    OpenText.Text = "AÇ"
    OpenText.TextColor3 = CurrentTheme.Accent
    OpenText.TextSize = 12

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Parent = Main
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    -- Sürükleme (Drag) Sistemi
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
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

    -- [SEKME BAR VE KONTEYNER]
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
        TabButton.TextColor3 = CurrentTheme.Text
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 12
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
        
        local tSize = TextService:GetTextSize(tabName, 12, Enum.Font.GothamBold, Vector2.new(1000, 30))
        TabButton.Size = UDim2.new(0, tSize.X + 20, 1, 0)
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 0, 0)

        local Container = Instance.new("ScrollingFrame")
        Container.Parent = ContainerHolder
        Container.Size = UDim2.new(1, 0, 1, 0)
        Container.BackgroundTransparency = 1
        Container.Visible = FirstTab
        Container.ScrollBarThickness = 2
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = Container
        ContentLayout.Padding = UDim.new(0, 6)
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
        end)

        TabButton.MouseButton1Click:Connect(function()
            for _, v in pairs(ContainerHolder:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            Container.Visible = true
        end)

        FirstTab = false
        local Elements = {}

        -- BUTTON
        function Elements:CreateButton(name, callback)
            local Button = Instance.new("TextButton")
            Button.Parent = Container
            Button.BackgroundColor3 = CurrentTheme.Element
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Text = "  " .. name
            Button.TextColor3 = CurrentTheme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = GlobalTextSize
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
            Button.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function Elements:CreateToggle(name, callback)
            local state = false
            local Toggle = Instance.new("TextButton")
            Toggle.Parent = Container
            Toggle.BackgroundColor3 = CurrentTheme.Element
            Toggle.Size = UDim2.new(1, -10, 0, 35)
            Toggle.Text = "  " .. name
            Toggle.TextColor3 = CurrentTheme.Text
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = GlobalTextSize
            Toggle.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)
            
            local Box = Instance.new("Frame")
            Box.Parent = Toggle
            Box.Position = UDim2.new(1, -30, 0.5, -10)
            Box.Size = UDim2.new(0, 20, 0, 20)
            Box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 5)

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                callback(state)
                TweenService:Create(Box, TweenInfo.new(0.3), {BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(60, 60, 60)}):Play()
            end)
        end

        -- SLIDER
        function Elements:CreateSlider(name, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Container
            SliderFrame.BackgroundColor3 = CurrentTheme.Element
            SliderFrame.Size = UDim2.new(1, -10, 0, 45)
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

            local Label = Instance.new("TextLabel")
            Label.Parent = SliderFrame
            Label.Text = "  " .. name .. ": " .. default
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.TextColor3 = CurrentTheme.Text
            Label.BackgroundTransparency = 1
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextSize = GlobalTextSize

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.Position = UDim2.new(0, 10, 0, 25)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            Bar.BackgroundColor3 = CurrentTheme.Main
            
            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = CurrentTheme.Accent
            Instance.new("UICorner", Fill)

            local function move(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max-min)*pos)
                Label.Text = "  " .. name .. ": " .. val
                callback(val)
            end
            Bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then move(input) end end)
        end

        -- INPUT
        function Elements:CreateInput(name, placeholder, callback)
            local InputFrame = Instance.new("Frame")
            InputFrame.Parent = Container
            InputFrame.BackgroundColor3 = CurrentTheme.Element
            InputFrame.Size = UDim2.new(1, -10, 0, 35)
            Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 8)

            local TextBox = Instance.new("TextBox")
            TextBox.Parent = InputFrame
            TextBox.Size = UDim2.new(1, -10, 1, 0)
            TextBox.Position = UDim2.new(0, 5, 0, 0)
            TextBox.BackgroundTransparency = 1
            TextBox.PlaceholderText = name .. ": " .. placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = CurrentTheme.Text
            TextBox.PlaceholderColor3 = CurrentTheme.Placeholder
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = GlobalTextSize
            TextBox.TextXAlignment = Enum.TextXAlignment.Left

            TextBox.FocusLost:Connect(function(enter) if enter then callback(TextBox.Text) end end)
        end

        -- DROPDOWN
        function Elements:CreateDropdown(name, list, callback)
            local open = false
            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = Container
            DropFrame.BackgroundColor3 = CurrentTheme.Element
            DropFrame.Size = UDim2.new(1, -10, 0, 35)
            DropFrame.ClipsDescendants = true
            Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)

            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = DropFrame
            DropBtn.Size = UDim2.new(1, 0, 0, 35)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = "  " .. name .. " (Seçiniz)"
            DropBtn.TextColor3 = CurrentTheme.Text
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.TextSize = GlobalTextSize
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left

            DropBtn.MouseButton1Click:Connect(function()
                open = not open
                TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = open and UDim2.new(1, -10, 0, 35 + (#list * 30)) or UDim2.new(1, -10, 0, 35)}):Play()
            end)

            for i, v in pairs(list) do
                local Opt = Instance.new("TextButton")
                Opt.Parent = DropFrame
                Opt.Size = UDim2.new(1, 0, 0, 30)
                Opt.Position = UDim2.new(0, 0, 0, 35 + (i-1)*30)
                Opt.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Opt.Text = tostring(v)
                Opt.TextColor3 = CurrentTheme.Text
                Opt.Font = Enum.Font.Gotham
                Opt.MouseButton1Click:Connect(function()
                    callback(v)
                    DropBtn.Text = "  " .. name .. ": " .. tostring(v)
                    open = false
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, -10, 0, 35)}):Play()
                end)
            end
        end

        return Elements
    end
    return Tabs
end

return Library

