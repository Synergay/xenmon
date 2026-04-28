return function(Library)
	local UDim2New, UDimNew, V2 = UDim2.new, UDim.new, Vector2.new
	local FromRGB = Color3.fromRGB
	local RS, UIS, Stats, Players = game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Stats"), game:GetService("Players")
	local LP = Players.LocalPlayer

	Library.WatermarkX = function(self, Properties)
		Properties = Properties or {}
		local W = {
			Format = Properties.Format or Properties.format or "{name} | {fps} fps | {ping} ms | {user}",
			Name = Properties.Name or Properties.name or self.Name or "solix",
			Anchor = Properties.Anchor or Properties.anchor or "TopRight",
			Visible = Properties.Visible ~= false,
			TickRate = Properties.TickRate or 0.5
		}

		local Frame = self:CreateInstance("Frame", {
			Parent = self.Holder.Instance,
			Name = "\0",
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2New(0, 0, 0, 28),
			BackgroundColor3 = FromRGB(15,12,16),
			Visible = W.Visible
		}) Frame:AddToTheme({BackgroundColor3 = "Background"})
		Frame:MakeDraggable()

		self:CreateInstance("UICorner", { Parent = Frame.Instance, CornerRadius = UDimNew(0,5) })

		local Stroke = self:CreateInstance("UIStroke", {
			Parent = Frame.Instance,
			Thickness = 1,
			Color = FromRGB(41,37,45)
		}) Stroke:AddToTheme({Color = "Border"})

		local Accent = self:CreateInstance("Frame", {
			Parent = Frame.Instance,
			Name = "\0",
			Size = UDim2New(0,3,1,-8),
			Position = UDim2New(0,5,0,4),
			BackgroundColor3 = FromRGB(232,186,248),
			BorderSizePixel = 0
		}) Accent:AddToTheme({BackgroundColor3 = "Accent"})
		self:CreateInstance("UICorner", { Parent = Accent.Instance, CornerRadius = UDimNew(1,0) })

		local Pad = self:CreateInstance("UIPadding", {
			Parent = Frame.Instance,
			PaddingLeft = UDimNew(0,14),
			PaddingRight = UDimNew(0,8),
			PaddingTop = UDimNew(0,6),
			PaddingBottom = UDimNew(0,6)
		})

		local Text = self:CreateInstance("TextLabel", {
			Parent = Frame.Instance,
			FontFace = self.Font,
			TextSize = 13,
			Text = W.Name,
			TextColor3 = FromRGB(255,255,255),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2New(0,0,1,0),
			TextXAlignment = Enum.TextXAlignment.Left
		}) Text:AddToTheme({TextColor3 = "Text"})

		local function applyAnchor()
			local a = W.Anchor
			if a == "TopRight" then
				Frame.Instance.AnchorPoint = V2(1,0); Frame.Instance.Position = UDim2New(1,-12,0,12)
			elseif a == "TopLeft" then
				Frame.Instance.AnchorPoint = V2(0,0); Frame.Instance.Position = UDim2New(0,12,0,12)
			elseif a == "TopCenter" then
				Frame.Instance.AnchorPoint = V2(0.5,0); Frame.Instance.Position = UDim2New(0.5,0,0,12)
			elseif a == "BottomRight" then
				Frame.Instance.AnchorPoint = V2(1,1); Frame.Instance.Position = UDim2New(1,-12,1,-12)
			elseif a == "BottomLeft" then
				Frame.Instance.AnchorPoint = V2(0,1); Frame.Instance.Position = UDim2New(0,12,1,-12)
			end
		end
		applyAnchor()

		local fps, ft, fc = 60, tick(), 0
		local last = 0

		Library:Connect(RS.RenderStepped, function()
			fc += 1
			local t = tick()
			if t - ft >= 1 then fps = fc; ft = t; fc = 0 end
			if t - last < W.TickRate then return end
			last = t
			local ping = 0
			pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			local s = W.Format
			s = s:gsub("{name}", W.Name)
			s = s:gsub("{fps}", tostring(fps))
			s = s:gsub("{ping}", tostring(ping))
			s = s:gsub("{user}", LP and LP.Name or "?")
			s = s:gsub("{time}", os.date("%H:%M:%S"))
			s = s:gsub("{place}", tostring(game.PlaceId))
			Text.Instance.Text = s
		end)

		function W:SetVisible(b) Frame.Instance.Visible = b end
		function W:SetFormat(f) self.Format = f end
		function W:SetAnchor(a) self.Anchor = a; applyAnchor() end
		function W:SetName(n) self.Name = n end
		function W:SetTickRate(r) self.TickRate = math.max(r or 0.5, 0.05) end
		W.Items = { Frame = Frame, Text = Text }
		return W
	end
end
