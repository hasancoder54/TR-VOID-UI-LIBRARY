--[[
    TR-VOID UI LIBRARY
    Developer: Hasan (hasancoder54)
    Version: 2.6
    Update: Tabs, TextBox, Keybind, Tema Değiştirme (ColorPicker) ve Slider/Dropdown entegrasyonu.
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 450
    local WindowHeight = cfg.Height or 350
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [OPEN BUTTON]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    OpenButtonFrame.BackgroundTransparency = 0.4 
    OpenButtonFrame.Position = UDim2.new(0, 15, 0, 10)
    OpenButtonFrame.Size = UDim2.new(0, 60, 0, 40)
    OpenButtonFrame.Visible = false
    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 10)
    OpenCorner.Parent = OpenButtonFrame
    local OpenText = Instance.new("TextButton")
    OpenText.Parent = OpenButtonFrame
    OpenText.BackgroundTransparency = 1
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Font = Enum.Font.GothamBold
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenText.TextSize = 12

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Main.ClipsDescendants = true
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = Main

    -- [TOP BAR]
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.Parent = Main
    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Text = "  " .. WindowName
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.BackgroundTransparency = 1
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BackgroundTransparency = 0.7
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- [SIDEBAR & TABS SYSTEM]
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 110, 1, -40)
    Sidebar.Position = UDim2.new(0, 5, 0, 40)
    Sidebar.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", Sidebar)
    TabList.Padding = UDim.new(0, 5)

    local PageContainer = Instance.new("Frame", Main)
    PageContainer.Size = UDim2.new(1, -125, 1, -45)
    PageContainer.Position = UDim2.new(0, 120, 0, 40)
    PageContainer.BackgroundTransparency = 1

    local Tabs = {}
    local FocusPage = nil

    function Tabs:CreateTab(tName)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        TabBtn.Text = tName
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.Gotham
        Instance.new("UICorner", TabBtn)

        local Page = Instance.new("ScrollingFrame", PageContainer)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.CanvasSize = UDim2.new(0,0,0,0)
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 5)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        if FocusPage == nil then
            FocusPage = Page
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)

        local Elements = {}

        -- [ELEMENTS START]
        function Elements:CreateButton(name, size, callback)
            local Button = Instance.new("TextButton", Page)
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.Text = "  " .. name
            Button.TextColor3 = Color3.fromRGB(220, 220, 220)
            Button.TextSize = size or 14
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 6)
            Button.MouseButton1Click:Connect(callback)
        end

        function Elements:CreateToggle(name, size, callback)
            local state = false
            local Tgl = Instance.new("TextButton", Page)
            Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Tgl.Size = UDim2.new(1, -10, 0, 35)
            Tgl.Text = "  " .. name
            Tgl.TextSize = size or 14
            Tgl.TextColor3 = Color3.fromRGB(220, 220, 220)
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Tgl)
            local Box = Instance.new("Frame", Tgl)
            Box.Size = UDim2.new(0, 30, 0, 18)
            Box.Position = UDim2.new(1, -40, 0.5, -9)
            Box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", Box).CornerRadius = UDim.new(1, 0)
            local Inner = Instance.new("Frame", Box)
            Inner.Size = UDim2.new(0, 14, 0, 14)
            Inner.Position = UDim2.new(0, 2, 0.5, -7)
            Inner.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Instance.new("UICorner", Inner).CornerRadius = UDim.new(1, 0)
            Tgl.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(Inner, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(200, 200, 200)}):Play()
                callback(state)
            end)
        end

        function Elements:CreateSlider(name, min, max, def, callback)
            local SFrame = Instance.new("Frame", Page)
            SFrame.Size = UDim2.new(1, -10, 0, 45)
            SFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", SFrame)
            local STitle = Instance.new("TextLabel", SFrame)
            STitle.Text = "  " .. name .. ": " .. def
            STitle.Size = UDim2.new(1, 0, 0, 20)
            STitle.BackgroundTransparency = 1; STitle.TextColor3 = Color3.fromRGB(200, 200, 200); STitle.TextXAlignment = Enum.TextXAlignment.Left
            local Bar = Instance.new("Frame", SFrame)
            Bar.Size = UDim2.new(0.9, 0, 0, 5); Bar.Position = UDim2.new(0.05, 0, 0.7, 0); Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local con; con = UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                            local p = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(p, 0, 1, 0)
                            local val = math.floor(min + (max-min)*p)
                            STitle.Text = "  " .. name .. ": " .. val
                            callback(val)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then con:Disconnect() end end)
                end
            end)
        end

        function Elements:CreateDropdown(name, list, callback)
            local DFrame = Instance.new("Frame", Page)
            DFrame.Size = UDim2.new(1, -10, 0, 35); DFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); DFrame.ClipsDescendants = true
            Instance.new("UICorner", DFrame)
            local DBtn = Instance.new("TextButton", DFrame)
            DBtn.Size = UDim2.new(1, 0, 0, 35); DBtn.Text = "  " .. name; DBtn.BackgroundTransparency = 1; DBtn.TextColor3 = Color3.fromRGB(200, 200, 200); DBtn.TextXAlignment = Enum.TextXAlignment.Left
            local open = false
            DBtn.MouseButton1Click:Connect(function()
                open = not open
                DFrame:TweenSize(open and UDim2.new(1, -10, 0, 35 + (#list * 25)) or UDim2.new(1, -10, 0, 35), "Out", "Quart", 0.3, true)
            end)
            for i, v in pairs(list) do
                local Opt = Instance.new("TextButton", DFrame)
                Opt.Size = UDim2.new(1, 0, 0, 25); Opt.Position = UDim2.new(0, 0, 0, 35 + (i-1)*25); Opt.Text = v; Opt.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Opt.TextColor3 = Color3.fromRGB(150, 150, 150)
                Opt.MouseButton1Click:Connect(function() callback(v); DBtn.Text = "  " .. name .. ": " .. v; open = false; DFrame:TweenSize(UDim2.new(1, -10, 0, 35), "Out", "Quart", 0.3, true) end)
            end
        end

        function Elements:CreateTextBox(name, placeholder, callback)
            local TBoxFrame = Instance.new("Frame", Page)
            TBoxFrame.Size = UDim2.new(1, -10, 0, 40); TBoxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", TBoxFrame)
            local Txt = Instance.new("TextBox", TBoxFrame)
            Txt.Size = UDim2.new(1, -20, 1, -10); Txt.Position = UDim2.new(0, 10, 0, 5); Txt.PlaceholderText = name .. ": " .. placeholder; Txt.BackgroundTransparency = 1; Txt.TextColor3 = Color3.fromRGB(255, 255, 255); Txt.TextXAlignment = Enum.TextXAlignment.Left
            Txt.FocusLost:Connect(function() callback(Txt.Text) end)
        end

        function Elements:CreateKeybind(name, def, callback)
            local bind = def.Name
            local BBtn = Instance.new("TextButton", Page)
            BBtn.Size = UDim2.new(1, -10, 0, 35); BBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); BBtn.Text = "  " .. name .. ": " .. bind; BBtn.TextColor3 = Color3.fromRGB(200, 200, 200); BBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", BBtn)
            BBtn.MouseButton1Click:Connect(function()
                BBtn.Text = "  Bas bir tuşa..."; local c; c = UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then bind = i.KeyCode.Name; BBtn.Text = "  " .. name .. ": " .. bind; c:Disconnect() end end)
            end)
            UserInputService.InputBegan:Connect(function(i) if i.KeyCode.Name == bind then callback() end end)
        end

        function Elements:CreateColorPicker(name, callback)
            local CP = Instance.new("TextButton", Page)
            CP.Size = UDim2.new(1, -10, 0, 35); CP.BackgroundColor3 = Color3.fromRGB(30, 30, 30); CP.Text = "  " .. name .. " (Tema Değiştir)"; CP.TextColor3 = Color3.fromRGB(200, 200, 200); CP.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", CP)
            CP.MouseButton1Click:Connect(function()
                local randomColor = Color3.fromHSV(math.random(), 0.8, 1)
                MainStroke.Color = randomColor
                callback(randomColor)
            end)
        end

        return Elements
    end

    -- Close/Open Logic
    CloseButton.MouseButton1Click:Connect(function() Main.Visible = false; OpenButtonFrame.Visible = true end)
    OpenText.MouseButton1Click:Connect(function() Main.Visible = true; OpenButtonFrame.Visible = false end)

    return Tabs
end

return Library

