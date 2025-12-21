
--[[
    TR-VOID UI LIBRARY (FULL VERSION)
    Developer: Hasan (hasancoder54)
    Version: 2.6
    Updates: 
    - Full Theme System (Anlık değişim)
    - Draggable Main Frame
    - Textbox Element Added
    - UI Smooth Animations
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- [TEMALAR]
Library.Themes = {
    ["Void"] = {
        Main = Color3.fromRGB(15, 15, 15),
        TopBar = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 120, 255),
        Element = Color3.fromRGB(30, 30, 30),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(150, 150, 150)
    },
    ["Dark"] = {
        Main = Color3.fromRGB(25, 25, 25),
        TopBar = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(200, 50, 50),
        Element = Color3.fromRGB(45, 45, 45),
        Text = Color3.fromRGB(230, 230, 230),
        Placeholder = Color3.fromRGB(120, 120, 120)
    },
    ["Blue"] = {
        Main = Color3.fromRGB(10, 20, 30),
        TopBar = Color3.fromRGB(15, 25, 40),
        Accent = Color3.fromRGB(0, 255, 255),
        Element = Color3.fromRGB(25, 40, 60),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(100, 150, 200)
    }
}

local CurrentTheme = Library.Themes["Void"]

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 400
    local WindowHeight = cfg.Height or 300
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [SÜRÜKLEME FONKSİYONU]
    local function MakeDraggable(topbarobject, object)
        local dragging, dragInput, dragStart, startPos
        topbarobject.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = object.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Parent = Main
    MakeDraggable(TopBar, Main)

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
    CloseButton.BackgroundTransparency = 0.7
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

    -- [CONTAINER]
    local Container = Instance.new("ScrollingFrame")
    Container.Parent = Main
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 5, 0, 40)
    Container.Size = UDim2.new(1, -10, 1, -45)
    Container.ScrollBarThickness = 2
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0, 5)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- Açılış Animasyonu
    Main:TweenSize(UDim2.new(0, WindowWidth, 0, WindowHeight), "Out", "Quart", 0.6, true)

    CloseButton.MouseButton1Click:Connect(function()
        Main:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true, function()
            ScreenGui:Destroy()
        end)
    end)

    local Elements = {}

    -- [ELEMENT: BUTTON]
    function Elements:CreateButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = Container
        Button.BackgroundColor3 = CurrentTheme.Element
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.Font = Enum.Font.Gotham
        Button.Text = "  " .. name
        Button.TextColor3 = CurrentTheme.Text
        Button.TextSize = 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
        
        Button.MouseButton1Click:Connect(function()
            callback()
            local originalColor = CurrentTheme.Element
            Button.BackgroundColor3 = CurrentTheme.Accent
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = originalColor}):Play()
        end)
    end

    -- [ELEMENT: TOGGLE]
    function Elements:CreateToggle(name, callback)
        local state = false
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Parent = Container
        ToggleBtn.BackgroundColor3 = CurrentTheme.Element
        ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
        ToggleBtn.Text = ""
        Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

        local TTitle = Instance.new("TextLabel")
        TTitle.Parent = ToggleBtn
        TTitle.Text = "  " .. name
        TTitle.Font = Enum.Font.Gotham
        TTitle.TextColor3 = CurrentTheme.Text
        TTitle.TextSize = 14
        TTitle.Size = UDim2.new(1, 0, 1, 0)
        TTitle.BackgroundTransparency = 1
        TTitle.TextXAlignment = Enum.TextXAlignment.Left

        local Switch = Instance.new("Frame")
        Switch.Parent = ToggleBtn
        Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Switch.Position = UDim2.new(1, -45, 0.5, -10)
        Switch.Size = UDim2.new(0, 35, 0, 20)
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

        local Dot = Instance.new("Frame")
        Dot.Parent = Switch
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Dot.Size = UDim2.new(0, 14, 0, 14)
        Dot.Position = UDim2.new(0, 3, 0.5, -7)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            local targetColor = state and CurrentTheme.Accent or Color3.fromRGB(255, 255, 255)
            TweenService:Create(Dot, TweenInfo.new(0.3), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        end)
    end

    -- [ELEMENT: SLIDER]
    function Elements:CreateSlider(name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = Container
        SliderFrame.BackgroundColor3 = CurrentTheme.Element
        SliderFrame.Size = UDim2.new(1, -10, 0, 45)
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

        local STitle = Instance.new("TextLabel")
        STitle.Parent = SliderFrame
        STitle.Text = "  " .. name
        STitle.Size = UDim2.new(1, 0, 0, 20)
        STitle.TextColor3 = CurrentTheme.Text
        STitle.BackgroundTransparency = 1
        STitle.TextXAlignment = Enum.TextXAlignment.Left

        local Bar = Instance.new("Frame")
        Bar.Parent = SliderFrame
        Bar.BackgroundColor3 = CurrentTheme.Main
        Bar.Position = UDim2.new(0, 10, 0, 25)
        Bar.Size = UDim2.new(1, -60, 0, 6)
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Parent = Bar
        Fill.BackgroundColor3 = CurrentTheme.Accent
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local ValLabel = Instance.new("TextLabel")
        ValLabel.Parent = SliderFrame
        ValLabel.Text = tostring(default)
        ValLabel.Position = UDim2.new(1, -45, 0, 20)
        ValLabel.Size = UDim2.new(0, 40, 0, 20)
        ValLabel.TextColor3 = CurrentTheme.Text
        ValLabel.BackgroundTransparency = 1

        local function move(input)
            local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            ValLabel.Text = tostring(val)
            callback(val)
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                move(input)
                local connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        move(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end

    -- [ELEMENT: TEXTBOX]
    function Elements:CreateTextbox(name, placeholder, callback)
        local BoxFrame = Instance.new("Frame")
        BoxFrame.Parent = Container
        BoxFrame.BackgroundColor3 = CurrentTheme.Element
        BoxFrame.Size = UDim2.new(1, -10, 0, 50)
        Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Parent = BoxFrame
        Label.Text = "  " .. name
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = CurrentTheme.Text
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local Input = Instance.new("TextBox")
        Input.Parent = BoxFrame
        Input.Size = UDim2.new(1, -20, 0, 22)
        Input.Position = UDim2.new(0, 10, 0, 22)
        Input.BackgroundColor3 = CurrentTheme.Main
        Input.PlaceholderText = placeholder
        Input.Text = ""
        Input.TextColor3 = CurrentTheme.Text
        Input.PlaceholderColor3 = CurrentTheme.Placeholder
        Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)

        Input.FocusLost:Connect(function(enter)
            if enter then callback(Input.Text) end
        end)
    end

    -- [ELEMENT: DROPDOWN]
    function Elements:CreateDropdown(name, list, callback)
        local DropFrame = Instance.new("Frame")
        DropFrame.Parent = Container
        DropFrame.BackgroundColor3 = CurrentTheme.Element
        DropFrame.Size = UDim2.new(1, -10, 0, 35)
        DropFrame.ClipsDescendants = true
        Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

        local DropBtn = Instance.new("TextButton")
        DropBtn.Parent = DropFrame
        DropBtn.Size = UDim2.new(1, 0, 0, 35)
        DropBtn.Text = "  " .. name .. " (Seçiniz)"
        DropBtn.BackgroundTransparency = 1
        DropBtn.TextColor3 = CurrentTheme.Text
        DropBtn.TextXAlignment = Enum.TextXAlignment.Left

        local open = false
        DropBtn.MouseButton1Click:Connect(function()
            open = not open
            DropFrame:TweenSize(open and UDim2.new(1, -10, 0, 35 + (#list * 30)) or UDim2.new(1, -10, 0, 35), "Out", "Quart", 0.4, true)
        end)

        for i, v in pairs(list) do
            local Opt = Instance.new("TextButton")
            Opt.Parent = DropFrame
            Opt.Size = UDim2.new(1, 0, 0, 30)
            Opt.Position = UDim2.new(0, 0, 0, 35 + (i-1)*30)
            Opt.BackgroundColor3 = CurrentTheme.TopBar
            Opt.Text = tostring(v)
            Opt.TextColor3 = CurrentTheme.Placeholder
            Opt.MouseButton1Click:Connect(function()
                callback(v)
                DropBtn.Text = "  " .. name .. ": " .. tostring(v)
                open = false
                DropFrame:TweenSize(UDim2.new(1, -10, 0, 35), "Out", "Quart", 0.4, true)
            end)
        end
    end

    -- [TEMA DEĞİŞTİRME]
    function Elements:ChangeTheme(themeName)
        local theme = Library.Themes[themeName]
        if theme then
            CurrentTheme = theme
            Main.BackgroundColor3 = theme.Main
            TopBar.BackgroundColor3 = theme.TopBar
            Title.TextColor3 = theme.Text
            -- Container içindeki tüm çocukları güncelle
            for _, child in pairs(Container:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    child.BackgroundColor3 = theme.Element
                    -- Alt objeler için daha derin döngü gerekebilir ama bu temel değişimdir.
                end
            end
        end
    end

    return Elements
end

return Library
