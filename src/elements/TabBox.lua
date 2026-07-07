local Creator = require("../modules/Creator")
local New = Creator.New
local TweenService = game:GetService("TweenService")

local Element = {}

function Element:New(Config)
    local TabBox = {
        __type = "TabBox",
        UIElements = {},
    }

    TabBox.UIElements.Main = Creator.NewRoundFrame(6, "Squircle", {
        Parent = Config.Parent,
        BackgroundTransparency = 0,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ThemeTag = { BackgroundColor3 = "ElementBackground" }
    })

    TabBox.UIElements.Container = New("Frame", {
        Parent = TabBox.UIElements.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    New("UIListLayout", {
        Parent = TabBox.UIElements.Container,
        FillDirection = Enum.FillDirection.Horizontal
    })

    local function CreateColumn(Title, Icon)
        local Holder = New("Frame", {
            Parent = TabBox.UIElements.Container,
            BackgroundTransparency = 1,
            Size = UDim2.new(0.5, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        local Canvas = New("CanvasGroup", {
            Parent = Holder,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        local TitleFrame = New("Frame", {
            Parent = Canvas,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 25)
        })
        
        if Icon then
            local IconObj = Creator.Image(Icon, Icon, 0, Config.Window.Folder, "TabHeader", true, true)
            IconObj.Size = UDim2.new(0, 16, 0, 16)
            IconObj.Parent = TitleFrame
            IconObj.Position = UDim2.new(0, 5, 0.5, 0)
        end
        
        New("TextLabel", {
            Parent = TitleFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -25, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            Text = Title or "",
            Font = Creator.Font,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ThemeTag = { TextColor3 = "Text" }
        })
        
        local Content = New("Frame", {
            Parent = Canvas,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y
        })
        
        New("UIListLayout", {
            Parent = Content,
            Padding = UDim.new(0, 5),
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
        
        return Canvas, Content
    end

    TabBox.LeftCanvas, TabBox.Left = CreateColumn(Config.LeftTitle, Config.LeftIcon)
    TabBox.RightCanvas, TabBox.Right = CreateColumn(Config.RightTitle, Config.RightIcon)

    function TabBox:Focus(Side)
        local Info = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        if Side == "Left" then
            TweenService:Create(TabBox.LeftCanvas, Info, {GroupTransparency = 0}):Play()
            TweenService:Create(TabBox.RightCanvas, Info, {GroupTransparency = 0.5}):Play()
        else
            TweenService:Create(TabBox.LeftCanvas, Info, {GroupTransparency = 0.5}):Play()
            TweenService:Create(TabBox.RightCanvas, Info, {GroupTransparency = 0}):Play()
        end
    end

    local function AttachAutoFocus(Canvas, Side)
        Canvas.DescendantAdded:Connect(function(child)
            if child:IsA("GuiButton") and child.Name ~= "TabButton" then
                child.MouseButton1Click:Connect(function()
                    TabBox:Focus(Side)
                end)
            end
        end)
    end

    AttachAutoFocus(TabBox.LeftCanvas, "Left")
    AttachAutoFocus(TabBox.RightCanvas, "Right")

    return TabBox.__type, TabBox
end

return Element
