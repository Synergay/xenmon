return function(Library)
	local UDim2New, UDimNew, V2 = UDim2.new, UDim.new, Vector2.new
	local FromRGB = Color3.fromRGB
	local UIS, TS = game:GetService("UserInputService"), game:GetService("TweenService")
	local TI = TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

	local origSection = Library.Pages.Section

	Library.Pages.Section = function(self, Properties)
		Properties = Properties or {}
		local collapsible = Properties.Collapsible or Properties.collapsible
		local resizable = Properties.Resizable or Properties.resizable
		local minH = Properties.MinHeight or 80
		local maxH = Properties.MaxHeight or 9999

		local sec = origSection(self, Properties)
		if not sec or not sec.Items then return sec end
		local section = sec.Items["Section"]
		local content = sec.Items["Content"]
		if not section or not content then return sec end

		if collapsible then
			section.Instance.ClipsDescendants = true

			local btn = Library:CreateInstance("ImageButton", {
				Parent = section.Instance,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = V2(1, 0),
				Position = UDim2New(1, -8, 0, 9),
				Size = UDim2New(0, 12, 0, 12),
				Image = "rbxassetid://6034818372",
				AutoButtonColor = false,
				Rotation = 0,
				ZIndex = 5
			}) btn:AddToTheme({ImageColor3 = "Text"})

			local open = true
			local sizeBeforeCollapse

			local function setOpen(v)
				if v == open then return end
				open = v
				if open then
					content.Instance.Visible = true
					TS:Create(btn.Instance, TI, {Rotation = 0}):Play()
					if sizeBeforeCollapse then
						TS:Create(section.Instance, TI, {Size = sizeBeforeCollapse}):Play()
					end
					task.delay(0.05, function()
						section.Instance.AutomaticSize = Enum.AutomaticSize.Y
					end)
				else
					sizeBeforeCollapse = UDim2New(section.Instance.Size.X.Scale, section.Instance.Size.X.Offset, 0, section.Instance.AbsoluteSize.Y)
					section.Instance.AutomaticSize = Enum.AutomaticSize.None
					TS:Create(btn.Instance, TI, {Rotation = -90}):Play()
					local target = UDim2New(sizeBeforeCollapse.X.Scale, sizeBeforeCollapse.X.Offset, 0, 32)
					local tw = TS:Create(section.Instance, TI, {Size = target})
					tw.Completed:Connect(function() if not open then content.Instance.Visible = false end end)
					tw:Play()
				end
			end

			btn:Connect("MouseButton1Click", function() setOpen(not open) end)
			sec.SetCollapsed = function(_, b) setOpen(not b) end
			sec.IsCollapsed = function() return not open end
		end

		if resizable then
			local handle = Library:CreateInstance("Frame", {
				Parent = section.Instance,
				Name = "\0",
				AnchorPoint = V2(0.5, 0),
				Position = UDim2New(0.5, 0, 0, 32),
				Size = UDim2New(0, 28, 0, 3),
				BackgroundColor3 = FromRGB(232, 186, 248),
				BorderSizePixel = 0,
				BackgroundTransparency = 0.55,
				ZIndex = 6
			}) handle:AddToTheme({BackgroundColor3 = "Accent"})
			Library:CreateInstance("UICorner", {Parent = handle.Instance, CornerRadius = UDimNew(1, 0)})

			local resizing, startY, startH = false, 0, 0

			handle:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					resizing = true
					startY = Input.Position.Y
					startH = section.Instance.AbsoluteSize.Y
					section.Instance.AutomaticSize = Enum.AutomaticSize.None
					local cc; cc = Input.Changed:Connect(function()
						if Input.UserInputState == Enum.UserInputState.End then
							resizing = false
							if cc then cc:Disconnect(); cc = nil end
						end
					end)
				end
			end)

			Library:Connect(UIS.InputChanged, function(Input)
				if not resizing then return end
				if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
					local dy = Input.Position.Y - startY
					local nh = math.clamp(startH + dy, minH, maxH)
					section.Instance.Size = UDim2New(section.Instance.Size.X.Scale, section.Instance.Size.X.Offset, 0, nh)
				end
			end)

			handle:Connect("MouseEnter", function()
				TS:Create(handle.Instance, TI, {BackgroundTransparency = 0, Size = UDim2New(0, 40, 0, 4)}):Play()
			end)
			handle:Connect("MouseLeave", function()
				if resizing then return end
				TS:Create(handle.Instance, TI, {BackgroundTransparency = 0.55, Size = UDim2New(0, 28, 0, 3)}):Play()
			end)
		end

		return sec
	end
end
