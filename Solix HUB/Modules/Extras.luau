return function(Library)
	local UDim2New, UDimNew, V2 = UDim2.new, UDim.new, Vector2.new
	local FromRGB = Color3.fromRGB

	Library.Sections.Divider = function(self, Text)
		local d = { Section = self }
		local Items = {}

		Items.Holder = Library:CreateInstance("Frame", {
			Parent = self.Items["Content"].Instance,
			Name = "\0",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2New(1, 0, 0, Text and 16 or 8)
		})

		if Text and Text ~= "" then
			Items.LabelLine = Library:CreateInstance("Frame", {
				Parent = Items.Holder.Instance,
				BackgroundColor3 = FromRGB(41, 37, 45),
				BorderSizePixel = 0,
				AnchorPoint = V2(0, 0.5),
				Position = UDim2New(0, 0, 0.5, 0),
				Size = UDim2New(0, 8, 0, 1)
			}) Items.LabelLine:AddToTheme({BackgroundColor3 = "Border"})

			Items.Label = Library:CreateInstance("TextLabel", {
				Parent = Items.Holder.Instance,
				FontFace = Library.Font,
				TextSize = 12,
				Text = Text,
				TextColor3 = FromRGB(185, 185, 185),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = V2(0, 0.5),
				Position = UDim2New(0, 14, 0.5, 0),
				Size = UDim2New(0, 0, 0, 14),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Left
			}) Items.Label:AddToTheme({TextColor3 = "Inactive Text"})

			Items.RightLine = Library:CreateInstance("Frame", {
				Parent = Items.Holder.Instance,
				BackgroundColor3 = FromRGB(41, 37, 45),
				BorderSizePixel = 0,
				AnchorPoint = V2(1, 0.5),
				Position = UDim2New(1, 0, 0.5, 0),
				Size = UDim2New(1, -24 - (#Text * 6), 0, 1)
			}) Items.RightLine:AddToTheme({BackgroundColor3 = "Border"})
		else
			Items.Line = Library:CreateInstance("Frame", {
				Parent = Items.Holder.Instance,
				BackgroundColor3 = FromRGB(41, 37, 45),
				BorderSizePixel = 0,
				AnchorPoint = V2(0, 0.5),
				Position = UDim2New(0, 0, 0.5, 0),
				Size = UDim2New(1, 0, 0, 1)
			}) Items.Line:AddToTheme({BackgroundColor3 = "Border"})
		end

		function d:SetText(t)
			if Items.Label then Items.Label.Instance.Text = t or "" end
		end
		function d:SetVisible(b) Items.Holder.Instance.Visible = b end

		d.Items = Items
		return d
	end

	Library.Sections.Spacer = function(self, Height)
		local s = { Section = self }
		s.Items = { Holder = Library:CreateInstance("Frame", {
			Parent = self.Items["Content"].Instance,
			Name = "\0",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2New(1, 0, 0, Height or 6)
		}) }
		return s
	end

	local origSlider = Library.Sections.Slider
	Library.Sections.SliderInput = function(self, Properties)
		Properties = Properties or {}
		local s = origSlider(self, Properties)
		if not s then return s end

		local content = self.Items["Content"]
		local box = Library:CreateInstance("Frame", {
			Parent = content.Instance,
			Name = "\0",
			BackgroundColor3 = FromRGB(22, 20, 24),
			BorderSizePixel = 0,
			Size = UDim2New(1, 0, 0, 24)
		}) box:AddToTheme({BackgroundColor3 = "Inline"})
		Library:CreateInstance("UICorner", {Parent = box.Instance, CornerRadius = UDimNew(0, 5)})
		local stk = Library:CreateInstance("UIStroke", {Parent = box.Instance, Thickness = 1, Color = FromRGB(41,37,45)})
		stk:AddToTheme({Color = "Border"})

		local lbl = Library:CreateInstance("TextLabel", {
			Parent = box.Instance,
			FontFace = Library.Font,
			TextSize = 12,
			Text = "Value",
			TextColor3 = FromRGB(185,185,185),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0, 8, 0, 0),
			Size = UDim2New(0, 60, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left
		}) lbl:AddToTheme({TextColor3 = "Inactive Text"})

		local tb = Library:CreateInstance("TextBox", {
			Parent = box.Instance,
			FontFace = Library.Font,
			TextSize = 12,
			PlaceholderText = "Type value..",
			PlaceholderColor3 = FromRGB(120, 120, 120),
			Text = tostring(Properties.Default or Properties.Min or 0),
			TextColor3 = FromRGB(255,255,255),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClearTextOnFocus = false,
			Position = UDim2New(0, 60, 0, 0),
			Size = UDim2New(1, -68, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right
		}) tb:AddToTheme({TextColor3 = "Text"})

		Library:Connect(tb.Instance.FocusLost, function()
			local v = tonumber(tb.Instance.Text)
			if v then
				v = math.clamp(v, Properties.Min or 0, Properties.Max or 100)
				s:Set(v)
			end
			tb.Instance.Text = tostring(Library.Flags[Properties.Flag] or v or "")
		end)

		if Properties.Flag and Library.SetFlags[Properties.Flag] then
			local prevSet = Library.SetFlags[Properties.Flag]
			Library.SetFlags[Properties.Flag] = function(val)
				prevSet(val)
				tb.Instance.Text = tostring(Library.Flags[Properties.Flag] or val)
			end
		end

		s.Items = s.Items or {}
		s.Items.Inputbox = tb
		s.Items.InputHolder = box
		return s
	end

	Library.Sections.Header = function(self, Text)
		local h = { Section = self }
		local Items = {}
		Items.Holder = Library:CreateInstance("Frame", {
			Parent = self.Items["Content"].Instance,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2New(1, 0, 0, 18)
		})
		Items.Label = Library:CreateInstance("TextLabel", {
			Parent = Items.Holder.Instance,
			FontFace = Library.Font,
			TextSize = 13,
			Text = Text or "",
			TextColor3 = FromRGB(232, 186, 248),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0, 0, 0, 0),
			Size = UDim2New(1, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Left
		}) Items.Label:AddToTheme({TextColor3 = "Accent"})
		h.Items = Items
		return h
	end
end
