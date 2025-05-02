-- Windows 11 Themed Roblox UI Library
-- Modular, supports: Tabs, Sections, Buttons, Toggles, Sliders
-- Usage: local tab = UILibrary.newTab({ Name = "Config" })
--        local section = tab.newSection({ Text = "Main" })
--        section.newToggle({ Text = "Test", Callback = function(v) print(v) end })

local UILibrary = {}
local TweenService = game:GetService("TweenService")
local UIScale = 1

-- Helper function for styling
local function createContainer(props)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = props.BackgroundTransparency or 0.15
	frame.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(245, 245, 255)
	frame.BorderSizePixel = 0
	frame.Size = props.Size or UDim2.new(1, 0, 0, 40)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.ClipsDescendants = true
	frame.Name = props.Name or "Container"

	local uicorner = Instance.new("UICorner")
	uicorner.CornerRadius = UDim.new(0, 12)
	uicorner.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.Parent = frame

	return frame
end

-- UI Container Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Win11UILibrary"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = createContainer({ Size = UDim2.new(0, 600, 0, 400), BackgroundTransparency = 0.1 })
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui

local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(0, 150, 1, 0)
tabHolder.BackgroundTransparency = 1
tabHolder.AutomaticSize = Enum.AutomaticSize.Y
tabHolder.Name = "TabHolder"
tabHolder.Parent = mainFrame

local tabButtons = Instance.new("UIListLayout")
tabButtons.SortOrder = Enum.SortOrder.LayoutOrder
tabButtons.Padding = UDim.new(0, 6)
tabButtons.Parent = tabHolder

local pages = Instance.new("Folder")
pages.Name = "Pages"
pages.Parent = mainFrame

-- Add tab
function UILibrary.newTab(tabInfo)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, -10, 0, 30)
	tabButton.Text = tabInfo.Name
	tabButton.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
	tabButton.BorderSizePixel = 0
	tabButton.Font = Enum.Font.SourceSansSemibold
	tabButton.TextSize = 18
	tabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	tabButton.Parent = tabHolder

	local page = createContainer({ Size = UDim2.new(1, -160, 1, -20), BackgroundTransparency = 0.05 })
	page.Position = UDim2.new(0, 160, 0, 10)
	page.Visible = false
	page.Parent = pages

	local sectionLayout = Instance.new("UIListLayout")
	sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sectionLayout.Padding = UDim.new(0, 12)
	sectionLayout.Parent = page

	tabButton.MouseButton1Click:Connect(function()
		for _, p in ipairs(pages:GetChildren()) do
			if p:IsA("Frame") then
				p.Visible = false
			end
		end
		page.Visible = true
	end)

	local Tab = {}
	function Tab.newSection(sectionInfo)
		local section = createContainer({ Name = sectionInfo.Text })
		section.Size = UDim2.new(1, -12, 0, 0)
		section.Parent = page

		local layout = Instance.new("UIListLayout")
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 8)
		layout.Parent = section

		local Section = {}

		function Section.newButton(buttonInfo)
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, 0, 0, 36)
			button.BackgroundColor3 = Color3.fromRGB(230, 240, 255)
			button.Text = buttonInfo.Text
			button.Font = Enum.Font.SourceSans
			button.TextSize = 16
			button.TextColor3 = Color3.fromRGB(0, 0, 0)
			button.BorderSizePixel = 0
			button.Parent = section

			button.MouseButton1Click:Connect(buttonInfo.Callback)
		end

		function Section.newToggle(toggleInfo)
			local toggle = Instance.new("TextButton")
			toggle.Size = UDim2.new(1, 0, 0, 36)
			toggle.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
			toggle.Text = toggleInfo.Text
			toggle.Font = Enum.Font.SourceSans
			toggle.TextSize = 16
			toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
			toggle.BorderSizePixel = 0
			toggle.Parent = section

			local state = toggleInfo.Default
			toggle.MouseButton1Click:Connect(function()
				state = not state
				toggle.BackgroundColor3 = state and Color3.fromRGB(200, 255, 200) or Color3.fromRGB(240, 240, 255)
				toggleInfo.Callback(state)
			end)
		end

		function Section.newSlider(sliderInfo)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 0, 50)
			frame.BackgroundTransparency = 1
			frame.Parent = section

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 20)
			label.BackgroundTransparency = 1
			label.Text = sliderInfo.Text .. ": " .. tostring(sliderInfo.Default) .. (sliderInfo.Suffix or "")
			label.Font = Enum.Font.SourceSans
			label.TextSize = 14
			label.TextColor3 = Color3.fromRGB(0, 0, 0)
			label.Parent = frame

			local slider = Instance.new("Slider") -- Placeholder: Replace with custom slider logic or external slider object
			-- You will need to implement a real slider using frame + input detection
		end

		return Section
	end

	return Tab
end

return UILibrary
