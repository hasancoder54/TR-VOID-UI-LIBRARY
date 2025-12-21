--[[
    TR-VOID UI LIBRARY v2.5 (MEGA UPDATE)
    Developer: Hasan (hasancoder54)
    Features: Tabs, ColorPicker, Keybind, TextBox, Slider, Dropdown
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 500
    local WindowHeight = cfg.Height or 350
    
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "TR_VOID_" .. math.random(1,1000)

    -- [OPEN BUTTON]
    local OpenButtonFrame = Instance.new("Frame", ScreenGui)
    OpenButtonFrame.Size = UDim2.new(0, 60, 0, 40)
    OpenButtonFrame.Position = UDim2.new(0, 15, 0, 10)
    OpenButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    OpenButtonFrame.Visible = false
    Instance.new("UICorner", OpenButtonFrame).CornerRadius = UDim.new(0, 10)
    
    local OpenText = Instance.new("TextButton", OpenButtonFrame)
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenText.BackgroundTransparency = 1

    -- [MAIN FRAME]
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, WindowWidth, 0, WindowHeight)
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

    -- [SIDEBAR (SEKMELER İÇİN)]
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 120, 1, -40)
    Sidebar.Position = UDim2.new(0, 5, 0, 35)
    Sidebar.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.CanvasSize = UDim2.new(0,0,0,0)
    TabContainer.ScrollBarThickness = 0
    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 5)

    -- [TOP BAR]
    local TopBar = Instance.new("Frame", Main)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Text = "  " .. WindowName
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", TopBar)
    Close.Text = "X"
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Close.BackgroundTransparency = 0.5

    -- [PAGE CONTAINER]
    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1, -135, 1, -40)
    Pages.Position = UDim2.new(0, 130, 0, 35)
    Pages.BackgroundTransparency = 1

    local Tabs = {}
    local firstPage = true

    function Tabs:CreateTab(tabName)
        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = firstPage
        Page.ScrollBarThickness = 2
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 5)

        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = firstPage and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do p.Visible = false end
            for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(25, 25, 25) end end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)

        firstPage = false
        local Elements = {}

        -- 1. BUTTON
        function Elements:CreateButton(name, size, callback)
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Btn.Text = "  " .. name
            Btn.TextSize = size or 14
            Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Btn)
            Btn.MouseButton1Click:Connect(callback)
        end

        -- 2. TOGGLE
        function Elements:CreateToggle(name, size, callback)
            local state = false
            local Tgl = Instance.new("TextButton", Page)
            Tgl.Size = UDim2.new(1, -10, 0, 35)
            Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Tgl.Text = "  " .. name
            Tgl.TextSize = size or 14
            Tgl.TextColor3 = Color3.fromRGB(220, 220, 220)
            Tgl.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", Tgl)
            local Ind = Instance.new("Frame", Tgl)
            Ind.Size = UDim2.new(0, 20, 0, 20)
            Ind.Position = UDim2.new(1, -30, 0.5, -10)
            Ind.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            Instance.new("UICorner", Ind).CornerRadius = UDim.new(1, 0)
            Tgl.MouseButton1Click:Connect(function()
                state = not state
                Ind.BackgroundColor3 = state and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
                callback(state)
            end)
        end

        -- 3. TEXTBOX
        function Elements:CreateTextBox(name, placeholder, callback)
            local BoxFrame = Instance.new("Frame", Page)
            BoxFrame.Size = UDim2.new(1, -10, 0, 45)
            BoxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", BoxFrame)
            local Label = Instance.new("TextLabel", BoxFrame)
            Label.Text = "  " .. name
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextXAlignment = Enum.TextXAlignment.Left
            local Input = Instance.new("TextBox", BoxFrame)
            Input.Size = UDim2.new(0.5, 0, 0.6, 0)
            Input.Position = UDim2.new(0.45, 0, 0.2, 0)
            Input.PlaceholderText = placeholder
            Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Input.TextColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Input)
            Input.FocusLost:Connect(function() callback(Input.Text) end)
        end

        -- 4. SLIDER
        function Elements:CreateSlider(name, min, max, def, callback)
            local SFrame = Instance.new("Frame", Page)
            SFrame.Size = UDim2.new(1, -10, 0, 45)
            SFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", SFrame)
            local Title = Instance.new("TextLabel", SFrame)
            Title.Text = "  " .. name .. ": " .. def
            Title.Size = UDim2.new(1, 0, 0, 20)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Color3.fromRGB(200, 200, 200)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            local Bar = Instance.new("Frame", SFrame)
            Bar.Size = UDim2.new(0.9, 0, 0, 5)
            Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            local Fill = Instance.new("Frame", Bar)
            Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    local con; con = UserInputService.InputChanged:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                            local p = math.clamp((inp.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                            Fill.Size = UDim2.new(p, 0, 1, 0)
                            local val = math.floor(min + (max-min)*p)
                            Title.Text = "  " .. name .. ": " .. val
                            callback(val)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then con:Disconnect() end end)
                end
            end)
        end

        -- 5. KEYBIND
        function Elements:CreateKeybind(name, default, callback)
            local currKey = default.Name
            local BindBtn = Instance.new("TextButton", Page)
            BindBtn.Size = UDim2.new(1, -10, 0, 35)
            BindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            BindBtn.Text = "  " .. name .. ": " .. currKey
            BindBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            BindBtn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", BindBtn)
            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "  " .. name .. ": ..."
                local con; con = UserInputService.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        currKey = inp.KeyCode.Name
                        BindBtn.Text = "  " .. name .. ": " .. currKey
                        con:Disconnect()
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(inp) if inp.KeyCode.Name == currKey then callback() end end)
        end

        -- 6. COLOR PICKER (Basit Versiyon)
        function Elements:CreateColorPicker(name, default, callback)
            local CPFrame = Instance.new("Frame", Page)
            CPFrame.Size = UDim2.new(1, -10, 0, 35)
            CPFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Instance.new("UICorner", CPFrame)
            local Title = Instance.new("TextLabel", CPFrame)
            Title.Text = "  " .. name
            Title.Size = UDim2.new(1, 0, 1, 0)
            Title.BackgroundTransparency = 1
            Title.TextColor3 = Color3.fromRGB(200, 200, 200)
            Title.TextXAlignment = Enum.TextXAlignment.Left
            local Disp = Instance.new("TextButton", CPFrame)
            Disp.Size = UDim2.new(0, 50, 0, 20)
            Disp.Position = UDim2.new(1, -60, 0.5, -10)
            Disp.BackgroundColor3 = default
            Disp.Text = ""
            Disp.MouseButton1Click:Connect(function()
                local newCol = Color3.fromHSV(math.random(), 1, 1) -- Rastgele renk seçer (Geliştirilebilir)
                Disp.BackgroundColor3 = newCol
                callback(newCol)
            end)
        end

        return Elements
    end

    Close.MouseButton1Click:Connect(function()
        Main.Visible = false
        OpenButtonFrame.Visible = true
    end)
    OpenText.MouseButton1Click:Connect(function()
        Main.Visible = true
        OpenButtonFrame.Visible = false
    end)

    return Tabs
end

return Library

