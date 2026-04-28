local BASE = (getgenv().SolixBase) or "https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/"

local function fetch(p) return game:HttpGet(BASE..p) end
local function load(p) return loadstring(fetch(p), p)() end

local Library = load("SolixMain.luau")

local mods = { "Image", "Loading", "Watermark", "Resizable", "Settings" }
for _, m in ipairs(mods) do
	local ok, err = pcall(function() load("Modules/"..m..".luau")(Library) end)
	if not ok then warn("[Solix] "..m.." failed: "..tostring(err)) end
end

getgenv().Library = Library
return Library
