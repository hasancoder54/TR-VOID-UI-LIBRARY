--[[
    TR-VOID UI LIBRARY
    Developer: Hasan (hasancoder54)
    Supported: Delta, Vega X, Fluxus (Android/PC)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    Main.Size = UDim2.new(0, 0, 0, 0) -- Opening Animation Start
    Main.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(40, 40, 40)
    MainStroke.Thickness = 1.5
    MainStroke.Parent = Main

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BorderSizePixel = 0

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar

    local Title = Instance.new("TextLabel")
    Title.Parent = TopBar
    Title.Text = WindowName
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -15, 1, 0)
    Title.BackgroundTransparency = 1

    -- Container (Scrolling Area)
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

    -- Auto Canvas Size
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- Opening Animation
    Main:TweenSize(UDim2.new(0, 400, 0, 300), "Out", "Quart", 0.6, true)

    -- Dragging Logic
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

    -- Elements Functions
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
        Button.TextColor3 = Color3.fromRGB(200, 200, 200)
        Button.TextSize = 13

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        local BtnStroke = Instance.new("UIStroke")
        BtnStroke.Color = Color3.fromRGB(45, 45, 45)
        BtnStroke.Thickness = 1
        BtnStroke.Parent = Button

        -- Click Animation
        Button.MouseButton1Click:Connect(function()
            callback()
            Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TweenService:Create(Button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end)
    end

    return Elements
end

return Library
