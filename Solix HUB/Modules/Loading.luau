return function(Library)
	local UDim2New, UDimNew, V2 = UDim2.new, UDim.new, Vector2.new
	local FromRGB = Color3.fromRGB
	local TS = game:GetService("TweenService")

	Library.Loading = function(self, Properties)
		Properties = Properties or {}
		local L = {
			Title = Properties.Title or Properties.title or self.Name or "Loading",
			Subtitle = Properties.Subtitle or Properties.subtitle or "Initializing..",
			Duration = Properties.Duration or Properties.duration or 0,
			Image = Properties.Image or Properties.image,
			Steps = Properties.Steps or Properties.steps,
			OnDone = Properties.OnDone or Properties.ondone,
			Progress = 0
		}

		local Holder = self:CreateInstance("ScreenGui", {
			Parent = gethui(),
			Name = "\0",
			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			DisplayOrder = 50,
			ResetOnSpawn = false
		})

		local BG = self:CreateInstance("Frame", {
			Parent = Holder.Instance,
			Name = "\0",
			Size = UDim2New(1,0,1,0),
			BackgroundTransparency = 0,
			BackgroundColor3 = FromRGB(0,0,0),
			BorderSizePixel = 0
		})

		local Card = self:CreateInstance("Frame", {
			Parent = Holder.Instance,
			Name = "\0",
			AnchorPoint = V2(0.5,0.5),
			Position = UDim2New(0.5,0,0.5,0),
			Size = UDim2New(0,360,0,140),
			BackgroundColor3 = FromRGB(15,12,16),
			BorderSizePixel = 0
		}) Card:AddToTheme({BackgroundColor3 = "Background"})

		self:CreateInstance("UICorner", { Parent = Card.Instance, CornerRadius = UDimNew(0,8) })

		local Stroke = self:CreateInstance("UIStroke", {
			Parent = Card.Instance,
			Thickness = 1,
			Color = FromRGB(41,37,45)
		}) Stroke:AddToTheme({Color = "Border"})

		local Shadow = self:CreateInstance("ImageLabel", {
			Parent = Card.Instance,
			Name = "\0",
			ImageTransparency = 0.55,
			AnchorPoint = V2(0.5,0.5),
			Image = "rbxassetid://112971167999062",
			ZIndex = -1,
			BackgroundTransparency = 1,
			SliceCenter = Rect.new(V2(112,112), V2(147,147)),
			ScaleType = Enum.ScaleType.Slice,
			Position = UDim2New(0.5,0,0.5,0),
			SliceScale = 0.6,
			Size = UDim2New(1, 60, 1, 60)
		}) Shadow:AddToTheme({ImageColor3 = "Shadow"})

		local iconOff = 0
		if L.Image then
			local img = self:CreateInstance("ImageLabel", {
				Parent = Card.Instance,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2New(0,16,0,16),
				Size = UDim2New(0,40,0,40),
				ScaleType = Enum.ScaleType.Fit,
				Image = (self.ResolveImage and self:ResolveImage(L.Image)) or L.Image
			})
			self:CreateInstance("UICorner", { Parent = img.Instance, CornerRadius = UDimNew(0,6) })
			iconOff = 56
		end

		local Title = self:CreateInstance("TextLabel", {
			Parent = Card.Instance,
			FontFace = self.Font,
			TextSize = 16,
			Text = L.Title,
			TextColor3 = FromRGB(255,255,255),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0,16+iconOff,0,18),
			Size = UDim2New(1,-32-iconOff,0,18)
		}) Title:AddToTheme({TextColor3 = "Text"})

		local Sub = self:CreateInstance("TextLabel", {
			Parent = Card.Instance,
			FontFace = self.Font,
			TextSize = 13,
			Text = L.Subtitle,
			TextColor3 = FromRGB(185,185,185),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0,16+iconOff,0,40),
			Size = UDim2New(1,-32-iconOff,0,16),
			TextTruncate = Enum.TextTruncate.AtEnd
		}) Sub:AddToTheme({TextColor3 = "Inactive Text"})

		local BarBG = self:CreateInstance("Frame", {
			Parent = Card.Instance,
			Position = UDim2New(0,16,1,-32),
			Size = UDim2New(1,-32,0,8),
			BackgroundColor3 = FromRGB(22,20,24),
			BorderSizePixel = 0
		}) BarBG:AddToTheme({BackgroundColor3 = "Inline"})
		self:CreateInstance("UICorner", { Parent = BarBG.Instance, CornerRadius = UDimNew(1,0) })

		local Bar = self:CreateInstance("Frame", {
			Parent = BarBG.Instance,
			Size = UDim2New(0,0,1,0),
			BackgroundColor3 = FromRGB(232,186,248),
			BorderSizePixel = 0
		}) Bar:AddToTheme({BackgroundColor3 = "Accent"})
		self:CreateInstance("UICorner", { Parent = Bar.Instance, CornerRadius = UDimNew(1,0) })

		local Pct = self:CreateInstance("TextLabel", {
			Parent = Card.Instance,
			FontFace = self.Font,
			TextSize = 11,
			Text = "0%",
			TextColor3 = FromRGB(185,185,185),
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(1,-48,1,-50),
			Size = UDim2New(0,32,0,14)
		}) Pct:AddToTheme({TextColor3 = "Inactive Text"})

		local done = false
		local fast = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

		function L:SetProgress(v, text)
			v = math.clamp(tonumber(v) or 0, 0, 1)
			self.Progress = v
			TS:Create(Bar.Instance, fast, {Size = UDim2New(v,0,1,0)}):Play()
			Pct.Instance.Text = math.floor(v*100).."%"
			if text then Sub.Instance.Text = text end
		end

		function L:SetSubtitle(t) Sub.Instance.Text = t end
		function L:SetTitle(t) Title.Instance.Text = t end

		function L:Finish(cb)
			if done then return end
			done = true
			self:SetProgress(1)
			task.wait(0.15)
			local out = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			TS:Create(BG.Instance, out, {BackgroundTransparency = 1}):Play()
			TS:Create(Card.Instance, out, {BackgroundTransparency = 1, Position = UDim2New(0.5,0,0.5,-20)}):Play()
			for _, d in Card.Instance:GetDescendants() do
				if d:IsA("TextLabel") then TS:Create(d, out, {TextTransparency = 1}):Play()
				elseif d:IsA("ImageLabel") then TS:Create(d, out, {ImageTransparency = 1}):Play()
				elseif d:IsA("Frame") then TS:Create(d, out, {BackgroundTransparency = 1}):Play()
				elseif d:IsA("UIStroke") then TS:Create(d, out, {Transparency = 1}):Play() end
			end
			task.wait(0.4)
			Holder:Clean()
			if cb then cb() end
			if L.OnDone then L.OnDone() end
		end

		if L.Steps and type(L.Steps) == "table" then
			task.spawn(function()
				local n = #L.Steps
				for i, step in ipairs(L.Steps) do
					if type(step) == "table" then
						L:SetProgress(i/n, step.Text or step.text)
						if step.Action then pcall(step.Action) end
						task.wait(step.Wait or step.wait or 0.15)
					elseif type(step) == "string" then
						L:SetProgress(i/n, step)
						task.wait(0.15)
					elseif type(step) == "function" then
						pcall(step, L)
						L:SetProgress(i/n)
					end
				end
				L:Finish()
			end)
		elseif L.Duration > 0 then
			task.spawn(function()
				local t0 = tick()
				while tick() - t0 < L.Duration do
					L:SetProgress((tick()-t0)/L.Duration)
					task.wait()
				end
				L:Finish()
			end)
		end

		L.Items = { Holder = Holder, Card = Card, Bar = Bar, Title = Title, Sub = Sub, Pct = Pct }
		return L
	end
end
