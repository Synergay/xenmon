return function(Library)
	local UDim2New, UDimNew = UDim2.new, UDim.new
	local FromRGB = Color3.fromRGB

	local function resolve(src)
		if typeof(src) == "number" then return "rbxassetid://"..src end
		if type(src) ~= "string" or src == "" then return "" end
		if src:sub(1,13) == "rbxassetid://" or src:sub(1,11) == "rbxasset://" then return src end
		if src:match("^%d+$") then return "rbxassetid://"..src end
		if Library.Images[src] then return Library:GetImage(src) end
		if src:sub(1,4) == "http" then
			local p = (Library.Folders.Assets).."/img_"..tostring(#src).."_"..tostring(string.byte(src, -1) or 0)..".png"
			if not isfile(p) then
				local ok, body = pcall(game.HttpGet, game, src)
				if ok then writefile(p, body) else return src end
			end
			local ok2, asset = pcall(getcustomasset, p)
			if ok2 then return asset end
		end
		return src
	end

	Library.ResolveImage = function(_, src) return resolve(src) end

	Library.Sections.Image = function(self, Properties)
		Properties = Properties or {}
		local img = {
			Section = self,
			Image = Properties.Image or Properties.image or "",
			Height = Properties.Height or Properties.height or 80,
			ScaleType = Properties.ScaleType or Properties.scaletype or Enum.ScaleType.Fit,
			Tooltip = Properties.Tooltip or Properties.tooltip,
			Rounded = Properties.Rounded ~= false,
		}

		local Items = {}

		Items.Holder = Library:CreateInstance("Frame", {
			Parent = self.Items["Content"].Instance,
			Name = "\0",
			BackgroundTransparency = 1,
			Size = UDim2New(1, 0, 0, img.Height),
			BorderSizePixel = 0,
			BackgroundColor3 = FromRGB(255,255,255)
		})

		Items.Image = Library:CreateInstance("ImageLabel", {
			Parent = Items.Holder.Instance,
			Name = "\0",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2New(1, 0, 1, 0),
			ScaleType = img.ScaleType,
			Image = resolve(img.Image),
			BackgroundColor3 = FromRGB(255,255,255)
		})

		if img.Rounded then
			Library:CreateInstance("UICorner", {
				Parent = Items.Image.Instance,
				CornerRadius = UDimNew(0, 6)
			})
		end

		if img.Tooltip then
			Items.Image:Tooltip(img.Tooltip)
		end

		function img:SetImage(src)
			self.Image = src
			Items.Image.Instance.Image = resolve(src)
		end
		function img:SetHeight(h)
			self.Height = h
			Items.Holder.Instance.Size = UDim2New(1, 0, 0, h)
		end
		function img:SetVisible(b) Items.Holder.Instance.Visible = b end
		function img:SetScaleType(s) Items.Image.Instance.ScaleType = s end

		img.Items = Items
		return img
	end

	Library.Sections.Banner = function(self, Properties)
		Properties = Properties or {}
		local b = {
			Section = self,
			Image = Properties.Image or "",
			Title = Properties.Title or "",
			Subtitle = Properties.Subtitle or "",
			Height = Properties.Height or 64
		}

		local Items = {}
		Items.Holder = Library:CreateInstance("Frame", {
			Parent = self.Items["Content"].Instance,
			Name = "\0",
			BackgroundTransparency = 0,
			Size = UDim2New(1, 0, 0, b.Height),
			BorderSizePixel = 0,
			BackgroundColor3 = FromRGB(22,20,24)
		}) Items.Holder:AddToTheme({BackgroundColor3 = "Inline"})

		Library:CreateInstance("UICorner", { Parent = Items.Holder.Instance, CornerRadius = UDimNew(0,6) })

		Items.Image = Library:CreateInstance("ImageLabel", {
			Parent = Items.Holder.Instance,
			Name = "\0",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2New(0, 8, 0.5, 0),
			Size = UDim2New(0, b.Height-16, 0, b.Height-16),
			ScaleType = Enum.ScaleType.Fit,
			Image = resolve(b.Image)
		})
		Library:CreateInstance("UICorner", { Parent = Items.Image.Instance, CornerRadius = UDimNew(0,5) })

		Items.Title = Library:CreateInstance("TextLabel", {
			Parent = Items.Holder.Instance,
			Name = "\0",
			FontFace = Library.Font,
			TextSize = 14,
			Text = b.Title,
			TextColor3 = FromRGB(255,255,255),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0, b.Height, 0, 10),
			Size = UDim2New(1, -b.Height-10, 0, 16)
		}) Items.Title:AddToTheme({TextColor3 = "Text"})

		Items.Sub = Library:CreateInstance("TextLabel", {
			Parent = Items.Holder.Instance,
			Name = "\0",
			FontFace = Library.Font,
			TextSize = 12,
			Text = b.Subtitle,
			TextColor3 = FromRGB(185,185,185),
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2New(0, b.Height, 0, 30),
			Size = UDim2New(1, -b.Height-10, 0, 14),
			TextWrapped = true
		}) Items.Sub:AddToTheme({TextColor3 = "Inactive Text"})

		function b:SetImage(s) Items.Image.Instance.Image = resolve(s) end
		function b:SetTitle(t) Items.Title.Instance.Text = t end
		function b:SetSubtitle(t) Items.Sub.Instance.Text = t end

		b.Items = Items
		return b
	end
end
