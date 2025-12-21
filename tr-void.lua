--[[
    TR-VOID UI LIBRARY (FULL VERSION)
    Developer: Hasan (hasancoder54)
    Version: 1.2
    Features: Minimize System, Smooth Animations, Auto-Layout, Mobile Support
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [OPEN BUTTON - TOP OF SCREEN]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Name = "OpenButtonFrame"
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    OpenButtonFrame.BackgroundTransparency = 0.4 
    OpenButtonFrame.Position = UDim2.new(0.5, -40, 0, -50) -- Hidden initially
    OpenButtonFrame.Size = UDim2.new(0, 80, 0, 30)
    OpenButtonFrame.BorderSizePixel = 0
    OpenButtonFrame.Visible = false

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 8)
    OpenCorner.Parent = OpenButtonFrame

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(255, 255, 255)
    OpenStroke.Transparency = 0.6
    OpenStroke.Thickness = 1
    OpenStroke.Parent = OpenButtonFrame

    local OpenText = Instance.new("TextButton")
    OpenText.Name = "OpenText"
    OpenText.Parent = OpenButtonFrame
    OpenText.BackgroundTransparency = 1
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Font = Enum.Font.GothamBold
    OpenText.Text = "OPEN"
    OpenText.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenText.TextSize = 12

    -- [MAIN MENU FRAME]
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    Main.Size = UDim2.new(0, 0, 0, 0) -- Opening Animation
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
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Text = WindowName
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.BackgroundTransparency = 1

    -- [CLOSE BUTTON (X)]
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
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

    -- [CONTAINER FOR ELEMENTS]
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Parent = Main
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 5, 0, 40)
    Container.Size = UDim2.new(1, -10, 1, -45)
    Container.ScrollBarThickness = 2
    Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)

    -- Auto Canvas Size Logic
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- [INITIAL OPENING ANIMATION]
    Main:TweenSize(UDim2.new(0, 400, 0, 300), "Out", "Quart", 0.6, true)

    -- [MINIMIZE / RESTORE LOGIC]
    CloseButton.MouseButton1Click:Connect(function()
        Main:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true, function()
            Main.Visible = false
            OpenButtonFrame.Visible = true
            OpenButtonFrame:TweenPosition(UDim2.new(0.5, -40, 0, 20), "Out", "Back", 0.5, true)
        end)
    end)

    OpenText.MouseButton1Click:Connect(function()
        OpenButtonFrame:TweenPosition(UDim2.new(0.5, -40, 0, -50), "In", "Quart", 0.3, true, function()
            OpenButtonFrame.Visible = false
            Main.Visible = true
            Main:TweenSize(UDim2.new(0, 400, 0, 300), "Out", "Back", 0.5, true)
        end)
    end)

    -- [DRAGGING SUPPORT]
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- [UI ELEMENTS FUNCTIONS]
    local Elements = {}

    function Elements:CreateButton(name, callback)
        local callback = callback or function() end
        
        local Button = Instance.new("TextButton")
        Button.Name = name .. "_Btn"
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.AutoButtonColor = false
        Button.Font = Enum.Font.Gotham
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(220, 220, 220)
        Button.TextSize = 13

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        local BtnStroke = Instance.new("UIStroke")
        BtnStroke.Color = Color3.fromRGB(50, 50, 50)
        BtnStroke.Thickness = 1
        BtnStroke.Parent = Button

        -- Click Animation
        Button.MouseButton1Click:Connect(function()
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            callback()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
    end

    return Elements
end

return Library
