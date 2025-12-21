--[[
    TR-VOID UI LIBRARY
    Developer: Hasan (hasancoder54)
    Version: 2.4
    Update: Added Slider, Dropdown, and Custom Window Size (Width/Height)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    local WindowWidth = cfg.Width or 400
    local WindowHeight = cfg.Height or 300
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [OPEN BUTTON]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    OpenButtonFrame.BackgroundTransparency = 0.4 
    OpenButtonFrame.Position = UDim2.new(0, 15, 0, -250)
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
    Main.Size = UDim2.new(0, 0, 0, 0) -- Başlangıç boyutu (Animasyon için)
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
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- [ANIMATIONS & DRAGGING]
    Main:TweenSize(UDim2.new(0, WindowWidth, 0, WindowHeight), "Out", "Quart", 0.6, true)

    CloseButton.MouseButton1Click:Connect(function()
        Main:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true, function()
            Main.Visible = false
            OpenButtonFrame.Visible = true
            OpenButtonFrame:TweenPosition(UDim2.new(0, 15, 0, 10), "Out", "Back", 0.5, true)
        end)
    end)

    OpenText.MouseButton1Click:Connect(function()
        OpenButtonFrame:TweenPosition(UDim2.new(0, 15, 0, -250), "In", "Quart", 0.3, true, function()
            OpenButtonFrame.Visible = false
            Main.Visible = true
            Main:TweenSize(UDim2.new(0, WindowWidth, 0, WindowHeight), "Out", "Back", 0.5, true)
        end)
    end)

    -- [ELEMENTS]
    local Elements = {}

    function Elements:CreateButton(name, size, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.Font = Enum.Font.Gotham
        Button.Text = "  " .. name
        Button.TextColor3 = Color3.fromRGB(220, 220, 220)
        Button.TextSize = size or 14
        Button.TextXAlignment = Enum.TextXAlignment.Left
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = Button
        Button.MouseButton1Click:Connect(function()
            callback()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
    end

    function Elements:CreateToggle(name, size, callback)
        local state = false
        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Parent = Container
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
        ToggleBtn.Text = ""
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ToggleBtn
        local TTitle = Instance.new("TextLabel")
        TTitle.Parent = ToggleBtn
        TTitle.Text = "  " .. name
        TTitle.Font = Enum.Font.Gotham
        TTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
        TTitle.TextSize = size or 14
        TTitle.TextXAlignment = Enum.TextXAlignment.Left
        TTitle.Size = UDim2.new(1, 0, 1, 0)
        TTitle.BackgroundTransparency = 1
        local Switch = Instance.new("Frame")
        Switch.Parent = ToggleBtn
        Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Switch.Position = UDim2.new(1, -45, 0.5, -10)
        Switch.Size = UDim2.new(0, 35, 0, 20)
        local Dot = Instance.new("Frame")
        Dot.Parent = Switch
        Dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        Dot.Size = UDim2.new(0, 14, 0, 14)
        Dot.Position = UDim2.new(0, 3, 0.5, -7)
        Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
        ToggleBtn.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            local targetColor = state and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 80, 80)
            TweenService:Create(Dot, TweenInfo.new(0.3), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
        end)
    end

    function Elements:CreateSlider(name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Parent = Container
        SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SliderFrame.Size = UDim2.new(1, -10, 0, 45)
        Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)
        local STitle = Instance.new("TextLabel")
        STitle.Parent = SliderFrame
        STitle.Text = "  " .. name
        STitle.Size = UDim2.new(1, 0, 0, 20)
        STitle.TextColor3 = Color3.fromRGB(220, 220, 220)
        STitle.BackgroundTransparency = 1
        STitle.TextXAlignment = Enum.TextXAlignment.Left
        local Bar = Instance.new("Frame")
        Bar.Parent = SliderFrame
        Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Bar.Position = UDim2.new(0, 10, 0, 25)
        Bar.Size = UDim2.new(1, -60, 0, 6)
        local Fill = Instance.new("Frame")
        Fill.Parent = Bar
        Fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        local ValLabel = Instance.new("TextLabel")
        ValLabel.Parent = SliderFrame
        ValLabel.Text = tostring(default)
        ValLabel.Position = UDim2.new(1, -45, 0, 20)
        ValLabel.Size = UDim2.new(0, 40, 0, 20)
        ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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

    function Elements:CreateDropdown(name, list, callback)
        local DropFrame = Instance.new("Frame")
        DropFrame.Parent = Container
        DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        DropFrame.Size = UDim2.new(1, -10, 0, 35)
        DropFrame.ClipsDescendants = true
        Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
        local DropBtn = Instance.new("TextButton")
        DropBtn.Parent = DropFrame
        DropBtn.Size = UDim2.new(1, 0, 0, 35)
        DropBtn.Text = "  " .. name .. " (Seçiniz)"
        DropBtn.BackgroundTransparency = 1
        DropBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
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
            Opt.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Opt.Text = v
            Opt.TextColor3 = Color3.fromRGB(180, 180, 180)
            Opt.MouseButton1Click:Connect(function()
                callback(v)
                DropBtn.Text = "  " .. name .. ": " .. v
                open = false
                DropFrame:TweenSize(UDim2.new(1, -10, 0, 35), "Out", "Quart", 0.4, true)
            end)
        end
    end

    return Elements
end

return Library
