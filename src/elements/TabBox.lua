local TweenService = game:GetService("TweenService")

local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

local FadeInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

function Element:New(ElementConfig)
	ElementConfig.ParentConfig = ElementConfig
	ElementConfig.TextOffset = 0

	local TabBoxModule = {
		__type = "TabBox",
	}

	local TabBoxFrame = require("../components/window/Element")(ElementConfig)
	local ContainerColor = TabBoxFrame.UIElements.Container.BackgroundColor3
	TabBoxFrame.UIElements.Container.BackgroundTransparency = 1

	local BoxesHolder = New("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		Parent = TabBoxFrame.UIElements.Container,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			Padding = UDim.new(0, 8),
			SortOrder = "LayoutOrder",
		}),
	})

	local Boxes = {}

	local function AddIcon(Parent, Icon)
		if not Icon then
			return
		end

		local IsAssetId = typeof(Icon) == "string" and Icon:match("^rbxassetid://") ~= nil

		if IsAssetId then
			New("ImageLabel", {
				Image = Icon,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 16, 0, 16),
				LayoutOrder = 1,
				Parent = Parent,
				ThemeTag = {
					ImageColor3 = "Text",
				},
			})
		else
			local IconObject = Creator.Image(Icon, Icon, 0, ElementConfig.Window.Folder, "TabBox", true, false)
			IconObject.Size = UDim2.new(0, 16, 0, 16)
			IconObject.LayoutOrder = 1
			IconObject.Parent = Parent
			TabBoxFrame:Colorize(IconObject.ImageLabel, "ImageColor3")
		end
	end

	local function CreateBox(Index, Title, Icon)
		local Box = New("TextButton", {
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(0.5, -4, 0, 30),
			LayoutOrder = Index,
			ClipsDescendants = true,
			Parent = BoxesHolder,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, ElementConfig.Window.ElementConfig.UICorner) }),
			New("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}),
			New("UIListLayout", {
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 6),
				SortOrder = "LayoutOrder",
			}),
		})

		Box.BackgroundColor3 = ContainerColor

		local Overlay = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1,
			ZIndex = 0,
			Parent = Box,
		}, {
			New("UICorner", { CornerRadius = UDim.new(0, ElementConfig.Window.ElementConfig.UICorner) }),
		})

		AddIcon(Box, Icon)

		New("TextLabel", {
			Text = Title,
			BackgroundTransparency = 1,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextSize = 13,
			AutomaticSize = "X",
			Size = UDim2.new(0, 0, 1, 0),
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "Text",
			},
			Parent = Box,
		})

		-- İçerik: box'a tıklanmadan hep gizli kalır, düz Frame (CanvasGroup değil)
		local Content = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Visible = false,
			LayoutOrder = Index,
			Parent = TabBoxFrame.UIElements.Container,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = "Vertical",
				SortOrder = "LayoutOrder",
			}),
		})

		Boxes[Index] = { Button = Box, Overlay = Overlay, Content = Content }

		return Box, Content
	end

	local ActiveIndex = nil

	local function SetActive(Index)
		if ActiveIndex == Index then
			return
		end
		ActiveIndex = Index

		for i, Data in next, Boxes do
			local IsActive = (i == Index)

			TweenService:Create(Data.Overlay, FadeInfo, {
				BackgroundTransparency = IsActive and 0.85 or 1,
			}):Play()

			Data.Content.Visible = IsActive
		end
	end

	local LeftButton, LeftContent = CreateBox(1, ElementConfig.LeftTitle or "Left", ElementConfig.LeftIcon)
	local RightButton, RightContent = CreateBox(2, ElementConfig.RightTitle or "Right", ElementConfig.RightIcon)

	Creator.AddSignal(LeftButton.MouseButton1Click, function()
		SetActive(1)
	end)

	Creator.AddSignal(RightButton.MouseButton1Click, function()
		SetActive(2)
	end)

	TabBoxModule.Left = LeftContent
	TabBoxModule.Right = RightContent

	return TabBoxModule.__type, TabBoxModule
end

return Element

