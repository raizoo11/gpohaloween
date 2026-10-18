local MacLib = (function()
local MacLib = { 
	Options = {}, 
	Folder = "Maclib", 
	GetService = function(service)
		return cloneref and cloneref(game:GetService(service)) or game:GetService(service)
	end
}

--// Services
local TweenService = MacLib.GetService("TweenService")
local RunService = MacLib.GetService("RunService")
local HttpService = MacLib.GetService("HttpService")
local ContentProvider = MacLib.GetService("ContentProvider")
local UserInputService = MacLib.GetService("UserInputService")
local Lighting = MacLib.GetService("Lighting")
local Players = MacLib.GetService("Players")

--// Variables
local isStudio = RunService:IsStudio()
local LocalPlayer = Players.LocalPlayer

local windowState
local acrylicBlur
local hasGlobalSetting

local tabs = {}
local currentTabInstance = nil
local tabIndex = 0
local unloaded = false

local assets = {
	interFont = "rbxassetid://12187365364",
	userInfoBlurred = "rbxassetid://18824089198",
	toggleBackground = "rbxassetid://18772190202",
	togglerHead = "rbxassetid://18772309008",
	buttonImage = "rbxassetid://10709791437",
	searchIcon = "rbxassetid://86737463322606",
	colorWheel = "rbxassetid://2849458409",
	colorTarget = "rbxassetid://73265255323268",
	grid = "rbxassetid://121484455191370",
	globe = "rbxassetid://108952102602834",
	transform = "rbxassetid://90336395745819",
	dropdown = "rbxassetid://18865373378",
	sliderbar = "rbxassetid://18772615246",
	sliderhead = "rbxassetid://18772834246",
}

--// Functions
local function GetGui()
	local newGui = Instance.new("ScreenGui")
	newGui.ScreenInsets = Enum.ScreenInsets.None
	newGui.ResetOnSpawn = false
	newGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	newGui.DisplayOrder = 2147483647

	local parent = RunService:IsStudio() 
		and LocalPlayer:FindFirstChild("PlayerGui")
		or (gethui and gethui())
		or (cloneref and cloneref(MacLib.GetService("CoreGui")) or MacLib.GetService("CoreGui"))

	newGui.Parent = parent
	return newGui
end

local function Tween(instance, tweeninfo, propertytable)
	return TweenService:Create(instance, tweeninfo, propertytable)
end

--// Library Functions
function MacLib:Window(Settings)
	local WindowFunctions = {Settings = Settings}
	if Settings.AcrylicBlur ~= nil then
		acrylicBlur = Settings.AcrylicBlur
	else
		acrylicBlur = true
	end

	local macLib = GetGui()

	local notifications = Instance.new("Frame")
	notifications.Name = "Notifications"
	notifications.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	notifications.BackgroundTransparency = 1
	notifications.BorderColor3 = Color3.fromRGB(0, 0, 0)
	notifications.BorderSizePixel = 0
	notifications.Size = UDim2.fromScale(1, 1)
	notifications.Parent = macLib
	notifications.ZIndex = 2

	local notificationsUIListLayout = Instance.new("UIListLayout")
	notificationsUIListLayout.Name = "NotificationsUIListLayout"
	notificationsUIListLayout.Padding = UDim.new(0, 10)
	notificationsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notificationsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notificationsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notificationsUIListLayout.Parent = notifications

	local notificationsUIPadding = Instance.new("UIPadding")
	notificationsUIPadding.Name = "NotificationsUIPadding"
	notificationsUIPadding.PaddingBottom = UDim.new(0, 10)
	notificationsUIPadding.PaddingLeft = UDim.new(0, 10)
	notificationsUIPadding.PaddingRight = UDim.new(0, 10)
	notificationsUIPadding.PaddingTop = UDim.new(0, 10)
	notificationsUIPadding.Parent = notifications

	local base = Instance.new("Frame")
	base.Name = "Base"
	base.AnchorPoint = Vector2.new(0.5, 0.5)
	base.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	base.BackgroundTransparency = Settings.AcrylicBlur and 0.05 or 0
	base.BorderColor3 = Color3.fromRGB(0, 0, 0)
	base.BorderSizePixel = 0
	base.Position = UDim2.fromScale(0.5, 0.5)
	base.Size = Settings.Size or UDim2.fromOffset(868, 650)

	local baseUIScale = Instance.new("UIScale")
	baseUIScale.Name = "BaseUIScale"
	baseUIScale.Parent = base

	local baseUICorner = Instance.new("UICorner")
	baseUICorner.Name = "BaseUICorner"
	baseUICorner.CornerRadius = UDim.new(0, 10)
	baseUICorner.Parent = base

	local baseUIStroke = Instance.new("UIStroke")
	baseUIStroke.Name = "BaseUIStroke"
	baseUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke.Transparency = 0.9
	baseUIStroke.Parent = base

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebar.BackgroundTransparency = 1
	sidebar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.fromScale(-3.52e-08, 4.69e-08)
	sidebar.Size = UDim2.fromScale(0.325, 1)

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.AnchorPoint = Vector2.new(1, 0)
	divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider.BackgroundTransparency = 0.9
	divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider.BorderSizePixel = 0
	divider.Position = UDim2.fromScale(1, 0)
	divider.Size = UDim2.new(0, 1, 1, 0)
	divider.Parent = sidebar

	local dividerInteract = Instance.new("TextButton")
	dividerInteract.Name = "DividerInteract"
	dividerInteract.AnchorPoint = Vector2.new(0.5, 0)
	dividerInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dividerInteract.BackgroundTransparency = 1
	dividerInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.BorderSizePixel = 0
	dividerInteract.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	dividerInteract.Position = UDim2.fromScale(0.5, 0)
	dividerInteract.Size = UDim2.new(1, 6, 1, 0)
	dividerInteract.Text = ""
	dividerInteract.TextColor3 = Color3.fromRGB(0, 0, 0)
	dividerInteract.TextSize = 14
	dividerInteract.Parent = divider

	local windowControls = Instance.new("Frame")
	windowControls.Name = "WindowControls"
	windowControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	windowControls.BackgroundTransparency = 1
	windowControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	windowControls.BorderSizePixel = 0
	windowControls.Size = UDim2.new(1, 0, 0, 31)

	local controls = Instance.new("Frame")
	controls.Name = "Controls"
	controls.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	controls.BackgroundTransparency = 1
	controls.BorderColor3 = Color3.fromRGB(0, 0, 0)
	controls.BorderSizePixel = 0
	controls.Size = UDim2.fromScale(1, 1)

	local uIListLayout = Instance.new("UIListLayout")
	uIListLayout.Name = "UIListLayout"
	uIListLayout.Padding = UDim.new(0, 5)
	uIListLayout.FillDirection = Enum.FillDirection.Horizontal
	uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uIListLayout.Parent = controls

	local uIPadding = Instance.new("UIPadding")
	uIPadding.Name = "UIPadding"
	uIPadding.PaddingLeft = UDim.new(0, 11)
	uIPadding.Parent = controls

	local windowControlSettings = {
		sizes = { enabled = UDim2.fromOffset(8, 8), disabled = UDim2.fromOffset(7, 7) },
		transparencies = { enabled = 0, disabled = 1 },
		strokeTransparency = 0.9,
	}

	local stroke = Instance.new("UIStroke")
	stroke.Name = "BaseUIStroke"
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Transparency = windowControlSettings.strokeTransparency

	local exit = Instance.new("TextButton")
	exit.Name = "Exit"
	exit.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	exit.Text = ""
	exit.TextColor3 = Color3.fromRGB(0, 0, 0)
	exit.TextSize = 14
	exit.AutoButtonColor = false
	exit.BackgroundColor3 = Color3.fromRGB(250, 93, 86)
	exit.BorderColor3 = Color3.fromRGB(0, 0, 0)
	exit.BorderSizePixel = 0

	local uICorner = Instance.new("UICorner")
	uICorner.Name = "UICorner"
	uICorner.CornerRadius = UDim.new(1, 0)
	uICorner.Parent = exit

	exit.Parent = controls

	local minimize = Instance.new("TextButton")
	minimize.Name = "Minimize"
	minimize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	minimize.Text = ""
	minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
	minimize.TextSize = 14
	minimize.AutoButtonColor = false
	minimize.BackgroundColor3 = Color3.fromRGB(252, 190, 57)
	minimize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	minimize.BorderSizePixel = 0
	minimize.LayoutOrder = 1

	local uICorner1 = Instance.new("UICorner")
	uICorner1.Name = "UICorner"
	uICorner1.CornerRadius = UDim.new(1, 0)
	uICorner1.Parent = minimize

	minimize.Parent = controls

	local maximize = Instance.new("TextButton")
	maximize.Name = "Maximize"
	maximize.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	maximize.Text = ""
	maximize.TextColor3 = Color3.fromRGB(0, 0, 0)
	maximize.TextSize = 14
	maximize.AutoButtonColor = false
	maximize.BackgroundColor3 = Color3.fromRGB(119, 174, 94)
	maximize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	maximize.BorderSizePixel = 0
	maximize.LayoutOrder = 1

	local uICorner2 = Instance.new("UICorner")
	uICorner2.Name = "UICorner"
	uICorner2.CornerRadius = UDim.new(1, 0)
	uICorner2.Parent = maximize

	maximize.Parent = controls

	local function applyState(button, enabled)
		local size = enabled and windowControlSettings.sizes.enabled or windowControlSettings.sizes.disabled
		local transparency = enabled and windowControlSettings.transparencies.enabled or windowControlSettings.transparencies.disabled

		button.Size = size
		button.BackgroundTransparency = transparency
		button.Active = enabled
		button.Interactable = enabled

		for _, child in ipairs(button:GetChildren()) do
			if child:IsA("UIStroke") then
				child.Transparency = transparency
			end
		end
		if not enabled then
			stroke:Clone().Parent = button
		end
	end

	applyState(maximize, false)

	local controlsList = {exit, minimize}
	for _, button in pairs(controlsList) do
		local buttonName = button.Name
		local isEnabled = true

		if Settings.DisabledWindowControls and table.find(Settings.DisabledWindowControls, buttonName) then
			isEnabled = false
		end

		applyState(button, isEnabled)
	end

	controls.Parent = windowControls

	local divider1 = Instance.new("Frame")
	divider1.Name = "Divider"
	divider1.AnchorPoint = Vector2.new(0, 1)
	divider1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider1.BackgroundTransparency = 0.9
	divider1.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider1.BorderSizePixel = 0
	divider1.Position = UDim2.fromScale(0, 1)
	divider1.Size = UDim2.new(1, 0, 0, 1)
	divider1.Parent = windowControls

	windowControls.Parent = sidebar

	local information = Instance.new("Frame")
	information.Name = "Information"
	information.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	information.BackgroundTransparency = 1
	information.BorderColor3 = Color3.fromRGB(0, 0, 0)
	information.BorderSizePixel = 0
	information.Position = UDim2.fromOffset(0, 31)
	information.Size = UDim2.new(1, 0, 0, 60)

	local divider2 = Instance.new("Frame")
	divider2.Name = "Divider"
	divider2.AnchorPoint = Vector2.new(0, 1)
	divider2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider2.BackgroundTransparency = 0.9
	divider2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider2.BorderSizePixel = 0
	divider2.Position = UDim2.fromScale(0, 1)
	divider2.Size = UDim2.new(1, 0, 0, 1)
	divider2.Parent = information

	local informationHolder = Instance.new("Frame")
	informationHolder.Name = "InformationHolder"
	informationHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationHolder.BackgroundTransparency = 1
	informationHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationHolder.BorderSizePixel = 0
	informationHolder.Size = UDim2.fromScale(1, 1)

	local informationHolderUIPadding = Instance.new("UIPadding")
	informationHolderUIPadding.Name = "InformationHolderUIPadding"
	informationHolderUIPadding.PaddingBottom = UDim.new(0, 10)
	informationHolderUIPadding.PaddingLeft = UDim.new(0, 23)
	informationHolderUIPadding.PaddingRight = UDim.new(0, 22)
	informationHolderUIPadding.PaddingTop = UDim.new(0, 10)
	informationHolderUIPadding.Parent = informationHolder

	local globalSettingsButton = Instance.new("ImageButton")
	globalSettingsButton.Name = "GlobalSettingsButton"
	globalSettingsButton.Image = assets.globe
	globalSettingsButton.ImageTransparency = 0.5
	globalSettingsButton.AnchorPoint = Vector2.new(1, 0.5)
	globalSettingsButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	globalSettingsButton.BackgroundTransparency = 1
	globalSettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettingsButton.BorderSizePixel = 0
	globalSettingsButton.Position = UDim2.fromScale(1, 0.5)
	globalSettingsButton.Size = UDim2.fromOffset(16,16)
	globalSettingsButton.Parent = informationHolder

	local function ChangeGlobalSettingsButtonState(State)
		if State == "Default" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.5
			}):Play()
		elseif State == "Hover" then
			Tween(globalSettingsButton, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.3
			}):Play()
		end
	end

	globalSettingsButton.MouseEnter:Connect(function()
		ChangeGlobalSettingsButtonState("Hover")
	end)
	globalSettingsButton.MouseLeave:Connect(function()
		ChangeGlobalSettingsButtonState("Default")
	end)

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleFrame.BackgroundTransparency = 1
	titleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	titleFrame.BorderSizePixel = 0
	titleFrame.Size = UDim2.fromScale(1, 1)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	title.Text = Settings.Title
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.RichText = true
	title.TextSize = 18
	title.TextTransparency = 0.1
	title.TextTruncate = Enum.TextTruncate.SplitWord
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.TextYAlignment = Enum.TextYAlignment.Top
	title.AutomaticSize = Enum.AutomaticSize.Y
	title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.BorderColor3 = Color3.fromRGB(0, 0, 0)
	title.BorderSizePixel = 0
	title.Size = UDim2.new(1, -20, 0, 0)
	title.Parent = titleFrame

	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	subtitle.RichText = true
	subtitle.Text = Settings.Subtitle
	subtitle.RichText = true
	subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.TextSize = 12
	subtitle.TextTransparency = 0.7
	subtitle.TextTruncate = Enum.TextTruncate.SplitWord
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.TextYAlignment = Enum.TextYAlignment.Top
	subtitle.AutomaticSize = Enum.AutomaticSize.Y
	subtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	subtitle.BackgroundTransparency = 1
	subtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
	subtitle.BorderSizePixel = 0
	subtitle.LayoutOrder = 1
	subtitle.Size = UDim2.new(1, -20, 0, 0)
	subtitle.Parent = titleFrame

	local titleFrameUIListLayout = Instance.new("UIListLayout")
	titleFrameUIListLayout.Name = "TitleFrameUIListLayout"
	titleFrameUIListLayout.Padding = UDim.new(0, 3)
	titleFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	titleFrameUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	titleFrameUIListLayout.Parent = titleFrame

	titleFrame.Parent = informationHolder

	informationHolder.Parent = information

	information.Parent = sidebar

	local sidebarGroup = Instance.new("Frame")
	sidebarGroup.Name = "SidebarGroup"
	sidebarGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarGroup.BackgroundTransparency = 1
	sidebarGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	sidebarGroup.BorderSizePixel = 0
	sidebarGroup.Position = UDim2.fromOffset(0, 91)
	sidebarGroup.Size = UDim2.new(1, 0, 1, -91)

	local userInfo = Instance.new("Frame")
	userInfo.Name = "UserInfo"
	userInfo.AnchorPoint = Vector2.new(0, 1)
	userInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userInfo.BackgroundTransparency = 1
	userInfo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userInfo.BorderSizePixel = 0
	userInfo.Position = UDim2.fromScale(0, 1)
	userInfo.Size = UDim2.new(1, 0, 0, 107)

	local informationGroup = Instance.new("Frame")
	informationGroup.Name = "InformationGroup"
	informationGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	informationGroup.BackgroundTransparency = 1
	informationGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
	informationGroup.BorderSizePixel = 0
	informationGroup.Size = UDim2.fromScale(1, 1)

	local informationGroupUIPadding = Instance.new("UIPadding")
	informationGroupUIPadding.Name = "InformationGroupUIPadding"
	informationGroupUIPadding.PaddingBottom = UDim.new(0, 17)
	informationGroupUIPadding.PaddingLeft = UDim.new(0, 25)
	informationGroupUIPadding.Parent = informationGroup

	local informationGroupUIListLayout = Instance.new("UIListLayout")
	informationGroupUIListLayout.Name = "InformationGroupUIListLayout"
	informationGroupUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	informationGroupUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	informationGroupUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	informationGroupUIListLayout.Parent = informationGroup

	local userId = LocalPlayer.UserId
	local thumbType = Enum.ThumbnailType.AvatarBust
	local thumbSize = Enum.ThumbnailSize.Size48x48
	local headshotImage, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)

	local headshot = Instance.new("ImageLabel")
	headshot.Name = "Headshot"
	headshot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	headshot.BackgroundTransparency = 1
	headshot.BorderColor3 = Color3.fromRGB(0, 0, 0)
	headshot.BorderSizePixel = 0
	headshot.Size = UDim2.fromOffset(32, 32)
	headshot.Image = (isReady and headshotImage) or "rbxassetid://0"

	local uICorner3 = Instance.new("UICorner")
	uICorner3.Name = "UICorner"
	uICorner3.CornerRadius = UDim.new(1, 0)
	uICorner3.Parent = headshot

	local baseUIStroke2 = Instance.new("UIStroke")
	baseUIStroke2.Name = "BaseUIStroke"
	baseUIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	baseUIStroke2.Color = Color3.fromRGB(255, 255, 255)
	baseUIStroke2.Transparency = 0.9
	baseUIStroke2.Parent = headshot

	headshot.Parent = informationGroup

	local userAndDisplayFrame = Instance.new("Frame")
	userAndDisplayFrame.Name = "UserAndDisplayFrame"
	userAndDisplayFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	userAndDisplayFrame.BackgroundTransparency = 1
	userAndDisplayFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	userAndDisplayFrame.BorderSizePixel = 0
	userAndDisplayFrame.LayoutOrder = 1
	userAndDisplayFrame.Size = UDim2.new(1, -42, 0, 32)

	local displayName = Instance.new("TextLabel")
	displayName.Name = "DisplayName"
	displayName.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	displayName.Text = LocalPlayer.DisplayName
	displayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	displayName.TextSize = 13
	displayName.TextTransparency = 0.1
	displayName.TextTruncate = Enum.TextTruncate.SplitWord
	displayName.TextXAlignment = Enum.TextXAlignment.Left
	displayName.TextYAlignment = Enum.TextYAlignment.Top
	displayName.AutomaticSize = Enum.AutomaticSize.XY
	displayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	displayName.BackgroundTransparency = 1
	displayName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	displayName.BorderSizePixel = 0
	displayName.Parent = userAndDisplayFrame
	displayName.Size = UDim2.fromScale(1,0)

	local userAndDisplayFrameUIPadding = Instance.new("UIPadding")
	userAndDisplayFrameUIPadding.Name = "UserAndDisplayFrameUIPadding"
	userAndDisplayFrameUIPadding.PaddingLeft = UDim.new(0, 8)
	userAndDisplayFrameUIPadding.PaddingTop = UDim.new(0, 3)
	userAndDisplayFrameUIPadding.Parent = userAndDisplayFrame

	local userAndDisplayFrameUIListLayout = Instance.new("UIListLayout")
	userAndDisplayFrameUIListLayout.Name = "UserAndDisplayFrameUIListLayout"
	userAndDisplayFrameUIListLayout.Padding = UDim.new(0, 1)
	userAndDisplayFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	userAndDisplayFrameUIListLayout.Parent = userAndDisplayFrame

	local username = Instance.new("TextLabel")
	username.Name = "Username"
	username.FontFace = Font.new(
		assets.interFont,
		Enum.FontWeight.SemiBold,
		Enum.FontStyle.Normal
	)
	username.Text = "@" .. LocalPlayer.Name
	username.TextColor3 = Color3.fromRGB(255, 255, 255)
	username.TextSize = 12
	username.TextTransparency = 0.7
	username.TextTruncate = Enum.TextTruncate.SplitWord
	username.TextXAlignment = Enum.TextXAlignment.Left
	username.TextYAlignment = Enum.TextYAlignment.Top
	username.AutomaticSize = Enum.AutomaticSize.XY
	username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	username.BackgroundTransparency = 1
	username.BorderColor3 = Color3.fromRGB(0, 0, 0)
	username.BorderSizePixel = 0
	username.LayoutOrder = 1
	username.Parent = userAndDisplayFrame
	username.Size = UDim2.fromScale(1,0)

	userAndDisplayFrame.Parent = informationGroup

	informationGroup.Parent = userInfo

	local userInfoUIPadding = Instance.new("UIPadding")
	userInfoUIPadding.Name = "UserInfoUIPadding"
	userInfoUIPadding.PaddingLeft = UDim.new(0, 10)
	userInfoUIPadding.PaddingRight = UDim.new(0, 10)
	userInfoUIPadding.Parent = userInfo

	userInfo.Parent = sidebarGroup

	local sidebarGroupUIPadding = Instance.new("UIPadding")
	sidebarGroupUIPadding.Name = "SidebarGroupUIPadding"
	sidebarGroupUIPadding.PaddingLeft = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingRight = UDim.new(0, 10)
	sidebarGroupUIPadding.PaddingTop = UDim.new(0, 31)
	sidebarGroupUIPadding.Parent = sidebarGroup

	local tabSwitchers = Instance.new("Frame")
	tabSwitchers.Name = "TabSwitchers"
	tabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchers.BackgroundTransparency = 1
	tabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchers.BorderSizePixel = 0
	tabSwitchers.Size = UDim2.new(1, 0, 1, -107)

	local tabSwitchersScrollingFrame = Instance.new("ScrollingFrame")
	tabSwitchersScrollingFrame.Name = "TabSwitchersScrollingFrame"
	tabSwitchersScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabSwitchersScrollingFrame.BottomImage = ""
	tabSwitchersScrollingFrame.CanvasSize = UDim2.new()
	tabSwitchersScrollingFrame.ScrollBarImageTransparency = 0.8
	tabSwitchersScrollingFrame.ScrollBarThickness = 1
	tabSwitchersScrollingFrame.TopImage = ""
	tabSwitchersScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabSwitchersScrollingFrame.BackgroundTransparency = 1
	tabSwitchersScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	tabSwitchersScrollingFrame.BorderSizePixel = 0
	tabSwitchersScrollingFrame.Size = UDim2.fromScale(1, 1)

	local tabSwitchersScrollingFrameUIListLayout = Instance.new("UIListLayout")
	tabSwitchersScrollingFrameUIListLayout.Name = "TabSwitchersScrollingFrameUIListLayout"
	tabSwitchersScrollingFrameUIListLayout.Padding = UDim.new(0, 17)
	tabSwitchersScrollingFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabSwitchersScrollingFrameUIListLayout.Parent = tabSwitchersScrollingFrame

	local tabSwitchersScrollingFrameUIPadding = Instance.new("UIPadding")
	tabSwitchersScrollingFrameUIPadding.Name = "TabSwitchersScrollingFrameUIPadding"
	tabSwitchersScrollingFrameUIPadding.PaddingTop = UDim.new(0, 2)
	tabSwitchersScrollingFrameUIPadding.Parent = tabSwitchersScrollingFrame

	tabSwitchersScrollingFrame.Parent = tabSwitchers

	tabSwitchers.Parent = sidebarGroup

	sidebarGroup.Parent = sidebar

	sidebar.Parent = base

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.AnchorPoint = Vector2.new(1, 0)
	content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	content.BackgroundTransparency = 1
	content.BorderColor3 = Color3.fromRGB(0, 0, 0)
	content.BorderSizePixel = 0
	content.Position = UDim2.fromScale(1, 4.69e-08)
	content.Size = UDim2.new(0, (base.AbsoluteSize.X - sidebar.AbsoluteSize.X), 1, 0)

	local resizingContent = false
	local defaultSidebarWidth = sidebar.AbsoluteSize.X
	local initialMouseX, initialSidebarWidth
	local snapRange = 20
	local minSidebarWidth = 107
	local maxSidebarWidth = base.AbsoluteSize.X - minSidebarWidth

	local TweenSettings = {
		DefaultTransparency = 0.9,
		HoverTransparency = 0.85,

		EasingStyle = Enum.EasingStyle.Sine
	}

	local function ChangeState(State)
		Tween(divider, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
			BackgroundTransparency = State == "Idle" and TweenSettings.DefaultTransparency or TweenSettings.HoverTransparency
		}):Play()  
	end

	dividerInteract.MouseEnter:Connect(function()
		ChangeState("Hover")
	end)
	dividerInteract.MouseLeave:Connect(function()
		ChangeState("Idle")
	end)

	dividerInteract.MouseButton1Down:Connect(function()
		resizingContent = true
		initialMouseX = UserInputService:GetMouseLocation().X
		initialSidebarWidth = sidebar.AbsoluteSize.X
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizingContent = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizingContent and input.UserInputType == Enum.UserInputType.MouseMovement then
			local deltaX = UserInputService:GetMouseLocation().X - initialMouseX
			local newSidebarWidth = initialSidebarWidth + deltaX

			if math.abs(newSidebarWidth - defaultSidebarWidth) < snapRange then
				newSidebarWidth = defaultSidebarWidth
			else
				newSidebarWidth = math.clamp(newSidebarWidth, minSidebarWidth, maxSidebarWidth)
			end

			sidebar.Size = UDim2.new(0, newSidebarWidth, 1, 0)
			content.Size = UDim2.new(0, base.AbsoluteSize.X - newSidebarWidth, 1, 0)
		end
	end)

	local topbar = Instance.new("Frame")
	topbar.Name = "Topbar"
	topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	topbar.BackgroundTransparency = 1
	topbar.BorderColor3 = Color3.fromRGB(0, 0, 0)
	topbar.BorderSizePixel = 0
	topbar.Size = UDim2.new(1, 0, 0, 63)

	local divider4 = Instance.new("Frame")
	divider4.Name = "Divider"
	divider4.AnchorPoint = Vector2.new(0, 1)
	divider4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	divider4.BackgroundTransparency = 0.9
	divider4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	divider4.BorderSizePixel = 0
	divider4.Position = UDim2.fromScale(0, 1)
	divider4.Size = UDim2.new(1, 0, 0, 1)
	divider4.Parent = topbar

	local elements = Instance.new("Frame")
	elements.Name = "Elements"
	elements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	elements.BackgroundTransparency = 1
	elements.BorderColor3 = Color3.fromRGB(0, 0, 0)
	elements.BorderSizePixel = 0
	elements.Size = UDim2.fromScale(1, 1)

	local uIPadding2 = Instance.new("UIPadding")
	uIPadding2.Name = "UIPadding"
	uIPadding2.PaddingLeft = UDim.new(0, 20)
	uIPadding2.PaddingRight = UDim.new(0, 20)
	uIPadding2.Parent = elements

	local moveIcon = Instance.new("ImageButton")
	moveIcon.Name = "MoveIcon"
	moveIcon.Image = assets.transform
	moveIcon.ImageTransparency = 0.7
	moveIcon.AnchorPoint = Vector2.new(1, 0.5)
	moveIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	moveIcon.BackgroundTransparency = 1
	moveIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	moveIcon.BorderSizePixel = 0
	moveIcon.Position = UDim2.fromScale(1, 0.5)
	moveIcon.Size = UDim2.fromOffset(15, 15)
	moveIcon.Parent = elements
	moveIcon.Visible = not Settings.DragStyle or Settings.DragStyle == 1

	local interact = Instance.new("TextButton")
	interact.Name = "Interact"
	interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
	interact.Text = ""
	interact.TextColor3 = Color3.fromRGB(0, 0, 0)
	interact.TextSize = 14
	interact.AnchorPoint = Vector2.new(0.5, 0.5)
	interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	interact.BackgroundTransparency = 1
	interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
	interact.BorderSizePixel = 0
	interact.Position = UDim2.fromScale(0.5, 0.5)
	interact.Size = UDim2.fromOffset(40, 40)
	interact.Parent = moveIcon

	local function ChangemoveIconState(State)
		if State == "Default" then
			Tween(moveIcon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.7
			}):Play()
		elseif State == "Hover" then
			Tween(moveIcon, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {
				ImageTransparency = 0.4
			}):Play()
		end
	end

	interact.MouseEnter:Connect(function()
		ChangemoveIconState("Hover")
	end)
	interact.MouseLeave:Connect(function()
		ChangemoveIconState("Default")
	end)

	local dragging_ = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		base.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	local function onDragStart(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging_ = true
			dragStart = input.Position
			startPos = base.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging_ = false
				end
			end)
		end
	end

	local function onDragUpdate(input)
		if dragging_ and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			dragInput = input
		end
	end

	if not Settings.DragStyle or Settings.DragStyle == 1 then
		interact.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				onDragStart(input)
			end
		end)

		interact.InputChanged:Connect(onDragUpdate)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging_ then
				update(input)
			end
		end)

		interact.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging_ = false
			end
		end)
	elseif Settings.DragStyle == 2 then
		base.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				onDragStart(input)
			end
		end)

		base.InputChanged:Connect(onDragUpdate)

		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging_ then
				update(input)
			end
		end)

		base.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging_ = false
			end
		end)
	end

	local currentTab = Instance.new("TextLabel")
	currentTab.Name = "CurrentTab"
	currentTab.FontFace = Font.new(assets.interFont)
	currentTab.RichText = true
	currentTab.Text = ""
	currentTab.RichText = true
	currentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.TextSize = 15
	currentTab.TextTransparency = 0.5
	currentTab.TextTruncate = Enum.TextTruncate.SplitWord
	currentTab.TextXAlignment = Enum.TextXAlignment.Left
	currentTab.TextYAlignment = Enum.TextYAlignment.Top
	currentTab.AnchorPoint = Vector2.new(0, 0.5)
	currentTab.AutomaticSize = Enum.AutomaticSize.Y
	currentTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	currentTab.BackgroundTransparency = 1
	currentTab.BorderColor3 = Color3.fromRGB(0, 0, 0)
	currentTab.BorderSizePixel = 0
	currentTab.Position = UDim2.fromScale(0, 0.5)
	currentTab.Size = UDim2.fromScale(0.9, 0)
	currentTab.Parent = elements

	elements.Parent = topbar

	topbar.Parent = content

	content.Parent = base

	local globalSettings = Instance.new("Frame")
	globalSettings.Name = "GlobalSettings"
	globalSettings.AutomaticSize = Enum.AutomaticSize.XY
	globalSettings.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	globalSettings.BorderColor3 = Color3.fromRGB(0, 0, 0)
	globalSettings.BorderSizePixel = 0
	globalSettings.Position = UDim2.fromScale(0.298, 0.104)

	local globalSettingsUIStroke = Instance.new("UIStroke")
	globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
	globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
	globalSettingsUIStroke.Transparency = 0.9
	globalSettingsUIStroke.Parent = globalSettings

	local globalSettingsUICorner = Instance.new("UICorner")
	globalSettingsUICorner.Name = "GlobalSettingsUICorner"
	globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
	globalSettingsUICorner.Parent = globalSettings

	local globalSettingsUIPadding = Instance.new("UIPadding")
	globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
	globalSettingsUIPadding.PaddingBottom = UDim.new(0, 10)
	globalSettingsUIPadding.PaddingTop = UDim.new(0, 10)
	globalSettingsUIPadding.Parent = globalSettings

	local globalSettingsUIListLayout = Instance.new("UIListLayout")
	globalSettingsUIListLayout.Name = "GlobalSettingsUIListLayout"
	globalSettingsUIListLayout.Padding = UDim.new(0, 5)
	globalSettingsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	globalSettingsUIListLayout.Parent = globalSettings

	local globalSettingsUIScale = Instance.new("UIScale")
	globalSettingsUIScale.Name = "GlobalSettingsUIScale"
	globalSettingsUIScale.Scale = 1e-07
	globalSettingsUIScale.Parent = globalSettings
	globalSettings.Parent = base
	base.Parent = macLib

	function WindowFunctions:UpdateTitle(NewTitle)
		title.Text = NewTitle
	end

	function WindowFunctions:UpdateSubtitle(NewSubtitle)
		subtitle.Text = NewSubtitle
	end

	local hovering
	local toggled = globalSettingsUIScale.Scale == 1 and true or false
	local function toggle()
		if not toggled then
			local intween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 1
			})
			intween:Play()
			intween.Completed:Wait()
			toggled = true
		elseif toggled then
			local outtween = Tween(globalSettingsUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			})
			outtween:Play()
			outtween.Completed:Wait()
			toggled = false
		end
	end
	globalSettingsButton.MouseButton1Click:Connect(function()
		if not hasGlobalSetting then return end
		toggle()
	end)
	globalSettings.MouseEnter:Connect(function()
		hovering = true
	end)
	globalSettings.MouseLeave:Connect(function()
		hovering = false
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and toggled and not hovering then
			toggle()
		end
	end)

	local BlurTarget = base

	local HS = HttpService
	local camera = workspace.CurrentCamera
	local MTREL = "Glass"
	local binds = {}
	local wedgeguid = HS:GenerateGUID(true)

	local DepthOfField

	for _,v in pairs(Lighting:GetChildren()) do
		if not v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
			DepthOfField = Instance.new('DepthOfFieldEffect')
			DepthOfField.FarIntensity = 0
			DepthOfField.FocusDistance = 51.6
			DepthOfField.InFocusRadius = 50
			DepthOfField.NearIntensity = 1
			DepthOfField.Name = HS:GenerateGUID(true)
			DepthOfField:AddTag(".")
		elseif v:IsA("DepthOfFieldEffect") and v:HasTag(".") then
			DepthOfField = v
		end
	end

	if not DepthOfField then
		DepthOfField = Instance.new('DepthOfFieldEffect')
		DepthOfField.FarIntensity = 0
		DepthOfField.FocusDistance = 51.6
		DepthOfField.InFocusRadius = 50
		DepthOfField.NearIntensity = 1
		DepthOfField.Name = HS:GenerateGUID(true)
		DepthOfField:AddTag(".")
	end

	local frame = Instance.new('Frame')
	frame.Parent = BlurTarget
	frame.Size = UDim2.new(0.97, 0, 0.97, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundTransparency = 1
	frame.Name = HS:GenerateGUID(true)

	do
		local function IsNotNaN(x)
			return x == x
		end
		local continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		while not continue do
			RunService.RenderStepped:Wait()
			continue = IsNotNaN(camera:ScreenPointToRay(0,0).Origin.x)
		end
	end

	local DrawQuad; do
		local acos, max, pi, sqrt = math.acos, math.max, math.pi, math.sqrt
		local sz = 0.2

		local function DrawTriangle(v1, v2, v3, p0, p1)
			local s1 = (v1 - v2).magnitude
			local s2 = (v2 - v3).magnitude
			local s3 = (v3 - v1).magnitude
			local smax = max(s1, s2, s3)
			local A, B, C
			if s1 == smax then
				A, B, C = v1, v2, v3
			elseif s2 == smax then
				A, B, C = v2, v3, v1
			elseif s3 == smax then
				A, B, C = v3, v1, v2
			end

			local para = ( (B-A).x*(C-A).x + (B-A).y*(C-A).y + (B-A).z*(C-A).z ) / (A-B).magnitude
			local perp = sqrt((C-A).magnitude^2 - para*para)
			local dif_para = (A - B).magnitude - para

			local st = CFrame.new(B, A)
			local za = CFrame.Angles(pi/2,0,0)

			local cf0 = st

			local Top_Look = (cf0 * za).lookVector
			local Mid_Point = A + CFrame.new(A, B).lookVector * para
			local Needed_Look = CFrame.new(Mid_Point, C).lookVector
			local dot = Top_Look.x*Needed_Look.x + Top_Look.y*Needed_Look.y + Top_Look.z*Needed_Look.z

			local ac = CFrame.Angles(0, 0, acos(dot))

			cf0 = cf0 * ac
			if ((cf0 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf0 = cf0 * CFrame.Angles(0, 0, -2*acos(dot))
			end
			cf0 = cf0 * CFrame.new(0, perp/2, -(dif_para + para/2))

			local cf1 = st * ac * CFrame.Angles(0, pi, 0)
			if ((cf1 * za).lookVector - Needed_Look).magnitude > 0.01 then
				cf1 = cf1 * CFrame.Angles(0, 0, 2*acos(dot))
			end
			cf1 = cf1 * CFrame.new(0, perp/2, dif_para/2)

			if not p0 then
				p0 = Instance.new('Part')
				p0.FormFactor = 'Custom'
				p0.TopSurface = 0
				p0.BottomSurface = 0
				p0.Anchored = true
				p0.CanCollide = false
				p0.CastShadow = false
				p0.Material = MTREL
				p0.Size = Vector3.new(sz, sz, sz)
				p0.Name = HS:GenerateGUID(true)
				local mesh = Instance.new('SpecialMesh', p0)
				mesh.MeshType = 2
				mesh.Name = wedgeguid
			end
			p0[wedgeguid].Scale = Vector3.new(0, perp/sz, para/sz)
			p0.CFrame = cf0

			if not p1 then
				p1 = p0:clone()
			end
			p1[wedgeguid].Scale = Vector3.new(0, perp/sz, dif_para/sz)
			p1.CFrame = cf1

			return p0, p1
		end

		function DrawQuad(v1, v2, v3, v4, parts)
			parts[1], parts[2] = DrawTriangle(v1, v2, v3, parts[1], parts[2])
			parts[3], parts[4] = DrawTriangle(v3, v2, v4, parts[3], parts[4])
		end
	end

	if binds[frame] then
		return binds[frame].parts
	end

	local parts = {}

	local parents = {}
	do
		local function add(child)
			if child:IsA'GuiObject' then
				parents[#parents + 1] = child
				add(child.Parent)
			end
		end
		add(frame)
	end

	local function IsVisible(instance)
		while instance do
			if instance:IsA("GuiObject") then
				if not instance.Visible then
					return false
				end
			elseif instance:IsA("ScreenGui") then
				if not instance.Enabled then
					return false
				end
				break
			end
			instance = instance.Parent
		end
		return true
	end

	local function UpdateOrientation(fetchProps)
		if not IsVisible(frame) or not acrylicBlur or unloaded then
			for _, pt in pairs(parts) do
				pt.Parent = nil
				DepthOfField.Enabled = false
				DepthOfField.Parent = nil
			end
			return
		end
		if not DepthOfField.Parent then
			DepthOfField.Parent = Lighting
		end
		DepthOfField.Enabled = true
		local properties = {
			Transparency = 0.98;
			BrickColor = BrickColor.new('Institutional white');
		}
		local zIndex = 1 - 0.05*frame.ZIndex

		local tl, br = frame.AbsolutePosition, frame.AbsolutePosition + frame.AbsoluteSize
		local tr, bl = Vector2.new(br.x, tl.y), Vector2.new(tl.x, br.y)
		do
			local rot = 0;
			for _, v in ipairs(parents) do
				rot = rot + v.Rotation
			end
			if rot ~= 0 and rot%180 ~= 0 then
				local mid = tl:lerp(br, 0.5)
				local s, c = math.sin(math.rad(rot)), math.cos(math.rad(rot))
				local vec = tl
				tl = Vector2.new(c*(tl.x - mid.x) - s*(tl.y - mid.y), s*(tl.x - mid.x) + c*(tl.y - mid.y)) + mid
				tr = Vector2.new(c*(tr.x - mid.x) - s*(tr.y - mid.y), s*(tr.x - mid.x) + c*(tr.y - mid.y)) + mid
				bl = Vector2.new(c*(bl.x - mid.x) - s*(bl.y - mid.y), s*(bl.x - mid.x) + c*(bl.y - mid.y)) + mid
				br = Vector2.new(c*(br.x - mid.x) - s*(br.y - mid.y), s*(br.x - mid.x) + c*(br.y - mid.y)) + mid
			end
		end
		DrawQuad(
			camera:ScreenPointToRay(tl.x, tl.y, zIndex).Origin, 
			camera:ScreenPointToRay(tr.x, tr.y, zIndex).Origin, 
			camera:ScreenPointToRay(bl.x, bl.y, zIndex).Origin, 
			camera:ScreenPointToRay(br.x, br.y, zIndex).Origin, 
			parts
		)
		if fetchProps then
			for _, pt in pairs(parts) do
				pt.Parent = camera
			end
			for propName, propValue in pairs(properties) do
				for _, pt in pairs(parts) do
					pt[propName] = propValue
				end
			end
		end
	end

	UpdateOrientation(true)

	RunService.RenderStepped:Connect(UpdateOrientation)

	function WindowFunctions:GlobalSetting(Settings)
		hasGlobalSetting = true
		local GlobalSettingFunctions = {}
		local globalSetting = Instance.new("TextButton")
		globalSetting.Name = "GlobalSetting"
		globalSetting.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
		globalSetting.Text = ""
		globalSetting.TextColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.TextSize = 14
		globalSetting.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		globalSetting.BackgroundTransparency = 1
		globalSetting.BorderColor3 = Color3.fromRGB(0, 0, 0)
		globalSetting.BorderSizePixel = 0
		globalSetting.Size = UDim2.fromOffset(200, 30)

		local globalSettingToggleUIPadding = Instance.new("UIPadding")
		globalSettingToggleUIPadding.Name = "GlobalSettingToggleUIPadding"
		globalSettingToggleUIPadding.PaddingLeft = UDim.new(0, 15)
		globalSettingToggleUIPadding.Parent = globalSetting

		local settingName = Instance.new("TextLabel")
		settingName.Name = "SettingName"
		settingName.FontFace = Font.new(assets.interFont)
		settingName.Text = Settings.Name
		settingName.RichText = true
		settingName.TextColor3 = Color3.fromRGB(255, 255, 255)
		settingName.TextSize = 13
		settingName.TextTransparency = 0.5
		settingName.TextTruncate = Enum.TextTruncate.SplitWord
		settingName.TextXAlignment = Enum.TextXAlignment.Left
		settingName.TextYAlignment = Enum.TextYAlignment.Top
		settingName.AnchorPoint = Vector2.new(0, 0.5)
		settingName.AutomaticSize = Enum.AutomaticSize.Y
		settingName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		settingName.BackgroundTransparency = 1
		settingName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		settingName.BorderSizePixel = 0
		settingName.Position = UDim2.fromScale(1.3e-07, 0.5)
		settingName.Size = UDim2.new(1,-40,0,0)
		settingName.Parent = globalSetting

		local globalSettingToggleUIListLayout = Instance.new("UIListLayout")
		globalSettingToggleUIListLayout.Name = "GlobalSettingToggleUIListLayout"
		globalSettingToggleUIListLayout.Padding = UDim.new(0, 10)
		globalSettingToggleUIListLayout.FillDirection = Enum.FillDirection.Horizontal
		globalSettingToggleUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		globalSettingToggleUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		globalSettingToggleUIListLayout.Parent = globalSetting

		local checkmark = Instance.new("TextLabel")
		checkmark.Name = "Checkmark"
		checkmark.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		checkmark.Text = "âœ“"
		checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.TextSize = 13
		checkmark.TextTransparency = 1
		checkmark.TextXAlignment = Enum.TextXAlignment.Left
		checkmark.TextYAlignment = Enum.TextYAlignment.Top
		checkmark.AnchorPoint = Vector2.new(0, 0.5)
		checkmark.AutomaticSize = Enum.AutomaticSize.Y
		checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		checkmark.BackgroundTransparency = 1
		checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		checkmark.BorderSizePixel = 0
		checkmark.LayoutOrder = -1
		checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
		checkmark.Size = UDim2.fromOffset(-10, 0)
		checkmark.Parent = globalSetting

		globalSetting.Parent = globalSettings

		local tweensettings = {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quint,
			transparencyIn = 0.2,
			transparencyOut = 0.5,
			checkSizeIncrease = 12,
			checkSizeDecrease = -globalSettingToggleUIListLayout.Padding.Offset,
			waitTime = 1
		}

		local tweens = {
			checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
			}),
			nameIn = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyIn
			}),
			nameOut = Tween(settingName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
				TextTransparency = tweensettings.transparencyOut
			})
		}

		local function Toggle(State)
			if not State then
				tweens.checkOut:Play()
				tweens.nameOut:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X <= 0 then
						checkmark.TextTransparency = 1
					end
				end)
			else
				tweens.checkIn:Play()
				tweens.nameIn:Play()
				checkmark:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					if checkmark.AbsoluteSize.X > 0 then
						checkmark.TextTransparency = 0
					end
				end)
			end
		end

		local toggled = Settings.Default
		Toggle(toggled)

		globalSetting.MouseButton1Click:Connect(function()
			toggled = not toggled
			Toggle(toggled)

			task.spawn(function()
				if Settings.Callback then
					Settings.Callback(toggled)
				end
			end)
		end)

		function GlobalSettingFunctions:UpdateName(NewName)
			settingName.Text = NewName
		end

		function GlobalSettingFunctions:UpdateState(NewState)
			Toggle(NewState)
			toggled = NewState
		end

		return GlobalSettingFunctions
	end

	function WindowFunctions:TabGroup()
		local SectionFunctions = {}

		local tabGroup = Instance.new("Frame")
		tabGroup.Name = "Section"
		tabGroup.AutomaticSize = Enum.AutomaticSize.Y
		tabGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		tabGroup.BackgroundTransparency = 1
		tabGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
		tabGroup.BorderSizePixel = 0
		tabGroup.Size = UDim2.fromScale(1, 0)

		local divider3 = Instance.new("Frame")
		divider3.Name = "Divider"
		divider3.AnchorPoint = Vector2.new(0.5, 1)
		divider3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		divider3.BackgroundTransparency = 0.9
		divider3.BorderColor3 = Color3.fromRGB(0, 0, 0)
		divider3.BorderSizePixel = 0
		divider3.Position = UDim2.fromScale(0.5, 1)
		divider3.Size = UDim2.new(1, -21, 0, 1)
		divider3.Parent = tabGroup

		local sectionTabSwitchers = Instance.new("Frame")
		sectionTabSwitchers.Name = "SectionTabSwitchers"
		sectionTabSwitchers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		sectionTabSwitchers.BackgroundTransparency = 1
		sectionTabSwitchers.BorderColor3 = Color3.fromRGB(0, 0, 0)
		sectionTabSwitchers.BorderSizePixel = 0
		sectionTabSwitchers.Size = UDim2.fromScale(1, 1)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 15)
		uIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = sectionTabSwitchers

		local uIPadding1 = Instance.new("UIPadding")
		uIPadding1.Name = "UIPadding"
		uIPadding1.PaddingBottom = UDim.new(0, 15)
		uIPadding1.Parent = sectionTabSwitchers

		sectionTabSwitchers.Parent = tabGroup
		tabGroup.Parent = tabSwitchersScrollingFrame

		function SectionFunctions:Tab(Settings)
			local TabFunctions = {Settings = Settings}
			local tabSwitcher = Instance.new("TextButton")
			tabSwitcher.Name = "TabSwitcher"
			tabSwitcher.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
			tabSwitcher.Text = ""
			tabSwitcher.TextColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.TextSize = 14
			tabSwitcher.AutoButtonColor = false
			tabSwitcher.AnchorPoint = Vector2.new(0.5, 0)
			tabSwitcher.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcher.BackgroundTransparency = 1
			tabSwitcher.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcher.BorderSizePixel = 0
			tabSwitcher.Position = UDim2.fromScale(0.5, 0)
			tabSwitcher.Size = UDim2.new(1, -21, 0, 40)

			tabIndex += 1
			tabSwitcher.LayoutOrder = tabIndex

			local tabSwitcherUICorner = Instance.new("UICorner")
			tabSwitcherUICorner.Name = "TabSwitcherUICorner"
			tabSwitcherUICorner.Parent = tabSwitcher

			local tabSwitcherUIStroke = Instance.new("UIStroke")
			tabSwitcherUIStroke.Name = "TabSwitcherUIStroke"
			tabSwitcherUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			tabSwitcherUIStroke.Color = Color3.fromRGB(255, 255, 255)
			tabSwitcherUIStroke.Transparency = 1
			tabSwitcherUIStroke.Parent = tabSwitcher

			local tabSwitcherUIListLayout = Instance.new("UIListLayout")
			tabSwitcherUIListLayout.Name = "TabSwitcherUIListLayout"
			tabSwitcherUIListLayout.Padding = UDim.new(0, 9)
			tabSwitcherUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			tabSwitcherUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tabSwitcherUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			tabSwitcherUIListLayout.Parent = tabSwitcher

			local tabImage

			if Settings.Image then
				tabImage = Instance.new("ImageLabel")
				tabImage.Name = "TabImage"
				tabImage.Image = Settings.Image
				tabImage.ImageTransparency = 0.5
				tabImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				tabImage.BackgroundTransparency = 1
				tabImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
				tabImage.BorderSizePixel = 0
				tabImage.Size = UDim2.fromOffset(18, 18)
				tabImage.Parent = tabSwitcher
			end

			local tabSwitcherName = Instance.new("TextLabel")
			tabSwitcherName.Name = "TabSwitcherName"
			tabSwitcherName.FontFace = Font.new(
				assets.interFont,
				Enum.FontWeight.Medium,
				Enum.FontStyle.Normal
			)
			tabSwitcherName.Text = Settings.Name
			tabSwitcherName.RichText = true
			tabSwitcherName.TextColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.TextSize = 16
			tabSwitcherName.TextTransparency = 0.5
			tabSwitcherName.TextTruncate = Enum.TextTruncate.SplitWord
			tabSwitcherName.TextXAlignment = Enum.TextXAlignment.Left
			tabSwitcherName.TextYAlignment = Enum.TextYAlignment.Top
			tabSwitcherName.AutomaticSize = Enum.AutomaticSize.Y
			tabSwitcherName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			tabSwitcherName.BackgroundTransparency = 1
			tabSwitcherName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			tabSwitcherName.BorderSizePixel = 0
			tabSwitcherName.Size = UDim2.fromScale(1, 0)
			tabSwitcherName.Parent = tabSwitcher
			tabSwitcherName.LayoutOrder = 1

			local tabSwitcherUIPadding = Instance.new("UIPadding")
			tabSwitcherUIPadding.Name = "TabSwitcherUIPadding"
			tabSwitcherUIPadding.PaddingLeft = UDim.new(0, 24)
			tabSwitcherUIPadding.PaddingRight = UDim.new(0, 35)
			tabSwitcherUIPadding.PaddingTop = UDim.new(0, 1)
			tabSwitcherUIPadding.Parent = tabSwitcher

			tabSwitcher.Parent = sectionTabSwitchers

			local elements1 = Instance.new("Frame")
			elements1.Name = "Elements"
			elements1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elements1.BackgroundTransparency = 1
			elements1.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elements1.BorderSizePixel = 0
			elements1.Position = UDim2.fromOffset(0, 63)
			elements1.Size = UDim2.new(1, 0, 1, -63)
			elements1.ClipsDescendants = true

			local elementsUIPadding = Instance.new("UIPadding")
			elementsUIPadding.Name = "ElementsUIPadding"
			elementsUIPadding.PaddingRight = UDim.new(0, 5)
			elementsUIPadding.PaddingTop = UDim.new(0, 10)
			elementsUIPadding.PaddingBottom = UDim.new(0, 10)
			elementsUIPadding.Parent = elements1

			local elementsScrolling = Instance.new("ScrollingFrame")
			elementsScrolling.Name = "ElementsScrolling"
			elementsScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
			elementsScrolling.BottomImage = ""
			elementsScrolling.CanvasSize = UDim2.new()
			elementsScrolling.ScrollBarImageTransparency = 0.5
			elementsScrolling.ScrollBarThickness = 1
			elementsScrolling.TopImage = ""
			elementsScrolling.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			elementsScrolling.BackgroundTransparency = 1
			elementsScrolling.BorderColor3 = Color3.fromRGB(0, 0, 0)
			elementsScrolling.BorderSizePixel = 0
			elementsScrolling.Size = UDim2.fromScale(1, 1)
			elementsScrolling.ClipsDescendants = false

			local elementsScrollingUIPadding = Instance.new("UIPadding")
			elementsScrollingUIPadding.Name = "ElementsScrollingUIPadding"
			elementsScrollingUIPadding.PaddingBottom = UDim.new(0, 5)
			elementsScrollingUIPadding.PaddingLeft = UDim.new(0, 11)
			elementsScrollingUIPadding.PaddingRight = UDim.new(0, 3)
			elementsScrollingUIPadding.PaddingTop = UDim.new(0, 5)
			elementsScrollingUIPadding.Parent = elementsScrolling

			local elementsScrollingUIListLayout = Instance.new("UIListLayout")
			elementsScrollingUIListLayout.Name = "ElementsScrollingUIListLayout"
			elementsScrollingUIListLayout.Padding = UDim.new(0, 15)
			elementsScrollingUIListLayout.FillDirection = Enum.FillDirection.Horizontal
			elementsScrollingUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			elementsScrollingUIListLayout.Parent = elementsScrolling

			local left = Instance.new("Frame")
			left.Name = "Left"
			left.AutomaticSize = Enum.AutomaticSize.Y
			left.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			left.BackgroundTransparency = 1
			left.BorderColor3 = Color3.fromRGB(0, 0, 0)
			left.BorderSizePixel = 0
			left.Position = UDim2.fromScale(0.512, 0)
			left.Size = UDim2.new(0.5, -10, 0, 0)

			local leftUIListLayout = Instance.new("UIListLayout")
			leftUIListLayout.Name = "LeftUIListLayout"
			leftUIListLayout.Padding = UDim.new(0, 15)
			leftUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			leftUIListLayout.Parent = left

			left.Parent = elementsScrolling

			local right = Instance.new("Frame")
			right.Name = "Right"
			right.AutomaticSize = Enum.AutomaticSize.Y
			right.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			right.BackgroundTransparency = 1
			right.BorderColor3 = Color3.fromRGB(0, 0, 0)
			right.BorderSizePixel = 0
			right.LayoutOrder = 1
			right.Position = UDim2.fromScale(0.512, 0)
			right.Size = UDim2.new(0.5, -10, 0, 0)

			local rightUIListLayout = Instance.new("UIListLayout")
			rightUIListLayout.Name = "RightUIListLayout"
			rightUIListLayout.Padding = UDim.new(0, 15)
			rightUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			rightUIListLayout.Parent = right

			right.Parent = elementsScrolling

			elementsScrolling.Parent = elements1

			function TabFunctions:Section(Settings)
				local SectionFunctions = {}
				local section = Instance.new("Frame")
				section.Name = "Section"
				section.AutomaticSize = Enum.AutomaticSize.Y
				section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				section.BackgroundTransparency = 0.98
				section.BorderColor3 = Color3.fromRGB(0, 0, 0)
				section.BorderSizePixel = 0
				section.Position = UDim2.fromScale(0, 6.78e-08)
				section.Size = UDim2.fromScale(1, 0)
				section.ClipsDescendants = true
				section.Parent = Settings.Side == "Left" and left or right

				local sectionUICorner = Instance.new("UICorner")
				sectionUICorner.Name = "SectionUICorner"
				sectionUICorner.Parent = section

				local sectionUIStroke = Instance.new("UIStroke")
				sectionUIStroke.Name = "SectionUIStroke"
				sectionUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				sectionUIStroke.Color = Color3.fromRGB(255, 255, 255)
				sectionUIStroke.Transparency = 0.95
				sectionUIStroke.Parent = section

				local sectionUIListLayout = Instance.new("UIListLayout")
				sectionUIListLayout.Name = "SectionUIListLayout"
				sectionUIListLayout.Padding = UDim.new(0, 10)
				sectionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				sectionUIListLayout.Parent = section

				local sectionUIPadding = Instance.new("UIPadding")
				sectionUIPadding.Name = "SectionUIPadding"
				sectionUIPadding.PaddingBottom = UDim.new(0, 20)
				sectionUIPadding.PaddingLeft = UDim.new(0, 20)
				sectionUIPadding.PaddingRight = UDim.new(0, 18)
				sectionUIPadding.PaddingTop = UDim.new(0, 22)
				sectionUIPadding.Parent = section

				function SectionFunctions:Button(Settings, Flag)
					local ButtonFunctions = {Settings = Settings}
					local button = Instance.new("Frame")
					button.Name = "Button"
					button.AutomaticSize = Enum.AutomaticSize.Y
					button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					button.BackgroundTransparency = 1
					button.BorderColor3 = Color3.fromRGB(0, 0, 0)
					button.BorderSizePixel = 0
					button.Size = UDim2.new(1, 0, 0, 38)
					button.Parent = section

					local buttonInteract = Instance.new("TextButton")
					buttonInteract.Name = "ButtonInteract"
					buttonInteract.FontFace = Font.new(assets.interFont)
					buttonInteract.RichText = true
					buttonInteract.TextColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.TextSize = 13
					buttonInteract.TextTransparency = 0.5
					buttonInteract.TextTruncate = Enum.TextTruncate.AtEnd
					buttonInteract.TextXAlignment = Enum.TextXAlignment.Left
					buttonInteract.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonInteract.BackgroundTransparency = 1
					buttonInteract.BorderColor3 = Color3.fromRGB(0, 0, 0)
					buttonInteract.BorderSizePixel = 0
					buttonInteract.Size = UDim2.fromScale(1, 1)
					buttonInteract.Parent = button
					buttonInteract.Text = ButtonFunctions.Settings.Name

					local buttonImage = Instance.new("ImageLabel")
					buttonImage.Name = "ButtonImage"
					buttonImage.Image = assets.buttonImage
					buttonImage.ImageTransparency = 0.5
					buttonImage.AnchorPoint = Vector2.new(1, 0.5)
					buttonImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					buttonImage.BackgroundTransparency = 1
					buttonImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					buttonImage.BorderSizePixel = 0
					buttonImage.Position = UDim2.fromScale(1, 0.5)
					buttonImage.Size = UDim2.fromOffset(15, 15)
					buttonImage.Parent = button

					local TweenSettings = {
						DefaultTransparency = 0.5,
						HoverTransparency = 0.3,

						EasingStyle = Enum.EasingStyle.Sine
					}

					local function ChangeState(State)
						if State == "Idle" then
							Tween(buttonInteract, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								TextTransparency = TweenSettings.DefaultTransparency
							}):Play()
							Tween(buttonImage, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								ImageTransparency = TweenSettings.DefaultTransparency
							}):Play()
						elseif State == "Hover" then
							Tween(buttonInteract, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								TextTransparency = TweenSettings.HoverTransparency
							}):Play()
							Tween(buttonImage, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
								ImageTransparency = TweenSettings.HoverTransparency
							}):Play()
						end
					end

					local function Callback()
						if ButtonFunctions.Settings.Callback then
							ButtonFunctions.Settings.Callback()
						end
					end

					buttonInteract.MouseEnter:Connect(function()
						ChangeState("Hover")
					end)
					buttonInteract.MouseLeave:Connect(function()
						ChangeState("Idle")
					end)

					buttonInteract.MouseButton1Click:Connect(Callback)
					function ButtonFunctions:UpdateName(Name)
						buttonInteract.Text = Name
					end
					function ButtonFunctions:SetVisibility(State)
						button.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ButtonFunctions
					end
					return ButtonFunctions
				end

				function SectionFunctions:Toggle(Settings, Flag)
					local ToggleFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Toggle" }
					local toggle = Instance.new("Frame")
					toggle.Name = "Toggle"
					toggle.AutomaticSize = Enum.AutomaticSize.Y
					toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					toggle.BackgroundTransparency = 1
					toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
					toggle.BorderSizePixel = 0
					toggle.Size = UDim2.new(1, 0, 0, 38)
					toggle.Parent = section

					local toggleName = Instance.new("TextLabel")
					toggleName.Name = "ToggleName"
					toggleName.FontFace = Font.new(assets.interFont)
					toggleName.Text = ToggleFunctions.Settings.Name
					toggleName.RichText = true
					toggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
					toggleName.TextSize = 13
					toggleName.TextTransparency = 0.5
					toggleName.TextTruncate = Enum.TextTruncate.AtEnd
					toggleName.TextXAlignment = Enum.TextXAlignment.Left
					toggleName.TextYAlignment = Enum.TextYAlignment.Top
					toggleName.AnchorPoint = Vector2.new(0, 0.5)
					toggleName.AutomaticSize = Enum.AutomaticSize.Y
					toggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					toggleName.BackgroundTransparency = 1
					toggleName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					toggleName.BorderSizePixel = 0
					toggleName.Position = UDim2.fromScale(0, 0.5)
					toggleName.Size = UDim2.new(1, -50, 0, 0)
					toggleName.Parent = toggle

					local toggle1 = Instance.new("ImageButton")
					toggle1.Name = "Toggle"
					toggle1.Image = assets.toggleBackground
					toggle1.ImageColor3 = Color3.fromRGB(87, 86, 86)
					toggle1.AutoButtonColor = false
					toggle1.AnchorPoint = Vector2.new(1, 0.5)
					toggle1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					toggle1.BackgroundTransparency = 1
					toggle1.BorderColor3 = Color3.fromRGB(0, 0, 0)
					toggle1.BorderSizePixel = 0
					toggle1.Position = UDim2.fromScale(1, 0.5)
					toggle1.Size = UDim2.fromOffset(41, 21)
					toggle1.ImageTransparency = 0.5

					local toggleUIPadding = Instance.new("UIPadding")
					toggleUIPadding.Name = "ToggleUIPadding"
					toggleUIPadding.PaddingBottom = UDim.new(0, 1)
					toggleUIPadding.PaddingLeft = UDim.new(0, -2)
					toggleUIPadding.PaddingRight = UDim.new(0, 3)
					toggleUIPadding.PaddingTop = UDim.new(0, 1)
					toggleUIPadding.Parent = toggle1

					local togglerHead = Instance.new("ImageLabel")
					togglerHead.Name = "TogglerHead"
					togglerHead.Image = assets.togglerHead
					togglerHead.ImageColor3 = Color3.fromRGB(255, 255, 255)
					togglerHead.AnchorPoint = Vector2.new(1, 0.5)
					togglerHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					togglerHead.BackgroundTransparency = 1
					togglerHead.BorderColor3 = Color3.fromRGB(0, 0, 0)
					togglerHead.BorderSizePixel = 0
					togglerHead.Position = UDim2.fromScale(0.5, 0.5)
					togglerHead.Size = UDim2.fromOffset(15, 15)
					togglerHead.ZIndex = 2
					togglerHead.Parent = toggle1
					togglerHead.ImageTransparency = 0.8

					toggle1.Parent = toggle

					local toggle1Transparency = {Enabled = 0, Disabled = 0.5}
					local togglerHeadTransparency = {Enabled = 0, Disabled = 0.85}

					local TweenSettings = {
						Info = TweenInfo.new(0.15, Enum.EasingStyle.Quad),

						EnabledPosition = UDim2.new(1, 0, 0.5, 0),
						DisabledPosition = UDim2.new(0.5, 0, 0.5, 0),
					}

					local togglebool = ToggleFunctions.Settings.Default

					local function NewState(State, callback)
						local transparencyValues = State and {toggle1Transparency.Enabled, togglerHeadTransparency.Enabled}
							or {toggle1Transparency.Disabled, togglerHeadTransparency.Disabled}
						local position = State and TweenSettings.EnabledPosition or TweenSettings.DisabledPosition

						Tween(toggle1, TweenSettings.Info, {
							ImageTransparency = transparencyValues[1]
						}):Play()

						Tween(togglerHead, TweenSettings.Info, {
							ImageTransparency = transparencyValues[2]
						}):Play()

						Tween(togglerHead, TweenSettings.Info, {
							Position = position
						}):Play()

						ToggleFunctions.State = State
						if callback then
							callback(togglebool)
						end
					end

					NewState(togglebool)

					local function Toggle()
						togglebool = not togglebool
						NewState(togglebool, ToggleFunctions.Settings.Callback)
					end

					toggle1.MouseButton1Click:Connect(Toggle)

					function ToggleFunctions:Toggle()
						Toggle()
					end
					function ToggleFunctions:UpdateState(State)
						togglebool = State
						NewState(togglebool, ToggleFunctions.Settings.Callback)
					end
					function ToggleFunctions:GetState()
						return togglebool
					end
					function ToggleFunctions:UpdateName(Name)
						toggleName.Text = Name
					end
					function ToggleFunctions:SetVisibility(State)
						toggle.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ToggleFunctions
					end
					return ToggleFunctions
				end

				function SectionFunctions:Slider(Settings, Flag)
					local SliderFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Slider" }
					local slider = Instance.new("Frame")
					slider.Name = "Slider"
					slider.AutomaticSize = Enum.AutomaticSize.Y
					slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					slider.BackgroundTransparency = 1
					slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
					slider.BorderSizePixel = 0
					slider.Size = UDim2.new(1, 0, 0, 38)
					slider.Parent = section

					local sliderName = Instance.new("TextLabel")
					sliderName.Name = "SliderName"
					sliderName.FontFace = Font.new(assets.interFont)
					sliderName.Text = SliderFunctions.Settings.Name
					sliderName.RichText = true
					sliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
					sliderName.TextSize = 13
					sliderName.TextTransparency = 0.5
					sliderName.TextTruncate = Enum.TextTruncate.AtEnd
					sliderName.TextXAlignment = Enum.TextXAlignment.Left
					sliderName.TextYAlignment = Enum.TextYAlignment.Top
					sliderName.AnchorPoint = Vector2.new(0, 0.5)
					sliderName.AutomaticSize = Enum.AutomaticSize.XY
					sliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderName.BackgroundTransparency = 1
					sliderName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderName.BorderSizePixel = 0
					sliderName.Position = UDim2.fromScale(1.3e-07, 0.5)
					sliderName.Parent = slider

					local sliderElements = Instance.new("Frame")
					sliderElements.Name = "SliderElements"
					sliderElements.AnchorPoint = Vector2.new(1, 0)
					sliderElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderElements.BackgroundTransparency = 1
					sliderElements.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderElements.BorderSizePixel = 0
					sliderElements.Position = UDim2.fromScale(1, 0)
					sliderElements.Size = UDim2.fromScale(1, 1)

					local sliderValue = Instance.new("TextBox")
					sliderValue.Name = "SliderValue"
					sliderValue.FontFace = Font.new(assets.interFont)
					sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
					sliderValue.TextSize = 12
					sliderValue.TextTransparency = 0.1
					--sliderValue.TextTruncate = Enum.TextTruncate.AtEnd
					sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderValue.BackgroundTransparency = 0.95
					sliderValue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderValue.BorderSizePixel = 0
					sliderValue.LayoutOrder = 1
					sliderValue.Position = UDim2.fromScale(-0.0789, 0.171)
					sliderValue.Size = UDim2.fromOffset(41, 21)
					sliderValue.ClipsDescendants = true

					local sliderValueUICorner = Instance.new("UICorner")
					sliderValueUICorner.Name = "SliderValueUICorner"
					sliderValueUICorner.CornerRadius = UDim.new(0, 4)
					sliderValueUICorner.Parent = sliderValue

					local sliderValueUIStroke = Instance.new("UIStroke")
					sliderValueUIStroke.Name = "SliderValueUIStroke"
					sliderValueUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					sliderValueUIStroke.Color = Color3.fromRGB(255, 255, 255)
					sliderValueUIStroke.Transparency = 0.9
					sliderValueUIStroke.Parent = sliderValue

					local sliderValueUIPadding = Instance.new("UIPadding")
					sliderValueUIPadding.Name = "SliderValueUIPadding"
					sliderValueUIPadding.PaddingLeft = UDim.new(0, 2)
					sliderValueUIPadding.PaddingRight = UDim.new(0, 2)
					sliderValueUIPadding.Parent = sliderValue

					sliderValue.Parent = sliderElements

					local sliderElementsUIListLayout = Instance.new("UIListLayout")
					sliderElementsUIListLayout.Name = "SliderElementsUIListLayout"
					sliderElementsUIListLayout.Padding = UDim.new(0, 20)
					sliderElementsUIListLayout.FillDirection = Enum.FillDirection.Horizontal
					sliderElementsUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
					sliderElementsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					sliderElementsUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					sliderElementsUIListLayout.Parent = sliderElements

					local sliderBar = Instance.new("ImageLabel")
					sliderBar.Name = "SliderBar"
					sliderBar.Image = assets.sliderbar
					sliderBar.ImageColor3 = Color3.fromRGB(87, 86, 86)
					sliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderBar.BackgroundTransparency = 1
					sliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderBar.BorderSizePixel = 0
					sliderBar.Position = UDim2.fromScale(0.219, 0.457)
					sliderBar.Size = UDim2.fromOffset(123, 3)

					local sliderHead = Instance.new("ImageButton")
					sliderHead.Name = "SliderHead"
					sliderHead.Image = assets.sliderhead
					sliderHead.AnchorPoint = Vector2.new(0.5, 0.5)
					sliderHead.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sliderHead.BackgroundTransparency = 1
					sliderHead.BorderColor3 = Color3.fromRGB(0, 0, 0)
					sliderHead.BorderSizePixel = 0
					sliderHead.Position = UDim2.fromScale(1, 0.5)
					sliderHead.Size = UDim2.fromOffset(12, 12)
					sliderHead.Parent = sliderBar

					sliderBar.Parent = sliderElements

					local sliderElementsUIPadding = Instance.new("UIPadding")
					sliderElementsUIPadding.Name = "SliderElementsUIPadding"
					sliderElementsUIPadding.PaddingTop = UDim.new(0, 3)
					sliderElementsUIPadding.Parent = sliderElements

					sliderElements.Parent = slider

					local dragging = false

					local DisplayMethods = {
						Hundredths = function(sliderValue) -- Deprecated use Settings.Precision
							return string.format("%.2f", sliderValue)
						end,
						Tenths = function(sliderValue) -- Deprecated use Settings.Precision
							return string.format("%.1f", sliderValue)
						end,
						Round = function(sliderValue, precision)
							if precision then
								return string.format("%." .. precision .. "f", sliderValue)
							else
								return tostring(math.round(sliderValue))
							end
						end,
						Degrees = function(sliderValue, precision)
							local formattedValue = precision and string.format("%." .. precision .. "f", sliderValue) or tostring(sliderValue)
							return formattedValue .. "Â°"
						end,
						Percent = function(sliderValue, precision)
							local percentage = (sliderValue - SliderFunctions.Settings.Minimum) / (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum) * 100
							return precision and string.format("%." .. precision .. "f", percentage) .. "%" or tostring(math.round(percentage)) .. "%"
						end,
						Value = function(sliderValue, precision)
							return precision and string.format("%." .. precision .. "f", sliderValue) or tostring(sliderValue)
						end
					}

					local ValueDisplayMethod = DisplayMethods[SliderFunctions.Settings.DisplayMethod] or DisplayMethods.Value
					local finalValue

					local function SetValue(val, ignorecallback)
						local posXScale

						if typeof(val) == "Instance" then
							local input = val
							posXScale = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
						else
							local value = val
							posXScale = (value - SliderFunctions.Settings.Minimum) / (SliderFunctions.Settings.Maximum - Settings.Minimum)
						end

						local pos = UDim2.new(posXScale, 0, 0.5, 0)
						sliderHead.Position = pos

						finalValue = posXScale * (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum) + Settings.Minimum

						sliderValue.Text = (Settings.Prefix or "") .. ValueDisplayMethod(finalValue, SliderFunctions.Settings.Precision) .. (Settings.Suffix or "")

						if not ignorecallback then
							task.spawn(function()
								if SliderFunctions.Settings.Callback then
									SliderFunctions.Settings.Callback(finalValue)
								end
							end)
						end

						SliderFunctions.Value = finalValue
					end

					SetValue(SliderFunctions.Settings.Default, true)

					sliderHead.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = true
							SetValue(input)
						end
					end)

					sliderHead.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							dragging = false
							if SliderFunctions.Settings.onInputComplete then
								SliderFunctions.Settings.onInputComplete(finalValue)
							end
						end
					end)

					sliderValue.FocusLost:Connect(function(enterPressed)
						local inputText = sliderValue.Text
						local value, isPercent = inputText:match("^(%-?%d+%.?%d*)(%%?)$")

						if value then
							value = tonumber(value)
							isPercent = isPercent == "%"

							if isPercent then
								value = SliderFunctions.Settings.Minimum + (value / 100) * (SliderFunctions.Settings.Maximum - SliderFunctions.Settings.Minimum)
							end

							local newValue = math.clamp(value, SliderFunctions.Settings.Minimum, SliderFunctions.Settings.Maximum)
							SetValue(newValue)
						else
							sliderValue.Text = ValueDisplayMethod(sliderValue)
						end

						if SliderFunctions.Settings.onInputComplete then
							SliderFunctions.Settings.onInputComplete(finalValue)
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
							SetValue(input)
						end
					end)

					local function updateSliderBarSize()
						local padding = sliderElementsUIListLayout.Padding.Offset
						local sliderValueWidth = sliderValue.AbsoluteSize.X
						local sliderNameWidth = sliderName.AbsoluteSize.X
						local totalWidth = sliderElements.AbsoluteSize.X

						local newBarWidth = (totalWidth - (padding + sliderValueWidth + sliderNameWidth + 20)) / baseUIScale.Scale
						sliderBar.Size = UDim2.new(sliderBar.Size.X.Scale, newBarWidth, sliderBar.Size.Y.Scale, sliderBar.Size.Y.Offset)
					end

					updateSliderBarSize()

					sliderName:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSliderBarSize)
					section:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSliderBarSize)

					function SliderFunctions:UpdateName(Name)
						sliderName = Name
					end
					function SliderFunctions:SetVisibility(State)
						slider.Visible = State
					end
					function SliderFunctions:UpdateValue(Value)
						SetValue(tonumber(Value), true)
					end
					function SliderFunctions:GetValue()
						return finalValue
					end

					if Flag then
						MacLib.Options[Flag] = SliderFunctions
					end
					return SliderFunctions
				end

				function SectionFunctions:Input(Settings, Flag)
					local InputFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Input" }
					local input = Instance.new("Frame")
					input.Name = "Input"
					input.AutomaticSize = Enum.AutomaticSize.Y
					input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					input.BackgroundTransparency = 1
					input.BorderColor3 = Color3.fromRGB(0, 0, 0)
					input.BorderSizePixel = 0
					input.Size = UDim2.new(1, 0, 0, 38)
					input.Parent = section

					local inputName = Instance.new("TextLabel")
					inputName.Name = "InputName"
					inputName.FontFace = Font.new(assets.interFont)
					inputName.Text = InputFunctions.Settings.Name
					inputName.RichText = true
					inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName.TextSize = 13
					inputName.TextTransparency = 0.5
					inputName.TextTruncate = Enum.TextTruncate.AtEnd
					inputName.TextXAlignment = Enum.TextXAlignment.Left
					inputName.TextYAlignment = Enum.TextYAlignment.Top
					inputName.AnchorPoint = Vector2.new(0, 0.5)
					inputName.AutomaticSize = Enum.AutomaticSize.XY
					inputName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName.BackgroundTransparency = 1
					inputName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName.BorderSizePixel = 0
					inputName.Position = UDim2.fromScale(0, 0.5)
					inputName.Parent = input

					local inputBox = Instance.new("TextBox")
					inputBox.Name = "InputBox"
					inputBox.FontFace = Font.new(assets.interFont)
					inputBox.Text = "Hello world!"
					inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.TextSize = 12
					inputBox.TextTransparency = 0.1
					inputBox.AnchorPoint = Vector2.new(1, 0.5)
					inputBox.AutomaticSize = Enum.AutomaticSize.X
					inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.BackgroundTransparency = 0.95
					inputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox.BorderSizePixel = 0
					inputBox.ClipsDescendants = true
					inputBox.LayoutOrder = 1
					inputBox.Position = UDim2.fromScale(1, 0.5)
					inputBox.Size = UDim2.fromOffset(21, 21)
					inputBox.TextXAlignment = Enum.TextXAlignment.Right

					local inputBoxUICorner = Instance.new("UICorner")
					inputBoxUICorner.Name = "InputBoxUICorner"
					inputBoxUICorner.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner.Parent = inputBox

					local inputBoxUIStroke = Instance.new("UIStroke")
					inputBoxUIStroke.Name = "InputBoxUIStroke"
					inputBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke.Transparency = 0.9
					inputBoxUIStroke.Parent = inputBox

					local inputBoxUIPadding = Instance.new("UIPadding")
					inputBoxUIPadding.Name = "InputBoxUIPadding"
					inputBoxUIPadding.PaddingLeft = UDim.new(0, 5)
					inputBoxUIPadding.PaddingRight = UDim.new(0, 5)
					inputBoxUIPadding.Parent = inputBox

					local inputBoxUISizeConstraint = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint.Parent = inputBox

					inputBox.Parent = input

					local Input = input
					local InputBox = inputBox
					local InputName = inputName
					local Constraint = inputBoxUISizeConstraint

					local function applyCharacterLimit(value)
						if InputFunctions.Settings.CharacterLimit then
							return value:sub(1, InputFunctions.Settings.CharacterLimit)
						end
						return value
					end

					local CharacterSubs = {
						All = function(value)
							return applyCharacterLimit(value)
						end,
						Numeric = function(value)
							local result = value:match("^%-?%d*$") and value or value:gsub("[^%d-]", ""):gsub("(%-)", function(match, pos)
								return pos == 1 and match or ""
							end)
							return applyCharacterLimit(result)
						end,
						Alphabetic = function(value)
							return applyCharacterLimit(value:gsub("[^a-zA-Z ]", ""))
						end,
						AlphaNumeric = function(value)
							return applyCharacterLimit(value:gsub("[^a-zA-Z0-9]", ""))
						end,
					}

					local AcceptedCharacters

					if type(InputFunctions.Settings.AcceptedCharacters) == "function" then
						AcceptedCharacters = InputFunctions.Settings.AcceptedCharacters
					else
						AcceptedCharacters = CharacterSubs[InputFunctions.Settings.AcceptedCharacters] or CharacterSubs.All
					end

					InputBox.AutomaticSize = Enum.AutomaticSize.X

					local function checkSize()
						local nameWidth = InputName.AbsoluteSize.X
						local totalWidth = Input.AbsoluteSize.X

						local maxWidth = (totalWidth - nameWidth - 20) / baseUIScale.Scale
						Constraint.MaxSize = Vector2.new(maxWidth, 9e9)
					end

					checkSize()
					InputName:GetPropertyChangedSignal("AbsoluteSize"):Connect(checkSize)

					InputBox.FocusLost:Connect(function()
						local inputText = InputBox.Text
						local filteredText = AcceptedCharacters(inputText)
						InputBox.Text = filteredText
						task.spawn(function()
							if InputFunctions.Settings.Callback then
								InputFunctions.Settings.Callback(filteredText)
							end
						end)
					end)
					InputBox.Text = InputFunctions.Settings.Default or ""
					InputBox.PlaceholderText = InputFunctions.Settings.Placeholder or ""

					InputBox:GetPropertyChangedSignal("Text"):Connect(function()
						InputBox.Text = AcceptedCharacters(InputBox.Text)
						if InputFunctions.Settings.onChanged then
							InputFunctions.Settings.onChanged(InputBox.Text)
						end
						InputFunctions.Text = InputBox.Text
					end)

					function InputFunctions:UpdateName(Name)
						inputName.Text = Name
					end
					function InputFunctions:SetVisibility(State)
						input.Visible = State
					end
					function InputFunctions:GetInput()
						return InputBox.Text
					end
					function InputFunctions:UpdatePlaceholder(Placeholder)
						inputBox.PlaceholderText = Placeholder
					end
					function InputFunctions:UpdateText(Text)
						local filteredText = AcceptedCharacters(Text)
						InputBox.Text = filteredText
						InputFunctions.Text = filteredText
						task.spawn(function()
							if InputFunctions.Settings.Callback then
								InputFunctions.Settings.Callback(filteredText)
							end
						end)
					end

					if Flag then
						MacLib.Options[Flag] = InputFunctions
					end
					return InputFunctions
				end

				function SectionFunctions:Keybind(Settings, Flag)
					local KeybindFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Keybind" }
					local keybind = Instance.new("Frame")
					keybind.Name = "Keybind"
					keybind.AutomaticSize = Enum.AutomaticSize.Y
					keybind.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					keybind.BackgroundTransparency = 1
					keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
					keybind.BorderSizePixel = 0
					keybind.Size = UDim2.new(1, 0, 0, 38)
					keybind.Parent = section

					local keybindName = Instance.new("TextLabel")
					keybindName.Name = "KeybindName"
					keybindName.FontFace = Font.new(assets.interFont)
					keybindName.Text = KeybindFunctions.Settings.Name
					keybindName.RichText = true
					keybindName.TextColor3 = Color3.fromRGB(255, 255, 255)
					keybindName.TextSize = 13
					keybindName.TextTransparency = 0.5
					keybindName.TextTruncate = Enum.TextTruncate.AtEnd
					keybindName.TextXAlignment = Enum.TextXAlignment.Left
					keybindName.TextYAlignment = Enum.TextYAlignment.Top
					keybindName.AnchorPoint = Vector2.new(0, 0.5)
					keybindName.AutomaticSize = Enum.AutomaticSize.XY
					keybindName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					keybindName.BackgroundTransparency = 1
					keybindName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					keybindName.BorderSizePixel = 0
					keybindName.Position = UDim2.fromScale(0, 0.5)
					keybindName.Parent = keybind

					local binderBox = Instance.new("TextBox")
					binderBox.Name = "BinderBox"
					binderBox.CursorPosition = -1
					binderBox.FontFace = Font.new(assets.interFont)
					binderBox.PlaceholderText = "..."
					binderBox.Text = ""
					binderBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					binderBox.TextSize = 12
					binderBox.TextTransparency = 0.1
					binderBox.AnchorPoint = Vector2.new(1, 0.5)
					binderBox.AutomaticSize = Enum.AutomaticSize.X
					binderBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					binderBox.BackgroundTransparency = 0.95
					binderBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					binderBox.BorderSizePixel = 0
					binderBox.ClipsDescendants = true
					binderBox.LayoutOrder = 1
					binderBox.Position = UDim2.fromScale(1, 0.5)
					binderBox.Size = UDim2.fromOffset(21, 21)

					local binderBoxUICorner = Instance.new("UICorner")
					binderBoxUICorner.Name = "BinderBoxUICorner"
					binderBoxUICorner.CornerRadius = UDim.new(0, 4)
					binderBoxUICorner.Parent = binderBox

					local binderBoxUIStroke = Instance.new("UIStroke")
					binderBoxUIStroke.Name = "BinderBoxUIStroke"
					binderBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					binderBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					binderBoxUIStroke.Transparency = 0.9
					binderBoxUIStroke.Parent = binderBox

					local binderBoxUIPadding = Instance.new("UIPadding")
					binderBoxUIPadding.Name = "BinderBoxUIPadding"
					binderBoxUIPadding.PaddingLeft = UDim.new(0, 5)
					binderBoxUIPadding.PaddingRight = UDim.new(0, 5)
					binderBoxUIPadding.Parent = binderBox

					local binderBoxUISizeConstraint = Instance.new("UISizeConstraint")
					binderBoxUISizeConstraint.Name = "BinderBoxUISizeConstraint"
					binderBoxUISizeConstraint.Parent = binderBox

					binderBox.Parent = keybind

					local focused
					local isBinding = false
					local reset = false
					local binded = KeybindFunctions.Settings.Default

					local function resetFocusState()
						focused = false
						isBinding = false
						binderBox:ReleaseFocus()
					end

					if binded then
						binderBox.Text = binded.Name
					end

					binderBox.Focused:Connect(function()
						focused = true
					end)

					binderBox.FocusLost:Connect(function()
						focused = false
					end)

					UserInputService.InputBegan:Connect(function(inp)
						if focused and not isBinding then
							isBinding = true

							local Event
							Event = UserInputService.InputBegan:Connect(function(input)
								if KeybindFunctions.Settings.Blacklist and (table.find(KeybindFunctions.KeybindFunctions.Settings.Blacklist, input.KeyCode) or table.find(KeybindFunctions.Settings.Blacklist, input.UserInputType)) then
									binderBox:ReleaseFocus()
									resetFocusState()
									Event:Disconnect()
									return
								end

								if input.UserInputType == Enum.UserInputType.Keyboard then
									binded = input.KeyCode
									binderBox.Text = input.KeyCode.Name
								elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
									binded = input.UserInputType
									binderBox.Text = input.UserInputType.Name
								end

								if KeybindFunctions.Settings.onBinded then
									KeybindFunctions.Settings.onBinded(binded)
								end
								reset = true
								resetFocusState()
								Event:Disconnect()
							end)
						else
							if not reset and (inp.KeyCode == binded or inp.UserInputType == binded) then
								if KeybindFunctions.Settings.Callback then
									KeybindFunctions.Settings.Callback(binded)
								end
								if KeybindFunctions.Settings.onBindHeld then
									KeybindFunctions.Settings.onBindHeld(true, binded)
								end
							else
								reset = false
							end
						end
					end)

					UserInputService.InputEnded:Connect(function(inp)
						if not focused and not isBinding then
							if inp.KeyCode == binded or inp.UserInputType == binded then
								if Settings.onBindHeld then
									Settings.onBindHeld(false, binded)
								end
							end
						end
					end)

					function KeybindFunctions:Bind(Key)
						binded = Key
						binderBox.Text = Key.Name
					end

					function KeybindFunctions:Unbind()
						binded = nil
						binderBox.Text = ""
					end

					function KeybindFunctions:GetBind()
						return binded
					end

					function KeybindFunctions:UpdateName(Name)
						keybindName = Name
					end

					function KeybindFunctions:SetVisibility(State)
						keybind.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = KeybindFunctions
					end

					return KeybindFunctions
				end

				function SectionFunctions:Dropdown(Settings, Flag)
					local DropdownFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Dropdown" }
					local Selected = {}
					local OptionObjs = {}

					local dropdown = Instance.new("Frame")
					dropdown.Name = "Dropdown"
					dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdown.BackgroundTransparency = 0.985
					dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdown.BorderSizePixel = 0
					dropdown.Size = UDim2.new(1, 0, 0, 38)
					dropdown.Parent = section
					dropdown.ClipsDescendants = true

					local dropdownUIPadding = Instance.new("UIPadding")
					dropdownUIPadding.Name = "DropdownUIPadding"
					dropdownUIPadding.PaddingLeft = UDim.new(0, 15)
					dropdownUIPadding.PaddingRight = UDim.new(0, 15)
					dropdownUIPadding.Parent = dropdown

					local interact = Instance.new("TextButton")
					interact.Name = "Interact"
					interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					interact.Text = ""
					interact.TextColor3 = Color3.fromRGB(0, 0, 0)
					interact.TextSize = 14
					interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					interact.BackgroundTransparency = 1
					interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interact.BorderSizePixel = 0
					interact.Size = UDim2.new(1, 0, 0, 38)
					interact.Parent = dropdown

					local dropdownName = Instance.new("TextLabel")
					dropdownName.Name = "DropdownName"
					dropdownName.FontFace = Font.new(assets.interFont)
					dropdownName.Text = Settings.Default and (DropdownFunctions.Settings.Name .. " â€¢ " .. table.concat(Selected, ", ")) or (DropdownFunctions.Settings.Name .. "...")
					dropdownName.RichText = true
					dropdownName.TextColor3 = Color3.fromRGB(255, 255, 255)
					dropdownName.TextSize = 13
					dropdownName.TextTransparency = 0.5
					dropdownName.TextTruncate = Enum.TextTruncate.SplitWord
					dropdownName.TextXAlignment = Enum.TextXAlignment.Left
					dropdownName.AutomaticSize = Enum.AutomaticSize.Y
					dropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownName.BackgroundTransparency = 1
					dropdownName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownName.BorderSizePixel = 0
					dropdownName.Size = UDim2.new(1, -20, 0, 38)
					dropdownName.Parent = dropdown

					local dropdownUIStroke = Instance.new("UIStroke")
					dropdownUIStroke.Name = "DropdownUIStroke"
					dropdownUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					dropdownUIStroke.Color = Color3.fromRGB(255, 255, 255)
					dropdownUIStroke.Transparency = 0.95
					dropdownUIStroke.Parent = dropdown

					local dropdownUICorner = Instance.new("UICorner")
					dropdownUICorner.Name = "DropdownUICorner"
					dropdownUICorner.CornerRadius = UDim.new(0, 6)
					dropdownUICorner.Parent = dropdown

					local dropdownImage = Instance.new("ImageLabel")
					dropdownImage.Name = "DropdownImage"
					dropdownImage.Image = assets.dropdown
					dropdownImage.ImageTransparency = 0.5
					dropdownImage.AnchorPoint = Vector2.new(1, 0)
					dropdownImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownImage.BackgroundTransparency = 1
					dropdownImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownImage.BorderSizePixel = 0
					dropdownImage.Position = UDim2.new(1, 0, 0, 12)
					dropdownImage.Size = UDim2.fromOffset(14, 14)
					dropdownImage.Parent = dropdown

					local dropdownFrame = Instance.new("Frame")
					dropdownFrame.Name = "DropdownFrame"
					dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					dropdownFrame.BackgroundTransparency = 1
					dropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
					dropdownFrame.BorderSizePixel = 0
					dropdownFrame.ClipsDescendants = true
					dropdownFrame.Size = UDim2.fromScale(1, 1)
					dropdownFrame.Visible = false
					dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y

					local dropdownFrameUIPadding = Instance.new("UIPadding")
					dropdownFrameUIPadding.Name = "DropdownFrameUIPadding"
					dropdownFrameUIPadding.PaddingTop = UDim.new(0, 38)
					dropdownFrameUIPadding.PaddingBottom = UDim.new(0, 10)
					dropdownFrameUIPadding.Parent = dropdownFrame

					local dropdownFrameUIListLayout = Instance.new("UIListLayout")
					dropdownFrameUIListLayout.Name = "DropdownFrameUIListLayout"
					dropdownFrameUIListLayout.Padding = UDim.new(0, 5)
					dropdownFrameUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					dropdownFrameUIListLayout.Parent = dropdownFrame

					local search = Instance.new("Frame")
					search.Name = "Search"
					search.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					search.BackgroundTransparency = 0.95
					search.BorderColor3 = Color3.fromRGB(0, 0, 0)
					search.BorderSizePixel = 0
					search.LayoutOrder = -1
					search.Size = UDim2.new(1, 0, 0, 30)
					search.Parent = dropdownFrame
					search.Visible = DropdownFunctions.Settings.Search

					local sectionUICorner = Instance.new("UICorner")
					sectionUICorner.Name = "SectionUICorner"
					sectionUICorner.Parent = search

					local searchIcon = Instance.new("ImageLabel")
					searchIcon.Name = "SearchIcon"
					searchIcon.Image = assets.searchIcon
					searchIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)
					searchIcon.AnchorPoint = Vector2.new(0, 0.5)
					searchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					searchIcon.BackgroundTransparency = 1
					searchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					searchIcon.BorderSizePixel = 0
					searchIcon.Position = UDim2.fromScale(0, 0.5)
					searchIcon.Size = UDim2.fromOffset(12, 12)
					searchIcon.Parent = search

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingLeft = UDim.new(0, 15)
					uIPadding.Parent = search

					local searchBox = Instance.new("TextBox")
					searchBox.Name = "SearchBox"
					searchBox.CursorPosition = -1
					searchBox.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
					searchBox.PlaceholderText = "Search..."
					searchBox.Text = ""
					searchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
					searchBox.TextSize = 14
					searchBox.TextXAlignment = Enum.TextXAlignment.Left
					searchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					searchBox.BackgroundTransparency = 1
					searchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					searchBox.BorderSizePixel = 0
					searchBox.Size = UDim2.fromScale(1, 1)

					local function CalculateDropdownSize()
						local totalHeight = 0
						local visibleChildrenCount = 0
						local padding = dropdownFrameUIPadding.PaddingTop.Offset + dropdownFrameUIPadding.PaddingBottom.Offset

						for _, v in pairs(dropdownFrame:GetChildren()) do
							if not v:IsA("UIComponent") and v.Visible then
								totalHeight += v.AbsoluteSize.Y
								visibleChildrenCount += 1
							end
						end

						local spacing = dropdownFrameUIListLayout.Padding.Offset * (visibleChildrenCount - 1)

						return totalHeight + spacing + padding
					end

					local function findOption()
						local searchTerm = searchBox.Text:lower()

						for _, v in pairs(OptionObjs) do
							local optionText = v.NameLabel.Text:lower()
							local isVisible = string.find(optionText, searchTerm) ~= nil

							if v.Button.Visible ~= isVisible then
								v.Button.Visible = isVisible
							end
						end

						dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
					end

					searchBox:GetPropertyChangedSignal("Text"):Connect(findOption)

					local uIPadding1 = Instance.new("UIPadding")
					uIPadding1.Name = "UIPadding"
					uIPadding1.PaddingLeft = UDim.new(0, 23)
					uIPadding1.Parent = searchBox

					searchBox.Parent = search

					local tweensettings = {
						duration = 0.2,
						easingStyle = Enum.EasingStyle.Quint,
						transparencyIn = 0.2,
						transparencyOut = 0.5,
						checkSizeIncrease = 12,
						checkSizeDecrease = -13,
						waitTime = 1
					}

					local function Toggle(optionName, State)
						local option = OptionObjs[optionName]

						if not option then return end

						local checkmark = option.Checkmark
						local optionNameLabel = option.NameLabel

						if State then
							if DropdownFunctions.Settings.Multi then
								if not table.find(Selected, optionName) then
									table.insert(Selected, optionName)
									DropdownFunctions.Value = Selected
								end
							else
								for name, opt in pairs(OptionObjs) do
									if name ~= optionName then
										Tween(opt.Checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
											Size = UDim2.new(opt.Checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, opt.Checkmark.Size.Y.Scale, opt.Checkmark.Size.Y.Offset)
										}):Play()
										Tween(opt.NameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
											TextTransparency = tweensettings.transparencyOut
										}):Play()
										opt.Checkmark.TextTransparency = 1
									end
								end
								Selected = {optionName}
								DropdownFunctions.Value = Selected[1]
							end
							Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}):Play()
							Tween(optionNameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								TextTransparency = tweensettings.transparencyIn
							}):Play()
							checkmark.TextTransparency = 0
						else
							if DropdownFunctions.Settings.Multi then
								local idx = table.find(Selected, optionName)
								if idx then
									table.remove(Selected, idx)
								end
							else
								Selected = {}
							end
							Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}):Play()
							Tween(optionNameLabel, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								TextTransparency = tweensettings.transparencyOut
							}):Play()
							checkmark.TextTransparency = 1
						end

						if Settings.Required and #Selected == 0 and not State then
							return
						end

						if #Selected > 0 then
							dropdownName.Text = DropdownFunctions.Settings.Name .. " â€¢ " .. table.concat(Selected, ", ")
						else
							dropdownName.Text = DropdownFunctions.Settings.Name .. "..."
						end
					end

					local dropped = false
					local db = false

					local function ToggleDropdown()
						if db then return end
						db = true
						local defaultDropdownSize = 38
						local isDropdownOpen = not dropped
						local targetSize = isDropdownOpen and UDim2.new(1, 0, 0, CalculateDropdownSize()) or UDim2.new(1, 0, 0, defaultDropdownSize)

						local dropTween = Tween(dropdown, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
							Size = targetSize
						})
						local iconTween = Tween(dropdownImage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Rotation = isDropdownOpen and -90 or 0
						})

						dropTween:Play()
						iconTween:Play()

						if isDropdownOpen then
							dropdownFrame.Visible = true
							dropTween.Completed:Connect(function()
								db = false
							end)
						else
							dropTween.Completed:Connect(function()
								dropdownFrame.Visible = false
								db = false
							end)
						end

						dropped = isDropdownOpen
					end

					interact.MouseButton1Click:Connect(ToggleDropdown)

					local function addOption(i, v)
						local option = Instance.new("TextButton")
						option.Name = "Option"
						option.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
						option.Text = ""
						option.TextColor3 = Color3.fromRGB(0, 0, 0)
						option.TextSize = 14
						option.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						option.BackgroundTransparency = 1
						option.BorderColor3 = Color3.fromRGB(0, 0, 0)
						option.BorderSizePixel = 0
						option.Size = UDim2.new(1, 0, 0, 30)

						local optionUIPadding = Instance.new("UIPadding")
						optionUIPadding.Name = "OptionUIPadding"
						optionUIPadding.PaddingLeft = UDim.new(0, 15)
						optionUIPadding.Parent = option

						local optionName = Instance.new("TextLabel")
						optionName.Name = "OptionName"
						optionName.FontFace = Font.new(assets.interFont)
						optionName.Text = v
						optionName.RichText = true
						optionName.TextColor3 = Color3.fromRGB(255, 255, 255)
						optionName.TextSize = 13
						optionName.TextTransparency = 0.5
						optionName.TextTruncate = Enum.TextTruncate.AtEnd
						optionName.TextXAlignment = Enum.TextXAlignment.Left
						optionName.TextYAlignment = Enum.TextYAlignment.Top
						optionName.AnchorPoint = Vector2.new(0, 0.5)
						optionName.AutomaticSize = Enum.AutomaticSize.XY
						optionName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						optionName.BackgroundTransparency = 1
						optionName.BorderColor3 = Color3.fromRGB(0, 0, 0)
						optionName.BorderSizePixel = 0
						optionName.Position = UDim2.fromScale(1.3e-07, 0.5)
						optionName.Parent = option

						local optionUIListLayout = Instance.new("UIListLayout")
						optionUIListLayout.Name = "OptionUIListLayout"
						optionUIListLayout.Padding = UDim.new(0, 10)
						optionUIListLayout.FillDirection = Enum.FillDirection.Horizontal
						optionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
						optionUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
						optionUIListLayout.Parent = option

						local checkmark = Instance.new("TextLabel")
						checkmark.Name = "Checkmark"
						checkmark.FontFace = Font.new(assets.interFont)
						checkmark.Text = "âœ“"
						checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
						checkmark.TextSize = 13
						checkmark.TextTransparency = 1
						checkmark.TextXAlignment = Enum.TextXAlignment.Left
						checkmark.TextYAlignment = Enum.TextYAlignment.Top
						checkmark.AnchorPoint = Vector2.new(0, 0.5)
						checkmark.AutomaticSize = Enum.AutomaticSize.Y
						checkmark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						checkmark.BackgroundTransparency = 1
						checkmark.BorderColor3 = Color3.fromRGB(0, 0, 0)
						checkmark.BorderSizePixel = 0
						checkmark.LayoutOrder = -1
						checkmark.Position = UDim2.fromScale(1.3e-07, 0.5)
						checkmark.Size = UDim2.fromOffset(-10, 0)
						checkmark.Parent = option

						option.Parent = dropdownFrame

						dropdownFrame.Parent = dropdown
						OptionObjs[v] = {
							Index = i,
							Button = option,
							NameLabel = optionName,
							Checkmark = checkmark
						}

						local tweensettings = {
							duration = 0.2,
							easingStyle = Enum.EasingStyle.Quint,
							transparencyIn = 0.2,
							transparencyOut = 0.5,
							checkSizeIncrease = 12,
							checkSizeDecrease = -optionUIListLayout.Padding.Offset,
							waitTime = 1
						}
						local tweens = {
							checkIn = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle), {
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeIncrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}),
							checkOut = Tween(checkmark, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								Size = UDim2.new(checkmark.Size.X.Scale, tweensettings.checkSizeDecrease, checkmark.Size.Y.Scale, checkmark.Size.Y.Offset)
							}),
							nameIn = Tween(optionName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								TextTransparency = tweensettings.transparencyIn
							}),
							nameOut = Tween(optionName, TweenInfo.new(tweensettings.duration, tweensettings.easingStyle),{
								TextTransparency = tweensettings.transparencyOut
							})
						}

						local isSelected = false
						if DropdownFunctions.Settings.Default then
							if DropdownFunctions.Settings.Multi then
								isSelected = table.find(DropdownFunctions.Settings.Default, v) and true or false
							else
								isSelected = (DropdownFunctions.Settings.Default == i) and true or false
							end
						end
						Toggle(v, isSelected)

						local option = OptionObjs[v].Button

						option.MouseButton1Click:Connect(function()
							local isSelected = table.find(Selected, v) and true or false
							local newSelected = not isSelected

							if DropdownFunctions.Settings.Required and not newSelected and #Selected <= 1 then
								return
							end

							Toggle(v, newSelected)

							task.spawn(function()
								if DropdownFunctions.Settings.Multi then
									local Return = {}
									for _, opt in ipairs(Selected) do
										Return[opt] = true
									end
									if DropdownFunctions.Settings.Callback then
										DropdownFunctions.Settings.Callback(Return)
									end

								else
									if newSelected and DropdownFunctions.Settings.Callback then
										DropdownFunctions.Settings.Callback(Selected[1] or nil)
									end
								end
							end)
						end)

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end

					if DropdownFunctions.Settings.Options then
						for i, v in pairs(DropdownFunctions.Settings.Options) do
							addOption(i, v)
						end
					end

					function DropdownFunctions:UpdateName(New)
						dropdownName.Text = New
					end
					function DropdownFunctions:SetVisibility(State)
						dropdown.Visible = State
					end
					function DropdownFunctions:UpdateSelection(newSelection)
						if not newSelection then return end

						for option, _ in pairs(OptionObjs) do
							Toggle(option, false)
						end

						local selectedOptions = {}
						if type(newSelection) == "number" then
							for option, data in pairs(OptionObjs) do
								local isSelected = data.Index == newSelection
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						elseif type(newSelection) == "string" then
							for option, data in pairs(OptionObjs) do
								local isSelected = option == newSelection
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						elseif type(newSelection) == "table" then
							for option, _ in pairs(OptionObjs) do
								local isSelected = table.find(newSelection, option) ~= nil
								Toggle(option, isSelected)
								if isSelected then
									table.insert(selectedOptions, option)
								end
							end
						end

						if DropdownFunctions.Settings.Callback then
							if DropdownFunctions.Settings.Multi then
								local Return = {}
								for _, opt in ipairs(selectedOptions) do
									Return[opt] = true
								end
								DropdownFunctions.Settings.Callback(Return)
							else
								DropdownFunctions.Settings.Callback(selectedOptions[1] or nil)
							end
						end
					end
					function DropdownFunctions:InsertOptions(newOptions)
						if not newOptions then return end
						DropdownFunctions.Settings.Options = newOptions
						for i, v in pairs(newOptions) do
							addOption(i, v)
						end
					end
					function DropdownFunctions:ClearOptions()
						for _, optionData in pairs(OptionObjs) do
							optionData.Button:Destroy()
						end
						OptionObjs = {}
						Selected = {}

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end
					function DropdownFunctions:GetOptions()
						local optionsStatus = {}

						for option, data in pairs(OptionObjs) do
							local isSelected = table.find(Selected, option) and true or false
							optionsStatus[option] = isSelected
						end

						return optionsStatus
					end

					function DropdownFunctions:RemoveOptions(remove)
						if not remove then return end
						for _, optionName in ipairs(remove) do
							local optionData = OptionObjs[optionName]

							if optionData then
								for i = #Selected, 1, -1 do
									if Selected[i] == optionName then
										table.remove(Selected, i)
									end
								end

								optionData.Button:Destroy()

								OptionObjs[optionName] = nil
							end
						end

						if dropped then
							dropdown.Size = UDim2.new(1, 0, 0, CalculateDropdownSize())
						end
					end
					function DropdownFunctions:IsOption(optionName)
						if not optionName then return end
						return OptionObjs[optionName] ~= nil
					end

					if Flag then
						MacLib.Options[Flag] = DropdownFunctions
					end

					return DropdownFunctions
				end

				function SectionFunctions:Colorpicker(Settings, Flag)
					local ColorpickerFunctions = { Settings = Settings, IgnoreConfig = false, Class = "Colorpicker" }

					local isAlpha = ColorpickerFunctions.Settings.Alpha and true or false
					ColorpickerFunctions.Color = ColorpickerFunctions.Settings.Default
					ColorpickerFunctions.Alpha = isAlpha and ColorpickerFunctions.Settings.Alpha

					local colorpicker = Instance.new("Frame")
					colorpicker.Name = "Colorpicker"
					colorpicker.AutomaticSize = Enum.AutomaticSize.Y
					colorpicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					colorpicker.BackgroundTransparency = 1
					colorpicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorpicker.BorderSizePixel = 0
					colorpicker.Size = UDim2.new(1, 0, 0, 38)
					colorpicker.Parent = section

					local colorpickerName = Instance.new("TextLabel")
					colorpickerName.Name = "KeybindName"
					colorpickerName.FontFace = Font.new(assets.interFont)
					colorpickerName.Text = Settings.Name
					colorpickerName.TextColor3 = Color3.fromRGB(255, 255, 255)
					colorpickerName.TextSize = 13
					colorpickerName.TextTransparency = 0.5
					colorpickerName.RichText = true
					colorpickerName.TextTruncate = Enum.TextTruncate.AtEnd
					colorpickerName.TextXAlignment = Enum.TextXAlignment.Left
					colorpickerName.TextYAlignment = Enum.TextYAlignment.Top
					colorpickerName.AnchorPoint = Vector2.new(0, 0.5)
					colorpickerName.AutomaticSize = Enum.AutomaticSize.XY
					colorpickerName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorpickerName.BackgroundTransparency = 1
					colorpickerName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorpickerName.BorderSizePixel = 0
					colorpickerName.Position = UDim2.fromScale(0, 0.5)
					colorpickerName.Parent = colorpicker

					local colorCbg = Instance.new("ImageLabel")
					colorCbg.Name = "NewColor"
					colorCbg.Image = assets.grid
					colorCbg.ScaleType = Enum.ScaleType.Tile
					colorCbg.TileSize = UDim2.fromOffset(500, 500)
					colorCbg.AnchorPoint = Vector2.new(1, 0.5)
					colorCbg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorCbg.BackgroundTransparency = 1
					colorCbg.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorCbg.BorderSizePixel = 0
					colorCbg.Position = UDim2.fromScale(1, 0.5)
					colorCbg.Size = UDim2.fromOffset(21, 21)

					local colorC = Instance.new("Frame")
					colorC.Name = "Color"
					colorC.AnchorPoint = Vector2.new(0.5, 0.5)
					colorC.BackgroundColor3 = ColorpickerFunctions.Color
					colorC.BorderSizePixel = 0
					colorC.Position = UDim2.fromScale(0.5, 0.5)
					colorC.Size = UDim2.fromScale(1, 1)
					colorC.BackgroundTransparency = ColorpickerFunctions.Alpha or 0

					local uICorner = Instance.new("UICorner")
					uICorner.Name = "UICorner"
					uICorner.CornerRadius = UDim.new(0, 6)
					uICorner.Parent = colorC

					local interact = Instance.new("TextButton")
					interact.Name = "Interact"
					interact.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					interact.Text = ""
					interact.TextColor3 = Color3.fromRGB(0, 0, 0)
					interact.TextSize = 14
					interact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					interact.BackgroundTransparency = 1
					interact.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interact.BorderSizePixel = 0
					interact.Size = UDim2.fromScale(1, 1)
					interact.Parent = colorC

					colorC.Parent = colorCbg

					local uICorner1 = Instance.new("UICorner")
					uICorner1.Name = "UICorner"
					uICorner1.CornerRadius = UDim.new(0, 8)
					uICorner1.Parent = colorCbg

					colorCbg.Parent = colorpicker

					local colorPicker = Instance.new("Frame")
					colorPicker.Name = "ColorPicker"
					colorPicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					colorPicker.BackgroundTransparency = 0.5
					colorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorPicker.BorderSizePixel = 0
					colorPicker.Size = UDim2.fromScale(1, 1)
					colorPicker.Visible = false

					local baseUICorner = Instance.new("UICorner")
					baseUICorner.Name = "BaseUICorner"
					baseUICorner.CornerRadius = UDim.new(0, 10)
					baseUICorner.Parent = colorPicker

					local prompt = Instance.new("Frame")
					prompt.Name = "Prompt"
					prompt.AnchorPoint = Vector2.new(0.5, 0.5)
					prompt.AutomaticSize = Enum.AutomaticSize.Y
					prompt.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
					prompt.BorderColor3 = Color3.fromRGB(0, 0, 0)
					prompt.BorderSizePixel = 0
					prompt.Position = UDim2.fromScale(0.5, 0.5)
					prompt.Size = UDim2.fromOffset(420, 0)

					local promptUIScale = Instance.new("UIScale")
					promptUIScale.Name = "BaseUIScale"
					promptUIScale.Parent = prompt
					promptUIScale.Scale = 0.95

					local globalSettingsUIStroke = Instance.new("UIStroke")
					globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
					globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
					globalSettingsUIStroke.Transparency = 0.9
					globalSettingsUIStroke.Parent = prompt

					local globalSettingsUICorner = Instance.new("UICorner")
					globalSettingsUICorner.Name = "GlobalSettingsUICorner"
					globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
					globalSettingsUICorner.Parent = prompt

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.Padding = UDim.new(0, 10)
					uIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = prompt

					local colorOptions = Instance.new("Frame")
					colorOptions.Name = "ColorOptions"
					colorOptions.AutomaticSize = Enum.AutomaticSize.XY
					colorOptions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorOptions.BackgroundTransparency = 1
					colorOptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorOptions.BorderSizePixel = 0
					colorOptions.LayoutOrder = 1
					colorOptions.Size = UDim2.fromScale(1, 0)

					local value = Instance.new("TextButton")
					value.Name = "Value"
					value.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
					value.Text = ""
					value.TextColor3 = Color3.fromRGB(0, 0, 0)
					value.TextSize = 14
					value.AutoButtonColor = false
					value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					value.BorderColor3 = Color3.fromRGB(0, 0, 0)
					value.BorderSizePixel = 0
					value.LayoutOrder = 1
					value.Position = UDim2.fromScale(0.092, 0.886)
					value.Size = UDim2.new(1, 0, 0, 15)

					local uIGradient = Instance.new("UIGradient")
					uIGradient.Name = "UIGradient"
					uIGradient.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
					})
					uIGradient.Parent = value

					local slide = Instance.new("Frame")
					slide.Name = "Slide"
					slide.AnchorPoint = Vector2.new(0, 0.5)
					slide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					slide.BorderColor3 = Color3.fromRGB(27, 42, 53)
					slide.BorderSizePixel = 0
					slide.Position = UDim2.fromScale(0, 0.5)
					slide.Size = UDim2.new(0, 13, 1, 8)

					local uICorner = Instance.new("UICorner")
					uICorner.Name = "UICorner"
					uICorner.CornerRadius = UDim.new(1, 0)
					uICorner.Parent = slide

					local uIStroke = Instance.new("UIStroke")
					uIStroke.Name = "UIStroke"
					uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uIStroke.Transparency = 0.5
					uIStroke.Parent = slide

					slide.Parent = value

					local uICorner1 = Instance.new("UICorner")
					uICorner1.Name = "UICorner"
					uICorner1.CornerRadius = UDim.new(0, 6)
					uICorner1.Parent = value

					local uIStroke1 = Instance.new("UIStroke")
					uIStroke1.Name = "UIStroke"
					uIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uIStroke1.Color = Color3.fromRGB(255, 255, 255)
					uIStroke1.Transparency = 0.9

					local uIGradient1 = Instance.new("UIGradient")
					uIGradient1.Name = "UIGradient"
					uIGradient1.Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
					})
					uIGradient1.Rotation = 180
					uIGradient1.Parent = uIStroke1

					uIStroke1.Parent = value

					value.Parent = colorOptions

					local uIListLayout1 = Instance.new("UIListLayout")
					uIListLayout1.Name = "UIListLayout"
					uIListLayout1.Padding = UDim.new(0, 25)
					uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout1.Parent = colorOptions

					local wheel = Instance.new("Frame")
					wheel.Name = "Wheel"
					wheel.AutomaticSize = Enum.AutomaticSize.Y
					wheel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					wheel.BackgroundTransparency = 1
					wheel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					wheel.BorderSizePixel = 0
					wheel.Size = UDim2.new(1, 0, 0, 100)

					local wheel1 = Instance.new("ImageButton")
					wheel1.Name = "Wheel"
					wheel1.Image = assets.colorWheel
					wheel1.AutoButtonColor = false
					wheel1.Active = false
					wheel1.BackgroundColor3 = Color3.fromRGB(248, 248, 248)
					wheel1.BackgroundTransparency = 1
					wheel1.BorderColor3 = Color3.fromRGB(27, 42, 53)
					wheel1.Selectable = false
					wheel1.Size = UDim2.fromOffset(220, 220)
					wheel1.SizeConstraint = Enum.SizeConstraint.RelativeYY

					local target = Instance.new("ImageLabel")
					target.Name = "Target"
					target.Image = assets.colorTarget
					target.ImageColor3 = Color3.fromRGB(0, 0, 0)
					target.AnchorPoint = Vector2.new(0.5, 0.5)
					target.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					target.BackgroundTransparency = 1
					target.BorderColor3 = Color3.fromRGB(27, 42, 53)
					target.Position = UDim2.fromScale(0.5, 0.5)
					target.Size = UDim2.fromOffset(22, 22)
					target.SizeConstraint = Enum.SizeConstraint.RelativeYY
					target.Parent = wheel1

					wheel1.Parent = wheel

					local inputs = Instance.new("Frame")
					inputs.Name = "Inputs"
					inputs.AnchorPoint = Vector2.new(1, 0.5)
					inputs.AutomaticSize = Enum.AutomaticSize.XY
					inputs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputs.BackgroundTransparency = 1
					inputs.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputs.BorderSizePixel = 0
					inputs.LayoutOrder = 1
					inputs.Position = UDim2.fromScale(1, 0.5)

					local uIListLayout2 = Instance.new("UIListLayout")
					uIListLayout2.Name = "UIListLayout"
					uIListLayout2.Padding = UDim.new(0, 5)
					uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout2.Parent = inputs

					local red = Instance.new("Frame")
					red.Name = "Red"
					red.AutomaticSize = Enum.AutomaticSize.XY
					red.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					red.BackgroundTransparency = 1
					red.BorderColor3 = Color3.fromRGB(0, 0, 0)
					red.BorderSizePixel = 0
					red.LayoutOrder = 1
					red.Size = UDim2.fromOffset(0, 38)

					local inputName = Instance.new("TextLabel")
					inputName.Name = "InputName"
					inputName.FontFace = Font.new(assets.interFont)
					inputName.Text = "Red"
					inputName.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName.TextSize = 13
					inputName.TextTransparency = 0.5
					inputName.TextTruncate = Enum.TextTruncate.AtEnd
					inputName.TextXAlignment = Enum.TextXAlignment.Left
					inputName.TextYAlignment = Enum.TextYAlignment.Top
					inputName.AnchorPoint = Vector2.new(0, 0.5)
					inputName.AutomaticSize = Enum.AutomaticSize.XY
					inputName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName.BackgroundTransparency = 1
					inputName.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName.BorderSizePixel = 0
					inputName.LayoutOrder = 2
					inputName.Position = UDim2.fromScale(0, 0.5)
					inputName.Parent = red

					local uIListLayout3 = Instance.new("UIListLayout")
					uIListLayout3.Name = "UIListLayout"
					uIListLayout3.Padding = UDim.new(0, 15)
					uIListLayout3.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout3.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout3.Parent = red

					local inputBox = Instance.new("TextBox")
					inputBox.Name = "InputBox"
					inputBox.ClearTextOnFocus = false
					inputBox.CursorPosition = -1
					inputBox.FontFace = Font.new(assets.interFont)
					inputBox.Text = "255"
					inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.TextSize = 12
					inputBox.TextTransparency = 0.1
					inputBox.TextXAlignment = Enum.TextXAlignment.Left
					inputBox.AnchorPoint = Vector2.new(1, 0.5)
					inputBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox.BackgroundTransparency = 0.95
					inputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox.BorderSizePixel = 0
					inputBox.ClipsDescendants = true
					inputBox.LayoutOrder = 1
					inputBox.Position = UDim2.fromScale(1, 0.5)
					inputBox.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner = Instance.new("UICorner")
					inputBoxUICorner.Name = "InputBoxUICorner"
					inputBoxUICorner.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner.Parent = inputBox

					local inputBoxUIStroke = Instance.new("UIStroke")
					inputBoxUIStroke.Name = "InputBoxUIStroke"
					inputBoxUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke.Transparency = 0.9
					inputBoxUIStroke.Parent = inputBox

					local inputBoxUISizeConstraint = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint.Parent = inputBox

					local inputBoxUIPadding = Instance.new("UIPadding")
					inputBoxUIPadding.Name = "InputBoxUIPadding"
					inputBoxUIPadding.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding.Parent = inputBox

					inputBox.Parent = red

					red.Parent = inputs

					local green = Instance.new("Frame")
					green.Name = "Green"
					green.AutomaticSize = Enum.AutomaticSize.XY
					green.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					green.BackgroundTransparency = 1
					green.BorderColor3 = Color3.fromRGB(0, 0, 0)
					green.BorderSizePixel = 0
					green.LayoutOrder = 2
					green.Size = UDim2.fromOffset(0, 38)

					local inputName1 = Instance.new("TextLabel")
					inputName1.Name = "InputName"
					inputName1.FontFace = Font.new(assets.interFont)
					inputName1.Text = "Green"
					inputName1.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName1.TextSize = 13
					inputName1.TextTransparency = 0.5
					inputName1.TextTruncate = Enum.TextTruncate.AtEnd
					inputName1.TextXAlignment = Enum.TextXAlignment.Left
					inputName1.TextYAlignment = Enum.TextYAlignment.Top
					inputName1.AnchorPoint = Vector2.new(0, 0.5)
					inputName1.AutomaticSize = Enum.AutomaticSize.XY
					inputName1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName1.BackgroundTransparency = 1
					inputName1.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName1.BorderSizePixel = 0
					inputName1.LayoutOrder = 2
					inputName1.Position = UDim2.fromScale(0, 0.5)
					inputName1.Parent = green

					local uIListLayout4 = Instance.new("UIListLayout")
					uIListLayout4.Name = "UIListLayout"
					uIListLayout4.Padding = UDim.new(0, 15)
					uIListLayout4.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout4.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout4.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout4.Parent = green

					local inputBox1 = Instance.new("TextBox")
					inputBox1.Name = "InputBox"
					inputBox1.ClearTextOnFocus = false
					inputBox1.FontFace = Font.new(assets.interFont)
					inputBox1.Text = "255"
					inputBox1.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox1.TextSize = 12
					inputBox1.TextTransparency = 0.1
					inputBox1.TextXAlignment = Enum.TextXAlignment.Left
					inputBox1.AnchorPoint = Vector2.new(1, 0.5)
					inputBox1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox1.BackgroundTransparency = 0.95
					inputBox1.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox1.BorderSizePixel = 0
					inputBox1.ClipsDescendants = true
					inputBox1.LayoutOrder = 1
					inputBox1.Position = UDim2.fromScale(1, 0.5)
					inputBox1.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner1 = Instance.new("UICorner")
					inputBoxUICorner1.Name = "InputBoxUICorner"
					inputBoxUICorner1.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner1.Parent = inputBox1

					local inputBoxUIStroke1 = Instance.new("UIStroke")
					inputBoxUIStroke1.Name = "InputBoxUIStroke"
					inputBoxUIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke1.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke1.Transparency = 0.9
					inputBoxUIStroke1.Parent = inputBox1

					local inputBoxUISizeConstraint1 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint1.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint1.Parent = inputBox1

					local inputBoxUIPadding1 = Instance.new("UIPadding")
					inputBoxUIPadding1.Name = "InputBoxUIPadding"
					inputBoxUIPadding1.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding1.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding1.Parent = inputBox1

					inputBox1.Parent = green

					green.Parent = inputs

					local blue = Instance.new("Frame")
					blue.Name = "Blue"
					blue.AutomaticSize = Enum.AutomaticSize.XY
					blue.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					blue.BackgroundTransparency = 1
					blue.BorderColor3 = Color3.fromRGB(0, 0, 0)
					blue.BorderSizePixel = 0
					blue.LayoutOrder = 3
					blue.Size = UDim2.fromOffset(0, 38)

					local inputName2 = Instance.new("TextLabel")
					inputName2.Name = "InputName"
					inputName2.FontFace = Font.new(assets.interFont)
					inputName2.Text = "Blue"
					inputName2.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName2.TextSize = 13
					inputName2.TextTransparency = 0.5
					inputName2.TextTruncate = Enum.TextTruncate.AtEnd
					inputName2.TextXAlignment = Enum.TextXAlignment.Left
					inputName2.TextYAlignment = Enum.TextYAlignment.Top
					inputName2.AnchorPoint = Vector2.new(0, 0.5)
					inputName2.AutomaticSize = Enum.AutomaticSize.XY
					inputName2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName2.BackgroundTransparency = 1
					inputName2.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName2.BorderSizePixel = 0
					inputName2.LayoutOrder = 2
					inputName2.Position = UDim2.fromScale(0, 0.5)
					inputName2.Parent = blue

					local uIListLayout5 = Instance.new("UIListLayout")
					uIListLayout5.Name = "UIListLayout"
					uIListLayout5.Padding = UDim.new(0, 15)
					uIListLayout5.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout5.Parent = blue

					local inputBox2 = Instance.new("TextBox")
					inputBox2.Name = "InputBox"
					inputBox2.ClearTextOnFocus = false
					inputBox2.FontFace = Font.new(assets.interFont)
					inputBox2.Text = "255"
					inputBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox2.TextSize = 12
					inputBox2.TextTransparency = 0.1
					inputBox2.TextXAlignment = Enum.TextXAlignment.Left
					inputBox2.AnchorPoint = Vector2.new(1, 0.5)
					inputBox2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox2.BackgroundTransparency = 0.95
					inputBox2.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox2.BorderSizePixel = 0
					inputBox2.ClipsDescendants = true
					inputBox2.LayoutOrder = 1
					inputBox2.Position = UDim2.fromScale(1, 0.5)
					inputBox2.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner2 = Instance.new("UICorner")
					inputBoxUICorner2.Name = "InputBoxUICorner"
					inputBoxUICorner2.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner2.Parent = inputBox2

					local inputBoxUIStroke2 = Instance.new("UIStroke")
					inputBoxUIStroke2.Name = "InputBoxUIStroke"
					inputBoxUIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke2.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke2.Transparency = 0.9
					inputBoxUIStroke2.Parent = inputBox2

					local inputBoxUISizeConstraint2 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint2.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint2.Parent = inputBox2

					local inputBoxUIPadding2 = Instance.new("UIPadding")
					inputBoxUIPadding2.Name = "InputBoxUIPadding"
					inputBoxUIPadding2.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding2.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding2.Parent = inputBox2

					inputBox2.Parent = blue

					blue.Parent = inputs

					local alpha = Instance.new("Frame")
					alpha.Name = "Alpha"
					alpha.AutomaticSize = Enum.AutomaticSize.XY
					alpha.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					alpha.BackgroundTransparency = 1
					alpha.BorderColor3 = Color3.fromRGB(0, 0, 0)
					alpha.BorderSizePixel = 0
					alpha.LayoutOrder = 4
					alpha.Size = UDim2.fromOffset(0, 38)
					alpha.Visible = isAlpha

					local inputName3 = Instance.new("TextLabel")
					inputName3.Name = "InputName"
					inputName3.FontFace = Font.new(assets.interFont)
					inputName3.Text = "Alpha"
					inputName3.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName3.TextSize = 13
					inputName3.TextTransparency = 0.5
					inputName3.TextTruncate = Enum.TextTruncate.AtEnd
					inputName3.TextXAlignment = Enum.TextXAlignment.Left
					inputName3.TextYAlignment = Enum.TextYAlignment.Top
					inputName3.AnchorPoint = Vector2.new(0, 0.5)
					inputName3.AutomaticSize = Enum.AutomaticSize.XY
					inputName3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName3.BackgroundTransparency = 1
					inputName3.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName3.BorderSizePixel = 0
					inputName3.LayoutOrder = 2
					inputName3.Position = UDim2.fromScale(0, 0.5)
					inputName3.Parent = alpha

					local uIListLayout6 = Instance.new("UIListLayout")
					uIListLayout6.Name = "UIListLayout"
					uIListLayout6.Padding = UDim.new(0, 15)
					uIListLayout6.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout6.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout6.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout6.Parent = alpha

					local inputBox3 = Instance.new("TextBox")
					inputBox3.Name = "InputBox"
					inputBox3.ClearTextOnFocus = false
					inputBox3.FontFace = Font.new(assets.interFont)
					inputBox3.Text = "0"
					inputBox3.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox3.TextSize = 12
					inputBox3.TextTransparency = 0.1
					inputBox3.TextXAlignment = Enum.TextXAlignment.Left
					inputBox3.AnchorPoint = Vector2.new(1, 0.5)
					inputBox3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox3.BackgroundTransparency = 0.95
					inputBox3.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox3.BorderSizePixel = 0
					inputBox3.ClipsDescendants = true
					inputBox3.LayoutOrder = 1
					inputBox3.Position = UDim2.fromScale(1, 0.5)
					inputBox3.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner3 = Instance.new("UICorner")
					inputBoxUICorner3.Name = "InputBoxUICorner"
					inputBoxUICorner3.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner3.Parent = inputBox3

					local inputBoxUIStroke3 = Instance.new("UIStroke")
					inputBoxUIStroke3.Name = "InputBoxUIStroke"
					inputBoxUIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke3.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke3.Transparency = 0.9
					inputBoxUIStroke3.Parent = inputBox3

					local inputBoxUISizeConstraint3 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint3.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint3.Parent = inputBox3

					local inputBoxUIPadding3 = Instance.new("UIPadding")
					inputBoxUIPadding3.Name = "InputBoxUIPadding"
					inputBoxUIPadding3.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding3.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding3.Parent = inputBox3

					inputBox3.Parent = alpha

					alpha.Parent = inputs

					local hex = Instance.new("Frame")
					hex.Name = "Hex"
					hex.AutomaticSize = Enum.AutomaticSize.XY
					hex.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					hex.BackgroundTransparency = 1
					hex.BorderColor3 = Color3.fromRGB(0, 0, 0)
					hex.BorderSizePixel = 0
					hex.Size = UDim2.fromOffset(0, 38)

					local inputName4 = Instance.new("TextLabel")
					inputName4.Name = "InputName"
					inputName4.FontFace = Font.new(assets.interFont)
					inputName4.Text = "Hex"
					inputName4.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputName4.TextSize = 13
					inputName4.TextTransparency = 0.5
					inputName4.TextTruncate = Enum.TextTruncate.AtEnd
					inputName4.TextXAlignment = Enum.TextXAlignment.Left
					inputName4.TextYAlignment = Enum.TextYAlignment.Top
					inputName4.AnchorPoint = Vector2.new(0, 0.5)
					inputName4.AutomaticSize = Enum.AutomaticSize.XY
					inputName4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputName4.BackgroundTransparency = 1
					inputName4.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputName4.BorderSizePixel = 0
					inputName4.LayoutOrder = 2
					inputName4.Position = UDim2.fromScale(0, 0.5)
					inputName4.Parent = hex

					local uIListLayout7 = Instance.new("UIListLayout")
					uIListLayout7.Name = "UIListLayout"
					uIListLayout7.Padding = UDim.new(0, 15)
					uIListLayout7.FillDirection = Enum.FillDirection.Horizontal
					uIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
					uIListLayout7.Parent = hex

					local inputBox4 = Instance.new("TextBox")
					inputBox4.Name = "InputBox"
					inputBox4.ClearTextOnFocus = false
					inputBox4.CursorPosition = -1
					inputBox4.FontFace = Font.new(assets.interFont)
					inputBox4.Text = "255"
					inputBox4.TextColor3 = Color3.fromRGB(255, 255, 255)
					inputBox4.TextSize = 12
					inputBox4.TextTransparency = 0.1
					inputBox4.TextXAlignment = Enum.TextXAlignment.Left
					inputBox4.AnchorPoint = Vector2.new(1, 0.5)
					inputBox4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					inputBox4.BackgroundTransparency = 0.95
					inputBox4.BorderColor3 = Color3.fromRGB(0, 0, 0)
					inputBox4.BorderSizePixel = 0
					inputBox4.ClipsDescendants = true
					inputBox4.LayoutOrder = 1
					inputBox4.Position = UDim2.fromScale(1, 0.5)
					inputBox4.Size = UDim2.fromOffset(75, 25)

					local inputBoxUICorner4 = Instance.new("UICorner")
					inputBoxUICorner4.Name = "InputBoxUICorner"
					inputBoxUICorner4.CornerRadius = UDim.new(0, 4)
					inputBoxUICorner4.Parent = inputBox4

					local inputBoxUIStroke4 = Instance.new("UIStroke")
					inputBoxUIStroke4.Name = "InputBoxUIStroke"
					inputBoxUIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					inputBoxUIStroke4.Color = Color3.fromRGB(255, 255, 255)
					inputBoxUIStroke4.Transparency = 0.9
					inputBoxUIStroke4.Parent = inputBox4

					local inputBoxUISizeConstraint4 = Instance.new("UISizeConstraint")
					inputBoxUISizeConstraint4.Name = "InputBoxUISizeConstraint"
					inputBoxUISizeConstraint4.Parent = inputBox4

					local inputBoxUIPadding4 = Instance.new("UIPadding")
					inputBoxUIPadding4.Name = "InputBoxUIPadding"
					inputBoxUIPadding4.PaddingLeft = UDim.new(0, 8)
					inputBoxUIPadding4.PaddingRight = UDim.new(0, 10)
					inputBoxUIPadding4.Parent = inputBox4

					inputBox4.Parent = hex

					hex.Parent = inputs

					inputs.Parent = wheel

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingRight = UDim.new(0, 5)
					uIPadding.Parent = wheel

					wheel.Parent = colorOptions

					local colorWells = Instance.new("Frame")
					colorWells.Name = "ColorWells"
					colorWells.AutomaticSize = Enum.AutomaticSize.Y
					colorWells.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					colorWells.BackgroundTransparency = 1
					colorWells.BorderColor3 = Color3.fromRGB(0, 0, 0)
					colorWells.BorderSizePixel = 0
					colorWells.LayoutOrder = 2
					colorWells.Size = UDim2.fromScale(1, 0)

					local uIGridLayout = Instance.new("UIGridLayout")
					uIGridLayout.Name = "UIGridLayout"
					uIGridLayout.CellPadding = UDim2.fromOffset(10, 0)
					uIGridLayout.CellSize = UDim2.new(0.5, -5, 0, 30)
					uIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIGridLayout.Parent = colorWells

					local newColor = Instance.new("ImageLabel")
					newColor.Name = "NewColor"
					newColor.Image = assets.grid
					newColor.ScaleType = Enum.ScaleType.Tile
					newColor.TileSize = UDim2.fromOffset(500, 500)
					newColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					newColor.BackgroundTransparency = 1
					newColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
					newColor.BorderSizePixel = 0
					newColor.Size = UDim2.fromOffset(100, 100)

					local uICorner2 = Instance.new("UICorner")
					uICorner2.Name = "UICorner"
					uICorner2.Parent = newColor

					local color = Instance.new("Frame")
					color.Name = "Color"
					color.AnchorPoint = Vector2.new(0.5, 0.5)
					color.BorderColor3 = Color3.fromRGB(27, 42, 53)
					color.BorderSizePixel = 0
					color.Position = UDim2.fromScale(0.5, 0.5)
					color.Size = UDim2.new(1, 1, 1, 1)

					local uICorner3 = Instance.new("UICorner")
					uICorner3.Name = "UICorner"
					uICorner3.Parent = color

					color.Parent = newColor

					newColor.Parent = colorWells

					local oldColor = Instance.new("ImageLabel")
					oldColor.Name = "OldColor"
					oldColor.Image = assets.grid
					oldColor.ScaleType = Enum.ScaleType.Tile
					oldColor.TileSize = UDim2.fromOffset(500, 500)
					oldColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					oldColor.BackgroundTransparency = 1
					oldColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
					oldColor.BorderSizePixel = 0
					oldColor.LayoutOrder = 1
					oldColor.Size = UDim2.fromOffset(100, 100)

					local uICorner4 = Instance.new("UICorner")
					uICorner4.Name = "UICorner"
					uICorner4.Parent = oldColor

					local color1 = Instance.new("Frame")
					color1.Name = "Color"
					color1.AnchorPoint = Vector2.new(0.5, 0.5)
					color1.BorderColor3 = Color3.fromRGB(27, 42, 53)
					color1.BorderSizePixel = 0
					color1.Position = UDim2.fromScale(0.5, 0.5)
					color1.Size = UDim2.new(1, 1, 1, 1)

					local uICorner5 = Instance.new("UICorner")
					uICorner5.Name = "UICorner"
					uICorner5.Parent = color1

					color1.Parent = oldColor

					oldColor.Parent = colorWells

					colorWells.Parent = colorOptions

					colorOptions.Parent = prompt

					local interactions = Instance.new("Frame")
					interactions.Name = "Interactions"
					interactions.AutomaticSize = Enum.AutomaticSize.Y
					interactions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					interactions.BackgroundTransparency = 1
					interactions.BorderColor3 = Color3.fromRGB(0, 0, 0)
					interactions.BorderSizePixel = 0
					interactions.LayoutOrder = 2
					interactions.Size = UDim2.fromScale(1, 0)

					local uIListLayout8 = Instance.new("UIListLayout")
					uIListLayout8.Name = "UIListLayout"
					uIListLayout8.Padding = UDim.new(0, 10)
					uIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout8.Parent = interactions

					local confirm = Instance.new("TextButton")
					confirm.Name = "Confirm"
					confirm.FontFace = Font.new(
						"rbxassetid://12187365364",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					confirm.Text = "Confirm"
					confirm.TextColor3 = Color3.fromRGB(255, 255, 255)
					confirm.TextSize = 15
					confirm.TextTransparency = 0.5
					confirm.TextTruncate = Enum.TextTruncate.AtEnd
					confirm.AutoButtonColor = false
					confirm.AutomaticSize = Enum.AutomaticSize.Y
					confirm.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					confirm.BorderColor3 = Color3.fromRGB(0, 0, 0)
					confirm.BorderSizePixel = 0
					confirm.Size = UDim2.fromScale(1, 0)

					local uIPadding1 = Instance.new("UIPadding")
					uIPadding1.Name = "UIPadding"
					uIPadding1.PaddingBottom = UDim.new(0, 9)
					uIPadding1.PaddingLeft = UDim.new(0, 10)
					uIPadding1.PaddingRight = UDim.new(0, 10)
					uIPadding1.PaddingTop = UDim.new(0, 9)
					uIPadding1.Parent = confirm

					local baseUICorner = Instance.new("UICorner")
					baseUICorner.Name = "BaseUICorner"
					baseUICorner.CornerRadius = UDim.new(0, 10)
					baseUICorner.Parent = confirm

					confirm.Parent = interactions

					local cancel = Instance.new("TextButton")
					cancel.Name = "Cancel"
					cancel.FontFace = Font.new(
						"rbxassetid://12187365364",
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					cancel.Text = "Cancel"
					cancel.TextColor3 = Color3.fromRGB(255, 255, 255)
					cancel.TextSize = 15
					cancel.TextTransparency = 0.5
					cancel.TextTruncate = Enum.TextTruncate.AtEnd
					cancel.AutoButtonColor = false
					cancel.AutomaticSize = Enum.AutomaticSize.Y
					cancel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					cancel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					cancel.BorderSizePixel = 0
					cancel.Size = UDim2.fromScale(1, 0)

					local baseUICorner1 = Instance.new("UICorner")
					baseUICorner1.Name = "BaseUICorner"
					baseUICorner1.CornerRadius = UDim.new(0, 10)
					baseUICorner1.Parent = cancel

					local uIPadding2 = Instance.new("UIPadding")
					uIPadding2.Name = "UIPadding"
					uIPadding2.PaddingBottom = UDim.new(0, 9)
					uIPadding2.PaddingLeft = UDim.new(0, 10)
					uIPadding2.PaddingRight = UDim.new(0, 10)
					uIPadding2.PaddingTop = UDim.new(0, 9)
					uIPadding2.Parent = cancel

					cancel.Parent = interactions

					local uIPadding3 = Instance.new("UIPadding")
					uIPadding3.Name = "UIPadding"
					uIPadding3.PaddingTop = UDim.new(0, 10)
					uIPadding3.Parent = interactions

					interactions.Parent = prompt

					local globalSettingsUIPadding = Instance.new("UIPadding")
					globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
					globalSettingsUIPadding.PaddingBottom = UDim.new(0, 20)
					globalSettingsUIPadding.PaddingLeft = UDim.new(0, 20)
					globalSettingsUIPadding.PaddingRight = UDim.new(0, 20)
					globalSettingsUIPadding.PaddingTop = UDim.new(0, 20)
					globalSettingsUIPadding.Parent = prompt

					local paragraph = Instance.new("Frame")
					paragraph.Name = "Paragraph"
					paragraph.AutomaticSize = Enum.AutomaticSize.Y
					paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BackgroundTransparency = 1
					paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BorderSizePixel = 0
					paragraph.Size = UDim2.fromScale(1, 0)

					local paragraphHeader = Instance.new("TextLabel")
					paragraphHeader.Name = "ParagraphHeader"
					paragraphHeader.FontFace = Font.new(
						"rbxassetid://12187365364",
						Enum.FontWeight.SemiBold,
						Enum.FontStyle.Normal
					)
					paragraphHeader.RichText = true
					paragraphHeader.Text = ColorpickerFunctions.Settings.Name
					paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.TextSize = 18
					paragraphHeader.TextTransparency = 0.4
					paragraphHeader.TextWrapped = true
					paragraphHeader.TextYAlignment = Enum.TextYAlignment.Top
					paragraphHeader.AutomaticSize = Enum.AutomaticSize.XY
					paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.BackgroundTransparency = 1
					paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphHeader.BorderSizePixel = 0
					paragraphHeader.Size = UDim2.fromScale(1, 0)
					paragraphHeader.Parent = paragraph

					local uIListLayout9 = Instance.new("UIListLayout")
					uIListLayout9.Name = "UIListLayout"
					uIListLayout9.Padding = UDim.new(0, 15)
					uIListLayout9.HorizontalAlignment = Enum.HorizontalAlignment.Center
					uIListLayout9.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout9.Parent = paragraph

					local uIPadding4 = Instance.new("UIPadding")
					uIPadding4.Name = "UIPadding"
					uIPadding4.PaddingBottom = UDim.new(0, 15)
					uIPadding4.Parent = paragraph

					local line = Instance.new("Frame")
					line.Name = "Line"
					line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					line.BackgroundTransparency = 0.9
					line.BorderColor3 = Color3.fromRGB(0, 0, 0)
					line.BorderSizePixel = 0
					line.LayoutOrder = 1
					line.Size = UDim2.new(1, 0, 0, 1)
					line.Parent = paragraph

					paragraph.Parent = prompt

					prompt.Parent = colorPicker

					colorPicker.Parent = base

					local fromHSV, fromRGB, v2, udim2 = Color3.fromHSV, Color3.fromRGB, Vector2.new, UDim2.new

					local wheel = wheel1
					local ring = target
					local slider = value
					local colour = color

					local modifierInputs = {
						Hex = hex.InputBox,
						Red = red.InputBox,
						Green = green.InputBox,
						Blue = blue.InputBox,
						Alpha = alpha.InputBox
					}

					local Mouse = LocalPlayer:GetMouse()

					local WheelDown, SlideDown = false, false
					local hue, saturation, value = 0, 0, 1

					local function toPolar(v)
						return math.atan2(v.y, v.x), v.magnitude
					end

					local function radToDeg(x)
						return ((x + math.pi) / (2 * math.pi)) * 360
					end

					local function degToRad(degrees)
						return degrees * (math.pi / 180)
					end

					local function hexToRGB(hex)
						hex = hex:gsub("#","")
						if #hex ~= 6 then return 0, 0, 0 end
						local r = tonumber(hex:sub(1, 2), 16) or 0
						local g = tonumber(hex:sub(3, 4), 16) or 0
						local b = tonumber(hex:sub(5, 6), 16) or 0
						return r, g, b
					end

					local function clampInput(value, min, max)
						local num = tonumber(value)
						if num then
							return math.clamp(num, min, max)
						end
						return min
					end

					local function update()
						local c = fromHSV(hue, saturation, value)
						colour.BackgroundColor3 = c
						colour.BackgroundTransparency = clampInput(modifierInputs.Alpha.Text, 0, 1)

						modifierInputs.Red.Text = tostring(math.floor(c.r * 255 + 0.5))
						modifierInputs.Green.Text = tostring(math.floor(c.g * 255 + 0.5))
						modifierInputs.Blue.Text = tostring(math.floor(c.b * 255 + 0.5))
						modifierInputs.Alpha.Text = clampInput(modifierInputs.Alpha.Text, 0, 1)

						local hexColor = string.format("#%02X%02X%02X", 
							math.floor(c.r * 255 + 0.5),
							math.floor(c.g * 255 + 0.5),
							math.floor(c.b * 255 + 0.5))
						modifierInputs.Hex.Text = hexColor
					end

					local function UpdateSlide(iX)
						local rY = iX - slider.AbsolutePosition.X
						local cY = math.clamp(rY, 0, slider.AbsoluteSize.X - slide.AbsoluteSize.X)
						slide.Position = udim2(0, cY, 0.5, 0)
						value = 1 - (cY / (slider.AbsoluteSize.X - slide.AbsoluteSize.X))
						update()
					end

					local function UpdateRing(iX, iY)
						local r = wheel.AbsoluteSize.x / 2
						local d = v2(iX, iY) - wheel.AbsolutePosition - wheel.AbsoluteSize / 2

						if d:Dot(d) > r * r then
							d = d.unit * r
						end

						ring.Position = udim2(0.5, d.x, 0.5, d.y)
						local phi, len = toPolar(d * v2(1, -1))
						hue, saturation = radToDeg(phi) / 360, math.clamp(len / r, 0, 1)
						slider.BackgroundColor3 = fromHSV(hue, saturation, 1)
						update()
					end

					local function UpdateSlideFromValue(value)
						local cY = (1 - value) * (slider.AbsoluteSize.X - slide.AbsoluteSize.X)
						slide.Position = UDim2.new(0, cY, 0.5, 0)
					end

					local function UpdateRingFromHSV(hue, saturation)
						local r = wheel.AbsoluteSize.X / 2
						local phi = degToRad(hue * 360)
						local len = saturation * r
						local x = len * math.cos(phi)
						local y = len * math.sin(phi)

						ring.Position = UDim2.new(0.5, -x, 0.5, y)
						slider.BackgroundColor3 = fromHSV(hue, saturation, 1)
					end

					local function updateFromRGB()
						local r = clampInput(modifierInputs.Red.Text, 0, 255)
						local g = clampInput(modifierInputs.Green.Text, 0, 255)
						local b = clampInput(modifierInputs.Blue.Text, 0, 255)
						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()

						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)
						update()
					end

					local function updateFromHex()
						local hex = modifierInputs.Hex.Text
						local r, g, b = hexToRGB(hex)

						r = clampInput(r, 0, 255)
						g = clampInput(g, 0, 255)
						b = clampInput(b, 0, 255)

						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()
						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)
						update()
					end

					local function updateFromSettings()
						local r = math.floor(ColorpickerFunctions.Color.R * 255 + 0.5)
						local g = math.floor(ColorpickerFunctions.Color.G * 255 + 0.5)
						local b = math.floor(ColorpickerFunctions.Color.B * 255 + 0.5)
						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b
						modifierInputs.Alpha.Text = isAlpha and ColorpickerFunctions.Alpha or 0

						local hexColor = string.format("#%02X%02X%02X", r,g,b)
						modifierInputs.Hex.Text = hexColor

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()

						color1.BackgroundColor3 = ColorpickerFunctions.Color
						color1.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						colour.BackgroundColor3 = Color3.fromRGB(r,g,b)
						colour.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)
					end

					wheel.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							WheelDown = true
							UpdateRing(Mouse.X, Mouse.Y)
						end
					end)

					slider.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							SlideDown = true
							UpdateSlide(Mouse.X)
						end
					end)

					slider.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							SlideDown = false
						end
					end)

					wheel.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
							WheelDown = false
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
							if SlideDown then
								UpdateSlide(Mouse.X)
							elseif WheelDown then
								UpdateRing(Mouse.X, Mouse.Y)
							end
						end
					end)

					local function onFocusEnter(instance)
						local placeholder = instance.Text
						instance.Text = ""
						instance.PlaceholderText = placeholder
					end

					modifierInputs.Hex.FocusLost:Connect(updateFromHex)
					modifierInputs.Red.FocusLost:Connect(updateFromRGB)
					modifierInputs.Green.FocusLost:Connect(updateFromRGB)
					modifierInputs.Blue.FocusLost:Connect(updateFromRGB)
					modifierInputs.Alpha.FocusLost:Connect(update)

					modifierInputs.Hex.Focused:Connect(function()
						onFocusEnter(modifierInputs.Hex)
					end)
					modifierInputs.Red.Focused:Connect(function()
						onFocusEnter(modifierInputs.Red)
					end)
					modifierInputs.Green.Focused:Connect(function()
						onFocusEnter(modifierInputs.Green)
					end)
					modifierInputs.Blue.Focused:Connect(function()
						onFocusEnter(modifierInputs.Blue)
					end)
					modifierInputs.Alpha.Focused:Connect(function()
						onFocusEnter(modifierInputs.Alpha)
					end)

					local function makeCanvas()
						local ColorPickerCanvas = Instance.new("CanvasGroup")
						ColorPickerCanvas.Name = "ColorPickerCanvas"
						ColorPickerCanvas.BackgroundTransparency = 1
						ColorPickerCanvas.BorderSizePixel = 0
						ColorPickerCanvas.Size = UDim2.fromScale(1, 1)
						ColorPickerCanvas.ZIndex = 5
						ColorPickerCanvas.GroupTransparency = 1
						ColorPickerCanvas.Parent = base
						ColorPickerCanvas.Visible = false
						return ColorPickerCanvas
					end

					local function transition(isIn)
						local canvas = makeCanvas()
						local tweenTransparency = isIn and 0 or 1
						local tweenScale = isIn and 1 or 0.95
						local stateTransparency = isIn and 1 or 0
						local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Sine)
						local canvasTween = Tween(canvas, tweenInfo, { GroupTransparency = tweenTransparency })
						local scaleTween = Tween(promptUIScale, tweenInfo, { Scale = tweenScale })

						colorPicker.Visible = true
						colorPicker.Parent = canvas
						canvas.Visible = true
						canvas.GroupTransparency = stateTransparency
						canvasTween:Play()
						scaleTween:Play()
						canvasTween.Completed:Wait()

						if not isIn then
							colorPicker.Visible = false
							canvas.Visible = false
						end

						colorPicker.Parent = base
						canvas:Destroy()
					end

					local function colorpickerIn()
						transition(true)
					end

					local function colorpickerOut()
						transition(false)
					end

					interact.MouseButton1Click:Connect(colorpickerIn)

					cancel.MouseButton1Click:Connect(colorpickerOut)
					confirm.MouseButton1Click:Connect(function()
						colorpickerOut()
						local c = fromHSV(hue, saturation, value)
						ColorpickerFunctions.Color = Color3.fromRGB(c.r * 255, c.g * 255, c.b * 255)
						ColorpickerFunctions.Alpha = isAlpha and clampInput(modifierInputs.Alpha.Text, 0, 1)

						color1.BackgroundColor3 = ColorpickerFunctions.Color
						color1.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						colorC.BackgroundColor3 = ColorpickerFunctions.Color
						colorC.BackgroundTransparency = isAlpha and ColorpickerFunctions.Alpha or 0

						if ColorpickerFunctions.Settings.Callback then
							task.spawn(function()
								ColorpickerFunctions.Settings.Callback(ColorpickerFunctions.Color, isAlpha and ColorpickerFunctions.Alpha)
							end)
						end
					end)

					updateFromSettings()

					function ColorpickerFunctions:UpdateName(New)
						colorpickerName.Text = New
					end
					function ColorpickerFunctions:SetVisibility(State)
						colorpicker.Visible = State
					end

					function ColorpickerFunctions:SetColor(color3)
						ColorpickerFunctions.Color = color3
						colorC.BackgroundColor3 = color3

						local r = math.floor(ColorpickerFunctions.Color.R * 255 + 0.5)
						local g = math.floor(ColorpickerFunctions.Color.G * 255 + 0.5)
						local b = math.floor(ColorpickerFunctions.Color.B * 255 + 0.5)
						modifierInputs.Red.Text = r
						modifierInputs.Green.Text = g
						modifierInputs.Blue.Text = b

						local hexColor = string.format("#%02X%02X%02X", r,g,b)
						modifierInputs.Hex.Text = hexColor

						hue, saturation, value = Color3.fromRGB(r, g, b):ToHSV()

						color1.BackgroundColor3 = ColorpickerFunctions.Color
						colour.BackgroundColor3 = Color3.fromRGB(r,g,b)

						UpdateSlideFromValue(value)
						UpdateRingFromHSV(hue, saturation)

						if ColorpickerFunctions.Settings.Callback then
							task.spawn(function()
								ColorpickerFunctions.Settings.Callback(ColorpickerFunctions.Color, isAlpha and ColorpickerFunctions.Alpha)
							end)
						end
					end

					function ColorpickerFunctions:SetAlpha(alpha)
						ColorpickerFunctions.Alpha = alpha
						colorC.Transparency = alpha
						updateFromSettings()
					end

					if Flag then
						MacLib.Options[Flag] = ColorpickerFunctions
					end
					return ColorpickerFunctions
				end

				function SectionFunctions:Header(Settings, Flag)
					local HeaderFunctions = {Settings = Settings}

					local header = Instance.new("Frame")
					header.Name = "Header"
					header.AutomaticSize = Enum.AutomaticSize.Y
					header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					header.BackgroundTransparency = 1
					header.BorderColor3 = Color3.fromRGB(0, 0, 0)
					header.BorderSizePixel = 0
					header.LayoutOrder = 0
					header.Size = UDim2.fromScale(1, 0)
					header.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 5)
					uIPadding.Parent = header

					local headerText = Instance.new("TextLabel")
					headerText.Name = "HeaderText"
					headerText.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					headerText.RichText = true
					headerText.Text = HeaderFunctions.Settings.Text or HeaderFunctions.Settings.Name
					headerText.TextColor3 = Color3.fromRGB(255, 255, 255)
					headerText.TextSize = 16
					headerText.TextTransparency = 0.3
					headerText.TextWrapped = true
					headerText.TextXAlignment = Enum.TextXAlignment.Left
					headerText.AutomaticSize = Enum.AutomaticSize.Y
					headerText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					headerText.BackgroundTransparency = 1
					headerText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					headerText.BorderSizePixel = 0
					headerText.Size = UDim2.fromScale(1, 0)
					headerText.Parent = header

					function HeaderFunctions:UpdateName(New)
						headerText.Text = New
					end
					function HeaderFunctions:SetVisibility(State)
						header.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = HeaderFunctions
					end
					return HeaderFunctions
				end

				function SectionFunctions:Label(Settings, Flag)
					local LabelFunctions = {Settings = Settings}

					local label = Instance.new("Frame")
					label.Name = "Label"
					label.AutomaticSize = Enum.AutomaticSize.Y
					label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					label.BackgroundTransparency = 1
					label.BorderColor3 = Color3.fromRGB(0, 0, 0)
					label.BorderSizePixel = 0
					label.Size = UDim2.new(1, 0, 0, 38)
					label.Parent = section

					local labelText = Instance.new("TextLabel")
					labelText.Name = "LabelText"
					labelText.FontFace = Font.new(assets.interFont)
					labelText.RichText = true
					labelText.Text = LabelFunctions.Settings.Text or LabelFunctions.Settings.Name -- Settings.Name Deprecated use Settings.Text
					labelText.TextColor3 = Color3.fromRGB(255, 255, 255)
					labelText.TextSize = 13
					labelText.TextTransparency = 0.5
					labelText.TextWrapped = true
					labelText.TextXAlignment = Enum.TextXAlignment.Left
					labelText.AutomaticSize = Enum.AutomaticSize.Y
					labelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					labelText.BackgroundTransparency = 1
					labelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					labelText.BorderSizePixel = 0
					labelText.Size = UDim2.fromScale(1, 1)
					labelText.Parent = label

					function LabelFunctions:UpdateName(New)
						labelText.Text = New
					end
					function LabelFunctions:SetVisibility(State)
						label.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = LabelFunctions
					end
					return LabelFunctions
				end

				function SectionFunctions:SubLabel(Settings, Flag)
					local SubLabelFunctions = {Settings = Settings}

					local subLabel = Instance.new("Frame")
					subLabel.Name = "SubLabel"
					subLabel.AutomaticSize = Enum.AutomaticSize.Y
					subLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					subLabel.BackgroundTransparency = 1
					subLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
					subLabel.BorderSizePixel = 0
					subLabel.Size = UDim2.new(1, 0, 0, 0)
					subLabel.Parent = section

					local subLabelText = Instance.new("TextLabel")
					subLabelText.Name = "SubLabelText"
					subLabelText.FontFace = Font.new(assets.interFont)
					subLabelText.RichText = true
					subLabelText.Text = SubLabelFunctions.Settings.Text or SubLabelFunctions.Settings.Name -- Settings.Name Deprecated use Settings.Text
					subLabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
					subLabelText.TextSize = 12
					subLabelText.TextTransparency = 0.7
					subLabelText.TextWrapped = true
					subLabelText.TextXAlignment = Enum.TextXAlignment.Left
					subLabelText.AutomaticSize = Enum.AutomaticSize.Y
					subLabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					subLabelText.BackgroundTransparency = 1
					subLabelText.BorderColor3 = Color3.fromRGB(0, 0, 0)
					subLabelText.BorderSizePixel = 0
					subLabelText.Size = UDim2.fromScale(1, 1)
					subLabelText.Parent = subLabel

					function SubLabelFunctions:UpdateName(New)
						subLabelText.Text = New
					end
					function SubLabelFunctions:SetVisibility(State)
						subLabel.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = SubLabelFunctions
					end
					return SubLabelFunctions
				end

				function SectionFunctions:Paragraph(Settings, Flag)
					local ParagraphFunctions = {Settings = Settings}

					local paragraph = Instance.new("Frame")
					paragraph.Name = "Paragraph"
					paragraph.AutomaticSize = Enum.AutomaticSize.Y
					paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BackgroundTransparency = 1
					paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraph.BorderSizePixel = 0
					paragraph.Size = UDim2.new(1, 0, 0, 38)
					paragraph.Parent = section

					local paragraphHeader = Instance.new("TextLabel")
					paragraphHeader.Name = "ParagraphHeader"
					paragraphHeader.FontFace = Font.new(
						assets.interFont,
						Enum.FontWeight.Medium,
						Enum.FontStyle.Normal
					)
					paragraphHeader.RichText = true
					paragraphHeader.Text = ParagraphFunctions.Settings.Header
					paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.TextSize = 15
					paragraphHeader.TextTransparency = 0.4
					paragraphHeader.TextWrapped = true
					paragraphHeader.TextXAlignment = Enum.TextXAlignment.Left
					paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
					paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphHeader.BackgroundTransparency = 1
					paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphHeader.BorderSizePixel = 0
					paragraphHeader.Size = UDim2.fromScale(1, 0)
					paragraphHeader.Parent = paragraph

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.Padding = UDim.new(0, 5)
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = paragraph

					local paragraphBody = Instance.new("TextLabel")
					paragraphBody.Name = "ParagraphBody"
					paragraphBody.FontFace = Font.new(assets.interFont)
					paragraphBody.RichText = true
					paragraphBody.Text = ParagraphFunctions.Settings.Body
					paragraphBody.TextColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.TextSize = 13
					paragraphBody.TextTransparency = 0.5
					paragraphBody.TextWrapped = true
					paragraphBody.TextXAlignment = Enum.TextXAlignment.Left
					paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
					paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					paragraphBody.BackgroundTransparency = 1
					paragraphBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
					paragraphBody.BorderSizePixel = 0
					paragraphBody.LayoutOrder = 1
					paragraphBody.Size = UDim2.fromScale(1, 0)
					paragraphBody.Parent = paragraph

					function ParagraphFunctions:UpdateHeader(New)
						paragraphHeader.Text = New
					end
					function ParagraphFunctions:UpdateBody(New)
						paragraphBody.Text = New
					end
					function ParagraphFunctions:SetVisibility(State)
						paragraph.Visible = State
					end

					if Flag then
						MacLib.Options[Flag] = ParagraphFunctions
					end
					return ParagraphFunctions
				end

				function SectionFunctions:Divider()
					local DividerFunctions = {}

					local divider = Instance.new("Frame")
					divider.Name = "Divider"
					divider.AnchorPoint = Vector2.new(0, 1)
					divider.AutomaticSize = Enum.AutomaticSize.Y
					divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					divider.BackgroundTransparency = 1
					divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
					divider.BorderSizePixel = 0
					divider.Position = UDim2.fromScale(0, 1)
					divider.Size = UDim2.new(1, 0, 0, 1)
					divider.Parent = section

					local uIPadding = Instance.new("UIPadding")
					uIPadding.Name = "UIPadding"
					uIPadding.PaddingBottom = UDim.new(0, 8)
					uIPadding.PaddingTop = UDim.new(0, 8)
					uIPadding.Parent = divider

					local uIListLayout = Instance.new("UIListLayout")
					uIListLayout.Name = "UIListLayout"
					uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uIListLayout.Parent = divider

					local line = Instance.new("Frame")
					line.Name = "Line"
					line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					line.BackgroundTransparency = 0.9
					line.BorderColor3 = Color3.fromRGB(0, 0, 0)
					line.BorderSizePixel = 0
					line.Size = UDim2.new(1, 0, 0, 1)
					line.Parent = divider

					function DividerFunctions:Remove()
						divider:Destroy()
					end
					function DividerFunctions:SetVisibility(State)
						divider.Visible = State
					end

					return DividerFunctions
				end

				function SectionFunctions:Spacer()
					local SpacerFunctions = {}

					local spacer = Instance.new("Frame")
					spacer.Name = "Spacer"
					spacer.AnchorPoint = Vector2.new(0, 1)
					spacer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					spacer.BackgroundTransparency = 1
					spacer.BorderColor3 = Color3.fromRGB(0, 0, 0)
					spacer.BorderSizePixel = 0
					spacer.Position = UDim2.fromScale(0, 1)
					spacer.Parent = section

					function SpacerFunctions:Remove()
						spacer:Destroy()
					end
					function SpacerFunctions:SetVisibility(State)
						spacer.Visible = State
					end

					return SpacerFunctions
				end

				return SectionFunctions
			end

			local function SelectCurrentTab()
				local easetime = 0.15

				if currentTabInstance then
					currentTabInstance.Parent = nil
				end

				for i, tabInfo in pairs(tabs) do
					Tween(i, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
						BackgroundTransparency = (i == tabSwitcher and 0.98 or 1)
					}):Play()

					if tabInfo.tabStroke then
						Tween(tabInfo.tabStroke, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							Transparency = (i == tabSwitcher and 0.95 or 1)
						}):Play()
					end
					if tabInfo.switcherImage then
						Tween(tabInfo.switcherImage, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							ImageTransparency = (i == tabSwitcher and 0.1 or 0.5)
						}):Play()
					end
					if tabInfo.switcherName then
						Tween(tabInfo.switcherName, TweenInfo.new(easetime, Enum.EasingStyle.Sine), {
							TextTransparency = (i == tabSwitcher and 0.1 or 0.5)
						}):Play()
					end
				end

				tabs[tabSwitcher].tabContent.Parent = content
				currentTabInstance = tabs[tabSwitcher].tabContent
				currentTab.Text = Settings.Name
			end

			tabSwitcher.MouseButton1Click:Connect(function()
				SelectCurrentTab()
			end)

			function TabFunctions:Select()
				SelectCurrentTab()
			end

			function TabFunctions:InsertConfigSection(Side)
				local configSection = TabFunctions:Section({ Side = "Left" })

				if isStudio then
					configSection:Label({Text = "Config system unavailable. (Environment isStudio)"})
					return "Config system unavailable." 
				end

				local inputPath = nil
				local selectedConfig = nil

				configSection:Input({
					Name = "Config Name",
					Placeholder = "Name",
					AcceptedCharacters = "All",
					Callback = function(input)
						inputPath = input
					end,
				})

				local configSelection = configSection:Dropdown({
					Name = "Select Config",
					Multi = false,
					Required = false,
					Options = MacLib:RefreshConfigList(),
					Callback = function(Value)
						selectedConfig = Value
					end,
				})

				configSection:Button({
					Name = "Create Config",
					Callback = function()
						if not inputPath or string.gsub(inputPath, " ", "") == "" then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Config name cannot be empty."
							})
							return
						end

						local success, returned = MacLib:SaveConfig(inputPath)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to save config, return error: " .. returned
							})
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Created config %q", inputPath),
						})

						configSelection:ClearOptions()
						configSelection:InsertOptions(MacLib:RefreshConfigList())
					end,
				})

				configSection:Button({
					Name = "Load Config",
					Callback = function()
						local success, returned = MacLib:LoadConfig(configSelection.Value)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to load config, return error: " .. returned
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Loaded config %q", configSelection.Value),
						})
					end,
				})

				configSection:Button({
					Name = "Overwrite Config",
					Callback = function()
						local success, returned = MacLib:SaveConfig(configSelection.Value)
						if not success then
							WindowFunctions:Notify({
								Title = "Interface",
								Description = "Unable to overwrite config, return error: " .. returned
							})
							return
						end

						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Overwrote config %q", configSelection.Value),
						})
					end,
				})

				configSection:Button({
					Name = "Refresh Config List",
					Callback = function()
						configSelection:ClearOptions()
						configSelection:InsertOptions(MacLib:RefreshConfigList())
					end,
				})

				local autoloadLabel

				configSection:Button({
					Name = "Set as autoload",
					Callback = function()
						local name = configSelection.Value
						writefile(MacLib.Folder .. "/settings/autoload.txt", name)
						autoloadLabel:UpdateName("Autoload config: " .. name)
						WindowFunctions:Notify({
							Title = "Interface",
							Description = string.format("Set %q as autoload", name),
						})
					end,
				})

				autoloadLabel = configSection:Label({Text = "Autoload config: None"})

				if isfile(MacLib.Folder .. "/settings/autoload.txt") then
					local name = readfile(MacLib.Folder .. "/settings/autoload.txt")
					autoloadLabel:UpdateName("Autoload config: " .. name)
				end
			end

			tabs[tabSwitcher] = {
				tabContent = elements1,
				tabStroke = tabSwitcherUIStroke,
				switcherImage = tabImage,
				switcherName = tabSwitcherName,
			}

			return TabFunctions
		end

		return SectionFunctions
	end

	function WindowFunctions:Notify(Settings)
		local NotificationFunctions = {}

		local notification = Instance.new("Frame")
		notification.Name = "Notification"
		notification.AnchorPoint = Vector2.new(0.5, 0.5)
		notification.AutomaticSize = Enum.AutomaticSize.Y
		notification.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notification.BorderSizePixel = 0
		notification.Position = UDim2.fromScale(0.5, 0.5)
		notification.Size = UDim2.fromOffset(Settings.SizeX or 250, 0)

		notification.Parent = notifications

		local notificationUIStroke = Instance.new("UIStroke")
		notificationUIStroke.Name = "NotificationUIStroke"
		notificationUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		notificationUIStroke.Color = Color3.fromRGB(255, 255, 255)
		notificationUIStroke.Transparency = 0.9
		notificationUIStroke.Parent = notification

		local notificationUICorner = Instance.new("UICorner")
		notificationUICorner.Name = "NotificationUICorner"
		notificationUICorner.CornerRadius = UDim.new(0, 10)
		notificationUICorner.Parent = notification

		local notificationUIScale = Instance.new("UIScale")
		notificationUIScale.Name = "NotificationUIScale"
		notificationUIScale.Parent = notification
		notificationUIScale.Scale = 0

		local notificationInformation = Instance.new("Frame")
		notificationInformation.Name = "NotificationInformation"
		notificationInformation.AutomaticSize = Enum.AutomaticSize.Y
		notificationInformation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationInformation.BackgroundTransparency = 1
		notificationInformation.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationInformation.BorderSizePixel = 0
		notificationInformation.Size = UDim2.fromScale(1, 1)

		local notificationTitle = Instance.new("TextLabel")
		notificationTitle.Name = "NotificationTitle"
		notificationTitle.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.SemiBold,
			Enum.FontStyle.Normal
		)
		notificationTitle.RichText = true
		notificationTitle.Text = Settings.Title
		notificationTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.TextSize = 13
		notificationTitle.TextTransparency = 0.2
		notificationTitle.TextTruncate = Enum.TextTruncate.SplitWord
		notificationTitle.TextXAlignment = Enum.TextXAlignment.Left
		notificationTitle.TextYAlignment = Enum.TextYAlignment.Top
		notificationTitle.AutomaticSize = Enum.AutomaticSize.XY
		notificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationTitle.BackgroundTransparency = 1
		notificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationTitle.BorderSizePixel = 0
		notificationTitle.Size = UDim2.new(1, -12, 0, 0)

		local notificationTitleUIPadding = Instance.new("UIPadding")
		notificationTitleUIPadding.Name = "NotificationTitleUIPadding"
		notificationTitleUIPadding.PaddingRight = UDim.new(0, 25)
		notificationTitleUIPadding.Parent = notificationTitle

		notificationTitle.Parent = notificationInformation

		local notificationDescription = Instance.new("TextLabel")
		notificationDescription.Name = "NotificationDescription"
		notificationDescription.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		notificationDescription.Text = Settings.Description
		notificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.TextSize = 11
		notificationDescription.TextTransparency = 0.5
		notificationDescription.TextWrapped = true
		notificationDescription.RichText = true
		notificationDescription.TextXAlignment = Enum.TextXAlignment.Left
		notificationDescription.TextYAlignment = Enum.TextYAlignment.Top
		notificationDescription.AutomaticSize = Enum.AutomaticSize.XY
		notificationDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationDescription.BackgroundTransparency = 1
		notificationDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationDescription.BorderSizePixel = 0
		notificationDescription.Size = UDim2.new(1, -12, 0, 0)

		local notificationDescriptionUIPadding = Instance.new("UIPadding")
		notificationDescriptionUIPadding.Name = "NotificationDescriptionUIPadding"
		notificationDescriptionUIPadding.PaddingRight = UDim.new(0, 25)
		notificationDescriptionUIPadding.PaddingTop = UDim.new(0, 17)
		notificationDescriptionUIPadding.Parent = notificationDescription

		notificationDescription.Parent = notificationInformation

		local notificationUIPadding = Instance.new("UIPadding")
		notificationUIPadding.Name = "NotificationUIPadding"
		notificationUIPadding.PaddingBottom = UDim.new(0, 12)
		notificationUIPadding.PaddingLeft = UDim.new(0, 10)
		notificationUIPadding.PaddingRight = UDim.new(0, 10)
		notificationUIPadding.PaddingTop = UDim.new(0, 10)
		notificationUIPadding.Parent = notificationInformation

		notificationInformation.Parent = notification

		local notificationControls = Instance.new("Frame")
		notificationControls.Name = "NotificationControls"
		notificationControls.AutomaticSize = Enum.AutomaticSize.Y
		notificationControls.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		notificationControls.BackgroundTransparency = 1
		notificationControls.BorderColor3 = Color3.fromRGB(0, 0, 0)
		notificationControls.BorderSizePixel = 0
		notificationControls.Size = UDim2.fromScale(1, 1)

		local interactable = Instance.new("TextButton")
		interactable.Name = "Interactable"
		interactable.FontFace = Font.new(assets.interFont)
		interactable.Text = "âœ“"
		interactable.TextColor3 = Color3.fromRGB(255, 255, 255)
		interactable.TextSize = 17
		interactable.TextTransparency = 0.2
		interactable.AnchorPoint = Vector2.new(1, 0.5)
		interactable.AutomaticSize = Enum.AutomaticSize.XY
		interactable.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		interactable.BackgroundTransparency = 1
		interactable.BorderColor3 = Color3.fromRGB(0, 0, 0)
		interactable.BorderSizePixel = 0
		interactable.LayoutOrder = 1
		interactable.Position = UDim2.fromScale(1, 0.5)
		interactable.Parent = notificationControls

		local uIPadding = Instance.new("UIPadding")
		uIPadding.Name = "UIPadding"
		uIPadding.PaddingBottom = UDim.new(0, 6)
		uIPadding.PaddingRight = UDim.new(0, 13)
		uIPadding.PaddingTop = UDim.new(0, 6)
		uIPadding.Parent = notificationControls

		notificationControls.Parent = notification

		local tweens = {
			In = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = Settings.Scale or 1
			}),
			Out = Tween(notificationUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Scale = 0
			}),
		}

		local styles = {
			None = function() interactable:Destroy() end,
			Confirm = function() interactable.Text = "âœ“" end,
			Cancel = function() interactable.Text = "âœ—" end
		}

		local style = styles[Settings.Style] or function() interactable:Destroy() end
		style()

		if interactable then
			interactable.MouseButton1Click:Connect(function()
				NotificationFunctions:Cancel()
				if Settings.Callback then
					task.spawn(Settings.Callback)
				end
			end)
		end

		local AnimateNotification = task.spawn(function()
			tweens.In:Play()

			Settings.Lifetime = Settings.Lifetime or 3

			if Settings.Lifetime ~= 0 then
				task.wait(Settings.Lifetime)

				local out = tweens.Out
				out:Play()
				out.Completed:Wait()
				notification:Destroy()
			end
		end)

		function NotificationFunctions:UpdateTitle(New)
			notificationTitle.Text = New
		end

		function NotificationFunctions:UpdateDescription(New)
			notificationDescription.Text = New
		end

		function NotificationFunctions:Resize(X)
			local targ = X or 250
			notification.Size = UDim2.fromOffset(targ, 0)
		end

		function NotificationFunctions:Cancel()
			task.cancel(AnimateNotification)

			local out = tweens.Out
			out:Play()
			out.Completed:Wait()
			notification:Destroy()
		end

		return NotificationFunctions
	end

	function WindowFunctions:Dialog(Settings)
		local DialogFunctions = {}

		local dialogCanvas = Instance.new("CanvasGroup")
		dialogCanvas.Name = "DialogCanvas"
		dialogCanvas.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dialogCanvas.BackgroundTransparency = 1
		dialogCanvas.BorderColor3 = Color3.fromRGB(0, 0, 0)
		dialogCanvas.BorderSizePixel = 0
		dialogCanvas.Size = UDim2.fromScale(1, 1)
		dialogCanvas.GroupTransparency = 1
		dialogCanvas.Parent = base

		local dialog = Instance.new("Frame")
		dialog.Name = "Dialog"
		dialog.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		dialog.BackgroundTransparency = 0.5
		dialog.BorderColor3 = Color3.fromRGB(0, 0, 0)
		dialog.BorderSizePixel = 0
		dialog.Size = UDim2.fromScale(1, 1)

		local dialogUICorner = Instance.new("UICorner")
		dialogUICorner.Name = "BaseUICorner"
		dialogUICorner.CornerRadius = UDim.new(0, 10)
		dialogUICorner.Parent = dialog

		local prompt = Instance.new("Frame")
		prompt.Name = "Prompt"
		prompt.AnchorPoint = Vector2.new(0.5, 0.5)
		prompt.AutomaticSize = Enum.AutomaticSize.Y
		prompt.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		prompt.BorderColor3 = Color3.fromRGB(0, 0, 0)
		prompt.BorderSizePixel = 0
		prompt.Position = UDim2.fromScale(0.5, 0.5)
		prompt.Size = UDim2.fromOffset(280, 0)

		local promptUIScale = Instance.new("UIScale")
		promptUIScale.Name = "BaseUIScale"
		promptUIScale.Parent = prompt
		promptUIScale.Scale = 0.95

		local globalSettingsUIStroke = Instance.new("UIStroke")
		globalSettingsUIStroke.Name = "GlobalSettingsUIStroke"
		globalSettingsUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		globalSettingsUIStroke.Color = Color3.fromRGB(255, 255, 255)
		globalSettingsUIStroke.Transparency = 0.9
		globalSettingsUIStroke.Parent = prompt

		local globalSettingsUICorner = Instance.new("UICorner")
		globalSettingsUICorner.Name = "GlobalSettingsUICorner"
		globalSettingsUICorner.CornerRadius = UDim.new(0, 10)
		globalSettingsUICorner.Parent = prompt

		local globalSettingsUIPadding = Instance.new("UIPadding")
		globalSettingsUIPadding.Name = "GlobalSettingsUIPadding"
		globalSettingsUIPadding.PaddingBottom = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingLeft = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingRight = UDim.new(0, 20)
		globalSettingsUIPadding.PaddingTop = UDim.new(0, 20)
		globalSettingsUIPadding.Parent = prompt

		local paragraph = Instance.new("Frame")
		paragraph.Name = "Paragraph"
		paragraph.AutomaticSize = Enum.AutomaticSize.Y
		paragraph.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		paragraph.BackgroundTransparency = 1
		paragraph.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraph.BorderSizePixel = 0
		paragraph.Size = UDim2.new(1, 0, 0, 38)

		local paragraphHeader = Instance.new("TextLabel")
		paragraphHeader.Name = "ParagraphHeader"
		paragraphHeader.FontFace = Font.new(
			assets.interFont,
			Enum.FontWeight.Medium,
			Enum.FontStyle.Normal
		)
		paragraphHeader.RichText = true
		paragraphHeader.Text = Settings.Title
		paragraphHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
		paragraphHeader.TextSize = 18
		paragraphHeader.TextTransparency = 0.4
		paragraphHeader.TextWrapped = true
		paragraphHeader.AutomaticSize = Enum.AutomaticSize.Y
		paragraphHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		paragraphHeader.BackgroundTransparency = 1
		paragraphHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraphHeader.BorderSizePixel = 0
		paragraphHeader.Size = UDim2.fromScale(1, 0)
		paragraphHeader.Parent = paragraph

		local uIListLayout = Instance.new("UIListLayout")
		uIListLayout.Name = "UIListLayout"
		uIListLayout.Padding = UDim.new(0, 15)
		uIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout.Parent = paragraph

		local paragraphBody = Instance.new("TextLabel")
		paragraphBody.Name = "ParagraphBody"
		paragraphBody.FontFace = Font.new(assets.interFont)
		paragraphBody.RichText = true
		paragraphBody.Text = Settings.Description
		paragraphBody.TextColor3 = Color3.fromRGB(255, 255, 255)
		paragraphBody.TextSize = 14
		paragraphBody.TextTransparency = 0.5
		paragraphBody.TextWrapped = true
		paragraphBody.AutomaticSize = Enum.AutomaticSize.Y
		paragraphBody.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		paragraphBody.BackgroundTransparency = 1
		paragraphBody.BorderColor3 = Color3.fromRGB(0, 0, 0)
		paragraphBody.BorderSizePixel = 0
		paragraphBody.LayoutOrder = 1
		paragraphBody.Size = UDim2.fromScale(1, 0)
		paragraphBody.Parent = paragraph

		paragraph.Parent = prompt

		local interactions = Instance.new("Frame")
		interactions.Name = "Interactions"
		interactions.AutomaticSize = Enum.AutomaticSize.Y
		interactions.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		interactions.BackgroundTransparency = 1
		interactions.BorderColor3 = Color3.fromRGB(0, 0, 0)
		interactions.BorderSizePixel = 0
		interactions.LayoutOrder = 1
		interactions.Size = UDim2.fromScale(1, 0)

		local uIListLayout1 = Instance.new("UIListLayout")
		uIListLayout1.Name = "UIListLayout"
		uIListLayout1.Padding = UDim.new(0, 10)
		uIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout1.Parent = interactions

		local uIPadding = Instance.new("UIPadding")
		uIPadding.Name = "UIPadding"
		uIPadding.PaddingTop = UDim.new(0, 20)
		uIPadding.Parent = interactions

		interactions.Parent = prompt

		local uIListLayout2 = Instance.new("UIListLayout")
		uIListLayout2.Name = "UIListLayout"
		uIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uIListLayout2.Parent = prompt

		prompt.Parent = dialog

		dialog.Parent = dialogCanvas

		local canvasIn = Tween(dialogCanvas, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { GroupTransparency = 0 })
		local canvasOut = Tween(dialogCanvas, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { GroupTransparency = 1 })

		local scaleIn = Tween(promptUIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { Scale = 1 })
		local scaleOut = Tween(promptUIScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), { Scale = 0.95 })

		local function dialogIn()
			canvasIn:Play()
			scaleIn:Play()
			canvasIn.Completed:Wait()
			dialog.Parent = base
		end

		local function dialogOut()
			if not dialog.Parent then return end
			dialog.Parent = dialogCanvas
			canvasOut:Play()
			scaleOut:Play()
			canvasOut.Completed:Wait()
			dialogCanvas:Destroy()
		end

		for _, v in pairs(Settings.Buttons) do
			local button = Instance.new("TextButton")
			button.Name = "Button"
			button.FontFace = Font.new(assets.interFont)
			button.Text = v.Name
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.TextSize = 15
			button.TextTransparency = 0.5
			button.TextTruncate = Enum.TextTruncate.AtEnd
			button.AutoButtonColor = false
			button.AutomaticSize = Enum.AutomaticSize.Y
			button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			button.BorderColor3 = Color3.fromRGB(0, 0, 0)
			button.BorderSizePixel = 0
			button.Size = UDim2.fromScale(1, 0)

			local uIPadding1 = Instance.new("UIPadding")
			uIPadding1.Name = "UIPadding"
			uIPadding1.PaddingBottom = UDim.new(0, 9)
			uIPadding1.PaddingLeft = UDim.new(0, 10)
			uIPadding1.PaddingRight = UDim.new(0, 10)
			uIPadding1.PaddingTop = UDim.new(0, 9)
			uIPadding1.Parent = button

			local baseUICorner1 = Instance.new("UICorner")
			baseUICorner1.Name = "BaseUICorner"
			baseUICorner1.CornerRadius = UDim.new(0, 10)
			baseUICorner1.Parent = button

			button.Parent = interactions

			local TweenSettings = {
				DefaultTransparency = 0,
				DefaultTransparency2 = 0.5,
				HoverTransparency = 0.3,
				HoverTransparency2 = 0.6,

				EasingStyle = Enum.EasingStyle.Sine
			}

			local function ChangeState(State)
				if State == "Idle" then
					Tween(button, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
						BackgroundTransparency = TweenSettings.DefaultTransparency,
						TextTransparency = TweenSettings.DefaultTransparency2
					}):Play()
				elseif State == "Hover" then
					Tween(button, TweenInfo.new(0.2, TweenSettings.EasingStyle), {
						BackgroundTransparency = TweenSettings.HoverTransparency,
						TextTransparency = TweenSettings.HoverTransparency2
					}):Play()
				end
			end

			button.MouseButton1Click:Connect(function()
				if dialogCanvas.GroupTransparency ~= 0 then return end
				if v.Callback then
					v.Callback()
				end

				dialogOut()
			end)

			button.MouseEnter:Connect(function()
				ChangeState("Hover")
			end)
			button.MouseLeave:Connect(function()
				ChangeState("Idle")
			end)
		end

		dialogIn()

		function DialogFunctions:UpdateTitle(New)
			paragraphHeader.Text = New
		end
		function DialogFunctions:UpdateDescription(New)
			paragraphBody.Text = New
		end

		function DialogFunctions:Cancel()
			dialogOut()
		end

		return DialogFunctions
	end

	function WindowFunctions:SetNotificationsState(State)
		notifications.Visible = State
	end

	function WindowFunctions:GetNotificationsState(State)
		return notifications.Visible
	end

	function WindowFunctions:SetState(State)
		windowState = State
		base.Visible = State
	end

	function WindowFunctions:GetState()
		return windowState
	end

	local onUnloadCallback

	function WindowFunctions:Unload()
		if onUnloadCallback then
			onUnloadCallback()  
		end
		macLib:Destroy()
		unloaded = true
	end

	function WindowFunctions.onUnloaded(callback)
		onUnloadCallback = callback
	end

	local MenuKeybind = Settings.Keybind or Enum.KeyCode.RightControl

	local function ToggleMenu()
		local state = not WindowFunctions:GetState()
		WindowFunctions:SetState(state)
		WindowFunctions:Notify({
			Title = Settings.Title,
			Description = (state and "Maximized " or "Minimized ") .. "the menu. Use " .. tostring(MenuKeybind.Name) .. " to toggle it.",
			Lifetime = 5
		})
	end

	UserInputService.InputEnded:Connect(function(inp, gpe)
		if gpe then return end
		if inp.KeyCode == MenuKeybind then
			ToggleMenu()
		end
	end)

	minimize.MouseButton1Click:Connect(ToggleMenu)
	exit.MouseButton1Click:Connect(function()
		WindowFunctions:Dialog({
			Title = Settings.Title,
			Description = "Are you sure you want to exit the menu? You will lose any unsaved configurations.",
			Buttons = {
				{
					Name = "Confirm",
					Callback = function()
						WindowFunctions:Unload()
					end,
				},
				{
					Name = "Cancel"
				}
			}
		})
	end)

	function WindowFunctions:SetKeybind(Keycode)
		MenuKeybind = Keycode
	end

	function WindowFunctions:SetAcrylicBlurState(State)
		acrylicBlur = State
		base.BackgroundTransparency = State and 0.05 or 0
	end

	function WindowFunctions:GetAcrylicBlurState()
		return acrylicBlur
	end

	local function _SetUserInfoState(State)
		if State then
			headshot.Image = (isReady and headshotImage) or "rbxassetid://0"
			username.Text = "@" .. LocalPlayer.Name
			displayName.Text = LocalPlayer.DisplayName
		else
			headshot.Image = assets.userInfoBlurred
			local nameLength = #LocalPlayer.Name
			local displayNameLength = #LocalPlayer.DisplayName
			username.Text = "@" .. string.rep(".", nameLength)
			displayName.Text = string.rep(".", displayNameLength)
		end
	end

	local showUserInfo
	if Settings.ShowUserInfo ~= nil then
		showUserInfo = Settings.ShowUserInfo
	else
		showUserInfo = true
	end

	_SetUserInfoState(showUserInfo)

	function WindowFunctions:SetUserInfoState(State)
		_SetUserInfoState(State)
	end
	function WindowFunctions:GetUserInfoState(State)
		return showUserInfo
	end

	function WindowFunctions:SetSize(Size)
		base.Size = Size
	end
	function WindowFunctions:GetSize(Size)
		return base.Size
	end

	function WindowFunctions:SetScale(Scale)
		baseUIScale.Scale = Scale
	end
	function WindowFunctions:GetScale()
		return baseUIScale.Scale
	end

	local ClassParser = {
		["Toggle"] = {
			Save = function(Flag, data)
				return {
					type = "Toggle", 
					flag = Flag, 
					state = data.State or false
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.state then
					MacLib.Options[Flag]:UpdateState(data.state)
				end
			end
		},
		["Slider"] = {
			Save = function(Flag, data)
				return {
					type = "Slider", 
					flag = Flag, 
					value = (data.Value and tostring(data.Value)) or false
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.value then
					MacLib.Options[Flag]:UpdateValue(data.value)
				end
			end
		},
		["Input"] = {
			Save = function(Flag, data)
				return {
					type = "Input", 
					flag = Flag, 
					text = data.Text
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.text and type(data.text) == "string" then
					MacLib.Options[Flag]:UpdateText(data.text)
				end
			end
		},
		["Keybind"] = {
			Save = function(Flag, data)
				return {
					type = "Keybind", 
					flag = Flag, 
					bind = (typeof(data.Bind) == "EnumItem" and data.Bind.Name) or nil
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.bind then
					MacLib.Options[Flag]:Bind(Enum.KeyCode[data.bind])
				end
			end
		},
		["Dropdown"] = {
			Save = function(Flag, data)
				return {
					type = "Dropdown", 
					flag = Flag, 
					value = data.Value
				}
			end,
			Load = function(Flag, data)
				if MacLib.Options[Flag] and data.value then
					MacLib.Options[Flag]:UpdateSelection(data.value)
				end
			end
		},
		["Colorpicker"] = {
			Save = function(Flag, data)
				local function Color3ToHex(color)
					return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
				end

				return {
					type = "Colorpicker", 
					flag = Flag, 
					color = Color3ToHex(data.Color) or nil,
					alpha = data.Alpha
				}
			end,
			Load = function(Flag, data)
				local function HexToColor3(hex)
					local r = tonumber(hex:sub(2, 3), 16) / 255
					local g = tonumber(hex:sub(4, 5), 16) / 255
					local b = tonumber(hex:sub(6, 7), 16) / 255
					return Color3.new(r, g, b)
				end

				if MacLib.Options[Flag] and data.color then
					MacLib.Options[Flag]:SetColor(HexToColor3(data.color)) 
					if data.alpha then
						MacLib.Options[Flag]:SetAlpha(data.alpha)
					end
				end
			end
		}
	}

	local function BuildFolderTree()
		if isStudio or not (isfolder and makefolder) then return "Config system unavailable." end

		local paths = {
			MacLib.Folder,
			MacLib.Folder .. "/settings"
		}

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function MacLib:LoadAutoLoadConfig()
		if isStudio or not (isfile and readfile) then return "Config system unavailable." end

		if isfile(MacLib.Folder .. "/settings/autoload.txt") then
			local name = readfile(MacLib.Folder .. "/settings/autoload.txt")

			local suc, err = MacLib:LoadConfig(name)
			if not suc then
				WindowFunctions:Notify({
					Title = "Interface",
					Description = "Error loading autoload config: " .. err
				})
			end

			WindowFunctions:Notify({
				Title = "Interface",
				Description = string.format("Autoloaded config: %q", name),
			})
		end
	end

	function MacLib:SetFolder(Folder)
		if isStudio then return "Config system unavailable." end

		MacLib.Folder = Folder;
		BuildFolderTree()
	end

	function MacLib:SaveConfig(Path)
		if isStudio or not writefile then return "Config system unavailable." end

		if (not Path) then
			return false, "Please select a config file."
		end

		local fullPath = MacLib.Folder .. "/settings/" .. Path .. ".json"

		local data = {
			objects = {}
		}

		for flag, option in next, MacLib.Options do
			if not ClassParser[option.Class] then continue end
			if option.IgnoreConfig then continue end

			table.insert(data.objects, ClassParser[option.Class].Save(flag, option))
		end	

		local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
		if not success then
			return false, "Unable to encode into JSON data"
		end

		writefile(fullPath, encoded)
		return true
	end

	function MacLib:LoadConfig(Path)
		if isStudio or not (isfile and readfile) then return "Config system unavailable." end

		if (not Path) then
			return false, "Please select a config file."
		end

		local file = MacLib.Folder .. "/settings/" .. Path .. ".json"
		if not isfile(file) then return false, "Invalid file" end

		local success, decoded = pcall(HttpService.JSONDecode, HttpService, readfile(file))
		if not success then return false, "Unable to decode JSON data." end

		for _, option in next, decoded.objects do
			if ClassParser[option.type] then
				task.spawn(function() 
					ClassParser[option.type].Load(option.flag, option) 
				end)
			end
		end

		return true
	end

	function MacLib:RefreshConfigList()
		if isStudio or not (isfolder and listfiles) then return "Config system unavailable." end

		local list = (isfolder(MacLib.Folder) and isfolder(MacLib.Folder .. "/settings")) and listfiles(MacLib.Folder .. "/settings") or {}

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == ".json" then
				local pos = file:find(".json", 1, true)
				local start = pos

				local char = file:sub(pos, pos)
				while char ~= "/" and char ~= "\\" and char ~= "" do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == "/" or char == "\\" then
					local name = file:sub(pos + 1, start - 1)
					if name ~= "options" then
						table.insert(out, name)
					end
				end
			end
		end

		return out
	end

	macLib.Enabled = false

	local assetList = {}
	for _, assetId in pairs(assets) do
		table.insert(assetList, assetId)
	end

	ContentProvider:PreloadAsync(assetList)
	macLib.Enabled = true
	windowState = true

	return WindowFunctions
end

function MacLib:Demo()
	local Window = MacLib:Window({
		Title = "Maclib Demo",
		Subtitle = "This is a subtitle.",
		Size = UDim2.fromOffset(868, 650),
		DragStyle = 1,
		DisabledWindowControls = {},
		ShowUserInfo = true,
		Keybind = Enum.KeyCode.RightControl,
		AcrylicBlur = true,
	})

	local globalSettings = {
		UIBlurToggle = Window:GlobalSetting({
			Name = "UI Blur",
			Default = Window:GetAcrylicBlurState(),
			Callback = function(bool)
				Window:SetAcrylicBlurState(bool)
				Window:Notify({
					Title = Window.Settings.Title,
					Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
					Lifetime = 5
				})
			end,
		}),
		NotificationToggler = Window:GlobalSetting({
			Name = "Notifications",
			Default = Window:GetNotificationsState(),
			Callback = function(bool)
				Window:SetNotificationsState(bool)
				Window:Notify({
					Title = Window.Settings.Title,
					Description = (bool and "Enabled" or "Disabled") .. " Notifications",
					Lifetime = 5
				})
			end,
		}),
		ShowUserInfo = Window:GlobalSetting({
			Name = "Show User Info",
			Default = Window:GetUserInfoState(),
			Callback = function(bool)
				Window:SetUserInfoState(bool)
				Window:Notify({
					Title = Window.Settings.Title,
					Description = (bool and "Showing" or "Redacted") .. " User Info",
					Lifetime = 5
				})
			end,
		})
	}

	local tabGroups = {
		TabGroup1 = Window:TabGroup()
	}

	local tabs = {
		Main = tabGroups.TabGroup1:Tab({ Name = "Demo", Image = "rbxassetid://18821914323" }),
		Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
	}

	local sections = {
		MainSection1 = tabs.Main:Section({ Side = "Left" }),
	}

	sections.MainSection1:Header({
		Name = "Header #1"
	})

	sections.MainSection1:Button({
		Name = "Button",
		Callback = function()
			Window:Dialog({
				Title = Window.Settings.Title,
				Description = "Lorem ipsum odor amet, consectetuer adipiscing elit. Eros vestibulum aliquet mattis, ex platea nunc.",
				Buttons = {
					{
						Name = "Confirm",
						Callback = function()
							print("Confirmed!")
						end,
					},
					{
						Name = "Cancel"
					}
				}
			})
		end,
	})

	sections.MainSection1:Input({
		Name = "Input",
		Placeholder = "Input",
		AcceptedCharacters = "All",
		Callback = function(input)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = "Successfully set input to " .. input
			})
		end,
		onChanged = function(input)
			print("Input is now " .. input)
		end,
	}, "Input")

	sections.MainSection1:Slider({
		Name = "Slider",
		Default = 50,
		Minimum = 0,
		Maximum = 100,
		DisplayMethod = "Percent",
		Precision = 0,
		Callback = function(Value)
			print("Changed to ".. Value)
		end
	}, "Slider")

	sections.MainSection1:Toggle({
		Name = "Toggle",
		Default = false,
		Callback = function(value)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (value and "Enabled " or "Disabled ") .. "Toggle"
			})
		end,
	}, "Toggle")

	sections.MainSection1:Keybind({
		Name = "Keybind",
		Blacklist = false,
		Callback = function(binded)
			Window:Notify({
				Title = "Demo Window",
				Description = "Pressed keybind - "..tostring(binded.Name),
				Lifetime = 3
			})
		end,
		onBinded = function(bind)
			Window:Notify({
				Title = "Demo Window",
				Description = "Successfully Binded Keybind to - "..tostring(bind.Name),
				Lifetime = 3
			})
		end,
	}, "Keybind")

	sections.MainSection1:Colorpicker({
		Name = "Colorpicker",
		Default = Color3.fromRGB(0, 255, 255),
		Callback = function(color)
			print("Color: ", color)
		end,
	}, "Colorpicker")

	local alphaColorPicker = sections.MainSection1:Colorpicker({
		Name = "Transparency Colorpicker",
		Default = Color3.fromRGB(255,0,0),
		Alpha = 0,
		Callback = function(color, alpha)
			print("Color: ", color, " Alpha: ", alpha)
		end,
	}, "TransparencyColorpicker")

	local rainbowActive
	local rainbowConnection
	local hue = 0

	sections.MainSection1:Toggle({
		Name = "Rainbow",
		Default = false,
		Callback = function(value)
			rainbowActive = value

			if rainbowActive then
				rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
					hue = (hue + deltaTime * 0.1) % 1
					alphaColorPicker:SetColor(Color3.fromHSV(hue, 1, 1))
				end)
			elseif rainbowConnection then
				rainbowConnection:Disconnect()
				rainbowConnection = nil
			end
		end,
	}, "RainbowToggle")

	local optionTable = {
		"Apple",
		"Banana",
		"Orange",
		"Grapes",
		"Pineapple",
		"Mango",
		"Strawberry",
		"Blueberry",
		"Watermelon",
		"Peach"
	}

	local Dropdown = sections.MainSection1:Dropdown({
		Name = "Dropdown",
		Multi = false,
		Required = true,
		Options = optionTable,
		Default = 1,
		Callback = function(Value)
			print("Dropdown changed: ".. Value)
		end,
	}, "Dropdown")

	local MultiDropdown = sections.MainSection1:Dropdown({
		Name = "Multi Dropdown",
		Search = true,
		Multi = true,
		Required = false,
		Options = optionTable,
		Default = {"Apple", "Orange"},
		Callback = function(Value)
			local Values = {}
			for Value, State in next, Value do
				table.insert(Values, Value)
			end
			print("Mutlidropdown changed:", table.concat(Values, ", "))
		end,
	}, "MultiDropdown")

	sections.MainSection1:Button({
		Name = "Update Selection",
		Callback = function()
			Dropdown:UpdateSelection("Grapes")
			MultiDropdown:UpdateSelection({"Banana", "Pineapple"})
		end,
	})

	sections.MainSection1:Divider()

	sections.MainSection1:Header({
		Text = "Header #2"
	})

	sections.MainSection1:Paragraph({
		Header = "Paragraph",
		Body = "Paragraph body. Lorem ipsum odor amet, consectetuer adipiscing elit. Morbi tempus netus aliquet per velit est gravida."
	})

	sections.MainSection1:Label({
		Text = "Label. Lorem ipsum odor amet, consectetuer adipiscing elit."
	})

	sections.MainSection1:SubLabel({
		Text = "Sub-Label. Lorem ipsum odor amet, consectetuer adipiscing elit."
	})

	MacLib:SetFolder("Maclib")
	tabs.Settings:InsertConfigSection("Left")

	Window.onUnloaded(function()
		print("Unloaded!")
	end)

	tabs.Main:Select()
	MacLib:LoadAutoLoadConfig()
end

return MacLib
end)()
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ================= Auto Join Private Server (First Sea) =================
-- Alur (sama kayak hub), dijalankan di MAIN MENU (PlaceId 1730877806):
--   1) ReplicatedStorage.Events.reserved:InvokeServer(<kode private server>)
--   2) klik  PlayerGui.chooseType.Frame.Options.Regular
--   3) klik  PlayerGui.ConfirmationPrompt.Main.OptionsFrame["First Sea"]
-- Diulang tiap RetryInterval detik sampai teleport kejadian.
-- Kode = bagian kode saja dari link private server (bukan link lengkap).
-- Setelan (toggle + kode) diatur dari GUI, disimpan ke file ConfigFile supaya
-- kebaca juga pas script jalan di main menu. Bisa juga lewat getgenv():
--   getgenv().AutoJoinPrivateServer = true ; getgenv().PrivateServerCode = "[REDACTED]"
-- NOTE: setelah teleport script harus jalan lagi di First Sea. Paling gampang pakai
-- folder autoexec executor-mu, atau isi ReexecuteUrl (butuh queue_on_teleport).
-- Semua dibungkus 1 table biar gak nambah banyak variabel local (batas Luau 200).
local PrivateServer = {
    MainMenuPlaceId = 1730877806,
    FirstSeaPlaceId = 3978370137,
    ConfigFile = "AutoEventDoor_PrivateServer.json",
    RetryInterval = 8,   -- detik antar percobaan join
    ReexecuteUrl = "",   -- opsional: URL raw script ini, buat di-queue_on_teleport
    Enabled = false,
    Code = "",
}

function PrivateServer.load()
    pcall(function()
        if typeof(isfile) == "function" and typeof(readfile) == "function"
            and isfile(PrivateServer.ConfigFile) then
            local data = game:GetService("HttpService"):JSONDecode(readfile(PrivateServer.ConfigFile))
            if type(data) == "table" then
                if type(data.Enabled) == "boolean" then PrivateServer.Enabled = data.Enabled end
                if type(data.Code) == "string" then PrivateServer.Code = data.Code end
            end
        end
    end)

    -- Override lewat getgenv (nama sama kayak di hub)
    pcall(function()
        local genv = getgenv()
        if genv.AutoJoinPrivateServer ~= nil then
            PrivateServer.Enabled = genv.AutoJoinPrivateServer == true
        end
        if type(genv.PrivateServerCode) == "string" and genv.PrivateServerCode ~= "" then
            PrivateServer.Code = genv.PrivateServerCode
        end
    end)

    PrivateServer.Code = tostring(PrivateServer.Code or ""):match("^%s*(.-)%s*$") or ""
end

function PrivateServer.save()
    pcall(function()
        local genv = getgenv()
        genv.AutoJoinPrivateServer = PrivateServer.Enabled
        genv.PrivateServerCode = PrivateServer.Code
    end)
    pcall(function()
        if typeof(writefile) == "function" then
            writefile(PrivateServer.ConfigFile, game:GetService("HttpService"):JSONEncode({
                Enabled = PrivateServer.Enabled,
                Code = PrivateServer.Code,
            }))
        end
    end)
end

-- Tunggu child bertingkat, mis. {"chooseType","Frame","Options","Regular"}
function PrivateServer.waitPath(root, names, timeout)
    local node = root
    for _, name in ipairs(names) do
        node = node and node:WaitForChild(name, timeout)
    end
    return node
end

-- Tekan tombol GUI: fire koneksi event (paling andal), fallback firesignal,
-- terakhir klik mouse beneran di tengah tombol.
function PrivateServer.press(btn)
    if typeof(getconnections) == "function" then
        for _, signalName in ipairs({"MouseButton1Click", "Activated"}) do
            local fired = false
            local ok, conns = pcall(getconnections, btn[signalName])
            if ok and type(conns) == "table" then
                for _, conn in ipairs(conns) do
                    if pcall(function() conn:Fire() end) then fired = true end
                end
            end
            if fired then return true end
        end
    end

    if typeof(firesignal) == "function" and pcall(firesignal, btn.MouseButton1Click) then
        return true
    end

    pcall(function()
        local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
        local inset = game:GetService("GuiService"):GetGuiInset()
        local x, y = pos.X + size.X / 2, pos.Y + size.Y / 2 + inset.Y
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
    return true
end

-- Satu kali percobaan join. Return: true kalau semua tombol berhasil ditekan
function PrivateServer.joinOnce()
    local code = PrivateServer.Code

    -- 1) kirim kode private server (di thread terpisah, InvokeServer bisa nunggu)
    task.spawn(function()
        pcall(function()
            local events = ReplicatedStorage:WaitForChild("Events", 10)
            local reserved = events and events:WaitForChild("reserved", 10)
            if reserved then
                reserved:InvokeServer(code)
            end
        end)
    end)
    task.wait(2)

    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if not playerGui then return false end

    -- 2) pilih "Regular"
    local regular = PrivateServer.waitPath(playerGui, {"chooseType", "Frame", "Options", "Regular"}, 10)
    if not regular then
        print("[AutoEventDoor] chooseType...Regular gak ketemu di main menu.")
        return false
    end
    PrivateServer.press(regular)
    task.wait(2)

    -- 3) konfirmasi "First Sea"
    local firstSea = PrivateServer.waitPath(playerGui, {"ConfirmationPrompt", "Main", "OptionsFrame", "First Sea"}, 10)
    if not firstSea then
        print("[AutoEventDoor] ConfirmationPrompt...'First Sea' gak ketemu.")
        return false
    end
    PrivateServer.press(firstSea)
    return true
end

function PrivateServer.runMenuLoop()
    pcall(function()
        local genv = getgenv()
        if genv.PrivateJoinLoopRunning then return end
        genv.PrivateJoinLoopRunning = true
    end)

    task.spawn(function()
        while game.PlaceId == PrivateServer.MainMenuPlaceId
            and PrivateServer.Enabled and PrivateServer.Code ~= "" do
            local ok, result = pcall(PrivateServer.joinOnce)
            if not ok then
                print("[AutoEventDoor] Join private server error: " .. tostring(result))
            end
            task.wait(PrivateServer.RetryInterval)
        end
        pcall(function() getgenv().PrivateJoinLoopRunning = false end)
    end)
end

PrivateServer.load()

-- Di MAIN MENU: cuma ngurusin join private server, script farm gak dijalankan di sini
-- (di menu belum ada dunia game / event door).
if game.PlaceId == PrivateServer.MainMenuPlaceId then
    if PrivateServer.Enabled and PrivateServer.Code ~= "" then
        print("[AutoEventDoor] Main menu: auto join private server (First Sea)...")

        local queueFn = queue_on_teleport or queueonteleport
        if PrivateServer.ReexecuteUrl ~= "" and typeof(queueFn) == "function" then
            pcall(queueFn, string.format("loadstring(game:HttpGet(%q))()", PrivateServer.ReexecuteUrl))
        end

        PrivateServer.runMenuLoop()
    else
        print("[AutoEventDoor] Main menu: Auto Join Private Server OFF atau kode kosong. " ..
            "Nyalain & isi kode dulu dari GUI pas lagi di dalam game (disimpan ke file).")
    end
    return
end

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ================= Candy reader =================

-- Baca jumlah Candy dari LocalPlayer.PlayerGui.CandyIndicator.CandyBox
-- Dukung baik TextLabel/TextButton (parse angka dari Text) maupun ValueBase (.Value)
local CachedCandyBox = nil

-- CandyIndicator/CandyBox cuma muncul di PlayerGui pas tool-nya di-equip, jadi
-- dia bisa ilang-muncul lagi tiap equip/unequip. Makanya di sini re-scan ringan
-- tiap kali cache-nya kosong/ke-invalid, BUKAN cuma sekali di awal.
local function findCandyBox()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return nil end

    local indicator = playerGui:FindFirstChild("CandyIndicator")
    if not indicator then return nil end

    return indicator:FindFirstChild("CandyBox")
end

-- Parse angka dari text, koma dibuang dulu (biar "1,250" kebaca 1250, bukan 1)
local function parseNumber(text)
    local cleaned = tostring(text):gsub(",", "")
    local numStr = cleaned:match("%d+")
    return numStr and tonumber(numStr) or nil
end

local function getCandyCount()
    if not CachedCandyBox or not CachedCandyBox.Parent then
        -- FindFirstChild doang (murah), gak pakai WaitForChild biar gak nge-block -
        -- fungsi ini dipanggil berkala jadi kalau belum ketemu, nanti dicoba lagi
        CachedCandyBox = findCandyBox()
        if not CachedCandyBox then return nil end
    end

    local candyBox = CachedCandyBox

    if candyBox:IsA("ValueBase") then
        return tonumber(candyBox.Value)
    end

    if candyBox:IsA("TextLabel") or candyBox:IsA("TextButton") then
        return parseNumber(candyBox.Text)
    end

    local nested = candyBox:FindFirstChildWhichIsA("ValueBase")
        or candyBox:FindFirstChildWhichIsA("TextLabel", true)
    if nested then
        if nested:IsA("ValueBase") then
            return tonumber(nested.Value)
        else
            return parseNumber(nested.Text)
        end
    end

    return nil
end

-- ================= Settings (bisa diubah lewat GUI) =================
local Settings = {
    SearchRadius = 50,
    HoldDuration = 1,   -- durasi (detik) fire ProximityPrompt di tiap door

    WalkSpeed = 16,
    WalkSpeedEnabled = false,
    TweenMode = true,   -- true = gerak pakai tween (BodyVelocity), false = hold WASD
    TweenSpeed = 30,    -- stud/detik
    TweenWalk = true,   -- tween "jalan": karakter tetap berdiri & animasi jalan/lari jalan (bukan melayang). OFF = tween lama (melayang)
    CandyTarget = 290,  -- kalau candy >= ini, pergi ke Witch buat beli chest
    DoorCooldown = 180, -- detik, cooldown per door setelah dikunjungi (3 menit)
    ChestOpenAt = 7, -- kalau Rare Fruit Chest >= ini, buka chest berulang sampai sisa CHEST_KEEP (2) (0 = mati)
    AutoMerchant = false, -- jalan ke Traveling Merchant & beli item pilihan
    AutoBuyRareChest = true,
    AutoBuyRaceReroll = false,
    AutoFishing = false,
    FishingBaits = {"Common Fish Bait"},
    AutoBuyBait = false,
    BaitThreshold = 10,
    BaitBuyAmount = 10,
    AutoCraftBait = false,
    CraftBaits = {},
    MerchantItems = "",   -- nama item, dipisah koma
    GeppoPass = true,   -- spam skill Geppo/Sky Walk selama tween (kayak di source)
    DoorGeppo = true,       -- sampai di door: tunggu sebentar, Geppo 1x, baru fire prompt
    DoorArriveWait = 0.5,   -- detik nunggu setelah sampai di door sebelum Geppo
    DoorGeppoDelay = 0.3,   -- detik jeda setelah Geppo sebelum fire prompt
    FpsCapEnabled = true,   -- batasi FPS (setfpscap) & tulis ulang terus
    FpsCap = 20,            -- batas FPS
    StuckRespawn = false,   -- 6 door gagal berturut-turut -> reset karakter (mati & respawn) sebagai jalan terakhir
    AutoDrop = false,       -- drop otomatis fruit dari rarity terpilih (equip + Backspace), cuma di sela farm. Default MATI
    DropRarities = {"Common"},
    DropInterval = 10,      -- detik antar pengecekan Backpack buat fruit yang perlu di-drop
}

local BUILDING_PATH = {"Islands", "Spooksville", "Building"}
local EVENT_DOOR_CHILD_NAME = "eventDoor"

-- Door yang DI-IGNORE (gak pernah dikunjungi & gak dihitung di progress), dipilih
-- lewat nomor urut di workspace.Islands.Spooksville.Building:GetChildren().
-- [59] = workspace.Islands.Spooksville.Building:GetChildren()[59].eventDoor
-- Tambah nomor lain dengan format [nomor] = true.
-- NOTE: urutan GetChildren() bisa beda antar server. Kalau yang ke-skip ternyata
-- bukan door yang dimaksud, pakai IGNORED_DOOR_NAMES (nama child di Building).
local IGNORED_DOOR_INDEXES = {
    [59] = true,
}
local IGNORED_DOOR_NAMES = {
    -- ["NamaChildBuilding"] = true,
}
local IgnoredDoorPrinted = {}
local TOGGLE_KEY = Enum.KeyCode.Comma
local MINE_DISTANCE = 8
local WAYPOINT_REACH_DISTANCE = 6

local Enabled = false
local LastKnownDoorCount = 0 -- total door yang ketemu terakhir kali di-scan, buat progress label

-- Cooldown per door: LastVisit[door] = waktu (tick) pas door itu terakhir dikunjungi.
-- Door yang gagal dicapai juga dicatat di sini (dihitung & kena cooldown), jadi
-- gak dicoba terus-terusan tanpa henti.
local LastVisit = {}
local COOLDOWN_BUFFER = 3 -- detik ekstra, jaga-jaga selisih waktu client vs server

-- Kapan door ini siap dipakai lagi (waktu tick). 0 = belum pernah dikunjungi = siap
local function getDoorReadyAt(door)
    local last = LastVisit[door]
    if not last then return 0 end
    return last + Settings.DoorCooldown + COOLDOWN_BUFFER
end

local function formatTime(seconds)
    seconds = math.max(0, math.floor(seconds))
    return string.format("%d:%02d", math.floor(seconds / 60), seconds % 60)
end

local StatusText, ToggleButton, ProgressLabel

local CandyTargetBox

local function hookWalkSpeedEnforcement(hum)
    hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if Settings.WalkSpeedEnabled and hum.WalkSpeed ~= Settings.WalkSpeed then
            hum.WalkSpeed = Settings.WalkSpeed
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")

    if Settings.WalkSpeedEnabled then
        Humanoid.WalkSpeed = Settings.WalkSpeed
    end

    hookWalkSpeedEnforcement(Humanoid)
end)

hookWalkSpeedEnforcement(Humanoid)

-- ================= Rare Fruit Chest counter =================
-- Baca jumlah "Rare Fruit Chest" di Backpack (+ Character, soalnya tool yang
-- lagi di-equip pindah ke Character). Jumlah dicari lewat beberapa cara karena
-- belum pasti game nyimpennya gimana:
--   1) Attribute / child ValueBase bernama Amount, Count, Quantity, Stack, Qty
--   2) Angka di nama tool / ToolTip, mis. "Rare Fruit Chest x5" atau "(5)"
--   3) Kalau gak ada info jumlah: tiap Tool dihitung 1 (jadi 2 tool = 2)
local CHEST_NAME = "Rare Fruit Chest"
local COUNT_KEYS = {"Amount", "Count", "Quantity", "Stack", "Qty"}
local ChestDebugPrinted = false

local function readToolCount(tool)
    for _, key in ipairs(COUNT_KEYS) do
        local attr = tool:GetAttribute(key)
        if type(attr) == "number" then return attr end

        local child = tool:FindFirstChild(key)
        if child and child:IsA("ValueBase") then
            local n = tonumber(child.Value)
            if n then return n end
        end
    end

    local fromName = tool.Name:match("[xX]%s*(%d+)") or tool.Name:match("%((%d+)%)")
    if fromName then return tonumber(fromName) end

    local fromTip = tool.ToolTip and (tool.ToolTip:match("[xX]%s*(%d+)") or tool.ToolTip:match("%((%d+)%)"))
    if fromTip then return tonumber(fromTip) end

    return nil
end

-- Print isi tool sekali aja, buat diagnosa kalau jumlahnya salah kebaca
local function debugDumpChest(tool)
    if ChestDebugPrinted then return end
    ChestDebugPrinted = true

    local parts = {}
    for k, v in pairs(tool:GetAttributes()) do
        table.insert(parts, "attr " .. tostring(k) .. "=" .. tostring(v))
    end
    for _, c in ipairs(tool:GetChildren()) do
        local val = c:IsA("ValueBase") and ("=" .. tostring(c.Value)) or ""
        table.insert(parts, c.ClassName .. " " .. c.Name .. val)
    end
    print("[AutoEventDoor] '" .. tool.Name .. "' ketemu. Isi: " ..
        (#parts > 0 and table.concat(parts, ", ") or "(kosong, dihitung 1 per tool)"))
end

local function getChestCountFromTools()
    local total = 0
    local lowerName = string.lower(CHEST_NAME)

    local function scan(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") and string.sub(string.lower(child.Name), 1, #lowerName) == lowerName then
                debugDumpChest(child)
                total = total + (readToolCount(child) or 1)
            end
        end
    end

    scan(LocalPlayer:FindFirstChild("Backpack"))
    scan(LocalPlayer.Character)
    return total
end

-- ---- Sumber utama: Hotbar GUI ----
-- LocalPlayer.PlayerGui.BackpackGui.Hotbar.Zero["Rare Fruit Chest"]
-- (kalau item pindah slot, dicari di semua slot Hotbar). Angka jumlah dicari di
-- TextLabel/TextButton di dalam item itu, dengan prioritas:
--   1) label bernama Amount/Count/Quantity/Stack/Qty
--   2) label berformat "x5"
--   3) label berisi angka murni (selain label nomor tombol/slot/nama)
-- Kalau item ketemu tapi angkanya gak kebaca, dihitung 1.
-- Kalau item gak ada di Hotbar, fallback ke hitung Tool di Backpack/Character.
local HotbarDebugPrinted = false
local COUNT_NAME_HINTS = {"amount", "count", "quantity", "stack", "qty"}
local IGNORE_NAME_HINTS = {"number", "key", "slot", "index", "name", "title", "hotkey"}

local function nameHas(name, hints)
    name = string.lower(name)
    for _, h in ipairs(hints) do
        if string.find(name, h, 1, true) then return true end
    end
    return false
end

-- Cache: hotbar:GetDescendants() itu mahal (ratusan objek GUI) dan dipanggil tiap detik lewat
-- label candy/chest -> bikin hitch kecil berulang. Node yang ketemu disimpan; kalau gak ketemu,
-- scan ulang paling cepat tiap 5 detik.
local HotbarChestCache = { node = nil, missUntil = 0 }

local function findHotbarChest()
    local cached = HotbarChestCache.node
    if cached and cached.Parent and cached:IsDescendantOf(game) then return cached end
    HotbarChestCache.node = nil
    if tick() < HotbarChestCache.missUntil then return nil end

    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    local backpackGui = gui and gui:FindFirstChild("BackpackGui")
    local hotbar = backpackGui and backpackGui:FindFirstChild("Hotbar")
    if not hotbar then
        HotbarChestCache.missUntil = tick() + 5
        return nil
    end

    -- Jalur yang kamu kasih dulu (slot Zero), baru scan semua slot
    local zero = hotbar:FindFirstChild("Zero")
    local direct = zero and zero:FindFirstChild(CHEST_NAME)
    if direct then
        HotbarChestCache.node = direct
        return direct
    end

    for _, d in ipairs(hotbar:GetDescendants()) do
        if d.Name == CHEST_NAME then
            HotbarChestCache.node = d
            return d
        end
    end

    HotbarChestCache.missUntil = tick() + 5
    return nil
end

local function readHotbarCount(node)
    local objs = {node}
    for _, d in ipairs(node:GetDescendants()) do
        table.insert(objs, d)
    end

    local named, xFormat, plain = nil, nil, nil
    local dump = {}

    for _, obj in ipairs(objs) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local text = tostring(obj.Text):gsub(",", "")
            table.insert(dump, obj.ClassName .. " " .. obj.Name .. "=\"" .. text .. "\"")

            local pure = text:match("^%s*(%d+)%s*$")
            local xN = text:match("^%s*[xX]%s*(%d+)%s*$") or text:match("[xX]%s*(%d+)")

            if nameHas(obj.Name, COUNT_NAME_HINTS) then
                local n = pure or xN
                if n then named = named or tonumber(n) end
            elseif not nameHas(obj.Name, IGNORE_NAME_HINTS) then
                if xN then
                    xFormat = xFormat or tonumber(xN)
                elseif pure then
                    plain = plain or tonumber(pure)
                end
            end
        elseif obj:IsA("ValueBase") and nameHas(obj.Name, COUNT_NAME_HINTS) then
            local n = tonumber(obj.Value)
            if n then named = named or n end
        end
    end

    -- Print struktur sekali aja, buat diagnosa kalau angkanya salah kebaca
    if not HotbarDebugPrinted then
        HotbarDebugPrinted = true
        print("[AutoEventDoor] Hotbar '" .. node:GetFullName() .. "' (" .. node.ClassName .. "). Label: " ..
            (#dump > 0 and table.concat(dump, " | ") or "(gak ada TextLabel/TextButton)"))
    end

    return named or xFormat or plain
end

local function getChestCount()
    local node = findHotbarChest()
    if node then
        return readHotbarCount(node) or 1
    end
    return getChestCountFromTools()
end

local function getCandyText()
    local candy = getCandyCount()
    return "Candy: " .. (candy and tostring(candy) or "-") .. "/" .. Settings.CandyTarget
        .. "  |  Chest: " .. getChestCount()
end

-- ================= Discord Webhook (item diperoleh) =================
-- Deteksi item baru di Backpack + Character: tiap 1.5 detik jumlah per-nama item dibandingkan
-- dengan snapshot sebelumnya, yang NAMBAH dikirim ke Discord (beberapa item -> 1 pesan, max 10 embed).
-- Dihitung dari total Backpack + Character, jadi equip/unequip tool (pindah container)
-- TIDAK ikut kekirim. Respawn: snapshot di-reset diam-diam supaya gak ada notif palsu.
-- Ringkasan: tiap 1 jam dikirim embed ringkasan (door, chest, merchant, item, candy, durasi aktif).
-- URL + toggle diatur dari GUI & disimpan ke file. Bungkus 1 table biar hemat local.
local Webhook = {
    ConfigFile = "AutoEventDoor_Webhook.json",
    Url = "",
    Enabled = true,
    Interval = 1.5,
    Rare = "Goro, Magu, Pika, Ito, Zushi, Goru, Hie, Mochi, Venom, Pteranodon, Tori, Dragon, Soul, Leopard, Brand Of Sacrifice, Nightfall Aura",
    -- ^ item/fruit langka -> ping @everyone. Pisah koma / baris baru; "1x Goro" juga boleh.
    --   Cocok per KATA utuh & gak peduli huruf besar ("Goro" kena "Goro" / "Goro Goro no Mi",
    --   tapi bukan "Goru" atau "Mito").
    -- Daftar default versi lama: kalau yang tersimpan di file persis salah satunya (artinya user
    -- belum pernah mengubahnya), dipakai default terbaru.
    legacyRare = {
        ["magu"] = true,
        ["goro, magu, pika, ito, zushi, goru, hie, mochi, venom, pteranodon, tori, dragon, soul, leopard"] = true,
    },
    SummaryEnabled = true,   -- kirim ringkasan berkala
    SummaryEvery = 3600,     -- detik (1 jam)
    nextSummary = 0,
    queue = {},
    sending = false,
    started = false,
    last = {},
    quietUntil = 0,
}

function Webhook.trim(s)
    return tostring(s or ""):match("^%s*(.-)%s*$") or ""
end

function Webhook.load()
    pcall(function()
        if typeof(isfile) == "function" and typeof(readfile) == "function"
            and isfile(Webhook.ConfigFile) then
            local data = game:GetService("HttpService"):JSONDecode(readfile(Webhook.ConfigFile))
    if type(data) == "table" then
                if type(data.Enabled) == "boolean" then Webhook.Enabled = data.Enabled end
                if type(data.Summary) == "boolean" then Webhook.SummaryEnabled = data.Summary end
                if type(data.Rare) == "string" then
                    local saved = Webhook.trim(data.Rare)
                    -- normalisasi: huruf kecil, spasi dirapikan, jarak di sekitar koma diseragamkan
                    local norm = saved:lower():gsub("%s+", " ")
                    norm = norm:gsub("%s*,%s*", ", ")
                    if not Webhook.legacyRare[norm] then
                        Webhook.Rare = saved
                    end
                end
                if type(data.Url) == "string" then Webhook.Url = Webhook.trim(data.Url) end
            end
        end
    end)
end

function Webhook.save()
    pcall(function()
        if typeof(writefile) == "function" then
            writefile(Webhook.ConfigFile, game:GetService("HttpService"):JSONEncode({
                Enabled = Webhook.Enabled,
                Summary = Webhook.SummaryEnabled,
                Rare = Webhook.Rare,
                Url = Webhook.Url,
            }))
        end
    end)
end

-- URL harus webhook Discord beneran (placeholder "XXXXX" ditolak)
function Webhook.valid()
    local u = Webhook.Url
    if type(u) ~= "string" then return false end
    return u:match("^https://[%w%.]*discord%.com/api/webhooks/%d+/[%w_%-]+") ~= nil
        or u:match("^https://[%w%.]*discordapp%.com/api/webhooks/%d+/[%w_%-]+") ~= nil
end

function Webhook.post(payload)
    local req = request or http_request or (syn and syn.request) or (http and http.request)
    if typeof(req) ~= "function" then
        error("executor gak punya request/http_request")
    end
    return req({
        Url = Webhook.Url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = game:GetService("HttpService"):JSONEncode(payload),
    })
end

function Webhook.flush()
    local ok, err = pcall(function()
        while #Webhook.queue > 0 do
            local first = table.remove(Webhook.queue, 1)
            local payload

            if first.ping then
                -- Item langka: pesan sendiri + @everyone (allowed_mentions wajib biar benar-benar ngePing)
                payload = {
                    content = "@everyone Item langka didapat: **" .. tostring(first.label or "?") .. "**",
                    allowed_mentions = { parse = { "everyone" } },
                    embeds = { first.embed },
                }
            else
                -- Gabung embed biasa jadi 1 pesan (max 10), berhenti kalau ketemu entri ping
                local batch = { first.embed }
                while #batch < 10 and Webhook.queue[1] and not Webhook.queue[1].ping do
                    table.insert(batch, table.remove(Webhook.queue, 1).embed)
                end
                payload = { embeds = batch }
            end

            local okPost, res = pcall(Webhook.post, payload)

            -- Kena rate limit Discord: tunggu sesuai Retry-After, coba sekali lagi
            if okPost and res and res.StatusCode == 429 then
                local headers = res.Headers or {}
                local retry = tonumber(headers["retry-after"] or headers["Retry-After"]) or 3
                task.wait(math.min(retry, 30) + 0.5)
                okPost, res = pcall(Webhook.post, payload)
            end

            if not okPost then
                print("[AutoEventDoor] Webhook gagal kirim: " .. tostring(res))
            else
                local code = res and res.StatusCode
                if code and (code < 200 or code >= 300) then
                    print("[AutoEventDoor] Webhook ditolak Discord (status " .. tostring(code) .. ").")
                end
            end

            task.wait(1.2) -- Discord: ~5 request / 2 detik per webhook
        end
    end)
    if not ok then
        print("[AutoEventDoor] Webhook error: " .. tostring(err))
    end
    Webhook.sending = false
end

-- ping = true -> kirim sebagai pesan terpisah dengan @everyone (label = nama item)
function Webhook.push(embed, ping, label)
    if not Webhook.valid() then return end
    table.insert(Webhook.queue, { embed = embed, ping = ping == true, label = label })
    if #Webhook.queue > 50 then table.remove(Webhook.queue, 1) end
    if Webhook.sending then return end
    Webhook.sending = true
    task.spawn(Webhook.flush)
end

-- Pecah teks jadi kata huruf/angka kecil: "Goro Goro no Mi" -> {goro, goro, no, mi}
function Webhook.tokens(s)
    local t = {}
    for w in string.gmatch(string.lower(tostring(s)), "%w+") do
        table.insert(t, w)
    end
    return t
end

-- Cocok kalau SEMUA kata sebuah entri Webhook.Rare muncul berurutan penuh di nama item
-- (per kata utuh, bukan potongan huruf: "Hie" gak kena "Thief", "Ito" gak kena "Mito").
-- Entri dipisah koma / baris baru; awalan jumlah ("1x Goro") diabaikan.
function Webhook.isRare(name)
    local nameTokens = Webhook.tokens(name)
    for entry in string.gmatch(Webhook.Rare or "", "[^,\n]+") do
        local clean = Webhook.trim(entry):gsub("^%d+%s*[xX]%s+", "")
        local et = Webhook.tokens(clean)
        if #et > 0 then
            for i = 1, #nameTokens - #et + 1 do
                local match = true
                for j = 1, #et do
                    if nameTokens[i + j - 1] ~= et[j] then
                        match = false
                        break
                    end
                end
                if match then return true end
            end
        end
    end
    return false
end

function Webhook.embed(title, description, color)
    return {
        title = title,
        description = description,
        color = color or 3066993, -- hijau
        footer = { text = LocalPlayer.Name .. " - " .. os.date("%H:%M:%S - %d/%m/%Y") },
    }
end

function Webhook.itemEmbed(name, amount)
    return Webhook.embed("Item Diperoleh!",
        string.format("**Item:** %s\n**Jumlah:** %s", name, tostring(amount)))
end

function Webhook.rareEmbed(name, amount)
    return Webhook.embed("ITEM LANGKA DIPEROLEH!",
        string.format("**Item:** %s\n**Jumlah:** %s", name, tostring(amount)), 15844367)
end

-- "Rare Fruit Chest x5" / "Rare Fruit Chest (5)" -> "Rare Fruit Chest"
function Webhook.baseName(name)
    local base = tostring(name):gsub("%s*[xX]%s*%d+$", "")
    base = base:gsub("%s*%(%d+%)$", "")
    return base
end

function Webhook.snapshot()
    local counts = {}
    local function scan(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then
                local key = Webhook.baseName(child.Name)
                counts[key] = (counts[key] or 0) + (readToolCount(child) or 1)
            end
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack"))
    scan(LocalPlayer.Character)
    return counts
end

function Webhook.check()
    -- Lagi respawn (Backpack/Character belum ada): jangan bandingin
    if not LocalPlayer.Character or not LocalPlayer:FindFirstChild("Backpack") then return end

    local now = Webhook.snapshot()

    -- Respawn / baru mulai: update diam-diam, jangan hitung & jangan kirim apa-apa
    if tick() < Webhook.quietUntil then
        Webhook.last = now
        return
    end

    local notify = Webhook.Enabled and Webhook.valid()
    for name, count in pairs(now) do
        local before = Webhook.last[name] or 0
        if count > before then
            Webhook.addItem(name, count - before) -- statistik ringkasan, selalu dihitung
            if notify then
                if Webhook.isRare(name) then
                    Webhook.push(Webhook.rareEmbed(name, count - before), true, name)
                else
                    Webhook.push(Webhook.itemEmbed(name, count - before))
                end
            end
        end
    end
    Webhook.last = now
end

-- ---------- Statistik & ringkasan berkala ----------
function Webhook.newCounters()
    return { doors = 0, failed = 0, chestsBought = 0, chestsOpened = 0, merchant = 0, dropped = 0, items = {} }
end

Webhook.stats = {
    win = Webhook.newCounters(),   -- jendela ringkasan yang lagi berjalan
    tot = Webhook.newCounters(),   -- total sejak script jalan
    winActive = 0, totActive = 0,  -- detik farm ON
    activeSince = nil,
    windowStart = tick(),
    startedAt = tick(),
}

function Webhook.count(key, n)
    local s = Webhook.stats
    n = n or 1
    s.win[key] = s.win[key] + n
    s.tot[key] = s.tot[key] + n
end

function Webhook.addItem(name, n)
    local s = Webhook.stats
    s.win.items[name] = (s.win.items[name] or 0) + n
    s.tot.items[name] = (s.tot.items[name] or 0) + n
end

-- Dipanggil tiap farm di-ON/OFF: catat lamanya script benar-benar aktif
function Webhook.setActive(on)
    local s, now = Webhook.stats, tick()
    if on then
        if not s.activeSince then s.activeSince = now end
    elseif s.activeSince then
        local d = now - s.activeSince
        s.winActive = s.winActive + d
        s.totActive = s.totActive + d
        s.activeSince = nil
    end
end

function Webhook.active(which)
    local s = Webhook.stats
    local base = (which == "win") and s.winActive or s.totActive
    if s.activeSince then base = base + (tick() - s.activeSince) end
    return base
end

function Webhook.fmtDur(seconds)
    seconds = math.max(0, math.floor(seconds))
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    if h > 0 then return string.format("%dj %02dm", h, m) end
    return string.format("%dm", m)
end

function Webhook.itemsText(totItems, winItems)
    local list = {}
    for name, n in pairs(totItems) do
        table.insert(list, { name = name, n = n, d = winItems[name] or 0 })
    end
    if #list == 0 then return "-" end
    table.sort(list, function(a, b)
        if a.n ~= b.n then return a.n > b.n end
        return a.name < b.name
    end)

    local lines, len = {}, 0
    for i, it in ipairs(list) do
        local line = string.format("â€¢ %s x%d", it.name, it.n)
        -- (+n) = tambahan di jam terakhir (cuma ditampilin kalau sebagian lama, sebagian baru)
        if it.d > 0 and it.d < it.n then line = line .. string.format(" (+%d)", it.d) end
        if i > 15 or len + #line > 900 then
            table.insert(lines, string.format("... +%d item lain", #list - i + 1))
            break
        end
        table.insert(lines, line)
        len = len + #line + 1
    end
    return table.concat(lines, "\n")
end

-- KUMULATIF: tiap ringkasan memuat total sejak script jalan (jam ke-2 = 2 jam, jam ke-3 = 3 jam, dst).
-- (+n) di tiap angka = tambahan sejak ringkasan sebelumnya.
function Webhook.summaryEmbed(manual)
    local s = Webhook.stats
    local w, t = s.win, s.tot
    local elapsed = tick() - s.startedAt
    local hours = math.max(1, math.floor(elapsed / 3600 + 0.5))
    local candy = getCandyCount()

    local function pair(key)
        return string.format("%d  (+%d)", t[key], w[key])
    end

    return {
        title = manual and ("Ringkasan (manual) - " .. Webhook.fmtDur(elapsed))
            or string.format("Ringkasan %d Jam", hours),
        description = string.format(
            "Total sejak script jalan: **%s**  |  Aktif: **%s**\n(+n) = tambahan sejak ringkasan sebelumnya",
            Webhook.fmtDur(elapsed), Webhook.fmtDur(Webhook.active("tot"))),
        color = 15844367, -- emas
        fields = {
            { name = "Door dikunjungi", value = pair("doors"), inline = true },
            { name = "Door gagal", value = pair("failed"), inline = true },
            { name = "Merchant", value = pair("merchant"), inline = true },
            { name = "Chest dibeli", value = pair("chestsBought"), inline = true },
            { name = "Chest dibuka", value = pair("chestsOpened"), inline = true },
            { name = "Fruit di-drop", value = pair("dropped"), inline = true },
            { name = "Sekarang", value = string.format("Candy %s/%d\nChest %d",
                candy and tostring(candy) or "-", Settings.CandyTarget, getChestCount()), inline = true },
            { name = "Item diperoleh (total)", value = Webhook.itemsText(t.items, w.items), inline = false },
        },
        footer = { text = string.format("%s - %s", LocalPlayer.Name, os.date("%H:%M:%S - %d/%m/%Y")) },
    }
end

-- manual = true: kirim sekarang tanpa mereset jendela hitungan
function Webhook.sendSummary(manual)
    Webhook.push(Webhook.summaryEmbed(manual))
end

function Webhook.resetWindow()
    local s = Webhook.stats
    local wasActive = s.activeSince ~= nil
    Webhook.setActive(false) -- tutup segmen aktif ke win+tot
    s.win = Webhook.newCounters()
    s.winActive = 0
    s.windowStart = tick()
    if wasActive then Webhook.setActive(true) end
end

function Webhook.tickSummary()
    if tick() < Webhook.nextSummary then return end
    Webhook.nextSummary = tick() + Webhook.SummaryEvery

    -- Jam sepi (farm gak pernah ON & gak ada item baru) gak perlu dikirim
    local s = Webhook.stats
    local hasActivity = Webhook.active("win") >= 1 or next(s.win.items) ~= nil
    if Webhook.SummaryEnabled and Webhook.valid() and hasActivity then
        Webhook.sendSummary(false)
    end
    Webhook.resetWindow()
end

function Webhook.start()
    if Webhook.started then return end
    Webhook.started = true

    Webhook.last = Webhook.snapshot()
    Webhook.quietUntil = tick() + 3
    Webhook.nextSummary = tick() + Webhook.SummaryEvery
    Webhook.stats.windowStart = tick()
    Webhook.stats.startedAt = tick()

    LocalPlayer.CharacterAdded:Connect(function()
        Webhook.quietUntil = tick() + 5
    end)

    task.spawn(function()
        while true do
            task.wait(Webhook.Interval)
            pcall(Webhook.check)
            pcall(Webhook.tickSummary)
        end
    end)
end

Webhook.load()

-- ================= FPS Cap =================
-- Batasi FPS ke Settings.FpsCap (default 20) lewat setfpscap milik executor, dan TULIS ULANG
-- tiap Fps.Interval detik karena game / executor kadang mengembalikan FPS ke normal.
-- OFF -> cap dilepas (setfpscap(0) = tanpa batas). Butuh executor yang punya setfpscap.
-- Fps.current = FPS terukur (jumlah frame Heartbeat per detik), ditampilkan di GUI.
local Fps = {
    Interval = 1,
    current = 0,
    frames = 0,
    last = tick(),
    started = false,
    warned = false,
    lastApply = 0,
    Refresh = 30,      -- tulis ulang paling lambat tiap sekian detik walau FPS terlihat normal
    HitchMs = 250,     -- frame selambat ini dicatat sebagai HITCH di log
    lastHitch = 0,
}

function Fps.fn()
    local fn = setfpscap or set_fps_cap
    if typeof(fn) == "function" then return fn end
    return nil
end

function Fps.write(value)
    local fn = Fps.fn()
    if not fn then
        if not Fps.warned then
            Fps.warned = true
            print("[AutoEventDoor] Executor gak punya setfpscap, FPS cap gak bisa dipakai.")
        end
        return false
    end
    return pcall(fn, value)
end

-- Tulis cap sekarang (kalau fitur ON)
function Fps.apply()
    if not Settings.FpsCapEnabled then return false end
    Fps.lastApply = tick()
    return Fps.write(Settings.FpsCap)
end

-- Tulis ulang HANYA kalau perlu: FPS terukur lari di atas cap (game / executor mengembalikannya)
-- atau sudah Fps.Refresh detik. Nulis cap tiap detik tanpa alasan bisa bikin hitch di sebagian executor.
function Fps.needsWrite()
    return Settings.FpsCapEnabled
        and (Fps.current > Settings.FpsCap + 2 or tick() - Fps.lastApply >= Fps.Refresh)
end

-- Lepas cap (dipanggil pas fitur dimatiin)
function Fps.release()
    return Fps.write(0)
end

function Fps.start()
    if Fps.started then return end
    Fps.started = true

    -- Detektor hitch: frame >= Fps.HitchMs dicatat beserta status script saat itu (lihat console).
    -- Fps.describe diisi belakangan (butuh Stat yang dibuat setelah modul ini).
    RunService.Heartbeat:Connect(function(dt)
        Fps.frames = Fps.frames + 1
        if dt * 1000 >= Fps.HitchMs then
            local now = tick()
            if now - Fps.lastHitch >= 2 then
                Fps.lastHitch = now
                local where = Fps.describe and Fps.describe() or "?"
                print(string.format("[AutoEventDoor] HITCH %.0f ms | %s", dt * 1000, where))
            end
        end
    end)

    Fps.apply()

    task.spawn(function()
        while true do
            task.wait(Fps.Interval)

            local now = tick()
            Fps.current = math.floor(Fps.frames / math.max(now - Fps.last, 0.001) + 0.5)
            Fps.frames, Fps.last = 0, now

            -- Kalau FPS lari di atas cap (atau cap-nya kebalik), dipaksa lagi
            if Fps.needsWrite() then Fps.apply() end
        end
    end)
end

-- ================= Auto Drop fruit - konfigurasi =================
-- Equip fruit dari kategori rarity terpilih lalu tekan Backspace (drop bawaan game). Logikanya ada
-- di dekat bagian "Equip Candy Corn Basket" dan dipanggil mainLoop di TITIK AMAN (karakter lagi
-- diam: sebelum cari door / saat nunggu cooldown), jadi gak bentrok sama gerak, fire prompt, atau
-- basket. Default MATI; pengaturan tersimpan ke file.
local Drop = {
    ConfigFile = "AutoEventDoor_Drop.json",
    running = false,
    manual = false,           -- true = lagi jalan dari tombol "Drop sekarang" waktu farm OFF
    now = false,              -- permintaan "Drop sekarang" waktu farm ON (dijalankan mainLoop)
    nextAt = 0,
    skipUntil = setmetatable({}, { __mode = "k" }),  -- [tool] = tick sampai kapan dilewati (drop gagal)
    Attempts = 3,             -- percobaan equip+Backspace per fruit
    Gap = 0.8,                -- detik jeda antar fruit
    MaxPerRun = 30,
}

function Drop.load()
    pcall(function()
        if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(Drop.ConfigFile) then
            local data = game:GetService("HttpService"):JSONDecode(readfile(Drop.ConfigFile))
            if type(data) == "table" then
                if type(data.Enabled) == "boolean" then Settings.AutoDrop = data.Enabled end
                if type(data.Rarities) == "table" then
                    local allowed, selected = {Common = true, Epic = true, Legendary = true, Mythical = true, Rare = true}, {}
                    for _, rarity in ipairs(data.Rarities) do
                        if allowed[rarity] and not table.find(selected, rarity) then table.insert(selected, rarity) end
                    end
                    Settings.DropRarities = selected
                end
                if type(data.Interval) == "number" and data.Interval >= 3 then
                    Settings.DropInterval = math.floor(data.Interval)
                end
            end
        end
    end)
end

function Drop.save()
    pcall(function()
        if typeof(writefile) == "function" then
            writefile(Drop.ConfigFile, game:GetService("HttpService"):JSONEncode({
                Enabled = Settings.AutoDrop,
                Rarities = Settings.DropRarities,
                Interval = Settings.DropInterval,
            }))
        end
    end)
end

Drop.load()

-- ================= GUI =================
-- Layout lebar + bertab (Farm / Gerak / Shop / Server) supaya gak panjang ke bawah.
-- RightShift = sembunyikan / tampilkan GUI. "," = toggle ON/OFF farm.
-- Semua widget dibuat lewat helper di tabel UI (hemat local, batas Luau 200).
local GUI_TOGGLE_KEY = Enum.KeyCode.RightShift

pcall(function()
    local old = CoreGui:FindFirstChild("AutoEventDoorGui")
    if old then old:Destroy() end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoEventDoorGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local UI = {
    C = {
        bg = Color3.fromRGB(24, 24, 28),
        bar = Color3.fromRGB(34, 34, 40),
        panel = Color3.fromRGB(30, 30, 36),
        input = Color3.fromRGB(46, 46, 54),
        accent = Color3.fromRGB(60, 100, 170),
        on = Color3.fromRGB(50, 160, 80),
        off = Color3.fromRGB(180, 50, 50),
        text = Color3.fromRGB(225, 225, 225),
        dim = Color3.fromRGB(140, 140, 150),
        candy = Color3.fromRGB(255, 180, 80),
        white = Color3.fromRGB(255, 255, 255),
    },
    Pages = {},
    Tabs = {},
    MacState = {},
}

function UI.corner(obj, radius)
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, radius or 6)
    return obj
end

function UI.label(parent, text, pos, size, color, font, textSize)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Position = pos
    l.Size = size
    l.Text = text
    l.TextColor3 = color or UI.C.text
    l.Font = font or Enum.Font.Gotham
    l.TextSize = textSize or 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

function UI.box(parent, pos, size, text, placeholder)
    local box = Instance.new("TextBox")
    box.Position = pos
    box.Size = size
    box.BackgroundColor3 = UI.C.input
    box.TextColor3 = UI.C.white
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.Text = tostring(text or "")
    box.ClearTextOnFocus = false
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.BorderSizePixel = 0
    box.Parent = parent
    UI.corner(box)
    Instance.new("UIPadding", box).PaddingLeft = UDim.new(0, 6)
    return box
end

function UI.button(parent, text, pos, size, color, textSize)
    local b = Instance.new("TextButton")
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = UI.C.white
    b.Font = Enum.Font.GothamBold
    b.TextSize = textSize or 12
    b.BorderSizePixel = 0
    b.Parent = parent
    UI.corner(b)
    return b
end

-- Tombol ON/OFF. get() baca state, set(v) terapkan state baru.
function UI.toggle(parent, pos, size, get, set, prefix)
    local btn = UI.button(parent, "", pos, size, UI.C.off)
    local function refresh()
        local on = get()
        btn.Text = (prefix or "") .. (on and "ON" or "OFF")
        btn.BackgroundColor3 = on and UI.C.on or UI.C.off
    end
    btn.MouseButton1Click:Connect(function()
        set(not get())
        refresh()
    end)
    refresh()
    return btn
end

function UI.page(name)
    local f = Instance.new("Frame")
    f.Name = name
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 1, 0)
    f.Visible = false
    f.Parent = UI.Content
    UI.Pages[name] = f
    return f
end

function UI.select(name)
    for n, f in pairs(UI.Pages) do f.Visible = (n == name) end
    for n, b in pairs(UI.Tabs) do
        b.BackgroundColor3 = (n == name) and UI.C.accent or UI.C.bar
    end
end

-- Label + kotak angka (2 kolom per halaman). col: 0 = kiri, 1 = kanan
function UI.pair(page, col, y, text, value)
    local x = col * 0.5
    UI.label(page, text, UDim2.new(x, 0, 0, y), UDim2.new(0.29, 0, 0, 26))
    return UI.box(page, UDim2.new(x + 0.29, 0, 0, y), UDim2.new(0.19, 0, 0, 26), value)
end

function UI.rowLabel(page, y, text)
    return UI.label(page, text, UDim2.new(0, 0, 0, y), UDim2.new(0.28, 0, 0, 26))
end

-- ---------- Frame utama ----------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 326)
MainFrame.Position = UDim2.new(0, 20, 0.5, -163)
MainFrame.BackgroundColor3 = UI.C.bg
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
UI.corner(MainFrame, 8)

do
    local title = UI.label(MainFrame, "GPO Auto Event Door", UDim2.new(0, 0, 0, 0),
        UDim2.new(1, 0, 0, 30), UI.C.white, Enum.Font.GothamBold, 14)
    title.BackgroundTransparency = 0
    title.BackgroundColor3 = UI.C.bar
    title.BorderSizePixel = 0
    Instance.new("UIPadding", title).PaddingLeft = UDim.new(0, 12)
    UI.corner(title, 8)

    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    titleFix.Position = UDim2.new(0, 0, 0, 20)
    titleFix.BackgroundColor3 = UI.C.bar
    titleFix.BorderSizePixel = 0
    titleFix.ZIndex = 0
    titleFix.Parent = MainFrame

    local hint = UI.label(MainFrame, ",  ON/OFF   |   RShift  hide", UDim2.new(0, 0, 0, 0),
        UDim2.new(1, -12, 0, 30), UI.C.dim, Enum.Font.Gotham, 11)
    hint.TextXAlignment = Enum.TextXAlignment.Right
end

-- ---------- Info strip ----------
StatusText = UI.label(MainFrame, "OFF", UDim2.new(0, 12, 0, 34),
    UDim2.new(1, -24, 0, 20), Color3.fromRGB(200, 200, 200), Enum.Font.GothamBold, 14)

local StatusDetail = UI.label(MainFrame, "", UDim2.new(0, 12, 0, 54),
    UDim2.new(1, -24, 0, 16), UI.C.dim, Enum.Font.Gotham, 11)

ProgressLabel = UI.label(MainFrame, "Opened: 0/0", UDim2.new(0, 12, 0, 72),
    UDim2.new(0.4, -12, 0, 18), UI.C.dim, Enum.Font.Gotham, 12)

local CandyLabel = UI.label(MainFrame, "Candy: -/290", UDim2.new(0.4, 0, 0, 72),
    UDim2.new(0.6, -12, 0, 18), UI.C.candy, Enum.Font.GothamBold, 12)

-- ---------- Tab bar + area konten ----------
do
    local tabBar = Instance.new("Frame")
    tabBar.BackgroundTransparency = 1
    tabBar.Position = UDim2.new(0, 10, 0, 94)
    tabBar.Size = UDim2.new(1, -20, 0, 26)
    tabBar.Parent = MainFrame

    for i, name in ipairs({"Halloween", "Traveling", "Shop", "Drop", "Server", "Webhook"}) do
        local tab = UI.button(tabBar, name, UDim2.new((i - 1) / 6, 0, 0, 0),
            UDim2.new(1 / 6, -4, 1, 0), UI.C.bar, 12)
        tab.MouseButton1Click:Connect(function() UI.select(name) end)
        UI.Tabs[name] = tab
    end

    local content = Instance.new("Frame")
    content.BackgroundColor3 = UI.C.panel
    content.BorderSizePixel = 0
    content.Position = UDim2.new(0, 10, 0, 124)
    content.Size = UDim2.new(1, -20, 0, 150)
    content.Parent = MainFrame
    UI.corner(content, 6)

    local pad = Instance.new("UIPadding", content)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)

    UI.Content = content
end

local CooldownBox, ChestTriggerBox, FpsCapBox, DropIntervalBox

-- ---------- Tab: Halloween ----------
do
    local page = UI.page("Halloween")
    CooldownBox = UI.pair(page, 1, 0, "Cooldown (s):", Settings.DoorCooldown)
    CandyTargetBox = UI.pair(page, 1, 34, "Candy Target:", Settings.CandyTarget)

    UI.rowLabel(page, 102, "FPS Cap:")
    FpsCapBox = UI.box(page, UDim2.new(0.28, 0, 0, 102), UDim2.new(0.24, 0, 0, 26), Settings.FpsCap)
    UI.toggle(page, UDim2.new(0.54, 0, 0, 102), UDim2.new(0.22, 0, 0, 26),
        function() return Settings.FpsCapEnabled end,
        function(v)
            Settings.FpsCapEnabled = v
            if v then Fps.apply() else Fps.release() end
        end)
    UI.label(page, "ditulis ulang tiap detik", UDim2.new(0.78, 0, 0, 102), UDim2.new(0.22, 0, 0, 26),
        UI.C.dim, Enum.Font.Gotham, 10)
end

-- ---------- Tab: Traveling ----------
do
    local page = UI.page("Traveling")
    UI.label(page, "Pilih tujuan dan atur Island Travel di tab ini.",
        UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), UI.C.dim, Enum.Font.Gotham, 11)
end

-- ---------- Tab: Shop ----------
do
    local page = UI.page("Shop")

    UI.rowLabel(page, 0, "Buka Chest di:")
    ChestTriggerBox = UI.box(page, UDim2.new(0.28, 0, 0, 0), UDim2.new(0.24, 0, 0, 26), Settings.ChestOpenAt)
    UI.label(page, "(0 = mati)", UDim2.new(0.54, 0, 0, 0), UDim2.new(0.4, 0, 0, 26), UI.C.dim, Enum.Font.Gotham, 11)

    UI.rowLabel(page, 34, "Auto Merchant:")
    UI.toggle(page, UDim2.new(0.28, 0, 0, 34), UDim2.new(0.24, 0, 0, 26),
        function() return Settings.AutoMerchant end,
        function(v) Settings.AutoMerchant = v end)

end

-- ---------- Tab: Drop (auto drop fruit) ----------
do
    local page = UI.page("Drop")

    UI.rowLabel(page, 0, "Auto Drop:")
    UI.toggle(page, UDim2.new(0.28, 0, 0, 0), UDim2.new(0.24, 0, 0, 26),
        function() return Settings.AutoDrop end,
        function(v)
            Settings.AutoDrop = v
            Drop.save()
        end)
    local dropNow = UI.button(page, "Drop sekarang", UDim2.new(0.54, 0, 0, 0), UDim2.new(0.46, 0, 0, 26), UI.C.accent)
    dropNow.MouseButton1Click:Connect(function()
        Drop.requestNow()
    end)

    UI.rowLabel(page, 34, "Cek tiap (s):")
    DropIntervalBox = UI.box(page, UDim2.new(0.28, 0, 0, 34), UDim2.new(0.24, 0, 0, 26), Settings.DropInterval)
    UI.label(page, "Pilih rarity Common / Epic / Rare di dropdown.",
        UDim2.new(0.54, 0, 0, 34), UDim2.new(0.46, 0, 0, 26), UI.C.dim, Enum.Font.Gotham, 10)

    local hint = UI.label(page,
        "Equip fruit lalu tekan Backspace, hanya di sela farm (bukan saat jalan / fire prompt). Basket di-equip lagi otomatis. Nama harus persis (Kilo / Kilo Kilo no Mi).",
        UDim2.new(0, 0, 0, 102), UDim2.new(1, 0, 0, 28), UI.C.dim, Enum.Font.Gotham, 10)
    hint.TextWrapped = true
    hint.TextYAlignment = Enum.TextYAlignment.Top
end

-- ---------- Tab: Server (auto join private server) ----------
do
    local page = UI.page("Server")

    UI.rowLabel(page, 0, "Private Code:")
    PrivateServer.CodeBox = UI.box(page, UDim2.new(0.28, 0, 0, 0), UDim2.new(0.42, -4, 0, 26), PrivateServer.Code)
    UI.toggle(page, UDim2.new(0.70, 0, 0, 0), UDim2.new(0.30, 0, 0, 26),
        function() return PrivateServer.Enabled end,
        function(v)
            PrivateServer.Enabled = v
            PrivateServer.Code = PrivateServer.CodeBox.Text:match("^%s*(.-)%s*$") or ""
            PrivateServer.save()
        end, "Join: ")

    local hint = UI.label(page, "Dipakai saat script dijalankan di MAIN MENU: kirim kode, pilih Regular, lalu konfirmasi First Sea.",
        UDim2.new(0, 0, 0, 36), UDim2.new(1, 0, 0, 40), UI.C.dim, Enum.Font.Gotham, 11)
    hint.TextWrapped = true
    hint.TextYAlignment = Enum.TextYAlignment.Top
end

-- ---------- Tab: Webhook ----------
do
    local page = UI.page("Webhook")

    UI.rowLabel(page, 0, "Webhook URL:")
    Webhook.UrlBox = UI.box(page, UDim2.new(0.28, 0, 0, 0), UDim2.new(0.72, 0, 0, 26),
        Webhook.Url, "https://discord.com/api/webhooks/...")

    UI.rowLabel(page, 34, "Notif item:")
    UI.toggle(page, UDim2.new(0.28, 0, 0, 34), UDim2.new(0.34, -4, 0, 26),
        function() return Webhook.Enabled end,
        function(v)
            Webhook.Enabled = v
            Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
            Webhook.save()
        end)

    local test = UI.button(page, "Test", UDim2.new(0.64, 0, 0, 34), UDim2.new(0.36, 0, 0, 26), UI.C.accent)
    test.MouseButton1Click:Connect(function()
        Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
        Webhook.save()
        if not Webhook.valid() then
            print("[AutoEventDoor] Webhook URL belum valid (harus https://discord.com/api/webhooks/<id>/<token>).")
            return
        end
        Webhook.push(Webhook.embed("Test Webhook", "Webhook terhubung.", 3447003))
    end)

    UI.rowLabel(page, 68, "Ringkasan 1 jam:")
    UI.toggle(page, UDim2.new(0.28, 0, 0, 68), UDim2.new(0.34, -4, 0, 26),
        function() return Webhook.SummaryEnabled end,
        function(v)
            Webhook.SummaryEnabled = v
            Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
            Webhook.save()
        end)
    local sumNow = UI.button(page, "Kirim sekarang", UDim2.new(0.64, 0, 0, 68), UDim2.new(0.36, 0, 0, 26), UI.C.accent)
    sumNow.MouseButton1Click:Connect(function()
        Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
        Webhook.save()
        if not Webhook.valid() then
            print("[AutoEventDoor] Webhook URL belum valid (harus https://discord.com/api/webhooks/<id>/<token>).")
            return
        end
        Webhook.sendSummary(true)
    end)

    UI.rowLabel(page, 102, "Ping @everyone:")
    Webhook.RareBox = UI.box(page, UDim2.new(0.28, 0, 0, 102), UDim2.new(0.72, 0, 0, 26),
        Webhook.Rare, "Item langka, pisah koma")
end

UI.select("Halloween")

-- ---------- Bar bawah: ON/OFF + Apply ----------
ToggleButton = UI.button(MainFrame, "OFF", UDim2.new(0, 10, 1, -44), UDim2.new(1, -20, 0, 34), UI.C.off, 14)

-- ---------- Status (judul berwarna + detail real-time) ----------
-- Stat.set(judul, detail, jenis): detail boleh string ATAU function() -> string yang
-- dievaluasi 4x/detik (jarak, ETA, countdown update sendiri).
-- Jenis: move (biru) / work (hijau) / wait (oranye) / warn (merah) / idle (abu).
local Stat = {
    title = "Siaga", detail = "", detailFn = nil, note = "", kind = "idle", since = tick(),
    colors = {
        move = Color3.fromRGB(90, 170, 255),
        work = Color3.fromRGB(90, 210, 130),
        wait = Color3.fromRGB(255, 180, 80),
        warn = Color3.fromRGB(255, 110, 110),
        idle = Color3.fromRGB(200, 200, 200),
    },
}

function Stat.set(title, detail, kind)
    Stat.title = title
    if type(detail) == "function" then
        Stat.detailFn, Stat.detail = detail, ""
    else
        Stat.detailFn, Stat.detail = nil, detail or ""
    end
    Stat.note = ""
    Stat.kind = kind or "work"
    Stat.since = tick()
end

function Stat.clear()
    Stat.set("Siaga", "", "idle")
end

-- Simpan / pulihkan status (dipakai aksi sementara: stun, keluar atap)
function Stat.snapshot()
    return { Stat.title, Stat.detail, Stat.detailFn, Stat.note, Stat.kind, Stat.since }
end

function Stat.restore(s)
    Stat.title, Stat.detail, Stat.detailFn, Stat.note, Stat.kind, Stat.since =
        s[1], s[2], s[3], s[4], s[5], s[6]
end

-- Detail "jarak | ETA | mode" menuju posisi dari getPos() (re-evaluasi tiap render)
function Stat.towards(getPos, extra)
    return function()
        local p = getPos()
        if not p then return extra or "" end
        local d = (RootPart.Position - p).Magnitude
        local speed = Settings.TweenMode and math.max(Settings.TweenSpeed, 1) or math.max(Humanoid.WalkSpeed, 1)
        local modeName = not Settings.TweenMode and "WASD" or (Settings.TweenWalk and "tween jalan" or "tween")
        local text = string.format("%.0f stud  |  ETA ~%ds  |  %s", d, math.ceil(d / speed), modeName)
        if extra and extra ~= "" then text = extra .. "  |  " .. text end
        return text
    end
end

local function renderStatus()
    if not Enabled then
        StatusText.Text = "OFF"
        StatusText.TextColor3 = UI.C.off
        StatusDetail.Text = "Tekan  ,  atau tombol ON untuk mulai"
        if UI.MacState.Status then UI.MacState.Status:UpdateName("Status: OFF - tekan Farm ON/OFF untuk mulai") end
        return
    end

    local detail = Stat.detail
    if Stat.detailFn then
        local ok, res = pcall(Stat.detailFn)
        detail = ok and tostring(res or "") or ""
    end
    if Stat.note ~= "" then
        detail = detail .. (detail ~= "" and "  |  " or "") .. Stat.note
    end

    StatusText.Text = Stat.title
    StatusText.TextColor3 = Stat.colors[Stat.kind] or UI.C.text
    StatusDetail.Text = detail
    if UI.MacState.Status then
        UI.MacState.Status:UpdateName("Status: " .. Stat.title .. (detail ~= "" and (" | " .. detail) or ""))
    end
end

local function updateGuiState()
    renderStatus()
    if Enabled then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = UI.C.on
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = UI.C.off
    end

    -- "Opened" = jumlah door yang lagi cooldown (udah dikunjungi & belum siap lagi)
    local count = 0
    local nowTick = tick()
    for door in pairs(LastVisit) do
        if door.Parent and nowTick < getDoorReadyAt(door) then
            count = count + 1
        end
    end
    local total = math.max(LastKnownDoorCount, count)
    ProgressLabel.Text = "Opened: " .. count .. "/" .. total .. "  |  FPS " .. Fps.current
    if UI.MacState.Progress then
        UI.MacState.Progress:UpdateName("Opened: " .. count .. "/" .. total .. "  |  FPS " .. Fps.current .. "  |  " .. getCandyText())
    end

    CandyLabel.Text = getCandyText()
end

local function applySettings()
    local ct = tonumber(CandyTargetBox.Text)
    local cd = tonumber(CooldownBox.Text)
    local cr = tonumber(ChestTriggerBox.Text)
    local fc = tonumber(FpsCapBox.Text)
    local di = tonumber(DropIntervalBox.Text)

    -- Kode private server: simpan ke file/getgenv biar kebaca di main menu
    PrivateServer.Code = PrivateServer.CodeBox.Text:match("^%s*(.-)%s*$") or ""
    PrivateServer.save()

    -- Webhook Discord
    Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
    Webhook.Rare = Webhook.trim(Webhook.RareBox.Text)
    Webhook.save()

    -- Auto Drop
    if di and di >= 3 then Settings.DropInterval = math.floor(di) end
    Drop.save()

    if cr and cr >= 0 then Settings.ChestOpenAt = math.floor(cr) end
    if fc and fc >= 5 then Settings.FpsCap = math.floor(fc) end

    if ct and ct > 0 then Settings.CandyTarget = math.floor(ct) end
    if cd and cd >= 0 then Settings.DoorCooldown = cd end

    CandyTargetBox.Text = tostring(Settings.CandyTarget)
    CooldownBox.Text = tostring(Settings.DoorCooldown)
    ChestTriggerBox.Text = tostring(Settings.ChestOpenAt)
    FpsCapBox.Text = tostring(Settings.FpsCap)
    DropIntervalBox.Text = tostring(Settings.DropInterval)
    PrivateServer.CodeBox.Text = PrivateServer.Code
    Webhook.UrlBox.Text = Webhook.Url
    Webhook.RareBox.Text = Webhook.Rare

    Fps.apply() -- cap baru langsung ditulis
    updateGuiState()
end

-- Kotak angka: Enter = apply. Kotak teks panjang (kode / URL): apply tiap fokus lepas
-- (biasanya di-paste lalu klik di luar).
for _, box in ipairs({CandyTargetBox, CooldownBox, ChestTriggerBox, FpsCapBox, DropIntervalBox}) do
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then applySettings() end
    end)
end
PrivateServer.CodeBox.FocusLost:Connect(function() applySettings() end)
Webhook.UrlBox.FocusLost:Connect(function() applySettings() end)
Webhook.RareBox.FocusLost:Connect(function() applySettings() end)

-- ================= MacLib UI =================
-- MacLib is bundled above the project script in this file.
ScreenGui.Enabled = false
UI.MacWindow = MacLib:Window({
    Title = "RaizooHub",
    Subtitle = "GPO Auto Event Door",
    Size = UDim2.fromOffset(868, 650),
    DragStyle = 1,
    ShowUserInfo = true,
    Keybind = GUI_TOGGLE_KEY,
    AcrylicBlur = true,
})
UI.MacGroup = UI.MacWindow:TabGroup()
UI.MacTabs = {
    Farm = UI.MacGroup:Tab({Name = "Halloween"}),
    Traveling = UI.MacGroup:Tab({Name = "Traveling"}),
    Fishing = UI.MacGroup:Tab({Name = "Fishing"}),
    Shop = UI.MacGroup:Tab({Name = "Shop"}),
    Drop = UI.MacGroup:Tab({Name = "Drop"}),
    Server = UI.MacGroup:Tab({Name = "Server"}),
    Webhook = UI.MacGroup:Tab({Name = "Webhook"}),
}
UI.MacSections = {}
for name, tab in pairs(UI.MacTabs) do
    UI.MacSections[name] = tab:Section({Side = "Left"})
end
function UI.MacInput(section, name, box, placeholder)
    return section:Input({
        Name = name,
        Default = tostring(box.Text),
        Placeholder = placeholder or "",
        AcceptedCharacters = "All",
        onChanged = function(value) box.Text = value end,
        Callback = function(value)
            box.Text = value
            applySettings()
        end,
    })
end
function UI.MacToggle(section, name, get, set)
    return section:Toggle({
        Name = name,
        Default = get(),
        Callback = function(value) set(value) end,
    })
end
function UI.MacButton(section, name, callback)
    return section:Button({Name = name, Callback = callback})
end

UI.MacSections.Farm:Header({Name = "Status"})
UI.MacState.Status = UI.MacSections.Farm:Label({Text = "OFF"})
UI.MacState.Progress = UI.MacSections.Farm:Label({Text = "Opened: 0/0"})
UI.MacToggle(UI.MacSections.Farm, "Farm ON/OFF", function() return Enabled end,
    function(value) UI.setEnabled(value) end)
UI.MacInput(UI.MacSections.Farm, "Cooldown (s)", CooldownBox)
UI.MacInput(UI.MacSections.Farm, "Candy Target", CandyTargetBox)
UI.MacSections.Farm:Header({Name = "Auto Buy Halloween"})
UI.MacState.HalloweenShopStatus = UI.MacSections.Farm:Label({Text = "Halloween Shop: idle"})
UI.MacToggle(UI.MacSections.Farm, "Auto Buy Rare Fruit Chest", function() return Settings.AutoBuyRareChest end,
    function(value) Settings.AutoBuyRareChest = value end)
UI.MacToggle(UI.MacSections.Farm, "Auto Buy Race Reroll x5 (Candy Target)", function() return Settings.AutoBuyRaceReroll end,
    function(value) Settings.AutoBuyRaceReroll = value end)
UI.MacInput(UI.MacSections.Farm, "FPS Cap", FpsCapBox)
UI.MacToggle(UI.MacSections.Farm, "FPS Cap aktif", function() return Settings.FpsCapEnabled end,
    function(value)
        Settings.FpsCapEnabled = value
        if value then Fps.apply() else Fps.release() end
    end)

UI.MacSections.Traveling:Header({Name = "Traveling"})

-- Standalone island tween modeled on Tensen's BodyVelocity/BodyGyro mover.
-- It keeps its speed/toggle independent from the movement settings used by the farm.
local fireGeppoOnce -- assigned below; Island Travel reuses the project's Geppo implementation.

UI.IslandTravel = {
    Enabled = false,
    Selected = "None",
    Speed = 70,
    Running = false,
    Tween = nil,
    FixedSpots = {
        ["Dressrosa Cafe"] = CFrame.new(8316, 69, 10526),
        ["Town of Beginnings"] = CFrame.new(-530, 9, -3402),
        ["Shell's Town"] = CFrame.new(-1382, 7, -5107),
    },
}
do
    local Travel = UI.IslandTravel

    function Travel.status(text)
        if UI.MacState.IslandTravel then
            UI.MacState.IslandTravel:UpdateName("Island Travel: " .. text)
        end
    end

    function Travel.finishTween(motion, arrived)
        if not motion or motion.finished then return end
        motion.finished = true
        motion.arrived = arrived == true
        motion.geppoActive = false
        if motion.connection then motion.connection:Disconnect(); motion.connection = nil end
        if motion.addedConnection then motion.addedConnection:Disconnect(); motion.addedConnection = nil end
        if motion.gyro then motion.gyro:Destroy(); motion.gyro = nil end
        if motion.velocity then motion.velocity:Destroy(); motion.velocity = nil end
        for part, canCollide in pairs(motion.originalCollision or {}) do
            if part.Parent then pcall(function() part.CanCollide = canCollide end) end
        end
        if motion.root and motion.root.Parent then
            pcall(function()
                motion.root.AssemblyLinearVelocity = Vector3.zero
                motion.root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        if motion.humanoid and motion.humanoid.Parent then
            pcall(function()
                motion.humanoid.PlatformStand = motion.platformStand
                motion.humanoid.AutoRotate = motion.autoRotate
            end)
        end
        if Travel.Tween == motion then Travel.Tween = nil end
        if arrived and Travel.Enabled then Travel.status("sudah sampai di " .. tostring(motion.islandName)) end
    end

    function Travel.stopOwnedTween()
        Travel.finishTween(Travel.Tween, false)
    end

    function Travel.obstacleLanding(root, hit, direction, raycastParams, allowLower)
        local part = hit and hit.Instance
        if not (part and part:IsA("BasePart")) then return nil end
        local normal = hit.Normal
        if math.abs(normal:Dot(Vector3.new(0, 1, 0))) >= 0.75 then return nil end

        local parent = part.Parent
        if parent and (parent:FindFirstChildOfClass("Humanoid")
            or parent.Parent and parent.Parent:FindFirstChildOfClass("Humanoid")) then
            return nil
        end

        local size = part.Size
        local cf = part.CFrame
        local wallTop = part.Position.Y
            + math.abs(cf.RightVector.Y) * size.X / 2
            + math.abs(cf.UpVector.Y) * size.Y / 2
            + math.abs(cf.LookVector.Y) * size.Z / 2
        local neededY = wallTop + math.max(root.Size.Y / 2 + 1.5, 3)
        if neededY <= root.Position.Y + 1 and not allowLower then return nil end
        if neededY > root.Position.Y + 1 then
            local ceilingParams = RaycastParams.new()
            ceilingParams.FilterType = Enum.RaycastFilterType.Exclude
            ceilingParams.FilterDescendantsInstances = {root.Parent}
            local ceiling = workspace:Raycast(root.Position, Vector3.new(0, neededY - root.Position.Y + 2, 0), ceilingParams)
            if ceiling and ceiling.Position.Y <= neededY + 1 then return nil end
        end

        local projectedDepth = math.abs(direction:Dot(cf.RightVector)) * size.X / 2
            + math.abs(direction:Dot(cf.LookVector)) * size.Z / 2
        return {
            point = hit.Position,
            direction = direction,
            clearanceY = neededY,
            depth = math.max(projectedDepth + 6, 8),
        }
    end

    function Travel.scanObstacle(root, direction, right, raycastParams, reach, allowLower)
        -- Include a low ray at foot height: during a climb the root is above the wall,
        -- so root-height rays miss the next closely-spaced wall in a row of buildings.
        local scanOrigin = root.Position - direction * 4
        local lowOrigin = scanOrigin - Vector3.new(0, math.max(root.Size.Y * 0.5 + 1, 3), 0)
        local rays = {
            {scanOrigin, direction * reach},
            {scanOrigin + right * 1.5, direction * reach},
            {scanOrigin - right * 1.5, direction * reach},
            {scanOrigin + Vector3.new(0, 4, 0), direction * reach},
            {scanOrigin + Vector3.new(0, 8, 0), direction * reach},
            {scanOrigin + Vector3.new(0, 12, 0), direction * reach},
            {lowOrigin, direction * reach},
            {lowOrigin + right * 1.5, direction * reach},
            {lowOrigin - right * 1.5, direction * reach},
        }
        local nearest, nearestDistance
        for _, ray in ipairs(rays) do
            local hit = workspace:Raycast(ray[1], ray[2], raycastParams)
            if hit then
                local obstacle = Travel.obstacleLanding(root, hit, direction, raycastParams, allowLower)
                if obstacle and (not nearestDistance or hit.Distance < nearestDistance) then
                    nearest, nearestDistance = obstacle, hit.Distance
                end
            end
        end
        return nearest
    end

    function Travel.beginTween(target, islandName, external)
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not (root and humanoid and humanoid.Health > 0) then return nil end

        local motion = {
            root = root,
            humanoid = humanoid,
            target = target,
            islandName = islandName,
            external = external == true,
            startedAt = tick(),
            platformStand = humanoid.PlatformStand,
            autoRotate = humanoid.AutoRotate,
        }
        local ok, result = pcall(function()
            local gyro = Instance.new("BodyGyro")
            gyro.Name = "RaizooIslandTweenGyro"
            gyro.P = 200000
            gyro.D = 1000
            gyro.MaxTorque = Vector3.new(0, 1e9, 0)
            gyro.CFrame = root.CFrame
            gyro.Parent = root
            motion.gyro = gyro

            local velocity = Instance.new("BodyVelocity")
            velocity.Name = "RaizooIslandTweenVelocity"
            -- Normal travel only pushes horizontally, so gravity and floor collision keep
            -- the character grounded. Vertical force is enabled only while clearing a wall.
            velocity.MaxForce = Vector3.new(1e9, 0, 1e9)
            velocity.Velocity = Vector3.zero
            velocity.Parent = root
            motion.velocity = velocity
            humanoid.AutoRotate = false
        end)
        if not ok then
            Travel.finishTween(motion, false)
            return nil, result
        end

        Travel.Tween = motion
        motion.geppoActive = true
        task.spawn(function()
            while motion.geppoActive and not motion.finished and Travel.Tween == motion do
                if motion.climb and fireGeppoOnce then fireGeppoOnce() end
                task.wait(math.random(5, 7) / 10)
            end
        end)
        local maxTime = 20 -- Tensen TweenToCFrame default
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {character}
        motion.connection = RunService.Heartbeat:Connect(function(dt)
            if Travel.Tween ~= motion or (not Travel.Enabled and not motion.external) or not root.Parent
                or not humanoid.Parent or humanoid.Health <= 0 then
                Travel.finishTween(motion, false)
                return
            end
            if tick() - motion.startedAt >= maxTime then
                Travel.finishTween(motion, false)
                return
            end

            local flatPosition = Vector3.new(root.Position.X, 0, root.Position.Z)
            local delta = target.Position - root.Position
            local flatDelta = Vector3.new(delta.X, 0, delta.Z)
            if flatDelta.Magnitude <= 5 then
                Travel.finishTween(motion, true)
                return
            end

            local flatDirection = flatDelta.Magnitude > 0.01 and flatDelta.Unit
                or Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
            if flatDirection.Magnitude <= 0.01 then flatDirection = Vector3.new(0, 0, -1) end
            flatDirection = flatDirection.Unit
            local look = Vector3.new(flatDirection.X, 0, flatDirection.Z)
            local right = Vector3.new(-look.Z, 0, look.X)
            local reach = math.max(12, Travel.Speed * dt * 2.5 + 6)
            if motion.climb then
                local climb = motion.climb
                -- Keep the elevated crossing active until the next barrier is also clear.
                -- Adjacent walls often arrive before the character has landed after wall 1.
                local nextObstacle = Travel.scanObstacle(root, look, right, raycastParams, reach, true)
                if nextObstacle then
                    local firstPoint = Vector3.new(climb.point.X, 0, climb.point.Z)
                    local nextPoint = Vector3.new(nextObstacle.point.X, 0, nextObstacle.point.Z)
                    local offset = (nextPoint - firstPoint):Dot(climb.direction)
                    climb.depth = math.max(climb.depth, offset + nextObstacle.depth)
                    climb.clearanceY = math.max(climb.clearanceY, nextObstacle.clearanceY)
                    if nextObstacle.clearanceY > root.Position.Y + 1 then
                        if fireGeppoOnce then fireGeppoOnce() end
                        root.CFrame = CFrame.new(root.Position.X, nextObstacle.clearanceY, root.Position.Z)
                            * root.CFrame.Rotation
                        root.AssemblyLinearVelocity = Vector3.new(
                            root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                    end
                end

                local progress = (flatPosition - Vector3.new(climb.point.X, 0, climb.point.Z))
                    :Dot(climb.direction)
                if progress > climb.depth then
                    motion.climb = nil
                    motion.velocity.MaxForce = Vector3.new(1e9, 0, 1e9)
                end
            end

            if not motion.climb then
                local obstacle = Travel.scanObstacle(root, look, right, raycastParams, reach, false)
                if obstacle then
                    motion.climb = obstacle
                    if fireGeppoOnce then fireGeppoOnce() end
                    root.CFrame = CFrame.new(root.Position.X, obstacle.clearanceY, root.Position.Z)
                        * root.CFrame.Rotation
                    root.AssemblyLinearVelocity = Vector3.new(
                        root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                    motion.velocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                end
            end

            motion.velocity.Velocity = look * Travel.Speed
            if flatDirection.Magnitude > 0.01 then
                motion.gyro.CFrame = CFrame.lookAt(root.Position, root.Position + flatDirection)
            end
        end)
        return motion
    end

    function Travel.resolveTarget(name)
        local fixed = Travel.FixedSpots[name]
        if typeof(fixed) == "Vector3" then return CFrame.new(fixed) end
        if typeof(fixed) == "CFrame" then return fixed end
        if name == "Land of the Sky" and game.PlaceId == 3978370137 then
            return CFrame.new(2845, 1598, -8732)
        end

        local islands = workspace:FindFirstChild("Islands")
        local island = islands and islands:FindFirstChild(name)
        if not island then return nil end
        local okPivot, pivot = pcall(function() return island:GetPivot() end)
        if not okPivot or not pivot then return nil end

        local okBox, boxCFrame, boxSize = pcall(function() return island:GetBoundingBox() end)
        if okBox and boxCFrame and boxSize then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Include
            params.FilterDescendantsInstances = {island}
            local topY = boxCFrame.Position.Y + boxSize.Y / 2 + 20
            local drop = boxSize.Y + 220
            for _, origin in ipairs({pivot.Position, boxCFrame.Position}) do
                local rayOrigin = Vector3.new(origin.X, math.max(topY, origin.Y + 5), origin.Z)
                local hit = workspace:Raycast(rayOrigin, Vector3.new(0, -drop, 0), params)
                if hit then return CFrame.new(hit.Position + Vector3.new(0, 3, 0)) end
            end
        end

        -- If the island has not streamed in yet, follow Tensen's safe pivot
        -- fallback and stay above the water until its geometry is available.
        local position = pivot.Position
        local waterY = 0
        if type(waterY) == "number" and position.Y < waterY + 30 and position.Y > waterY - 150 then
            position = Vector3.new(position.X, waterY + 30, position.Z)
        elseif position.Y < 30 and position.Y > -150 then
            position = Vector3.new(position.X, 30, position.Z)
        end
        return CFrame.new(position)
    end

    function Travel.start()
        Travel.Enabled = true
        if Travel.Running then return end
        Travel.Running = true
        task.spawn(function()
            while Travel.Enabled do
                if Enabled then
                    UI.setEnabled(false)
                    task.wait(0.3)
                end

                local name = Travel.Selected
                if not name or name == "" or name == "None" then
                    Travel.status("pilih pulau dulu")
                    task.wait(0.5)
                    continue
                end

                local target = Travel.resolveTarget(name)
                if not target then
                    Travel.status("pulau belum ditemukan: " .. tostring(name))
                    task.wait(1)
                    continue
                end

                local character = LocalPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then
                    Travel.status("menunggu karakter")
                    task.wait(0.5)
                    continue
                end
                if (root.Position - target.Position).Magnitude <= 8 then
                    Travel.status("sudah sampai di " .. name)
                    task.wait(0.5)
                    continue
                end

                Travel.status("menuju " .. name)
                local motion, reason = Travel.beginTween(target, name)
                if not motion then
                    Travel.status("gagal memulai tween: " .. tostring(reason or "karakter belum siap"))
                    task.wait(1)
                    continue
                end
                while Travel.Enabled and Travel.Tween == motion do task.wait(0.2) end
                task.wait(0.2)
            end
            Travel.stopOwnedTween()
            Travel.Running = false
            Travel.status("nonaktif")
        end)
    end

    function Travel.stop()
        Travel.Enabled = false
        Travel.stopOwnedTween()
    end

    function Travel.moveTo(target, islandName, shouldContinue)
        if typeof(target) ~= "CFrame" or Travel.Enabled or Travel.Tween then
            return false
        end
        local function alive()
            return (not shouldContinue or shouldContinue()) and not Travel.Enabled
        end
        while alive() do
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(0.25); continue end
            if (root.Position - target.Position).Magnitude <= 8 then return true end
            local motion = Travel.beginTween(target, islandName, true)
            if not motion then return false end
            while Travel.Tween == motion and alive() do task.wait(0.1) end
            if Travel.Tween == motion then Travel.finishTween(motion, false) end
            if not alive() then return false end
            task.wait(0.2)
        end
        return false
    end

    function Travel.refreshOptions()
        local names, seen = {"None"}, {None = true}
        local function add(name)
            if type(name) == "string" and name ~= "" and not seen[name] then
                seen[name] = true
                table.insert(names, name)
            end
        end
        local islands = workspace:FindFirstChild("Islands")
        if islands then
            for _, island in ipairs(islands:GetChildren()) do add(island.Name) end
        end
        for name in pairs(Travel.FixedSpots) do add(name) end
        if game.PlaceId == 3978370137 then add("Land of the Sky") end
        table.sort(names, function(a, b)
            if a == "None" then return true end
            if b == "None" then return false end
            return a < b
        end)
        if UI.MacState.IslandTravelDropdown then
            UI.MacState.IslandTravelDropdown:ClearOptions()
            UI.MacState.IslandTravelDropdown:InsertOptions(names)
            UI.MacState.IslandTravelDropdown:UpdateSelection(Travel.Selected)
        end
    end
end

UI.MacSections.Fishing:Header({Name = "Fishing Tensen"})
UI.MacState.FishingStatus = UI.MacSections.Fishing:Label({Text = "Fishing: nonaktif"})
UI.MacToggle(UI.MacSections.Fishing, "Auto Fishing", function() return Settings.AutoFishing end,
    function(value) if value then Fishing.start() else Fishing.stop() end end)
UI.MacState.FishingBaits = UI.MacSections.Fishing:Dropdown({
    Name = "Prioritas bait",
    Search = false,
    Multi = true,
    Required = false,
    Options = FISH_BAITS,
    Default = Settings.FishingBaits,
    Callback = function(value)
        local selected = {}
        for _, bait in ipairs(FISH_BAITS) do if value[bait] then table.insert(selected, bait) end end
        Settings.FishingBaits = selected
    end,
}, "FishingBaits")
UI.MacToggle(UI.MacSections.Fishing, "Auto Buy Common Bait", function() return Settings.AutoBuyBait end,
    function(value) Settings.AutoBuyBait = value end)
UI.MacSections.Fishing:Input({
    Name = "Beli jika bait di bawah",
    Default = tostring(Settings.BaitThreshold),
    AcceptedCharacters = "Numeric",
    Callback = function(value) Settings.BaitThreshold = math.max(0, tonumber(value) or 10) end,
})
UI.MacSections.Fishing:Input({
    Name = "Jumlah beli",
    Default = tostring(Settings.BaitBuyAmount),
    AcceptedCharacters = "Numeric",
    Callback = function(value) Settings.BaitBuyAmount = math.max(1, tonumber(value) or 10) end,
})
UI.MacToggle(UI.MacSections.Fishing, "Auto Craft Bait", function() return Settings.AutoCraftBait end,
    function(value) Settings.AutoCraftBait = value end)
UI.MacSections.Fishing:Dropdown({
    Name = "Bait untuk di-craft",
    Search = false,
    Multi = true,
    Required = false,
    Options = FISH_BAITS,
    Default = Settings.CraftBaits,
    Callback = function(value)
        local selected = {}
        for _, bait in ipairs(FISH_BAITS) do if value[bait] then table.insert(selected, bait) end end
        Settings.CraftBaits = selected
    end,
}, "CraftBaits")
UI.MacSections.Fishing:Label({Text = "Fishing otomatis menuju spot Tensen yang dikenal. Craft bait perlu data ikan dan NPC Blacksmith Sen."})

local Fishing = {
    Running = false,
    SessionKey = nil,
    ActionKey = nil,
    Status = nil,
}
local FISH_BAITS = {"Common Fish Bait", "Rare Fish Bait", "Legendary Fish Bait"}
local fishRarityCache, fishRarityCheckedAt = nil, 0

function Fishing.setStatus(text)
    if UI.MacState.FishingStatus then UI.MacState.FishingStatus:UpdateName("Fishing: " .. tostring(text)) end
end

function Fishing.inventory()
    local stats = ReplicatedStorage:FindFirstChild("Stats" .. LocalPlayer.Name)
    local inv = stats and stats:FindFirstChild("Inventory")
    inv = inv and inv:FindFirstChild("Inventory")
    if not inv or not inv.Value or inv.Value == "" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(inv.Value) end)
    return ok and type(data) == "table" and data or nil
end

function Fishing.amount(data, name)
    local value = data and data[name]
    if type(value) == "table" then value = value.Amount end
    return tonumber(value) or 0
end

function Fishing.baitCount(name)
    return Fishing.amount(Fishing.inventory(), name)
end

function Fishing.selectedBait()
    local inventory = Fishing.inventory() or {}
    local wanted = {}
    for k, v in pairs(Settings.FishingBaits or {}) do
        if type(k) == "number" and type(v) == "string" then wanted[v] = true
        elseif type(k) == "string" and v then wanted[k] = true end
    end
    for _, name in ipairs(FISH_BAITS) do
        if wanted[name] and Fishing.amount(inventory, name) > 0 then return name end
    end
    for _, name in ipairs(FISH_BAITS) do if wanted[name] then return name end end
    return "Common Fish Bait"
end

function Fishing.findRod(container)
    if not container then return nil end
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") and item.Name:lower():find("rod", 1, true) then return item end
    end
    return nil
end

function Fishing.equipRod()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid then return false end
    if Fishing.findRod(character) then return true end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    local rod = Fishing.findRod(backpack)
    if rod then humanoid:EquipTool(rod); task.wait(0.5); return Fishing.findRod(character) ~= nil end
    local tools = ReplicatedStorage:FindFirstChild("Events")
    tools = tools and tools:FindFirstChild("Tools")
    if tools and tools:IsA("RemoteFunction") then
        pcall(function() tools:InvokeServer("equip", "Fishing Rod") end)
    end
    task.wait(0.75)
    return Fishing.findRod(character) ~= nil
end

function Fishing.action(action, sessionKey, actionKey, extra)
    local fishing = ReplicatedStorage:FindFirstChild("Fishing")
    local remotes = fishing and fishing:FindFirstChild("Remotes")
    local remote = remotes and remotes:FindFirstChild("Action")
    if not remote or not remote:IsA("RemoteFunction") then return nil end
    local payload = extra or {}
    payload.Action = action
    payload.SessionKey = sessionKey
    payload.ActionKey = actionKey
    local ok, result = pcall(function() return remote:InvokeServer(payload) end)
    return ok and result or nil
end

function Fishing.soundOn(root)
    if not root then return false end
    for _, name in ipairs({"Small", "Medium", "Large", "Giant"}) do
        local sound = root:FindFirstChild(name)
        if sound and sound:IsA("Sound") then return true end
    end
    return false
end

function Fishing.waterY(position, fallback)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    local hit = workspace:Raycast(position + Vector3.new(0, 120, 0), Vector3.new(0, -500, 0), params)
    if hit and hit.Material == Enum.Material.Water then return hit.Position.Y end
    return fallback
end

function Fishing.castGoal(root)
    local distance = 40
    local flatLook = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
    if flatLook.Magnitude < 0.01 then flatLook = Vector3.new(0, 0, -1) end
    flatLook = flatLook.Unit
    local point = root.Position + flatLook * distance
    point = Vector3.new(point.X, Fishing.waterY(point, root.Position.Y - 4), point.Z)
    return point
end

function Fishing.pinHook(goal)
    task.spawn(function()
        local effects = workspace:FindFirstChild("Effects")
        local hook = effects and effects:WaitForChild(LocalPlayer.Name .. "'s hook", 3)
        if not hook then return end
        pcall(function()
            if hook:IsA("BasePart") then
                hook.CFrame = CFrame.new(goal)
                local position = Instance.new("BodyPosition")
                position.MaxForce = Vector3.new(0, 2e9, 0)
                position.Position = goal
                position.Parent = hook
            end
        end)
    end)
end

function Fishing.closeSession()
    local sessionKey, actionKey = Fishing.SessionKey, Fishing.ActionKey
    if sessionKey or actionKey then
        for _, action in ipairs({"Reel", "HookReturning", "Cancel"}) do
            local result = Fishing.action(action, sessionKey, actionKey)
            if type(result) == "table" and result.ActionKey then actionKey = result.ActionKey end
            task.wait(0.08)
        end
    end
    Fishing.SessionKey, Fishing.ActionKey = nil, nil
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        for _, name in ipairs({"Small", "Medium", "Large", "Giant"}) do
            local sound = root:FindFirstChild(name)
            if sound then pcall(function() sound:Destroy() end) end
        end
    end
end

function Fishing.fishOnce()
    if not Fishing.equipRod() then Fishing.setStatus("fishing rod belum ada"); task.wait(1); return end
    local bait = Fishing.selectedBait()
    if Fishing.baitCount(bait) <= 0 then
        Fishing.setStatus("umpan habis: " .. bait)
        task.wait(2)
        return
    end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then task.wait(0.5); return end
    local goal = Fishing.castGoal(root)
    Fishing.setStatus("melempar " .. bait)
    local result = Fishing.action("Throw", nil, nil, {Goal = goal, Bait = bait})
    if type(result) ~= "table" or result.Accepted ~= true then
        Fishing.setStatus("lemparan ditolak server")
        task.wait(1)
        return
    end

    Fishing.SessionKey, Fishing.ActionKey = result.SessionKey, result.ActionKey
    Fishing.pinHook(goal)
    local landed = false
    for _ = 1, 5 do
        if not Settings.AutoFishing then break end
        local response = Fishing.action("Landed", Fishing.SessionKey, Fishing.ActionKey)
        if type(response) == "table" then
            if response.ActionKey then Fishing.ActionKey = response.ActionKey end
            if response.Accepted == true then landed = true; break end
        end
        if Fishing.soundOn(root) then landed = true; break end
        task.wait(0.2)
    end
    if not landed then Fishing.closeSession(); Fishing.setStatus("gagal mendaratkan kail"); task.wait(0.5); return end

    Fishing.setStatus("menunggu ikan")
    local started = tick()
    while Settings.AutoFishing and tick() - started < 45 and not Fishing.soundOn(root) do task.wait(0.2) end
    if not Settings.AutoFishing then Fishing.closeSession(); return end
    if not Fishing.soundOn(root) then Fishing.closeSession(); Fishing.setStatus("lemparan kedaluwarsa"); return end

    Fishing.setStatus("menarik ikan")
    local biteAt = tick()
    while Settings.AutoFishing and tick() - biteAt < 8 do task.wait(0.2) end
    local reelAt = tick()
    while Settings.AutoFishing and Fishing.soundOn(root) and tick() - reelAt < 5 do
        local response = Fishing.action("Reel", Fishing.SessionKey, Fishing.ActionKey)
        if type(response) == "table" and response.ActionKey then Fishing.ActionKey = response.ActionKey end
        task.wait(0.1)
    end
    local returning = Fishing.action("HookReturning", Fishing.SessionKey, Fishing.ActionKey)
    if type(returning) == "table" and returning.ActionKey then Fishing.ActionKey = returning.ActionKey end
    Fishing.action("Cancel", Fishing.SessionKey, Fishing.ActionKey)
    Fishing.SessionKey, Fishing.ActionKey = nil, nil
    Fishing.setStatus("siap cast berikutnya")
    task.wait(0.3)
end

function Fishing.getSpot()
    if game.PlaceId == 7465136166 then
        return CFrame.new(-6763.41016, 27.0749931, 9203.70215)
    elseif game.PlaceId == 116480749200627 then
        return CFrame.new(-15.0580778, 4.21153259, -1423.65332)
    elseif game.PlaceId == 3978370137 then
        return CFrame.new(-1343.58374, 4.12497234, -4965.4873)
    end
    return nil
end

function Fishing.buyBaitIfLow()
    if not Settings.AutoBuyBait or not Settings.AutoFishing then return end
    local count = Fishing.baitCount("Common Fish Bait")
    if count >= Settings.BaitThreshold then return end
    local buyables = workspace:FindFirstChild("BuyableItems")
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not buyables or not root then return end
    local best, bestDistance = nil, math.huge
    for _, item in ipairs(buyables:GetChildren()) do
        local shopPart = item:IsA("Model") and item:FindFirstChild("ShopPart")
        if item.Name == "Common Fish Bait" and shopPart and shopPart:IsA("BasePart") then
            local distance = (root.Position - shopPart.Position).Magnitude
            if distance < bestDistance then best, bestDistance = item, distance end
        end
    end
    if not best then return end
    local event = ReplicatedStorage:FindFirstChild("Events")
    local shop = event and event:FindFirstChild("Shop")
    if shop and shop:IsA("RemoteFunction") then
        Fishing.setStatus("membeli Common Fish Bait")
        pcall(function() shop:InvokeServer(best, math.max(1, math.floor(Settings.BaitBuyAmount))) end)
    end
end

function Fishing.rarityOf(entry)
    if type(entry) == "string" then return entry end
    if type(entry) == "table" then
        if type(entry[1]) == "string" then return entry[1] end
        return entry.Rarity or entry.rarity
    end
    return nil
end

function Fishing.fishRarities()
    if fishRarityCache and tick() - fishRarityCheckedAt < 60 then return fishRarityCache end
    fishRarityCheckedAt = tick()
    local result, scanned = {}, 0
    for _, module in ipairs(ReplicatedStorage:GetDescendants()) do
        if module:IsA("ModuleScript") and module.Name:lower():find("fish", 1, true) then
            scanned += 1
            if scanned > 40 then break end
            local ok, data = pcall(require, module)
            if ok and type(data) == "table" then
                local function walk(tbl, depth)
                    for key, value in pairs(tbl) do
                        if type(key) == "string" then
                            local rarity = Fishing.rarityOf(value)
                            if rarity == "Common" or rarity == "Rare" or rarity == "Legendary" then result[key] = rarity
                            elseif type(value) == "table" and depth < 2 then walk(value, depth + 1) end
                        elseif type(value) == "table" and depth < 2 then walk(value, depth + 1) end
                    end
                end
                walk(data, 0)
            end
        end
    end
    if next(result) then fishRarityCache = result end
    return fishRarityCache or {}
end

function Fishing.craftOne(bait)
    local rarity = bait:gsub(" Fish Bait", "")
    local inventory, rarityTable = Fishing.inventory(), Fishing.fishRarities()
    if not inventory then return false, "inventory belum siap" end
    local materials = {}
    for name, fishRarity in pairs(rarityTable) do
        if fishRarity == rarity and Fishing.amount(inventory, name) > 0 then table.insert(materials, name) end
    end
    table.sort(materials)
    if #materials == 0 then return false, "data rarity/bahan ikan belum ditemukan" end
    local extra = {}
    if rarity == "Rare" then
        local first = materials[1]
        local second
        for i = 2, #materials do if materials[i] ~= first then second = materials[i]; break end end
        if second then
            extra[first], extra[second] = "Rare Fish", "Rare Fish"
        elseif Fishing.amount(inventory, first) >= 2 then
            extra[first] = "Rare Fish"
        else
            return false, "butuh dua ikan Rare"
        end
    else
        extra[rarity .. " Fish"] = materials[1]
    end
    local remote = ReplicatedStorage:FindFirstChild("CraftingRemote")
    if not remote or not remote:IsA("RemoteFunction") then return false, "CraftingRemote tidak ditemukan" end
    local before = Fishing.baitCount(bait)
    local ok = pcall(function()
        remote:InvokeServer({BlueprintItem = bait, Method = "Craft", ExtraData = extra, Count = 1})
    end)
    if not ok then return false, "permintaan craft gagal" end
    local deadline = tick() + 3
    repeat task.wait(0.2) until Fishing.baitCount(bait) > before or tick() > deadline or not Settings.AutoCraftBait
    return Fishing.baitCount(bait) > before, Fishing.baitCount(bait) > before and "berhasil" or "server belum memberi bait"
end

function Fishing.craftIfPending()
    if not Settings.AutoCraftBait then return false end
    local inventory = Fishing.inventory()
    if not inventory then return false end
    local selected = {}
    for k, v in pairs(Settings.CraftBaits or {}) do
        if type(k) == "number" and type(v) == "string" then table.insert(selected, v)
        elseif type(k) == "string" and v then table.insert(selected, k) end
    end
    table.sort(selected)
    for _, bait in ipairs(selected) do
        if Fishing.amount(inventory, bait) < 300 then
            local rarity = bait:gsub(" Fish Bait", "")
            local canCraft = false
            for name, fishRarity in pairs(Fishing.fishRarities()) do
                if fishRarity == rarity and Fishing.amount(inventory, name) > 0 then canCraft = true; break end
            end
            if canCraft then
                local npcFolder = workspace:FindFirstChild("NPCs")
                local npc = npcFolder and npcFolder:FindFirstChild("Blacksmith Sen")
                local npcRoot = npc and (npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart"))
                if not npcRoot then Fishing.setStatus("Blacksmith Sen belum ditemukan"); return false end
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return false end
                if (root.Position - npcRoot.Position).Magnitude > 20 then
                    Fishing.setStatus("menuju Blacksmith Sen")
                    if not Travel.moveTo(CFrame.new(npcRoot.Position + npcRoot.CFrame.LookVector * 5), "Craft Bait", function()
                        return Settings.AutoFishing and Settings.AutoCraftBait and not Enabled
                    end) then return false end
                end
                local ok, message = Fishing.craftOne(bait)
                Fishing.setStatus(message .. ": " .. bait)
                task.wait(0.4)
                return ok
            end
        end
    end
    return false
end

function Fishing.start()
    Settings.AutoFishing = true
    if Fishing.Running then return end
    Fishing.Running = true
    task.spawn(function()
        while Settings.AutoFishing do
            if Enabled or UI.IslandTravel.Enabled then
                Fishing.setStatus("tunggu farm/travel selesai")
                task.wait(0.5)
            else
                pcall(Fishing.buyBaitIfLow)
                if Fishing.craftIfPending() then
                    task.wait(0.5)
                else
                    local spot = Fishing.getSpot()
                    if spot then
                        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and (root.Position - spot.Position).Magnitude > 10 then
                            Fishing.setStatus("menuju spot Tensen")
                            Travel.moveTo(spot, "Fishing", function()
                                return Settings.AutoFishing and not Enabled and not UI.IslandTravel.Enabled
                            end)
                        end
                    end
                    if Settings.AutoFishing and not Enabled and not UI.IslandTravel.Enabled then
                        if not spot then Fishing.setStatus("tempat ini tidak ada spot Tensen; berdiri dekat air") end
                        Fishing.fishOnce()
                    end
                end
            end
            task.wait(0.15)
        end
        Fishing.closeSession()
        Fishing.Running = false
        Fishing.setStatus("nonaktif")
    end)
end

function Fishing.stop()
    Settings.AutoFishing = false
    Fishing.closeSession()
end

UI.MacSections.Traveling:Header({Name = "Island Travel (Tween gaya Tensen)"})
UI.MacState.IslandTravel = UI.MacSections.Traveling:Label({Text = "Island Travel: nonaktif"})
local islandTravelOptions = {"None"}
do
    local seen = {None = true}
    local islands = workspace:FindFirstChild("Islands")
    if islands then
        for _, island in ipairs(islands:GetChildren()) do
            if not seen[island.Name] then seen[island.Name] = true; table.insert(islandTravelOptions, island.Name) end
        end
    end
    for name in pairs(UI.IslandTravel.FixedSpots) do
        if type(name) == "string" and not seen[name] then seen[name] = true; table.insert(islandTravelOptions, name) end
    end
    if game.PlaceId == 3978370137 and not seen["Land of the Sky"] then
        seen["Land of the Sky"] = true
        table.insert(islandTravelOptions, "Land of the Sky")
    end
    table.sort(islandTravelOptions, function(a, b)
        if a == "None" then return true end
        if b == "None" then return false end
        return a < b
    end)
end
UI.MacState.IslandTravelDropdown = UI.MacSections.Traveling:Dropdown({
    Name = "Select Island",
    Options = islandTravelOptions,
    Default = "None",
    Required = false,
    Callback = function(value)
        UI.IslandTravel.Selected = value or "None"
        if UI.IslandTravel.Enabled then UI.IslandTravel.stopOwnedTween() end
    end,
}, "IslandTravelDestination")
UI.MacButton(UI.MacSections.Traveling, "Refresh Island List", UI.IslandTravel.refreshOptions)
UI.MacToggle(UI.MacSections.Traveling, "Tween To Island", function() return UI.IslandTravel.Enabled end,
    function(value)
        if value then UI.IslandTravel.start() else UI.IslandTravel.stop() end
    end)
UI.MacSections.Traveling:Slider({
    Name = "Island Tween Speed",
    Minimum = 10,
    Maximum = 200,
    Default = UI.IslandTravel.Speed,
    Precision = 0,
    Callback = function(value)
        UI.IslandTravel.Speed = math.floor(value)
        if UI.IslandTravel.Enabled then UI.IslandTravel.stopOwnedTween() end
    end,
}, "IslandTravelSpeed")

UI.MacSections.Shop:Header({Name = "Shop"})
UI.MacInput(UI.MacSections.Shop, "Buka Chest di candy", ChestTriggerBox)
UI.MacToggle(UI.MacSections.Shop, "Auto Merchant", function() return Settings.AutoMerchant end,
    function(value) Settings.AutoMerchant = value end)
local function getMerchantToolOptions()
    local root = ReplicatedStorage:FindFirstChild("Tools")
    local options, seen = {}, {}
    if not root then return options end
    for _, item in ipairs(root:GetDescendants()) do
        if item:IsA("Tool") and not seen[item.Name] then
            seen[item.Name] = true
            table.insert(options, item.Name)
        end
    end
    if #options == 0 then
        for _, item in ipairs(root:GetChildren()) do
            if not item:IsA("Folder") and not seen[item.Name] then
                seen[item.Name] = true
                table.insert(options, item.Name)
            end
        end
    end
    table.sort(options)
    return options
end

local merchantDefaults = {}
for itemName in string.gmatch(Settings.MerchantItems or "", "[^,]+") do
    table.insert(merchantDefaults, Webhook.trim(itemName))
end
UI.MacState.MerchantItems = UI.MacSections.Shop:Dropdown({
    Name = "Item Merchant",
    Search = true,
    Multi = true,
    Options = getMerchantToolOptions(),
    Default = merchantDefaults,
    Callback = function(selected)
        local names = {}
        for name, enabled in pairs(selected or {}) do
            if enabled then table.insert(names, name) end
        end
        table.sort(names)
        Settings.MerchantItems = table.concat(names, ", ")
    end,
}, "MerchantItems")

UI.MacSections.Drop:Header({Name = "Auto Drop"})
UI.MacToggle(UI.MacSections.Drop, "Auto Drop", function() return Settings.AutoDrop end,
    function(value) Settings.AutoDrop = value; Drop.save() end)
UI.MacButton(UI.MacSections.Drop, "Drop sekarang", function() Drop.requestNow() end)
UI.MacState.DropRarities = UI.MacSections.Drop:Dropdown({
    Name = "Rarity yang di-drop",
    Search = false,
    Multi = true,
    Options = {"Common", "Epic", "Legendary", "Mythical", "Rare"},
    Default = Settings.DropRarities,
    Callback = function(selected)
        local ordered, selectedSet = {}, selected or {}
        for _, rarity in ipairs({"Common", "Epic", "Legendary", "Mythical", "Rare"}) do
            if selectedSet[rarity] then table.insert(ordered, rarity) end
        end
        Settings.DropRarities = ordered
        Drop.save()
    end,
}, "DropRarities")
UI.MacInput(UI.MacSections.Drop, "Cek tiap (s)", DropIntervalBox)
UI.MacSections.Drop:Label({Text = "Pilih rarity dari ReplicatedStorage.Modules.ToolDesc.Fruits."})

UI.MacSections.Server:Header({Name = "Private Server"})
UI.MacInput(UI.MacSections.Server, "Private Code", PrivateServer.CodeBox)
UI.MacToggle(UI.MacSections.Server, "Auto Join", function() return PrivateServer.Enabled end,
    function(value)
        PrivateServer.Enabled = value
        PrivateServer.Code = PrivateServer.CodeBox.Text:match("^%s*(.-)%s*$") or ""
        PrivateServer.save()
    end)
UI.MacSections.Server:Label({Text = "Auto Join digunakan saat script berjalan di main menu."})

UI.MacSections.Webhook:Header({Name = "Discord Webhook"})
UI.MacInput(UI.MacSections.Webhook, "Webhook URL", Webhook.UrlBox, "https://discord.com/api/webhooks/...")
UI.MacToggle(UI.MacSections.Webhook, "Notif item", function() return Webhook.Enabled end,
    function(value)
        Webhook.Enabled = value
        Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
        Webhook.save()
    end)
UI.MacButton(UI.MacSections.Webhook, "Test webhook", function()
    Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
    Webhook.save()
    if Webhook.valid() then
        Webhook.push(Webhook.embed("Test Webhook", "Webhook terhubung.", 3447003))
    end
end)
UI.MacToggle(UI.MacSections.Webhook, "Ringkasan 1 jam", function() return Webhook.SummaryEnabled end,
    function(value)
        Webhook.SummaryEnabled = value
        Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
        Webhook.save()
    end)
UI.MacButton(UI.MacSections.Webhook, "Kirim ringkasan", function()
    Webhook.Url = Webhook.trim(Webhook.UrlBox.Text)
    Webhook.save()
    if Webhook.valid() then Webhook.sendSummary(true) end
end)
UI.MacInput(UI.MacSections.Webhook, "Ping item langka", Webhook.RareBox, "Nama item, pisah koma")
UI.MacTabs.Farm:Select()

-- RightShift: sembunyikan / tampilkan GUI (script tetap jalan)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == GUI_TOGGLE_KEY then
        MainFrame.Visible = not MainFrame.Visible
        print("[AutoEventDoor] GUI " .. (MainFrame.Visible and "ditampilkan"
            or "disembunyikan (tekan RightShift untuk menampilkan lagi)"))
    end
end)

-- ================= Core Logic =================
local function getBuildingFolder()
    local folder = workspace
    for _, name in ipairs(BUILDING_PATH) do
        folder = folder:FindFirstChild(name)
        if not folder then return nil end
    end
    return folder
end

local function getDoorPosition(door)
    if door:IsA("BasePart") then
        return door.Position
    elseif door:IsA("Model") then
        if door.PrimaryPart then
            return door.PrimaryPart.Position
        end
        local part = door:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.Position end
    else
        -- Accessory / Folder / instance lain: ambil BasePart pertama di dalamnya
        local part = door:FindFirstChildWhichIsA("BasePart", true)
        if part then return part.Position end
    end
    return nil
end

local function getAllEventDoors()
    local building = getBuildingFolder()
    if not building then return {} end

    local doors = {}
    for index, child in ipairs(building:GetChildren()) do
        local door = child:FindFirstChild(EVENT_DOOR_CHILD_NAME)
        if door then
            if IGNORED_DOOR_INDEXES[index] or IGNORED_DOOR_NAMES[child.Name] then
                -- Door di-ignore: print sekali biar kelihatan yang mana yang ke-skip
                if not IgnoredDoorPrinted[child] then
                    IgnoredDoorPrinted[child] = true
                    print("[AutoEventDoor] Ignore door #" .. index .. " (" .. child:GetFullName() .. ")")
                end
            else
                table.insert(doors, door)
            end
        end
    end

    LastKnownDoorCount = #doors -- simpen buat progress label "Opened: x/total"
    return doors
end

-- Label singkat door buat status: "#12 (NamaBuilding)"
local function doorLabel(door)
    local building = door and door.Parent and door.Parent.Parent
    if building then
        for i, child in ipairs(building:GetChildren()) do
            if child == door.Parent then
                return "#" .. i .. " (" .. child.Name .. ")"
            end
        end
    end
    return door and door.Name or "?"
end

-- Pilih door berikutnya:
--  1) Door yang SUDAH SIAP (belum pernah dikunjungi / cooldown udah abis):
--     yang terdekat dalam SearchRadius dulu, kalau gak ada yang terdekat tanpa batas radius.
--  2) Kalau SEMUA door masih cooldown: pilih door yang cooldown-nya paling duluan abis.
--     Itu door yang paling dulu dikunjungi (= "balik ke door pertama"). Caller
--     jalan ke sana lalu nunggu sampai siap.
local function findNextEventDoor()
    local doors = getAllEventDoors()
    local originPos = RootPart.Position
    local now = tick()

    local nearestInRadius, nearestInRadiusDist = nil, math.huge
    local nearestAny, nearestAnyDist = nil, math.huge

    for _, door in ipairs(doors) do
        if now >= getDoorReadyAt(door) then
            local pos = getDoorPosition(door)
            if pos then
                local dist = (pos - originPos).Magnitude
                if dist <= Settings.SearchRadius and dist < nearestInRadiusDist then
                    nearestInRadius = door
                    nearestInRadiusDist = dist
                end
                if dist < nearestAnyDist then
                    nearestAny = door
                    nearestAnyDist = dist
                end
            end
        end
    end

    if nearestInRadius then return nearestInRadius end
    if nearestAny then return nearestAny end

    -- Semua door lagi cooldown: ambil yang paling cepat siap
    local soonest, soonestAt = nil, math.huge
    for _, door in ipairs(doors) do
        if getDoorPosition(door) then
            local readyAt = getDoorReadyAt(door)
            if readyAt < soonestAt then
                soonest = door
                soonestAt = readyAt
            end
        end
    end

    return soonest
end

-- ============ Deteksi STUN ============
-- LocalPlayer.StunFolder.Stun aktif pas karakter lagi kena stun (animasi ambil
-- candy, diculik, dll). Dipakai buat nunggu animasi selesai di ANTARA aksi
-- (mis. abis fire prompt door). TWEEN gak ikut berhenti kena stun/hit.
-- Tipe instance "Stun" belum pasti, jadi dicek fleksibel:
--   Bool -> true = stun | Number/Int -> > 0 | String -> gak kosong |
--   Folder/Configuration -> punya child | tipe lain -> ada = stun
local STUN_MAX_WAIT = 25 -- detik, batas nunggu stun (pengaman kalau deteksi salah)
local StunDebugPrinted = false

local function isStunned()
    local folder = LocalPlayer:FindFirstChild("StunFolder")
    local stun = folder and folder:FindFirstChild("Stun")
    if not stun then return false end

    if not StunDebugPrinted then
        StunDebugPrinted = true
        print("[AutoEventDoor] StunFolder.Stun ketemu, tipe: " .. stun.ClassName)
    end

    if stun:IsA("BoolValue") then return stun.Value end
    if stun:IsA("NumberValue") or stun:IsA("IntValue") then return stun.Value > 0 end
    if stun:IsA("StringValue") then return stun.Value ~= "" end
    if stun:IsA("ValueBase") then return stun.Value ~= nil end
    if stun:IsA("Folder") or stun:IsA("Configuration") then
        return #stun:GetChildren() > 0
    end
    return true
end

-- Tunggu sampai stun habis. Return: true kalau tadi sempat stun
local function waitUntilNotStunned()
    if not isStunned() then return false end

    local start = tick()
    local prev = Stat.snapshot()
    Stat.set("Stun / animasi", function()
        return string.format("menunggu karakter bisa gerak lagi (%.1fs)", tick() - start)
    end, "warn")

    while Enabled and isStunned() do
        if tick() - start >= STUN_MAX_WAIT then
            print("[AutoEventDoor] Stun lebih dari " .. STUN_MAX_WAIT .. " detik, lanjut paksa.")
            break
        end
        task.wait(0.1)
    end

    Stat.restore(prev)
    task.wait(0.15) -- jeda kecil biar kontrol karakter balik normal
    return true
end

-- ============ Trigger ProximityPrompt event door ============
-- Target: <door>.Frame.ProximityPrompt
-- (door = workspace.Islands.Spooksville.Building:GetChildren()[i].eventDoor)

local function getDoorPrompt(door)
    local frame = door and door:FindFirstChild("Frame")
    if not frame then return nil end

    local prompt = frame:FindFirstChild("ProximityPrompt")
    if prompt and prompt:IsA("ProximityPrompt") then
        return prompt
    end

    -- Jaga-jaga kalau prompt-nya ada di dalam child lain di Frame
    return frame:FindFirstChildWhichIsA("ProximityPrompt", true)
end

-- Fallback kalau executor gak punya fireproximityprompt: tap E manual
local function tapKeyE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    task.wait(0.05)
end

-- Aktifin prompt event door berulang-ulang selama `duration` detik.
-- Return: true kalau prompt ketemu & dipicu minimal sekali
local function triggerDoorPrompt(door, duration)
    local prompt = getDoorPrompt(door)
    if not prompt then
        print("[AutoEventDoor] ProximityPrompt gak ketemu di eventDoor.Frame, fallback ke tombol E.")
        local startTime = tick()
        while Enabled and (tick() - startTime) < duration do
            tapKeyE()
        end
        return false
    end

    -- Kalau lagi stun (mis. sisa animasi sebelumnya), tunggu dulu
    waitUntilNotStunned()

    local startTime = tick()
    local fired = false

    while Enabled and prompt.Parent and (tick() - startTime) < duration do
        if typeof(fireproximityprompt) == "function" then
            -- Langsung trigger prompt, gak perlu tahan E & gak peduli jarak/hold duration
            local ok = pcall(fireproximityprompt, prompt)
            fired = fired or ok
            task.wait(0.1)
        else
            -- Executor gak support: pakai API bawaan Roblox (hold sesuai HoldDuration prompt)
            local ok = pcall(function()
                prompt:InputHoldBegin()
                task.wait(math.max(prompt.HoldDuration, 0.05) + 0.05)
                prompt:InputHoldEnd()
            end)
            fired = fired or ok
            if not ok then
                tapKeyE()
            end
        end

        -- Stun mulai setelah fire = prompt sudah kena (animasi ambil candy /
        -- diculik). Berhenti spam, caller yang nunggu stun habis.
        if fired and isStunned() then
            break
        end
    end

    return fired
end

-- ====================================================================
-- NAV v2 - PATHFINDING (WASD relatif kamera / tween BodyVelocity)
-- ====================================================================

-- ============ Input (WASD relatif kamera) ============
local HeldKeys = {
    [Enum.KeyCode.W] = false,
    [Enum.KeyCode.A] = false,
    [Enum.KeyCode.S] = false,
    [Enum.KeyCode.D] = false,
}

local function setKeyHeld(keyCode, shouldHold)
    if HeldKeys[keyCode] == shouldHold then return end
    HeldKeys[keyCode] = shouldHold
    VirtualInputManager:SendKeyEvent(shouldHold, keyCode, false, game)
end

local function releaseAllMoveKeys()
    for key in pairs(HeldKeys) do
        setKeyHeld(key, false)
    end
end

local function enableMovementMode()
    -- AutoRotate dibiarkan default (true)
end

local function disableMovementMode()
    releaseAllMoveKeys()
end

-- ============ Indikator arah (visual aja) ============
-- Rangkaian beam mengikuti seluruh waypoint hingga tujuan akhir.
local IndicatorBeam
do
    local originPart = Instance.new("Part")
    originPart.Name = "AutoEventDoorIndicatorOrigin"
    originPart.Size = Vector3.new(0.2, 0.2, 0.2)
    originPart.Transparency = 1
    originPart.CanCollide = false
    originPart.CanQuery = false
    originPart.CanTouch = false
    originPart.Anchored = true
    originPart.Parent = workspace

    RunService.Heartbeat:Connect(function()
        if RootPart and RootPart.Parent then
            originPart.CFrame = RootPart.CFrame
        end
    end)

    local originAttachment = Instance.new("Attachment")
    originAttachment.Parent = originPart

    local endpoint = Instance.new("Part")
    endpoint.Name = "AutoEventDoorIndicatorEndpoint"
    endpoint.Shape = Enum.PartType.Ball
    endpoint.Size = Vector3.new(0.38, 0.38, 0.38)
    endpoint.Material = Enum.Material.Neon
    endpoint.Color = Color3.fromRGB(255, 194, 105)
    endpoint.Transparency = 1
    endpoint.CastShadow = false
    endpoint.Anchored = true
    endpoint.CanCollide = false
    endpoint.CanQuery = false
    endpoint.CanTouch = false
    endpoint.Parent = workspace

    local endpointLight = Instance.new("PointLight")
    endpointLight.Color = endpoint.Color
    endpointLight.Brightness = 0.55
    endpointLight.Range = 5
    endpointLight.Enabled = false
    endpointLight.Parent = endpoint

    IndicatorBeam = {
        originPart = originPart,
        originAttachment = originAttachment,
        endpoint = endpoint,
        endpointLight = endpointLight,
        segments = {},
    }
end

local function createIndicatorSegment(index)
    local node = Instance.new("Part")
    node.Name = "AutoEventDoorIndicatorNode"
    node.Size = Vector3.new(0.2, 0.2, 0.2)
    node.Transparency = 1
    node.CanCollide = false
    node.CanQuery = false
    node.CanTouch = false
    node.Anchored = true
    node.Parent = workspace

    local attachment = Instance.new("Attachment")
    attachment.Parent = node

    local beam = Instance.new("Beam")
    beam.Width0 = 0.13
    beam.Width1 = 0.045
    beam.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 205, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 174, 92)),
    })
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.62),
        NumberSequenceKeypoint.new(0.72, 0.38),
        NumberSequenceKeypoint.new(1, 0.12),
    })
    beam.LightEmission = 0.25
    beam.LightInfluence = 0
    beam.FaceCamera = true
    beam.Enabled = false
    beam.Parent = IndicatorBeam.originPart

    local segment = {node = node, attachment = attachment, beam = beam}
    IndicatorBeam.segments[index] = segment
    return segment
end

local function showDirectionPath(points)
    local count = #points
    for index = 1, count do
        local segment = IndicatorBeam.segments[index] or createIndicatorSegment(index)
        segment.node.Position = points[index]
        segment.beam.Attachment0 = index == 1
            and IndicatorBeam.originAttachment
            or IndicatorBeam.segments[index - 1].attachment
        segment.beam.Attachment1 = segment.attachment
        segment.beam.Enabled = true
    end

    for index = count + 1, #IndicatorBeam.segments do
        IndicatorBeam.segments[index].beam.Enabled = false
    end

    if count > 0 then
        IndicatorBeam.endpoint.Position = points[count]
        IndicatorBeam.endpoint.Transparency = 0.12
        IndicatorBeam.endpointLight.Enabled = true
    end
end

local function hideDirectionIndicator()
    for _, segment in ipairs(IndicatorBeam.segments) do
        segment.beam.Enabled = false
    end
    IndicatorBeam.endpoint.Transparency = 1
    IndicatorBeam.endpointLight.Enabled = false
end

-- ============ Geppo / Sky Walk (dipanggil dari tween & mainLoop) ============
fireGeppoOnce = function()
    pcall(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local statsFolder = ReplicatedStorage:FindFirstChild("Stats" .. LocalPlayer.Name)
        local stats = statsFolder and statsFolder:FindFirstChild("Stats")
        local skills = statsFolder and statsFolder:FindFirstChild("Skills")
        local events = ReplicatedStorage:FindFirstChild("Events")
        local skill = events and events:FindFirstChild("Skill")
        if not skill then return end

        local cf = CFrame.lookAt(root.Position, root.Position + root.CFrame.LookVector + Vector3.new(0, 5, 0))
        local style = stats and stats:FindFirstChild("FightingStyle") and stats.FightingStyle.Value

        if style == "Rokushiki" then
            skill:InvokeServer("Geppo", {char = char, cf = cf})
        elseif style == "BlackLeg" then
            skill:InvokeServer("Sky Walk", {char = char, cf = cf})
        elseif style == "Kamishiki" then
            skill:InvokeServer("KamishikiGeppo", {char = char, cf = cf})
        elseif skills and skills:FindFirstChild("skyWalk") and skills.skyWalk.Value == true then
            skill:InvokeServer("Sky Walk2", {char = char, cf = cf})
        end
    end)
end

-- ============ NAV ============
local Nav = {
    -- path
    Variants = {},          -- diisi di bawah (urutan percobaan AgentRadius)
    MaxAttempts = 4,        -- hitung ulang path dari posisi sekarang sampai sekian kali
    MinGap = 6,             -- waypoint lebih rapat dari ini dibuang (kecuali belokan/lompat)
    TurnAngle = 35,         -- derajat; belokan setajam ini wajib dipertahankan
    -- arrival
    ReachFlat = 4.5,        -- jarak datar waypoint tengah dianggap kena (mode WASD)
    ReachFinal = 3,         -- jarak datar waypoint terakhir (mode WASD)
    PointArrive = 4,        -- target non-pintu (Witch/Merchant): jarak datar dianggap sampai
    DoorStandOffset = 5,    -- titik berdiri di depan/belakang pintu (stud)
    -- mode WASD
    SegTimeout = 8,         -- detik maksimal per waypoint
    StuckInterval = 0.6,
    StuckDist = 1.0,
    MaxStrikes = 3,
    -- roof escape
    MinGroundY = 3,         -- permukaan di bawah ini dianggap air/bukan tujuan
    MaxExitPaths = 8,       -- maksimal kandidat titik keluar yang di-path
    ExitBudget = 3.5,       -- detik maksimal buat nyari titik keluar (jangan diem lama)
    RoofCheckHeight = 40,   -- atap lebih tinggi dari ini dianggap bukan atap
    RoofRays = 4,           -- dari 5 sinar ke atas, minimal sekian yang kena baru dianggap ketutup atap
    -- tween
    TweenStop = 2.5,
    TweenReachMid = 3.5,
    GroundFollow = true,
    GroundGain = 12,
    ProgressInterval = 0.8,
    MinProgress = 1.5,
    NearFlat = 4,
    MaxStuckChecks = 3,     -- cek progress berturut-turut tanpa kemajuan = tween nyerah (path dihitung ulang)
    -- pemulihan posisi buntu / terkurung
    MaxRecoveries = 2,      -- berapa kali geser/lompat per goTo kalau path gagal gara-gara posisi kita
    RelocateDist = 14,      -- jarak maksimal cari ruang terbuka (stud)
    HopDist = 14,           -- jarak lompat keluar (stud)
    HopClearY = 9,          -- tinggi sinar cek "bebas di atas rintangan" (dari pusat badan)
    HopUpSpeed = 40,
    HopUpTime = 0.45,
    HopFwdSpeed = 16,
    HopFwdTime = 0.7,
    StreakHop = 3,          -- door gagal berturut-turut sebanyak ini -> lompat keluar
    RespawnStreak = 6,      -- ...sebanyak ini -> respawn (kalau Settings.StuckRespawn ON)
    failStreak = 0,
    lastStatusName = "",    -- hasil PathStatus terakhir (buat diagnosa & keputusan pemulihan)
}

function Nav.agent(radius, height)
    return {
        AgentRadius = radius,
        AgentHeight = height or 5,
        AgentCanJump = true,
        AgentJumpHeight = 7,
        AgentMaxSlope = 45,
        WaypointSpacing = 8,
    }
end

Nav.Variants = { Nav.agent(3), Nav.agent(2), Nav.agent(1.5), Nav.agent(1, 4) }

-- ---------- util raycast ----------
function Nav.worldIgnore()
    local list = {}
    for _, name in ipairs({"PlayerCharacters", "NPCs", "Effects"}) do
        local folder = workspace:FindFirstChild(name)
        if folder then table.insert(list, folder) end
    end
    return list
end

function Nav.rayParams(extra)
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Exclude
    p.IgnoreWater = true
    pcall(function() p.RespectCanCollide = true end)
    local list = { LocalPlayer.Character }
    if extra then
        for _, v in ipairs(extra) do table.insert(list, v) end
    end
    p.FilterDescendantsInstances = list
    return p
end

-- Y permukaan di bawah `pos`. Model ber-Humanoid (monster/pemain) & part script ini diabaikan.
function Nav.groundY(pos, length, params)
    length = length or 80
    params = params or Nav.rayParams(Nav.worldIgnore())
    local ignore = params.FilterDescendantsInstances
    for _ = 1, 5 do
        params.FilterDescendantsInstances = ignore
        local result = workspace:Raycast(pos, Vector3.new(0, -length, 0), params)
        if not result then return nil end

        local inst = result.Instance
        local model = inst:FindFirstAncestorOfClass("Model")
        if string.sub(inst.Name, 1, 13) == "AutoEventDoor" then
            table.insert(ignore, inst)
        elseif model and model:FindFirstChildOfClass("Humanoid") then
            table.insert(ignore, model)
        else
            return result.Position.Y
        end
    end
    return nil
end

function Nav.standingHeight(hum, root)
    if hum.RigType == Enum.HumanoidRigType.R6 then return 3 end
    return hum.HipHeight + root.Size.Y / 2
end

-- Ketutup atap beneran = hampir semua dari 5 sinar ke atas kena sesuatu yang dekat
-- (kanopi / teras sebagian & objek tinggi di langit gak dihitung).
function Nav.isCovered(pos)
    local params = Nav.rayParams(Nav.worldIgnore())
    local up = Vector3.new(0, Nav.RoofCheckHeight, 0)
    local hits = 0
    for _, o in ipairs({
        Vector3.zero, Vector3.new(4, 0, 0), Vector3.new(-4, 0, 0),
        Vector3.new(0, 0, 4), Vector3.new(0, 0, -4),
    }) do
        if workspace:Raycast(pos + o, up, params) then hits = hits + 1 end
    end
    return hits >= Nav.RoofRays
end

-- Garis pandang ke pintu: kosong, atau yang kena memang bagian pintu itu sendiri
function Nav.canSee(target, targetPos)
    local origin = RootPart.Position + Vector3.new(0, 1.5, 0)
    local r = workspace:Raycast(origin, targetPos - origin, Nav.rayParams(Nav.worldIgnore()))
    return r == nil or r.Instance:IsDescendantOf(target)
end

function Nav.jump()
    pcall(function() Humanoid.Jump = true end)
end

-- ---------- path ----------
-- Return: waypoints, path, partial   (nil kalau semua varian gagal)
-- Nav.lastStatusName = PathStatus varian terakhir yang dicoba (Success / NoPath /
-- FailStartNotEmpty / FailFinishNotEmpty / ClosestNoPath / ClosestOutOfRange).
-- allowPartial: kalau gak ada yang Success, pakai path "terdekat" (ClosestNoPath /
-- ClosestOutOfRange) -> partial = true.
function Nav.computePath(fromPos, toPos, maxVariants, allowPartial)
    local n = math.min(maxVariants or #Nav.Variants, #Nav.Variants)
    local partialWps, partialPath
    Nav.lastStatusName = "Error"

    for i = 1, n do
        local path = PathfindingService:CreatePath(Nav.Variants[i])
        local ok = pcall(function()
            path:ComputeAsync(fromPos, toPos)
        end)
        if ok then
            local status = path.Status
            Nav.lastStatusName = status.Name
            if status == Enum.PathStatus.Success then
                return path:GetWaypoints(), path, false
            end
            if allowPartial and not partialWps
                and (status == Enum.PathStatus.ClosestNoPath or status == Enum.PathStatus.ClosestOutOfRange) then
                local wps = path:GetWaypoints()
                if #wps >= 2 then partialWps, partialPath = wps, path end
            end
        end
    end

    if partialWps then return partialWps, partialPath, true end
    return nil, nil, false
end

-- Catat hitung path yang lambat (>= 120 ms) buat bantu cari sumber freeze
Nav.computePathRaw = Nav.computePath
function Nav.computePath(...)
    local t0 = tick()
    local a, b, c = Nav.computePathRaw(...)
    local ms = (tick() - t0) * 1000
    if ms >= 120 then
        print(string.format("[AutoEventDoor] LAMBAT: hitung path %.0f ms (%s)", ms, tostring(Nav.lastStatusName)))
    end
    return a, b, c
end

function Nav.pathLength(waypoints)
    local len, prev = 0, RootPart.Position
    for _, w in ipairs(waypoints) do
        len = len + (w.Position - prev).Magnitude
        prev = w.Position
    end
    return len
end

-- Buang waypoint yang terlalu rapat, tapi belokan tajam & titik lompat selalu dipertahankan
function Nav.filter(waypoints)
    local out = {}
    local last = RootPart.Position
    local lastDir = nil

    for i, wp in ipairs(waypoints) do
        local gap = (wp.Position - last).Magnitude
        local isLast = (i == #waypoints)
        local isJump = wp.Action == Enum.PathWaypointAction.Jump

        local sharp = false
        if lastDir and gap > 0.1 then
            local d = (wp.Position - last).Unit
            local angle = math.deg(math.acos(math.clamp(lastDir:Dot(d), -1, 1)))
            sharp = angle >= Nav.TurnAngle
        end

        if isLast or isJump or sharp or gap >= Nav.MinGap then
            if gap > 0.1 then lastDir = (wp.Position - last).Unit end
            table.insert(out, wp)
            last = wp.Position
        end
    end
    return out
end

-- Titik berdiri di depan & belakang pintu (pivot +/- LookVector * offset), di-snap ke lantai
function Nav.doorGoals(door)
    local pivot
    pcall(function() pivot = door:GetPivot() end)
    if not pivot then return {} end

    local look = Vector3.new(pivot.LookVector.X, 0, pivot.LookVector.Z)
    if look.Magnitude < 0.1 then return {} end
    look = look.Unit

    local goals = {}
    for _, sign in ipairs({1, -1}) do
        local p = pivot.Position + look * (Nav.DoorStandOffset * sign)
        local gy = Nav.groundY(p + Vector3.new(0, 2, 0), 30)
        table.insert(goals, gy and Vector3.new(p.X, gy, p.Z) or p)
    end
    return goals
end

-- Dari beberapa kandidat tujuan, pilih yang path-nya ada & wajar.
-- Hemat CPU: kandidat dicoba dari yang terdekat (garis lurus); kalau path pertama sudah wajar
-- (gak berputar jauh) sisi satunya TIDAK dihitung. Cuma kalau path pertama gagal / berputar jauh
-- sisi lain ikut dihitung dan yang terpendek dipakai. (Tiap ComputeAsync bisa bikin hitch.)
-- Return: goal, waypoints, path
function Nav.pickGoal(goals)
    local origin = RootPart.Position
    local sorted = {}
    for _, g in ipairs(goals) do table.insert(sorted, g) end
    table.sort(sorted, function(a, b)
        return (a - origin).Magnitude < (b - origin).Magnitude
    end)

    local best, bestWps, bestPath, bestLen
    for _, g in ipairs(sorted) do
        local wps, path = Nav.computePath(origin, g, 2)
        if wps then
            local len = Nav.pathLength(wps)
            if not bestLen or len < bestLen then
                best, bestWps, bestPath, bestLen = g, wps, path, len
            end
            if len <= (g - origin).Magnitude * 1.5 + 10 then break end
        end
    end
    return best, bestWps, bestPath
end

-- ---------- driver 1: WASD ----------
-- Tombol relatif ke kamera (kamera cuma dibaca, tidak pernah diputar)
function Nav.steer(targetPos)
    local camera = workspace.CurrentCamera
    if not camera then
        releaseAllMoveKeys()
        return
    end

    local o = RootPart.Position
    local flat = Vector3.new(targetPos.X - o.X, 0, targetPos.Z - o.Z)
    if flat.Magnitude < 0.1 then
        releaseAllMoveKeys()
        return
    end

    local obj = camera.CFrame:VectorToObjectSpace(flat.Unit)
    setKeyHeld(Enum.KeyCode.W, obj.Z < -0.15)
    setKeyHeld(Enum.KeyCode.S, obj.Z > 0.15)
    setKeyHeld(Enum.KeyCode.D, obj.X > 0.15)
    setKeyHeld(Enum.KeyCode.A, obj.X < -0.15)
end

function Nav.unstick(strike)
    releaseAllMoveKeys()
    Nav.jump()
    task.wait(0.25)
    if strike <= 1 then return end

    setKeyHeld(Enum.KeyCode.S, true)
    task.wait(0.4)
    setKeyHeld(Enum.KeyCode.S, false)

    local key = (strike % 2 == 0) and Enum.KeyCode.D or Enum.KeyCode.A
    setKeyHeld(key, true)
    task.wait(0.5)
    setKeyHeld(key, false)

    Nav.jump()
    task.wait(0.2)
end

-- Return: "Arrived" | "Finished" | "Blocked" | "Stuck" | "Stopped"
function Nav.followWalk(waypoints, isDone, state)
    local i, n = 1, #waypoints
    local indicatorPoints = {}
    for _, waypoint in ipairs(waypoints) do
        table.insert(indicatorPoints, waypoint.Position)
    end
    showDirectionPath(indicatorPoints)
    local segStart = tick()
    local lastPos, lastCheck = RootPart.Position, tick()
    local strikes = 0
    local jumped = false

    local function finish(status)
        releaseAllMoveKeys()
        hideDirectionIndicator()
        return status
    end

    while Enabled do
        if isDone() then return finish("Arrived") end
        if state and state.blocked then return finish("Blocked") end
        if i > n then return finish("Finished") end

        -- Stun: lepas tombol, tunggu, jangan dihitung sebagai macet
        if isStunned() then
            releaseAllMoveKeys()
            local t0 = tick()
            waitUntilNotStunned()
            segStart = segStart + (tick() - t0)
            lastPos, lastCheck, strikes = RootPart.Position, tick(), 0
            continue
        end

        local wp = waypoints[i]
        local pos = RootPart.Position
        local flatDist = Vector3.new(wp.Position.X - pos.X, 0, wp.Position.Z - pos.Z).Magnitude
        local reach = (i == n) and Nav.ReachFinal or Nav.ReachFlat

        -- Waypoint bertanda Jump: lompat sekali begitu sudah dekat
        if wp.Action == Enum.PathWaypointAction.Jump and not jumped and flatDist <= 8 then
            jumped = true
            Nav.jump()
        end

        -- Kena: langsung lanjut ke waypoint berikutnya TANPA lepas tombol (gak ada patah-patah)
        if flatDist <= reach then
            i = i + 1
            segStart, jumped, strikes = tick(), false, 0
            lastPos, lastCheck = RootPart.Position, tick()
            continue
        end

        if (tick() - segStart) > Nav.SegTimeout then
            return finish("Stuck")
        end

        RunService.Heartbeat:Wait()
        Nav.steer(wp.Position)

        if tick() - lastCheck >= Nav.StuckInterval then
            if (RootPart.Position - lastPos).Magnitude < Nav.StuckDist then
                strikes = strikes + 1
                if strikes >= Nav.MaxStrikes then return finish("Stuck") end
                Nav.unstick(strikes)
            else
                strikes = 0
            end
            lastPos, lastCheck = RootPart.Position, tick()
        end
    end

    return finish("Stopped")
end

-- ---------- driver 2: tween fisika (BodyVelocity + BodyGyro) ----------
-- Satu BodyVelocity untuk SELURUH rangkaian titik (gak dibuat-hancurin tiap waypoint),
-- jadi jalannya mulus. Horizontal ke titik aktif, tinggi ngikutin lantai di bawah
-- (kecuali waypoint-nya lebih tinggi = tangga/ledge). TANPA noclip: kalau gak ada
-- progress beberapa kali berturut-turut, tween berhenti dengan reason "stuck" dan
-- goTo menghitung ulang path dari posisi sekarang. Selama stun, watchdog dijeda.
-- Dua gaya gerak (Settings.TweenWalk):
--  * JALAN (default): Humanoid TIDAK di-PlatformStand. Tiap frame Humanoid:Move(arah) dipanggil
--    (animasi jalan/lari ikut main), badan DIHADAPKAN ke arah jalan lewat RenderStep (menimpa
--    shiftlock / kamera yang memaksa badan menghadap kamera), dan BodyVelocity
--    cuma mengatur kecepatan HORIZONTAL (sumbu Y bebas) -> Humanoid sendiri yang menjaga karakter
--    tetap di tanah / naik undakan kecil / jatuh. Waypoint bertanda Jump -> loncat.
--  * MELAYANG (TweenWalk OFF): gaya lama, PlatformStand + BodyGyro + tinggi ngikutin lantai.
-- jumps (opsional): jumps[i] = true kalau waypoint ke-i bertanda Jump.
-- Return: reachedFinal(bool), reason(string)
function Nav.tweenAlong(points, timeout, isDone, state, jumps)
    local root, hum = RootPart, Humanoid
    if not root or not root.Parent or not hum or not hum.Parent or #points == 0 then
        return false, "invalid"
    end

    timeout = timeout or 12
    local walk = Settings.TweenWalk == true
    local standH = Nav.standingHeight(hum, root)
    local up = Vector3.new(0, standH, 0)
    local n = #points
    local indicatorPoints = {}
    for _, point in ipairs(points) do
        table.insert(indicatorPoints, point + up)
    end
    showDirectionPath(indicatorPoints)
    local idx = 1
    local groundParams = (not walk) and Nav.rayParams(Nav.worldIgnore()) or nil
    local jumpedIdx = 0
    local prevAutoJump = nil
    local faceDir = Vector3.zero -- arah hadap badan (mode jalan)


    local gyro = nil
    if not walk then
        gyro = Instance.new("BodyGyro")
        gyro.Name = "EvDoorTweenGyro"
        gyro.P = 200000
        gyro.D = 1000
        gyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        gyro.CFrame = root.CFrame
        gyro.Parent = root
    end

    local vel = Instance.new("BodyVelocity")
    vel.Name = "EvDoorTweenVel"
    vel.MaxForce = walk and Vector3.new(1e9, 0, 1e9) or Vector3.new(1e9, 1e9, 1e9)
    vel.Velocity = Vector3.zero
    vel.Parent = root

    if walk then
        pcall(function()
            prevAutoJump = hum.AutoJumpEnabled
            hum.AutoJumpEnabled = true -- loncat otomatis kalau mentok undakan
        end)

        -- Hadapkan badan ke arah jalan. Kamera / shiftlock game memaksa badan menghadap arah KAMERA
        -- tiap frame (RenderStepped, prioritas Camera), jadi tanpa ini karakter berjalan mundur atau
        -- menyamping setiap arah jalan beda dari arah kamera. Rotasi ditimpa SESUDAH kamera
        -- (prioritas Camera + 1); posisi tidak disentuh.
        pcall(function() RunService:UnbindFromRenderStep("EvDoorFace") end)
        pcall(function()
            RunService:BindToRenderStep("EvDoorFace", Enum.RenderPriority.Camera.Value + 1, function()
                if faceDir.Magnitude > 0.01 and root.Parent then
                    root.CFrame = CFrame.lookAt(root.Position, root.Position + faceDir)
                end
            end)
        end)
    else
        hum.PlatformStand = true
        hum.AutoRotate = false
    end

    local startTime = tick()
    local reached, reason = false, "timeout"

    local lastDist = (points[1] + up - root.Position).Magnitude
    local lastCheck = tick()
    local stuckChecks = 0

    local tweening = true
    if Settings.GeppoPass then
        task.spawn(function()
            while tweening and Enabled do
                fireGeppoOnce()
                task.wait(math.random(5, 7) / 10)
            end
        end)
    end

    while Enabled and (tick() - startTime) < timeout do
        if not root.Parent then reason = "dead" break end
        if state and state.blocked then reason = "blocked" break end
        if isDone and isDone() then
            reached, reason = true, "done"
            break
        end

        local pos = root.Position
        local isFinal = (idx == n)
        local goal = points[idx] + up
        local delta = goal - pos
        local flat = Vector3.new(delta.X, 0, delta.Z)
        local dist = delta.Magnitude

        if isFinal then
            if dist <= Nav.TweenStop or (flat.Magnitude <= Nav.TweenStop and math.abs(delta.Y) <= 4) then
                reached, reason = true, "final"
                break
            end
        elseif flat.Magnitude <= Nav.TweenReachMid then
            -- waypoint tengah kena: ganti target tanpa berhenti
            idx = idx + 1
            local g = points[idx] + up
            lastDist = (g - root.Position).Magnitude
            lastCheck = tick()
            stuckChecks = 0
                    continue
        end

        local dt = RunService.Heartbeat:Wait()
        local maxSpeed = math.max(Settings.TweenSpeed, 1)

        if walk then
            local flatDist = flat.Magnitude
            local hSpeed = maxSpeed
            if isFinal then
                hSpeed = math.min(maxSpeed, flatDist / math.max(dt, 1 / 60))
            end
            local dir = Vector3.zero
            if flatDist > 0.05 then dir = flat.Unit end
            if dir.Magnitude > 0 then faceDir = dir end

            -- Waypoint bertanda Jump: loncat sekali begitu sudah dekat
            if jumps and jumps[idx] and jumpedIdx ~= idx and flatDist <= 8 then
                jumpedIdx = idx
                Nav.jump()
            end

            vel.Velocity = dir * hSpeed -- sumbu Y diabaikan (MaxForce.Y = 0)
            pcall(function() hum:Move(dir, false) end)
        elseif Nav.GroundFollow then
            local flatDist = flat.Magnitude
            local hSpeed = maxSpeed
            if isFinal then
                hSpeed = math.min(maxSpeed, flatDist / math.max(dt, 1 / 60))
            end
            local hVel = Vector3.zero
            if flatDist > 0.05 then hVel = flat.Unit * hSpeed end

            local curPos = root.Position
            local gY = Nav.groundY(curPos, 80, groundParams)
            local desiredY = gY and (gY + standH) or goal.Y
            -- Waypoint lebih tinggi dari lantai di bawah (tangga/ledge): naik ke tingginya
            if (goal.Y - standH) > (gY or -math.huge) + 1 and flatDist < 8 then
                desiredY = goal.Y
            end
            local vy = math.clamp((desiredY - curPos.Y) * Nav.GroundGain, -maxSpeed, maxSpeed)
            vel.Velocity = Vector3.new(hVel.X, vy, hVel.Z)
        else
            -- GroundFollow dimatiin: lurus 3D ke titik aktif
            if dist > 0.05 then
                local speed = maxSpeed
                if isFinal then
                    speed = math.min(maxSpeed, dist / math.max(dt, 1 / 60))
                end
                vel.Velocity = delta.Unit * speed
            else
                vel.Velocity = Vector3.zero
            end
        end

        if gyro and flat.Magnitude > 0.5 then
            gyro.CFrame = CFrame.lookAt(pos, pos + flat)
        end

        -- Watchdog progress ke titik aktif (dijeda selama stun)
        if isStunned() then
            lastCheck, lastDist, stuckChecks = tick(), dist, 0
        elseif tick() - lastCheck >= Nav.ProgressInterval then
            local progress = lastDist - dist
            if progress < Nav.MinProgress and flat.Magnitude > Nav.NearFlat then
                stuckChecks = stuckChecks + 1
                if walk then Nav.jump() end -- mentok undakan / rintangan rendah: coba loncat dulu
                if stuckChecks >= Nav.MaxStuckChecks then
                    reason = "stuck"
                    break
                end
            else
                stuckChecks = 0
            end
            lastDist, lastCheck = dist, tick()
        end
    end

    tweening = false
    if walk then pcall(function() RunService:UnbindFromRenderStep("EvDoorFace") end) end
    pcall(function() vel:Destroy() end)
    if gyro then pcall(function() gyro:Destroy() end) end
    pcall(function()
        if walk then
            -- berhenti horizontal saja; sumbu Y biar fisika (jatuh / napak) yang urus
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            hum:Move(Vector3.zero, false)
            if prevAutoJump ~= nil then hum.AutoJumpEnabled = prevAutoJump end
        else
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            hum.PlatformStand = false
            hum.AutoRotate = true
        end
    end)
    hideDirectionIndicator()

    return reached, reason
end

-- Return: "Arrived" | "Finished" | "Blocked" | "Stuck" | "Stopped"
function Nav.followTween(waypoints, isDone, state)
    local points, jumps = {}, {}
    for i, w in ipairs(waypoints) do
        table.insert(points, w.Position)
        if w.Action == Enum.PathWaypointAction.Jump then jumps[i] = true end
    end
    local timeout = Nav.pathLength(waypoints) / math.max(Settings.TweenSpeed, 1) * 2.5 + 10

    local reached, reason = Nav.tweenAlong(points, timeout, isDone, state, jumps)

    if isDone() then return "Arrived" end
    if reached then return "Finished" end
    if not Enabled then return "Stopped" end
    if reason == "blocked" then return "Blocked" end
    return "Stuck"
end

function Nav.follow(waypoints, isDone, state)
    if Settings.TweenMode then
        return Nav.followTween(waypoints, isDone, state)
    end
    return Nav.followWalk(waypoints, isDone, state)
end

-- ---------- keluar dari bawah atap ----------
-- Sampling cincin (radius 10..160, tiap 22.5 derajat). Tiap titik di-raycast dari
-- 300 stud di atas ke bawah: yang kena permukaan datar & di atas air = kandidat titik
-- terbuka. Kandidat terdekat yang path-nya ada dipakai sebagai jalan keluar.
-- Return: titik keluar, waypoints, path   (nil kalau gak ada)
function Nav.findExit()
    local origin = RootPart.Position
    local params = Nav.rayParams(Nav.worldIgnore())
    local tried = 0
    local t0 = tick()

    for radius = 10, 160, 10 do
        for k = 0, 15 do
            local a = k * math.pi / 8
            local sample = origin + Vector3.new(math.cos(a) * radius, 0, math.sin(a) * radius)
            local hit = workspace:Raycast(sample + Vector3.new(0, 300, 0), Vector3.new(0, -500, 0), params)

            if hit and hit.Position.Y > Nav.MinGroundY and hit.Normal.Y > 0.6 then
                if (tick() - t0) > Nav.ExitBudget then return nil end
                tried = tried + 1
                local wps, path = Nav.computePath(origin, hit.Position + Vector3.new(0, 3, 0), 1)
                if wps then return hit.Position, wps, path end
                if tried >= Nav.MaxExitPaths then return nil end
            end
        end
    end
    return nil
end

function Nav.escapeRoof()
    local prev = Stat.snapshot()
    Stat.set("Keluar dari bawah atap", "mencari titik terbuka...", "warn")

    local exitPos, wps, path = Nav.findExit()
    if not exitPos then
        print("[AutoEventDoor] Gak nemu jalan keluar dari bawah atap.")
        Stat.restore(prev)
        return false
    end
    Stat.set("Keluar dari bawah atap", Stat.towards(function() return exitPos end, "titik terbuka"), "warn")

    local function done()
        local d = RootPart.Position - exitPos
        return Vector3.new(d.X, 0, d.Z).Magnitude <= Nav.PointArrive
    end

    local state = { blocked = false }
    local conn = path and path.Blocked:Connect(function() state.blocked = true end)
    local status = Nav.follow(Nav.filter(wps), done, state)
    if conn then conn:Disconnect() end

    Stat.restore(prev)
    return status == "Arrived" or status == "Finished"
end

-- ---------- pemulihan: posisi buntu / terkurung ----------
-- Jarak bebas horizontal dari origin sepanjang dir (maks maxDist), diukur pada ketinggian
-- dy relatif pusat badan.
function Nav.freeDistance(origin, dir, maxDist, dy, params)
    local from = origin + Vector3.new(0, dy, 0)
    local r = workspace:Raycast(from, dir * maxDist, params)
    if r then return (r.Position - from).Magnitude end
    return maxDist
end

function Nav.flatDir(from, to)
    local d = Vector3.new(to.X - from.X, 0, to.Z - from.Z)
    if d.Magnitude > 0.1 then return d.Unit end
    return Vector3.zero
end

-- Pindah ke ruang terbuka terdekat TANPA pathfinding: cari arah yang bebas di tinggi kaki &
-- pinggang (condong ke arah tujuan), lalu jalan lurus ke sana.
-- Return: true kalau posisi bergeser >= 3 stud
function Nav.relocate(goalPos)
    local root, hum = RootPart, Humanoid
    if not root or not root.Parent or not hum or not hum.Parent then return false end

    local origin = root.Position
    local standH = Nav.standingHeight(hum, root)
    local params = Nav.rayParams(Nav.worldIgnore())
    local goalDir = Nav.flatDir(origin, goalPos)

    local best, bestScore, bestFree
    for k = 0, 15 do
        local a = k * math.pi / 8
        local dir = Vector3.new(math.cos(a), 0, math.sin(a))
        local free = math.min(
            Nav.freeDistance(origin, dir, Nav.RelocateDist, -1.5, params),
            Nav.freeDistance(origin, dir, Nav.RelocateDist, 1.5, params))
        if free >= 4 then
            local score = free + 5 * dir:Dot(goalDir)
            if not bestScore or score > bestScore then
                best, bestScore, bestFree = dir, score, free
            end
        end
    end
    if not best then return false end

    local target = origin + best * (bestFree - 1.5)
    local gy = Nav.groundY(target + Vector3.new(0, 4, 0), 30)
    if not gy or gy < Nav.MinGroundY or math.abs(gy - (origin.Y - standH)) > 10 then
        return false
    end
    local point = Vector3.new(target.X, gy, target.Z)

    local function done()
        local d = RootPart.Position - point
        return Vector3.new(d.X, 0, d.Z).Magnitude <= Nav.PointArrive - 1
    end
    Nav.follow({ { Position = point } }, done)

    return (RootPart.Position - origin).Magnitude >= 3
end

-- Lompat keluar dari kurungan (peti / tong / labu / sudut teras): naik ~18 stud, lalu maju
-- ~12 stud ke arah yang paling lapang DI ATAS rintangan dan mendaratnya di tanah yang rata
-- (bukan atap / jurang / air). Murni BodyVelocity, tanpa noclip.
-- Return: true kalau posisi bergeser >= 3 stud
function Nav.hopOut(goalPos)
    local root, hum = RootPart, Humanoid
    if not root or not root.Parent or not hum or not hum.Parent then return false end

    local origin = root.Position
    local standH = Nav.standingHeight(hum, root)
    local groundNow = Nav.groundY(origin, 40) or (origin.Y - standH)
    local params = Nav.rayParams(Nav.worldIgnore())
    local goalDir = goalPos and Nav.flatDir(origin, goalPos) or Vector3.zero

    local best, bestScore
    for k = 0, 15 do
        local a = k * math.pi / 8
        local dir = Vector3.new(math.cos(a), 0, math.sin(a))
        local land = origin + dir * Nav.HopDist
        local gy = Nav.groundY(land + Vector3.new(0, 14, 0), 60)
        if gy and gy > Nav.MinGroundY and math.abs(gy - groundNow) <= 8 then
            local clear = Nav.freeDistance(origin, dir, Nav.HopDist, Nav.HopClearY, params)
            local score = clear + 5 * dir:Dot(goalDir)
            if not bestScore or score > bestScore then best, bestScore = dir, score end
        end
    end
    if not best then return false end

    local vel = Instance.new("BodyVelocity")
    vel.Name = "EvDoorHopVel"
    vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    vel.Velocity = Vector3.zero
    vel.Parent = root
    hum.PlatformStand = true
    hum.AutoRotate = false

    -- fase 1: naik (sedikit maju)
    local t0 = tick()
    while Enabled and (tick() - t0) < Nav.HopUpTime do
        vel.Velocity = best * 8 + Vector3.new(0, Nav.HopUpSpeed, 0)
        RunService.Heartbeat:Wait()
    end

    -- fase 2: maju, sumbu Y dilepas -> gravitasi yang menurunkan
    vel.MaxForce = Vector3.new(1e9, 0, 1e9)
    t0 = tick()
    while Enabled and (tick() - t0) < Nav.HopFwdTime do
        vel.Velocity = best * Nav.HopFwdSpeed
        RunService.Heartbeat:Wait()
    end

    pcall(function() vel:Destroy() end)
    pcall(function()
        hum.PlatformStand = false
        hum.AutoRotate = true
    end)

    -- tunggu mendarat
    t0 = tick()
    while Enabled and hum.Parent and hum.FloorMaterial == Enum.Material.Air and (tick() - t0) < 2 do
        task.wait(0.1)
    end
    task.wait(0.2)

    return RootPart ~= nil and (RootPart.Position - origin).Magnitude >= 3
end

-- Dipanggil goTo kalau path gagal gara-gara posisi kita sendiri.
-- level 1: pindah ke ruang terbuka, kalau terkurung lompat keluar.
-- level 2: kalau beneran ketutup atap, cari jalan keluar (dibatasi waktu); sisanya lompat.
-- Return: true kalau posisi bergeser (layak hitung path lagi)
function Nav.recover(goalPos, level)
    local prev = Stat.snapshot()
    local why = tostring(Nav.lastStatusName)
    local moved = false

    if level <= 1 then
        Stat.set("Posisi buntu", "path gagal (" .. why .. "), pindah ke ruang terbuka...", "warn")
        moved = Nav.relocate(goalPos)
        if not moved and Enabled then
            Stat.set("Terkurung", "lompat keluar dari rintangan...", "warn")
            moved = Nav.hopOut(goalPos)
        end
    else
        if Nav.isCovered(RootPart.Position) then
            moved = Nav.escapeRoof()
        end
        if not moved and Enabled then
            Stat.set("Terkurung", "lompat keluar dari rintangan...", "warn")
            moved = Nav.hopOut(goalPos)
        end
    end

    Stat.restore(prev)
    return moved
end

-- Dipanggil mainLoop kalau beberapa door gagal BERUNTUN (script diem muter-muter di tempat).
-- Lompat keluar; kalau Settings.StuckRespawn ON & sudah RespawnStreak kali -> respawn karakter.
function Nav.hardRecover(streak)
    local prev = Stat.snapshot()
    print("[AutoEventDoor] " .. streak .. " door gagal berturut-turut, pemulihan posisi...")

    if Settings.StuckRespawn and streak >= Nav.RespawnStreak then
        Stat.set("Macet berturut-turut", streak .. " door gagal, respawn karakter...", "warn")
        pcall(function() Humanoid.Health = 0 end)
        task.wait(1)

        local t0 = tick()
        while Enabled and (tick() - t0) < 20 do
            if Humanoid and Humanoid.Parent and Humanoid.Health > 0 and RootPart and RootPart.Parent then
                break
            end
            task.wait(0.5)
        end
        task.wait(1.5)
        Nav.failStreak = 0
    else
        Stat.set("Macet berturut-turut", streak .. " door gagal, lompat keluar...", "warn")
        Nav.hopOut(nil)
    end

    Stat.restore(prev)
end

-- ---------- orkestrator ----------
-- Return: "Arrived" | "Blocked" | "Stuck" | "Stopped"
function Nav.goTo(goalPos, isDone, preWps, prePath)
    local recoveries = 0

    for attempt = 1, Nav.MaxAttempts do
        if not Enabled then return "Stopped" end
        if isDone() then return "Arrived" end

        if attempt > 1 then
            Stat.note = "path ulang " .. attempt .. "/" .. Nav.MaxAttempts
        end

        local waypoints, path, partial
        if attempt == 1 and preWps then
            waypoints, path = preWps, prePath
        else
            waypoints, path, partial = Nav.computePath(RootPart.Position, goalPos, nil, true)
        end

        if not waypoints then
            local why = Nav.lastStatusName
            print("[AutoEventDoor] Path gagal (" .. tostring(why) .. ").")

            -- Gagal gara-gara POSISI kita (terkurung / pulau navmesh terpisah): geser dulu,
            -- lalu coba lagi. FailFinishNotEmpty = tujuannya yang bermasalah -> gak ada gunanya geser.
            if recoveries < Nav.MaxRecoveries and (why == "FailStartNotEmpty" or why == "NoPath") then
                recoveries = recoveries + 1
                if Nav.recover(goalPos, recoveries) then
                    continue
                end
            end
            return "Blocked"
        end

        local state = { blocked = false }
        local conn = path and path.Blocked:Connect(function() state.blocked = true end)
        local status = Nav.follow(Nav.filter(waypoints), isDone, state)
        if conn then conn:Disconnect() end

        if status == "Arrived" or status == "Stopped" then return status end

        if status == "Finished" then
            local d = RootPart.Position - goalPos
            if Vector3.new(d.X, 0, d.Z).Magnitude <= Nav.PointArrive + 2 then
                return "Arrived"
            end
            -- Path parsial (tujuan gak punya navmesh / terlalu jauh): ujungnya didekati lurus
            if partial then
                Nav.follow({ { Position = goalPos } }, isDone)
                if isDone() then return "Arrived" end
            end
        end
        -- "Stuck" / "Blocked" / "Finished" tapi belum dekat: loop = hitung ulang dari posisi sekarang
    end

    return isDone() and "Arrived" or "Stuck"
end

-- ============ API publik (nama sama kayak sebelumnya) ============

-- Tween lurus ke satu titik (dipakai fallback Witch). targetPos = titik LANTAI.
local function tweenToPoint(targetPos, timeout)
    local reached = Nav.tweenAlong({targetPos}, timeout or 8)
    return reached
end

-- target: eventDoor (Model/Part) atau Part tujuan biasa (ShopTarget / MerchantTarget).
-- Return: true kalau sampai
local function walkToDoorHeld(target)
    local center = getDoorPosition(target)
    if not center then return false end

    local isDoor = (target.Name == EVENT_DOOR_CHILD_NAME)
    local lost = false

    local function isDone()
        if not target.Parent then lost = true return true end
        local c = getDoorPosition(target)
        if not c then lost = true return true end

        if isDoor then
            -- cukup dekat (3D) & kelihatan, atau udah nempel banget secara datar
            local d = (RootPart.Position - c).Magnitude
            if d <= MINE_DISTANCE and Nav.canSee(target, c) then return true end
            local dd = RootPart.Position - c
            return Vector3.new(dd.X, 0, dd.Z).Magnitude <= Nav.PointArrive
        end

        local dd = RootPart.Position - c
        return Vector3.new(dd.X, 0, dd.Z).Magnitude <= Nav.PointArrive and math.abs(dd.Y) <= 10
    end

    if isDone() then return not lost end

    -- Pilih titik tujuan
    local goal, wps, path
    if isDoor then
        goal, wps, path = Nav.pickGoal(Nav.doorGoals(target))
    end
    if not goal then
        goal = center
    end

    local status = Nav.goTo(goal, isDone, wps, path)
    if lost then
        releaseAllMoveKeys()
        return false
    end

    releaseAllMoveKeys()
    return status == "Arrived"
end

-- ============ Trip ke Witch of Halloween buat beli chest ============
local SHOP_ITEM = "Rare Fruit Chest"
local SHOP_WAIT = 2          -- tunggu sebelum beli setelah sampai di NPC
local MAX_BUYS_PER_TRIP = 20 -- pengaman biar gak infinite loop

local function getWitchHat()
    local npcs = workspace:FindFirstChild("NPCs")
    local witch = npcs and npcs:FindFirstChild("Witch of Halloween")
    return witch and witch:FindFirstChild("Witch's HatHat")
end

-- ============ Sampai ke Witch (target di LANTAI, bukan topi) ============
-- Sebelumnya tujuannya topi ("Witch's HatHat") yang posisinya melayang di atas
-- kepala NPC / bisa jauh dari lantai, jadi sering "gak beneran sampai". Sekarang:
--   1) cari badan NPC, ambil titik ~4 stud di depannya (arah karakter), turun ke LANTAI
--   2) jalan lewat pathfinding
--   3) kalau belum pas (jarak datar > SHOP_ARRIVE_FLAT), tween lurus, max 3x
--   4) kalau tetap belum pas, batalin pembelian (return false -> backoff, script tetap jalan)
local SHOP_ARRIVE_FLAT = 6
local ShopRetryAt = 0 -- kalau trip gagal, jangan dicoba lagi sebelum waktu ini (tick)

local ShopTarget = Instance.new("Part")
ShopTarget.Name = "AutoEventDoorShopTarget"
ShopTarget.Size = Vector3.new(1, 1, 1)
ShopTarget.Transparency = 1
ShopTarget.CanCollide = false
ShopTarget.CanQuery = false
ShopTarget.Anchored = true
ShopTarget.Parent = workspace

-- Return: posisi lantai dekat Witch, atau nil kalau NPC gak ketemu
local function getWitchStandPosition()
    local npcs = workspace:FindFirstChild("NPCs")
    local witch = npcs and npcs:FindFirstChild("Witch of Halloween")
    if not witch then return nil end

    local ref = witch:FindFirstChild("HumanoidRootPart")
        or witch.PrimaryPart
        or witch:FindFirstChildWhichIsA("BasePart", true)
    if not ref then return nil end

    -- Geser ~4 stud dari NPC ke arah karakter, biar gak nabrak badan NPC
    local offset = Vector3.zero
    local toPlayer = RootPart.Position - ref.Position
    local flat = Vector3.new(toPlayer.X, 0, toPlayer.Z)
    if flat.Magnitude > 1 then
        offset = flat.Unit * 4
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {Character, witch, ShopTarget, IndicatorBeam.originPart}

    local origin = ref.Position + offset + Vector3.new(0, 5, 0)
    local result = workspace:Raycast(origin, Vector3.new(0, -80, 0), params)

    if result then
        return result.Position
    end
    return ref.Position + offset - Vector3.new(0, 3, 0)
end

-- Return: true kalau akhirnya cukup dekat (jarak datar <= SHOP_ARRIVE_FLAT)
local function arriveAtWitch()
    local ground = getWitchStandPosition()
    if not ground then return false end
    ShopTarget.Position = ground

    local function closeEnough()
        local d = RootPart.Position - ground
        return Vector3.new(d.X, 0, d.Z).Magnitude <= SHOP_ARRIVE_FLAT and math.abs(d.Y) <= 10
    end

    if closeEnough() then return true end

    -- 1) Pathfinding biasa
    walkToDoorHeld(ShopTarget)
    if not Enabled then return false end
    if closeEnough() then return true end

    -- 2) Fallback: tween lurus (nempel lantai), hitung ulang posisi NPC tiap percobaan
    for attempt = 1, 3 do
        if not Enabled then return false end

        ground = getWitchStandPosition() or ground
        ShopTarget.Position = ground

        print("[AutoEventDoor] Belum pas sampai di Witch, tween langsung (percobaan " .. attempt .. "/3).")
        Stat.set("Menuju Witch (tween langsung)", Stat.towards(function() return ground end, "percobaan " .. attempt .. "/3"), "move")
        tweenToPoint(ground, 30)
        if closeEnough() then return true end
    end

    return closeEnough()
end

-- Race Reroll dan Rare Fruit Chest hanya diproses setelah CandyTarget tercapai.
local RaceRerollRetryAt = 0
local HalloweenShopStatus
local function doShopTrip()
    if not getWitchStandPosition() then
        print("[AutoEventDoor] Witch of Halloween gak ketemu di workspace.NPCs.")
        return false
    end

    print("[AutoEventDoor] Candy cukup, jalan ke Witch of Halloween...")
    Stat.set("Menuju Witch of Halloween", Stat.towards(function() return ShopTarget.Position end, "candy mencapai target"), "move")
    local arrived = arriveAtWitch()
    if not Enabled then return false end
    if not arrived then
        print("[AutoEventDoor] Belum pas sampai di Witch, pembelian dibatalkan.")
        return false
    end

    task.wait(SHOP_WAIT)
    if not Enabled then return false end

    local rerollBought = false
    if Settings.AutoBuyRaceReroll and tick() >= RaceRerollRetryAt then
        local before = getCandyCount()
        if before and before >= Settings.CandyTarget then
            HalloweenShopStatus("membeli Race Reroll x5")
            local ok, response = pcall(function()
                local remote = ReplicatedStorage:WaitForChild("HalloweenShopRemote", 5)
                if not remote then error("HalloweenShopRemote belum tersedia") end
                return remote:InvokeServer("Race Reroll x5")
            end)

            if ok and response ~= false
                and not (type(response) == "table" and (response.Success == false or response.Accepted == false)) then
                task.wait(1)
                local after = getCandyCount()
                if after and after < before then
                    rerollBought = true
                    RaceRerollRetryAt = tick() + 30
                    HalloweenShopStatus("Race Reroll x5 terbeli")
                else
                    RaceRerollRetryAt = tick() + 60
                    HalloweenShopStatus("candy tidak berkurang; pembelian gagal")
                end
            else
                RaceRerollRetryAt = tick() + 60
                HalloweenShopStatus("pembelian Race Reroll ditolak")
            end
        end
    end

    local bought = 0
    while Settings.AutoBuyRareChest and Enabled and bought < MAX_BUYS_PER_TRIP do
        local before = getCandyCount()
        if before and before < Settings.CandyTarget then break end

        Stat.set("Beli " .. SHOP_ITEM, string.format("pembelian ke-%d  |  candy %s", bought + 1, tostring(before)), "work")
        local ok, err = pcall(function()
            local remote = ReplicatedStorage:WaitForChild("HalloweenShopRemote", 5)
            remote:InvokeServer(SHOP_ITEM)
        end)

        if not ok then
            print("[AutoEventDoor] Gagal beli " .. SHOP_ITEM .. ": " .. tostring(err))
            break
        end

        task.wait(1)
        local after = getCandyCount()
        if before and after and after >= before then
            print("[AutoEventDoor] Candy gak berkurang, pembelian dianggap gagal.")
            break
        end

        bought = bought + 1
        Webhook.count("chestsBought", 1)
        if not (before and after) then break end
    end

    if bought > 0 then
        print("[AutoEventDoor] Beli " .. SHOP_ITEM .. " x" .. bought .. ", balik ngumpulin candy.")
    end
    return bought > 0 or rerollBought
end

HalloweenShopStatus = function(text)
    if UI.MacState.HalloweenShopStatus then
        UI.MacState.HalloweenShopStatus:UpdateName("Halloween Shop: " .. tostring(text))
    end
end

-- ============ Auto Merchant (Traveling Merchant) ============
-- Dari source: merchant dianggap "lagi muncul" kalau ada value
-- ReplicatedStorage.CompassGuider["Traveling Merchant"] (Vector3 / CFrame = posisi
-- merchant). Kalau value itu gak ada, merchant lagi gak keluar. Stok merchant
-- restock tiap 30 menit; 1 stok cukup dibeli sekali, jadi setelah beli kita
-- tandai MerchantBought dan baru reset pas marker-nya hilang (stok berikutnya).

-- Beli item: Events.TravelingMerchentRemote:InvokeServer(itemName, <angka>, <GUID>)
-- (ejaan "Merchent" memang begitu di game). Angka & GUID dari contoh remote-mu;
-- nilainya sama di dua item berbeda, jadi bukan per-item, kemungkinan per-stok
-- merchant (berubah tiap restock). Kalau pembelian mulai ditolak setelah merchant
-- restock, ambil nilai baru dari remote spy dan ganti di dalam fungsi di bawah.
-- (Konstantanya sengaja di DALAM fungsi, biar gak nambah variabel local di level
-- atas script - batas Luau 200 local per scope.)
local MERCHANT_BUY_CONFIGURED = true
local function buyMerchantItem(itemName)
    local STOCK_ID = 1613697448
    local STOCK_GUID = "6a75e173-f8a5-4d9e-b989-25536ecbd53c"

    local events = ReplicatedStorage:WaitForChild("Events", 5)
    local remote = events and events:WaitForChild("TravelingMerchentRemote", 5)
    if not remote then
        error("Events.TravelingMerchentRemote gak ketemu")
    end

    -- Return: balasan server (dicetak di console buat diagnosa)
    return remote:InvokeServer(itemName, STOCK_ID, STOCK_GUID)
end

local MerchantBought = false   -- stok yang lagi keluar sudah dibeli
local MerchantRetryAt = 0
local MerchantFails = 0
local MerchantWarned = false

local MerchantTarget = Instance.new("Part")
MerchantTarget.Name = "AutoEventDoorMerchantTarget"
MerchantTarget.Size = Vector3.new(1, 1, 1)
MerchantTarget.Transparency = 1
MerchantTarget.CanCollide = false
MerchantTarget.Anchored = true
MerchantTarget.Parent = workspace

local function getMerchantMarker()
    local compassGuider = ReplicatedStorage:FindFirstChild("CompassGuider")
    return compassGuider and compassGuider:FindFirstChild("Traveling Merchant")
end

local function getMerchantPosition(marker)
    local value = marker and marker.Value
    if typeof(value) == "CFrame" then return value.Position end
    if typeof(value) == "Vector3" then return value end
    return nil
end

-- Peli dibaca dari HUD.Main.Peli.TextLabel (sama kayak di source)
local function getPeli()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    local hud = gui and gui:FindFirstChild("HUD")
    local main = hud and hud:FindFirstChild("Main")
    local peli = main and main:FindFirstChild("Peli")
    local label = peli and peli:FindFirstChild("TextLabel")
    if not label then return 0 end
    local digits = label.Text:gsub("[^%d]", "")
    return tonumber(digits) or 0
end

local function getMerchantItemList()
    local list = {}
    for name in string.gmatch(Settings.MerchantItems or "", "[^,]+") do
        name = name:match("^%s*(.-)%s*$")
        if name ~= "" then table.insert(list, name) end
    end
    return list
end

-- Return: true kalau minimal 1 item berhasil dibeli
local function doMerchantTrip(marker)
    local pos = getMerchantPosition(marker)
    if not pos then
        print("[AutoEventDoor] Posisi Traveling Merchant gak kebaca dari marker.")
        return false
    end

    local items = getMerchantItemList()
    print("[AutoEventDoor] Traveling Merchant muncul, jalan ke sana...")

    MerchantTarget.Position = pos
    Stat.set("Menuju Traveling Merchant", Stat.towards(function() return pos end), "move")
    local arrived = walkToDoorHeld(MerchantTarget)
    if not arrived or not Enabled then
        return false
    end

    task.wait(1)

    local bought = 0
    for _, itemName in ipairs(items) do
        if not Enabled then break end

        Stat.set("Beli dari merchant", itemName, "work")
        local ok, res = pcall(buyMerchantItem, itemName)
        if ok and res ~= false then
            bought = bought + 1
            Webhook.count("merchant", 1)
            print("[AutoEventDoor] Beli dari merchant: " .. itemName .. " (balasan server: " .. tostring(res) .. ")")
        else
            local err = ok and ("ditolak server: " .. tostring(res)) or res
            print("[AutoEventDoor] Gagal beli " .. itemName .. ": " .. tostring(err))
        end
        task.wait(0.5)
    end

    return bought > 0
end

-- ============ Equip Candy Corn Basket ============
-- Basket harus ter-equip dulu sebelum nyari event door (dan CandyIndicator juga
-- baru muncul di PlayerGui pas tool-nya di-equip). Tool yang lagi di-equip
-- pindah dari Backpack ke Character, jadi dicek dua-duanya.
local BASKET_NAME = "Candy Corn Basket"

-- Cari tool basket di sebuah container: nama persis dulu, kalau gak ada baru
-- cari Tool yang namanya mengandung "candy corn" (jaga-jaga namanya beda dikit)
local function findBasketIn(container)
    if not container then return nil end

    local exact = container:FindFirstChild(BASKET_NAME)
    if exact and exact:IsA("Tool") then
        return exact
    end

    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Tool") and string.find(string.lower(child.Name), "candy corn", 1, true) then
            return child
        end
    end

    return nil
end

-- Daftar nama Tool di Backpack & Character, buat debug kalau basket gak ketemu
local function listToolNames()
    local names = {}
    local function collect(container, label)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then
                table.insert(names, label .. ": " .. child.Name)
            end
        end
    end
    collect(LocalPlayer:FindFirstChild("Backpack"), "Backpack")
    collect(LocalPlayer.Character, "Character")
    return #names > 0 and table.concat(names, ", ") or "(gak ada Tool sama sekali)"
end

-- Return: tool, isEquipped
-- NOTE: Di Roblox, tool yang di-equip PINDAH dari Backpack ke Character, jadi
-- ilang dari Backpack itu NORMAL. Makanya Character dicek duluan.
local function getBasketTool()
    local equippedTool = findBasketIn(LocalPlayer.Character)
    if equippedTool then
        return equippedTool, true
    end

    local backpackTool = findBasketIn(LocalPlayer:FindFirstChild("Backpack"))
    if backpackTool then
        return backpackTool, false
    end

    return nil, false
end

-- Return: true kalau basket sudah ter-equip (atau berhasil di-equip)
local function ensureBasketEquipped()
    local tool, equipped = getBasketTool()
    if equipped then return true end
    if not tool then return false end -- basket gak ada di Backpack

    local hum = Humanoid
    if not hum or not hum.Parent then return false end

    pcall(function()
        hum:EquipTool(tool)
    end)

    -- Tunggu sampai beneran pindah ke Character (maks 3 detik)
    local waitStart = tick()
    while Enabled and (tick() - waitStart) < 3 do
        local _, nowEquipped = getBasketTool()
        if nowEquipped then
            task.wait(0.3) -- kasih waktu CandyIndicator muncul di PlayerGui
            return true
        end
        task.wait(0.1)
    end

    return false
end

-- ============ Auto Drop fruit ============
-- Alur: tiap Settings.DropInterval detik (cuma di titik aman mainLoop) cek Backpack/Character.
-- Fruit dengan nama yang cocok di ReplicatedStorage.Modules.ToolDesc.Fruits -> equip -> Backspace
-- (maks Drop.Attempts kali; gagal = dilewati 60 detik). Habis satu putaran, basket di-equip lagi.
-- Pencocokan memakai nama kategori Common/Epic/Rare; Candy Corn Basket dan Rare Fruit Chest
-- selalu dikecualikan.
function Drop.norm(name)
    local s = Webhook.baseName(name):lower()
    s = s:gsub("%s+", " ")
    return Webhook.trim(s)
end

Drop.FruitCatalog = {}
function Drop.refreshFruitCatalog()
    local fruits = ReplicatedStorage:FindFirstChild("Modules")
    fruits = fruits and fruits:FindFirstChild("ToolDesc")
    fruits = fruits and fruits:FindFirstChild("Fruits")
    local catalog = {Common = {}, Epic = {}, Legendary = {}, Mythical = {}, Rare = {}}
    if fruits then
        for rarity in pairs(catalog) do
            local folder = fruits:FindFirstChild(rarity)
            if folder then
                for _, item in ipairs(folder:GetDescendants()) do
                    local key = Drop.norm(item.Name)
                    if key ~= "" then
                        catalog[rarity][key] = true
                        local base = key:gsub("%s+no%s+mi$", "")
                        catalog[rarity][base] = true
                        local firstWord, secondWord = base:match("^(%S+)%s+(%S+)$")
                        if firstWord and firstWord == secondWord then catalog[rarity][firstWord] = true end
                    end
                end
            end
        end
    end
    Drop.FruitCatalog = catalog
end

function Drop.shouldDrop(name)
    local n = Drop.norm(name)
    if n == "" or n == Drop.norm(BASKET_NAME) or n == Drop.norm(CHEST_NAME) then return false end
    local candidates = {n}
    local withoutNoMi = n:gsub("%s+no%s+mi$", "")
    if withoutNoMi ~= n then table.insert(candidates, withoutNoMi) end
    local firstWord, secondWord = withoutNoMi:match("^(%S+)%s+(%S+)$")
    if firstWord and firstWord == secondWord then table.insert(candidates, firstWord) end

    for _, rarity in ipairs(Settings.DropRarities or {}) do
        local names = Drop.FruitCatalog[rarity]
        if names then
            for _, candidate in ipairs(candidates) do
                if names[candidate] then return true end
            end
        end
    end
    return false
end

-- Daftar Tool (Backpack + Character) yang perlu di-drop sekarang
function Drop.collect()
    Drop.refreshFruitCatalog()
    local list, now = {}, tick()
    local function scan(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") and (Drop.skipUntil[child] or 0) <= now and Drop.shouldDrop(child.Name) then
                table.insert(list, child)
            end
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack"))
    scan(LocalPlayer.Character)
    return list
end

-- Equip lalu Backspace untuk satu tool. Return: true kalau tool hilang / jumlahnya berkurang
function Drop.one(tool)
    local hum = Humanoid
    if not hum or not hum.Parent then return false end

    local function mine()
        return tool.Parent == LocalPlayer.Character or tool.Parent == LocalPlayer:FindFirstChild("Backpack")
    end
    local before = readToolCount(tool) or 1

    for _ = 1, Drop.Attempts do
        if not mine() then return true end

        if tool.Parent ~= LocalPlayer.Character then
            pcall(function() hum:EquipTool(tool) end)
            local t0 = tick()
            while tool.Parent ~= LocalPlayer.Character and mine() and (tick() - t0) < 2 do
                task.wait(0.1)
            end
        end

        if tool.Parent == LocalPlayer.Character then
            task.wait(0.3) -- jeda biar server nganggep tool udah ke-equip
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Backspace, false, game)
            task.wait(0.08)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Backspace, false, game)

            local t0 = tick()
            while (tick() - t0) < 1.2 do
                if not mine() then return true end
                if (readToolCount(tool) or 1) < before then return true end
                task.wait(0.1)
            end
        end
        task.wait(0.3)
    end
    return false
end

-- Satu putaran drop. manual = true: dari tombol "Drop sekarang" saat farm OFF.
-- Return: jumlah fruit yang berhasil di-drop
function Drop.run(manual)
    if Drop.running then return 0 end
    Drop.running = true
    Drop.manual = manual == true

    local dropped = 0
    local prev = Stat.snapshot()

    local ok, err = pcall(function()
        local list = Drop.collect()
        for i, tool in ipairs(list) do
            if i > Drop.MaxPerRun then break end
            if not (Enabled or Drop.manual) then break end -- farm dimatiin di tengah putaran

            waitUntilNotStunned()
            Stat.set("Auto Drop", string.format("%s  |  %d/%d", tool.Name, i, #list), "work")

            local name = tool.Name
            if Drop.one(tool) then
                dropped = dropped + 1
                Webhook.count("dropped", 1)
                print("[AutoEventDoor] Drop: " .. name)
            else
                Drop.skipUntil[tool] = tick() + 60
                print("[AutoEventDoor] Drop gagal, dilewati 60 detik: " .. name)
            end
            task.wait(Drop.Gap)
        end

        -- Balikin basket ke tangan (farm butuh basket ter-equip)
        if dropped > 0 or #list > 0 then ensureBasketEquipped() end
    end)
    if not ok then print("[AutoEventDoor] Auto Drop error: " .. tostring(err)) end

    Stat.restore(prev)
    Drop.running = false
    Drop.manual = false
    return dropped
end

-- Dipanggil mainLoop di titik aman. Return: true kalau barusan menjalankan satu putaran drop.
function Drop.tick()
    if Drop.running then return false end

    local requested = Drop.now
    if not requested then
        if not Settings.AutoDrop or tick() < Drop.nextAt then return false end
    end
    Drop.nextAt = tick() + math.max(Settings.DropInterval, 3)
    Drop.now = false

    if #Drop.collect() == 0 then
        if requested then print("[AutoEventDoor] Drop: gak ada fruit di daftar yang perlu di-drop.") end
        return false
    end

    Drop.run(false)
    return true
end

-- Tombol "Drop sekarang": farm ON -> dijalankan mainLoop di titik aman; farm OFF -> langsung.
function Drop.requestNow()
    if Drop.running then return end
    if Enabled then
        Drop.now = true
        print("[AutoEventDoor] Drop: diminta, dijalankan di sela farm...")
    else
        task.spawn(Drop.run, true)
    end
end

-- ============ Buka Rare Fruit Chest ============
-- Kalau Rare Fruit Chest >= Settings.ChestOpenAt (default 7), ulang terus:
--   1) equip tool "Rare Fruit Chest" dari Backpack
--   2) klik layar (tengah screen)
--   3) tunggu PlayerGui.ConfirmationPrompt muncul, lalu klik
--      ConfirmationPrompt.Main.OptionsFrame.Accept (ImageButton)
--   4) tunggu 9 detik, cek jumlah chest
-- sampai chest tinggal CHEST_KEEP (2), lalu balik farm door. (Basket otomatis
-- di-equip lagi di iterasi mainLoop berikutnya.)
local CHEST_KEEP = 2                -- chest yang disisakan (berhenti buka kalau jumlah <= ini)
local OPEN_WAIT_AFTER_ACCEPT = 9
local PROMPT_WAIT = 4               -- tunggu prompt muncul setelah klik layar
local OPEN_MAX_CYCLES = 60          -- pengaman biar gak infinite loop
local OPEN_MAX_NOPROGRESS = 3       -- chest gak berkurang sekian siklus = nyerah
local OPEN_MAX_PROMPT_FAILS = 3     -- prompt gak muncul sekian kali berturut-turut = nyerah
local ChestRetryAt = 0

-- ---- Equip chest ----
local function findChestToolIn(container)
    if not container then return nil end

    local exact = container:FindFirstChild(CHEST_NAME)
    if exact and exact:IsA("Tool") then return exact end

    local lowerName = string.lower(CHEST_NAME)
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Tool") and string.sub(string.lower(child.Name), 1, #lowerName) == lowerName then
            return child
        end
    end
    return nil
end

-- Return: tool, isEquipped (tool yang di-equip pindah ke Character, jadi dicek duluan)
local function getChestTool()
    local equippedTool = findChestToolIn(LocalPlayer.Character)
    if equippedTool then return equippedTool, true end

    local backpackTool = findChestToolIn(LocalPlayer:FindFirstChild("Backpack"))
    if backpackTool then return backpackTool, false end

    return nil, false
end

-- Return: tool kalau chest sudah ter-equip (atau berhasil di-equip), nil kalau gagal
local function ensureChestEquipped()
    local tool, equipped = getChestTool()
    if equipped then return tool end
    if not tool then return nil end

    local hum = Humanoid
    if not hum or not hum.Parent then return nil end

    pcall(function()
        hum:EquipTool(tool)
    end)

    local waitStart = tick()
    while Enabled and (tick() - waitStart) < 3 do
        local nowTool, nowEquipped = getChestTool()
        if nowEquipped then
            task.wait(0.3)
            return nowTool
        end
        task.wait(0.1)
    end
    return nil
end

-- ---- Klik ----
-- Klik kiri di tengah layar (pakai ukuran viewport kamera)
local function clickScreenCenter()
    local camera = workspace.CurrentCamera
    local size = camera and camera.ViewportSize or Vector2.new(800, 600)
    local x, y = size.X / 2, size.Y / 2

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- Klik beneran di tengah sebuah GuiObject (koordinat + inset topbar kalau perlu)
local function clickGuiObject(obj)
    local pos, size = obj.AbsolutePosition, obj.AbsoluteSize
    local screenGui = obj:FindFirstAncestorWhichIsA("ScreenGui")
    local insetY = 0
    if screenGui and not screenGui.IgnoreGuiInset then
        insetY = game:GetService("GuiService"):GetGuiInset().Y
    end

    local x = pos.X + size.X / 2
    local y = pos.Y + size.Y / 2 + insetY

    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    task.wait(0.05)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- Fire koneksi event tombol (cara paling andal buat ImageButton). Berhenti di
-- signal pertama yang punya koneksi biar gak ke-trigger dobel.
local BUTTON_SIGNALS = {"MouseButton1Click", "Activated"}

local function fireButtonSignals(btn)
    for _, name in ipairs(BUTTON_SIGNALS) do
        local signal = btn[name]
        local fired = false

        if typeof(getconnections) == "function" then
            local ok, conns = pcall(getconnections, signal)
            if ok and type(conns) == "table" then
                for _, conn in ipairs(conns) do
                    if pcall(function() conn:Fire() end) then
                        fired = true
                    end
                end
            end
        elseif typeof(firesignal) == "function" then
            if pcall(firesignal, signal) then
                fired = true
            end
        end

        if fired then return true end
    end
    return false
end

-- ---- ConfirmationPrompt ----
-- Return: tombol Accept kalau prompt lagi muncul, nil kalau belum/sudah hilang
local function getAcceptButton()
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    local prompt = gui and gui:FindFirstChild("ConfirmationPrompt")
    local main = prompt and prompt:FindFirstChild("Main")
    local options = main and main:FindFirstChild("OptionsFrame")
    local accept = options and options:FindFirstChild("Accept")
    if not accept then return nil end

    if prompt:IsA("ScreenGui") and not prompt.Enabled then return nil end
    if main:IsA("GuiObject") and not main.Visible then return nil end
    if accept:IsA("GuiObject") and (not accept.Visible or accept.AbsoluteSize.X <= 0) then return nil end

    return accept
end

local function waitForAccept(timeout)
    local start = tick()
    while Enabled and (tick() - start) < timeout do
        local accept = getAcceptButton()
        if accept then
            task.wait(0.2) -- kasih waktu animasi muncul selesai
            return getAcceptButton() or accept
        end
        task.wait(0.1)
    end
    return nil
end

local function acceptPrompt(accept)
    fireButtonSignals(accept)
    task.wait(0.5)

    -- Kalau prompt masih nongol, klik beneran di tombolnya
    local still = getAcceptButton()
    if still then
        clickGuiObject(still)
        task.wait(0.5)
    end
end

-- Nunggu sambil tetap respon ke toggle OFF
local function waitWhileEnabled(seconds, label)
    local start = tick()
    Stat.set(label, function()
        return string.format("menunggu hasil %.0fs", math.max(0, seconds - (tick() - start)))
    end, "work")
    while Enabled and (tick() - start) < seconds do
        task.wait(0.25)
    end
end

-- Return: true kalau chest berhasil turun sampai <= CHEST_KEEP
local function doChestOpen()
    local last = getChestCount()
    local noProgress = 0
    local promptFails = 0
    print("[AutoEventDoor] Chest " .. last .. " >= " .. Settings.ChestOpenAt .. ", mulai buka sampai sisa " .. CHEST_KEEP .. "...")

    for cycle = 1, OPEN_MAX_CYCLES do
        if not Enabled then return false end

        waitUntilNotStunned()
        if not Enabled then return false end

        -- Sudah tinggal sisa? Jangan buka lagi
        if getChestCount() <= CHEST_KEEP then
            print("[AutoEventDoor] Chest tinggal " .. getChestCount() .. ", berhenti buka.")
            Stat.clear()
            return true
        end

        local tool = ensureChestEquipped()
        if not tool then
            print("[AutoEventDoor] '" .. CHEST_NAME .. "' gak ketemu / gagal di-equip dari Backpack.")
            return false
        end

        Stat.set("Buka Rare Fruit Chest", "sisa " .. last .. "  |  berhenti di " .. CHEST_KEEP, "work")

        clickScreenCenter()
        local accept = waitForAccept(PROMPT_WAIT)

        if not accept then
            -- Cadangan: aktifin tool langsung kalau klik layar gak memicu prompt
            pcall(function() tool:Activate() end)
            accept = waitForAccept(3)
        end

        if not accept then
            promptFails = promptFails + 1
            print("[AutoEventDoor] ConfirmationPrompt gak muncul (" .. promptFails .. "/" .. OPEN_MAX_PROMPT_FAILS .. ").")
            if promptFails >= OPEN_MAX_PROMPT_FAILS then
                return false
            end
            task.wait(1)
            continue
        end

        promptFails = 0
        acceptPrompt(accept)

        waitWhileEnabled(OPEN_WAIT_AFTER_ACCEPT, "Buka Rare Fruit Chest")
        if not Enabled then return false end

        local now = getChestCount()
        print("[AutoEventDoor] Buka chest siklus " .. cycle .. ": " .. last .. " -> " .. now)
        if now < last then Webhook.count("chestsOpened", last - now) end

        if now <= CHEST_KEEP then
            Stat.clear()
            return true
        end

        if now >= last then
            noProgress = noProgress + 1
            if noProgress >= OPEN_MAX_NOPROGRESS then
                print("[AutoEventDoor] Chest gak berkurang " .. OPEN_MAX_NOPROGRESS .. " siklus berturut-turut, berhenti.")
                return false
            end
        else
            noProgress = 0
        end
        last = now
    end

    return false
end

-- Kick farm saat item target baru muncul di data Inventory, sama seperti cek bait/ikan Fishing.
local RareItemKickWatcherRunning = false
local function rareInventoryCounts(data)
    if type(data) ~= "table" then return nil end
    local counts = {brand = 0, nightfall = 0}
    for name, value in pairs(data) do
        if type(name) == "string" then
            local normalized = Webhook.trim(name):lower()
            if normalized == "brand of sacrifice" then
                counts.brand = Fishing.amount(data, name)
            elseif normalized == "nightfall aura" then
                counts.nightfall = Fishing.amount(data, name)
            end
        end
    end
    return counts
end

local function startRareItemKickWatcher()
    if RareItemKickWatcherRunning then return end
    RareItemKickWatcherRunning = true
    task.spawn(function()
        -- Tunggu data inventory siap agar item lama tidak dianggap baru didapat.
        local previous
        while Enabled and not previous do
            previous = rareInventoryCounts(Fishing.inventory())
            if not previous then task.wait(0.5) end
        end

        while Enabled and previous do
            task.wait(0.5)
            if not Enabled then break end

            local current = rareInventoryCounts(Fishing.inventory())
            if current then
                local obtained
                if current.brand > previous.brand then
                    obtained = "Brand of Sacrifice"
                elseif current.nightfall > previous.nightfall then
                    obtained = "Nightfall Aura"
                end

                if obtained then
                    Enabled = false
                    Webhook.setActive(false)
                    releaseAllMoveKeys()
                    disableMovementMode()
                    pcall(function()
                        LocalPlayer:Kick(obtained .. " diperoleh; Halloween Farm dihentikan.")
                    end)
                    RareItemKickWatcherRunning = false
                    return
                end
                previous = current
            end
        end
        RareItemKickWatcherRunning = false
    end)
end

-- Guard biar gak ada 2 mainLoop jalan bareng kalau toggle OFF lalu cepat ON lagi
local MainLoopRunning = false

local function mainLoop()
    if MainLoopRunning then return end
    MainLoopRunning = true

    local shopFailures = 0
    local basketWarned = false

    while Enabled do
        -- Jangan ngapa-ngapain selagi stun (diculik / animasi ambil candy)
        waitUntilNotStunned()
        if not Enabled then break end

        -- "Drop sekarang" manual lagi jalan (farm baru dinyalain di tengah drop): tunggu selesai
        while Drop.running and Enabled do task.wait(0.2) end
        if not Enabled then break end

        -- Basket harus ter-equip dulu sebelum ngapa-ngapain (cari door / cek candy).
        -- Dicek tiap iterasi, jadi kalau ke-unequip / respawn, otomatis di-equip lagi.
        if not ensureBasketEquipped() then
            Stat.set("Menunggu " .. BASKET_NAME, "tool gak ketemu di Backpack / Character", "warn")
            if not basketWarned and Enabled then
                print("[AutoEventDoor] '" .. BASKET_NAME .. "' gak ketemu di Backpack/Character, nunggu... Tool yang kebaca: " .. listToolNames())
                basketWarned = true
            end
            task.wait(1)
            continue
        end
        basketWarned = false

        -- Auto Drop fruit: dijalankan DI SINI (titik aman: karakter diam, belum jalan/tween/fire prompt)
        -- supaya gak bentrok sama farm. Habis drop, iterasi diulang dari awal (basket di-equip lagi).
        if Drop.tick() then
            continue
        end

        local tripped = false

        -- Traveling Merchant: marker hilang = stok berikutnya boleh dibeli lagi
        local merchantMarker = getMerchantMarker()
        if not merchantMarker then
            MerchantBought = false
            MerchantFails = 0
        end

        if Settings.AutoMerchant and merchantMarker and not MerchantBought
            and tick() >= MerchantRetryAt and getPeli() > 0 then
            local items = getMerchantItemList()
            if #items == 0 then
                if not MerchantWarned then
                    print("[AutoEventDoor] Auto Merchant ON tapi daftar item kosong.")
                    MerchantWarned = true
                end
            elseif not MERCHANT_BUY_CONFIGURED then
                if not MerchantWarned then
                    print("[AutoEventDoor] Auto Merchant: buyMerchantItem() belum diisi, trip dilewati.")
                    MerchantWarned = true
                end
            else
                tripped = true
                if doMerchantTrip(merchantMarker) then
                    MerchantBought = true
                    MerchantFails = 0
                else
                    MerchantFails = MerchantFails + 1
                    MerchantRetryAt = tick() + math.min(30 * MerchantFails, 120)
                    print("[AutoEventDoor] Trip merchant gagal, coba lagi " .. math.ceil(MerchantRetryAt - tick()) .. " detik lagi.")
                end
            end
        end

        -- Rare Fruit Chest numpuk (>= trigger): buka sampai tinggal CHEST_KEEP, lalu balik farm door/candy.
        -- math.max: kalau "Buka Chest di" diisi <= CHEST_KEEP, trigger tetap minimal CHEST_KEEP + 1
        -- (kalau tidak, doChestOpen langsung selesai tanpa buka apa-apa tapi farm door ke-skip terus).
        if not tripped and Settings.ChestOpenAt > 0 and tick() >= ChestRetryAt then
            if getChestCount() >= math.max(Settings.ChestOpenAt, CHEST_KEEP + 1) then
                tripped = true

                if not doChestOpen() and Enabled then
                    -- gagal / gak ada progress: jangan diulang terus, coba lagi 60 detik lagi
                    ChestRetryAt = tick() + 60
                    print("[AutoEventDoor] Buka chest gagal, coba lagi 60 detik lagi. Lanjut farm candy dulu.")
                end

                Stat.clear()
            end
        end

        -- Candy mencapai target: trip ke Witch untuk item yang diaktifkan.
        local candyCount = getCandyCount()
        local raceRerollReady = Settings.AutoBuyRaceReroll and tick() >= RaceRerollRetryAt
        if (Settings.AutoBuyRareChest or raceRerollReady) and not tripped
            and candyCount and candyCount >= Settings.CandyTarget and tick() >= ShopRetryAt then
            tripped = true

            if doShopTrip() then
                shopFailures = 0
                ShopRetryAt = 0
            elseif Enabled then
                -- Gagal (NPC gak ketemu / remote error / candy gak berkurang):
                -- JANGAN matiin script. Coba lagi nanti dengan jeda makin lama
                -- (30s, 60s, ... max 180s), sementara lanjut farm door.
                shopFailures = shopFailures + 1
                local backoff = math.min(30 * shopFailures, 180)
                ShopRetryAt = tick() + backoff
                print("[AutoEventDoor] Trip Witch gagal (" .. shopFailures .. "x), coba lagi " ..
                    backoff .. " detik lagi. Lanjut farm door dulu.")
                task.wait(1)
            end
        end

        if not tripped then
            local door = findNextEventDoor()

            if door then
                local label = doorLabel(door)
                Stat.set("Menuju event door " .. label,
                    Stat.towards(function() return getDoorPosition(door) end), "move")
                local arrived = walkToDoorHeld(door)

                if arrived and door.Parent and Enabled then
                    Nav.failStreak = 0
                    -- Kalau door ini masih cooldown, tunggu di sini sampai siap.
                    -- Sambil nunggu, kalau candy udah cukup buat beli chest, batalin
                    -- nunggu supaya iterasi berikutnya langsung ke Witch.
                    local interrupted = false
                    if tick() < getDoorReadyAt(door) then
                        Stat.set("Menunggu cooldown door", function()
                            return label .. "  |  siap dalam " .. formatTime(getDoorReadyAt(door) - tick())
                        end, "wait")
                    end
                    while Enabled and door.Parent and tick() < getDoorReadyAt(door) do
                        Drop.tick() -- lagi diam nunggu cooldown = titik aman buat drop

                        local candyNow = getCandyCount()
                        if candyNow and candyNow >= Settings.CandyTarget and tick() >= ShopRetryAt then
                            interrupted = true
                            break
                        end

                        task.wait(1)
                    end

                    if not interrupted and Enabled and door.Parent then
                        LastVisit[door] = tick() -- cooldown mulai dihitung dari sekarang
                        Stat.set("Sampai di event door " .. label,
                            Settings.DoorGeppo and "geppo lalu fire prompt" or "fire prompt", "work")

                        -- Sampai di door: tunggu sebentar, Geppo SEKALI, baru fire prompt
                        if Settings.DoorGeppo then
                            task.wait(Settings.DoorArriveWait)
                            -- Lagi stun pun tetap Geppo (gak nunggu stun habis)
                            if Enabled and door.Parent then
                                fireGeppoOnce() -- InvokeServer, otomatis nunggu server
                                task.wait(Settings.DoorGeppoDelay)
                            end
                        end

                        Stat.set("Fire prompt " .. label, function()
                            return string.format("%.1f / %.0f detik", tick() - Stat.since, Settings.HoldDuration)
                        end, "work")
                        triggerDoorPrompt(door, Settings.HoldDuration)
                        Webhook.count("doors", 1)

                        -- Animasi ambil candy / diculik = stun. Kasih waktu stun
                        -- ke-replicate, lalu tunggu sampai habis sebelum gerak lagi.
                        task.wait(0.3)
                        waitUntilNotStunned()

                        -- Mundur sebentar sebelum cari pintu berikutnya - badan kemungkinan
                        -- lagi nempel ke tembok/pintu ini.
                        Stat.set("Selesai door " .. label, "mundur, lalu cari door berikutnya", "idle")
                        if Enabled then
                            setKeyHeld(Enum.KeyCode.S, true)
                            task.wait(0.4)
                            setKeyHeld(Enum.KeyCode.S, false)
                        end

                        updateGuiState()
                    end
                elseif Enabled and door.Parent then
                    -- Door gagal dicapai: tetap DIHITUNG (kena cooldown juga), jadi
                    -- progress naik dan script lanjut ke door lain, bukan macet di sini
                    print("[AutoEventDoor] Gagal nyampe ke salah satu door, di-skip & dihitung.")
                    Stat.set("Gagal sampai ke door " .. label, "di-skip & kena cooldown, lanjut door lain", "warn")
                    LastVisit[door] = tick()
                    Webhook.count("failed", 1)

                    -- Gagal beruntun = kemungkinan karakter terjebak: lompat keluar (atau respawn)
                    Nav.failStreak = Nav.failStreak + 1
                    if Nav.failStreak >= Nav.StreakHop then
                        Nav.hardRecover(Nav.failStreak)
                    end
                    updateGuiState()
                end
            else
                Stat.set("Mencari event door", "belum ada door yang tersedia / Building belum ke-load", "wait")
                task.wait(0.5)
            end
        end

        task.wait(0.2)
    end

    Stat.clear()
    releaseAllMoveKeys()
    disableMovementMode()
    MainLoopRunning = false
end

UI.setEnabled = function(state)
    Enabled = state
    Webhook.setActive(state)
    updateGuiState()

    if Enabled then
        Stat.set("Memulai", "cek basket, lalu cari event door...", "work")
        print("[AutoEventDoor] ON")
        startRareItemKickWatcher()
        task.spawn(mainLoop)
    else
        print("[AutoEventDoor] OFF")
        releaseAllMoveKeys()
        disableMovementMode()
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    UI.setEnabled(not Enabled)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY then
        UI.setEnabled(not Enabled)
    end
end)

Humanoid.WalkSpeed = Settings.WalkSpeed
updateGuiState()

-- Refresh label Candy tiap 1 detik, independen dari ON/OFF status, biar keliatan real-time
-- Status tampil real-time (4x/detik, murah); candy/progress/chest tiap 1 detik
task.spawn(function()
    local acc = 0
    while true do
        pcall(renderStatus)
        acc = acc + 0.25
        if acc >= 1 then
            acc = 0
            pcall(updateGuiState)
        end
        task.wait(0.25)
    end
end)

-- Dipakai detektor hitch: judul + detail status saat frame lambat
function Fps.describe()
    local detail = Stat.detail
    if Stat.detailFn then
        local ok, res = pcall(Stat.detailFn)
        detail = ok and tostring(res or "") or ""
    end
    return Stat.title .. (detail ~= "" and (" | " .. detail) or "")
end

Fps.start()
Webhook.start()

print("[AutoEventDoor] Script loaded. Tekan ',' atau klik tombol GUI untuk toggle ON/OFF.")
