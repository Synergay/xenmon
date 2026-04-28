return function(Library)
	local UDim2New, UDimNew, V2 = UDim2.new, UDim.new, Vector2.new
	local FromRGB = Color3.fromRGB
	local UIS = game:GetService("UserInputService")

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
			local title = sec.Items["Title"] or sec.Items["TitleLabel"]
			local btn = Library:CreateInstance("ImageButton", {
				Parent = section.Instance,
				Name = "\0",
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AnchorPoint = V2(1,0),
				Position = UDim2New(1,-6,0,4),
				Size = UDim2New(0,14,0,14),
				Image = "rbxassetid://6034818372",
				AutoButtonColor = false,
				ZIndex = 5
			}) btn:AddToTheme({ImageColor3 = "Text"})

			local open = true
			local savedH = section.Instance.Size

			btn:Connect("MouseButton1Click", function()
				open = not open
				if open then
					section.Instance.Size = savedH
					content.Instance.Visible = true
					btn.Instance.Rotation = 0
				else
					savedH = section.Instance.Size
					content.Instance.Visible = false
					section.Instance.Size = UDim2New(savedH.X.Scale, savedH.X.Offset, 0, 28)
					btn.Instance.Rotation = -90
				end
			end)

			sec.SetCollapsed = function(_, b)
				if (not b) ~= open then btn:Connect("MouseButton1Click") end
			end
		end

		if resizable then
			local handle = Library:CreateInstance("Frame", {
				Parent = section.Instance,
				Name = "\0",
				AnchorPoint = V2(0.5,1),
				Position = UDim2New(0.5,0,1,0),
				Size = UDim2New(0,30,0,4),
				BackgroundColor3 = FromRGB(232,186,248),
				BorderSizePixel = 0,
				BackgroundTransparency = 0.5,
				ZIndex = 6
			}) handle:AddToTheme({BackgroundColor3 = "Accent"})
			Library:CreateInstance("UICorner", { Parent = handle.Instance, CornerRadius = UDimNew(1,0) })

			local resizing, startY, startH = false, 0, 0

			handle:Connect("InputBegan", function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					resizing = true
					startY = Input.Position.Y
					startH = section.Instance.AbsoluteSize.Y
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

			handle:Connect("MouseEnter", function() handle.Instance.BackgroundTransparency = 0 end)
			handle:Connect("MouseLeave", function() handle.Instance.BackgroundTransparency = 0.5 end)
		end

		return sec
	end
end
