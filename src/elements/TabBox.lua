local Creator = require("../modules/Creator")
local New = Creator.New
local TweenService = game:GetService("TweenService")

local Element = {}

function Element:New(Config)
    local TabBox = {
        __type = "TabBox",
        UIElements = {},
        CurrentSide = ""
    }

    TabBox.UIElements.Main = New("Frame", {
        Parent = Config.Parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })

    local MainLayout = New("UIListLayout", {
        Parent = TabBox.UIElements.Main,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local TopBar = New("Frame", {
        Parent = TabBox.UIElements.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        LayoutOrder = 1
    })

    New("UIListLayout", {
        Parent = TopBar,
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local function CreateTabButton(Title, Icon, Order)
        local Button = Creator.NewRoundFrame(6, "Squircle", {
            Parent = TopBar,
            Size = UDim2.new(0.5, -4, 1, 0),
            LayoutOrder = Order,
            BackgroundColor3 = Color3.fromRGB(32, 32, 32),
            ThemeTag = { BackgroundColor3 = "ElementBackground" }
        })

        local ClickBtn = New("TextButton", {
            Parent = Button,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Text = "",
            Font = Creator.Font,
            TextSize = 14
        })

        local TargetFrame = New("Frame", {
            Parent = Button,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0)
        })

        local Layout = New("UIListLayout", {
            Parent = TargetFrame,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 6)
        })

        if Icon then
            local IconObj = Creator.Image(Icon, Icon, 0, Config.Window.Folder, "TabHeader", true, true)
            IconObj.Size = UDim2.new(0, 16, 0, 16)
            IconObj.Parent = TargetFrame
        end

        local Label = New("TextLabel", {
            Parent = TargetFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            Text = Title or "",
            FontFace = Font.new(typeof(Creator.Font) == "Instance" and Creator.Font.Family or Creator.Font, Enum.FontWeight.Medium),
            TextSize = 14,
            ThemeTag = { TextColor3 = "Text" }
        })

        return Button, ClickBtn
    end

    local LeftBtnFrame, LeftClick = CreateTabButton(Config.LeftTitle, Config.LeftIcon, 1)
    local RightBtnFrame, RightClick = CreateTabButton(Config.RightTitle, Config.RightIcon, 2)

    TabBox.LeftCanvas = New("CanvasGroup", {
        Parent = TabBox.UIElements.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 2,
        GroupTransparency = 1,
        Visible = false
    })

    local LeftBox = Creator.NewRoundFrame(6, "Squircle", {
        Parent = TabBox.LeftCanvas,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        ThemeTag = { BackgroundColor3 = "ElementBackground" }
    })

    TabBox.Left = New("Frame", {
        Parent = LeftBox,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    New("UIListLayout", { Parent = TabBox.Left, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center })
    New("UIPadding", { Parent = TabBox.Left, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

    TabBox.RightCanvas = New("CanvasGroup", {
        Parent = TabBox.UIElements.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 3,
        GroupTransparency = 1,
        Visible = false
    })

    local RightBox = Creator.NewRoundFrame(6, "Squircle", {
        Parent = TabBox.RightCanvas,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.fromRGB(28, 28, 28),
        ThemeTag = { BackgroundColor3 = "ElementBackground" }
    })

    TabBox.Right = New("Frame", {
        Parent = RightBox,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    New("UIListLayout", { Parent = TabBox.Right, Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center })
    New("UIPadding", { Parent = TabBox.Right, PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) })

    function TabBox:SwitchTo(Side)
        if TabBox.CurrentSide == Side and (TabBox.LeftCanvas.Visible or TabBox.RightCanvas.Visible) then 
            return 
        end

        local Info = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

        if Side == "Left" then
            if TabBox.RightCanvas.Visible then
                TweenService:Create(TabBox.RightCanvas, Info, {GroupTransparency = 1}):Play()
                task.delay(0.35, function()
                    if TabBox.CurrentSide == "Left" then
                        TabBox.RightCanvas.Visible = false
                    end
                end)
            end
            
            TabBox.LeftCanvas.Visible = true
            TweenService:Create(TabBox.LeftCanvas, Info, {GroupTransparency = 0}):Play()
            TabBox.CurrentSide = "Left"
        elseif Side == "Right" then
            if TabBox.LeftCanvas.Visible then
                TweenService:Create(TabBox.LeftCanvas, Info, {GroupTransparency = 1}):Play()
                task.delay(0.35, function()
                    if TabBox.CurrentSide == "Right" then
                        TabBox.LeftCanvas.Visible = false
                    end
                end)
            end
            
            TabBox.RightCanvas.Visible = true
            TweenService:Create(TabBox.RightCanvas, Info, {GroupTransparency = 0}):Play()
            TabBox.CurrentSide = "Right"
        end
    end

    LeftClick.MouseButton1Click:Connect(function() TabBox:SwitchTo("Left") end)
    RightClick.MouseButton1Click:Connect(function() TabBox:SwitchTo("Right") end)

    return TabBox.__type, TabBox
end

return Element
