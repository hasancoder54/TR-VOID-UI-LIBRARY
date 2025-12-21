--[[
    TR-VOID UI LIBRARY (PRO)
    Developer: Hasan (hasancoder54)
    Version: 2.7
    Updates: 
    - Open/Close Button System Fixed
    - Ultra Smooth Corners (UICorner)
    - Full Theme Support
    - Draggable UI
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

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

    -- [OPEN BUTTON FRAME]
    local OpenButtonFrame = Instance.new("Frame")
    OpenButtonFrame.Parent = ScreenGui
    OpenButtonFrame.BackgroundColor3 = CurrentTheme.Main
    OpenButtonFrame.Position = UDim2.new(0, -100, 0.5, -20) -- Başlangıçta ekran dışında
    OpenButtonFrame.Size = UDim2.new(0, 80, 0, 40)
    OpenButtonFrame.Visible = false
    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 10)
    OpenCorner.Parent = OpenButtonFrame

    local OpenText = Instance.new("TextButton")
    OpenText.Parent = OpenButtonFrame
    OpenText.BackgroundTransparency = 1
    OpenText.Size = UDim2.new(1, 0, 1, 0)
    OpenText.Font = Enum.Font.GothamBold
    OpenText.Text = "AÇ"
    OpenText.TextColor3 = CurrentTheme.Accent
    OpenText.TextSize = 14

    -- [MAIN FRAME]
    local Main = Instance.new("Frame")
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = CurrentTheme.Main
    Main.Position = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.ClipsDescendants = true
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12) -- Daha yumuşak kenarlar
    MainCorner.Parent = Main

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = CurrentTheme.TopBar
    TopBar.Parent = Main
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar

    -- Sürükleme
    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

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

    -- [CONTAINER]
    local Container = Instance.new("ScrollingFrame")
    Container.Parent = Main
    Container.BackgroundTransparency = 1
    Container.Position = UDim2.new(0, 5, 0, 45)
    Container.Size = UDim2.new(1, -10, 1, -50)
    Container.ScrollBarThickness = 2
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Container
    Layout.Padding = UDim.new(0, 6)

    -- [AÇ / KAPAT MANTIĞI]
    CloseButton.MouseButton1Click:Connect(function()
        Main:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true, function()
            Main.Visible = false
            OpenButtonFrame.Visible = true
            OpenButtonFrame:TweenPosition(UDim2.new(0, 10, 0.5, -20), "Out", "Back", 0.5)
        end)
    end)

    OpenText.MouseButton1Click:Connect(function()
        OpenButtonFrame:TweenPosition(UDim2.new(0, -100, 0.5, -20), "In", "Quart", 0.4, true, function()
            OpenButtonFrame.Visible = false
            Main.Visible = true
            Main:TweenSize(UDim2.new(0, WindowWidth, 0, WindowHeight), "Out", "Back", 0.5)
        end)
    end)

    Main:TweenSize(UDim2.new(0, WindowWidth, 0, WindowHeight), "Out", "Quart", 0.6)

    local Elements = {}

    function Elements:CreateButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = Container
        Button.BackgroundColor3 = CurrentTheme.Element
        Button.Size = UDim2.new(1, -10, 0, 35)
        Button.Text = "  " .. name
        Button.TextColor3 = CurrentTheme.Text
        Button.Font = Enum.Font.Gotham
        Button.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
        Button.MouseButton1Click:Connect(callback)
    end

    function Elements:CreateToggle(name, callback)
        local state = false
        local Toggle = Instance.new("TextButton")
        Toggle.Parent = Container
        Toggle.BackgroundColor3 = CurrentTheme.Element
        Toggle.Size = UDim2.new(1, -10, 0, 35)
        Toggle.Text = "  " .. name
        Toggle.TextColor3 = CurrentTheme.Text
        Toggle.Font = Enum.Font.Gotham
        Toggle.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

        local Status = Instance.new("Frame")
        Status.Parent = Toggle
        Status.Position = UDim2.new(1, -35, 0.5, -10)
        Status.Size = UDim2.new(0, 25, 0, 20)
        Status.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Instance.new("UICorner", Status).CornerRadius = UDim.new(0, 6)

        Toggle.MouseButton1Click:Connect(function()
            state = not state
            callback(state)
            TweenService:Create(Status, TweenInfo.new(0.3), {BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(60, 60, 60)}):Play()
        end)
    end

    function Elements:CreateTextbox(name, placeholder, callback)
        local Box = Instance.new("TextBox")
        Box.Parent = Container
        Box.BackgroundColor3 = CurrentTheme.Element
        Box.Size = UDim2.new(1, -10, 0, 35)
        Box.PlaceholderText = name .. ": " .. placeholder
        Box.Text = ""
        Box.TextColor3 = CurrentTheme.Text
        Box.PlaceholderColor3 = CurrentTheme.Placeholder
        Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 8)
        Box.FocusLost:Connect(function(enter) if enter then callback(Box.Text) end end)
    end

    return Elements
end

return Library

