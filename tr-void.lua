--[[
    TR-VOID UI LIBRARY (FIXED VERSION)
    Developer: Hasan (hasancoder54)
    Version: 1.5
    Fix: Open Button Position & Mobile Optimization
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(cfg)
    local WindowName = cfg.Name or "TR-VOID"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TR_VOID_UI_" .. math.random(100,999)
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- [OPEN BUTTON - EKRANIN EN ÜSTÜNE SABİTLENDİ]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    OpenButtonFrame.BackgroundTransparency = 0.4 
    OpenButtonFrame.Position = UDim2.new(0.5, -40, 0, -40) -- Başlangıçta ekranın dışında (yukarıda)
    OpenButtonFrame.Size = UDim2.new(0, 80, 0, 30)
    OpenButtonFrame.BorderSizePixel = 0
    OpenButtonFrame.Visible = false

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 8)
    OpenCorner.Parent = OpenButtonFrame

    local OpenStroke = Instance.new("UIStroke")
    OpenStroke.Color = Color3.fromRGB(255, 255, 255)
    OpenStroke.Transparency = 0.7
    OpenStroke.Parent = OpenButtonFrame

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
    Main.Position = UDim2.new(0.5, -200, 0.5, -150)
    Main.Size = UDim2.new(0, 0, 0, 0)
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
    Container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)

    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 5)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)

    -- [ANIMATIONS]
    Main:TweenSize(UDim2.new(0, 400, 0, 300), "Out", "Quart", 0.6, true)

    -- KAPATMA MANTIĞI: Open butonu yukarıdan sadece çok az görünür (En üst)
    CloseButton.MouseButton1Click:Connect(function()
        Main:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true, function()
            Main.Visible = false
            OpenButtonFrame.Visible = true
            OpenButtonFrame:TweenPosition(UDim2.new(0.5, -40, 0, 0), "Out", "Back", 0.5, true)
        end)
    end)

    -- AÇMA MANTIĞI: Open butonu tekrar yukarı saklanır
    OpenText.MouseButton1Click:Connect(function()
        OpenButtonFrame:TweenPosition(UDim2.new(0.5, -40, 0, -40), "In", "Quart", 0.3, true, function()
            OpenButtonFrame.Visible = false
            Main.Visible = true
            Main:TweenSize(UDim2.new(0, 400, 0, 300), "Out", "Back", 0.5, true)
        end)
    end)

    -- [DRAGGING]
    local dragging, dragStart, startPos
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

    local Elements = {}

    function Elements:CreateButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = Container
        Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.Font = Enum.Font.Gotham
        Button.Text = "  " .. name
        Button.TextColor3 = Color3.fromRGB(220, 220, 220)
        Button.TextSize = 13
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Button.AutoButtonColor = false

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

    function Elements:CreateToggle(name, callback)
        local state = "neutral"
        local callback = callback or function() end

        local ToggleBtn = Instance.new("TextButton")
        ToggleBtn.Parent = Container
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleBtn.Size = UDim2.new(1, -10, 0, 35)
        ToggleBtn.Text = ""
        ToggleBtn.AutoButtonColor = false

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 6)
        Corner.Parent = ToggleBtn

        local Title = Instance.new("TextLabel")
        Title.Parent = ToggleBtn
        Title.Text = "  " .. name
        Title.Font = Enum.Font.Gotham
        Title.TextColor3 = Color3.fromRGB(220, 220, 220)
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Size = UDim2.new(1, 0, 1, 0)
        Title.BackgroundTransparency = 1

        local Switch = Instance.new("Frame")
        Switch.Parent = ToggleBtn
        Switch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Switch.Position = UDim2.new(1, -45, 0.5, -10)
        Switch.Size = UDim2.new(0, 35, 0, 20)
        local SCorner = Instance.new("UICorner")
        SCorner.CornerRadius = UDim.new(1, 0)
        SCorner.Parent = Switch

        local Dot = Instance.new("Frame")
        Dot.Parent = Switch
        Dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        Dot.Size = UDim2.new(0, 14, 0, 14)
        Dot.Position = UDim2.new(0.5, -7, 0.5, -7)
        local DCorner = Instance.new("UICorner")
        DCorner.CornerRadius = UDim.new(1, 0)
        DCorner.Parent = Dot

        ToggleBtn.MouseButton1Click:Connect(function()
            if state == "neutral" or state == "off" then
                state = "on"
                callback(true)
                TweenService:Create(Dot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 255, 120)}):Play()
                Dot:TweenPosition(UDim2.new(1, -17, 0.5, -7), "Out", "Back", 0.3, true)
            else
                state = "off"
                callback(false)
                TweenService:Create(Dot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
                Dot:TweenPosition(UDim2.new(0, 3, 0.5, -7), "Out", "Back", 0.3, true)
            end
        end)
    end

    return Elements
end

return Library

