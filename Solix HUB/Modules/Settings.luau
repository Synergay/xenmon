return function(Library)
	local UIS = game:GetService("UserInputService")

	Library.SettingsPage = function(self, Window, Properties)
		Properties = Properties or {}
		local p = Window:Page({ Name = Properties.Name or "Settings", Columns = 2 })
		local s = p:Section({ Name = "UI", Side = 1 })
		local s2 = p:Section({ Name = "Configs", Side = 2 })
		local s3 = p:Section({ Name = "Theme", Side = 2 })

		local capturing = false

		s:Label("Menu Keybind", "Left")
		local kb = s:Button({ Name = "Click to bind: "..tostring(Library.MenuKeybind), Callback = function(self_)
			if capturing then return end
			capturing = true
			self_:SetText("Press a key..")
			local conn; conn = UIS.InputBegan:Connect(function(Input, gp)
				local k = tostring(Input.KeyCode)
				if k == "Enum.KeyCode.Unknown" then k = tostring(Input.UserInputType) end
				Library.MenuKeybind = k
				self_:SetText("Click to bind: "..k)
				capturing = false
				if conn then conn:Disconnect() end
			end)
		end })

		if s.Slider then
			s:Slider({ Name = "Tween Speed", Min = 0.05, Max = 1, Default = Library.Tween.Time, Float = 0.05, Suffix = "s",
				Callback = function(v) Library.Tween.Time = v end })
		end

		if Library.WatermarkX or Library.Watermark then
			s:Toggle({ Name = "Watermark", Default = false, Callback = function(v)
				if Library.__wm then Library.__wm:SetVisible(v) end
			end })
		end

		s2:Button({ Name = "Save Config", Callback = function()
			local data = Library:GetConfig()
			local name = "config_"..tostring(game.GameId)..".json"
			writefile(Library.Folders.Configs.."/"..name, data)
			if Library.Notification then Library:Notification("Config saved", name, 2) end
		end })
		s2:Button({ Name = "Load Config", Callback = function()
			local name = "config_"..tostring(game.GameId)..".json"
			local p2 = Library.Folders.Configs.."/"..name
			if isfile(p2) then
				Library:LoadConfig(readfile(p2))
				if Library.Notification then Library:Notification("Config loaded", name, 2) end
			end
		end })
		s2:Button({ Name = "Unload UI", Callback = function() Library:Unload() end })

		s3:Label("Theme", "Left")
		local themes = {}
		for n, _ in pairs(Library.Themes or {}) do table.insert(themes, n) end
		if #themes > 0 and s3.Dropdown then
			s3:Dropdown({ Name = "Preset", Items = themes, Default = themes[1], Callback = function(v)
				if Library.LoadTheme then Library:LoadTheme(v)
				elseif Library.Themes[v] then
					for k, c in pairs(Library.Themes[v]) do Library:ChangeTheme(k, c) end
				end
			end })
		end

		return p
	end
end
