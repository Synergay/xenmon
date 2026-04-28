local BASE = (getgenv().SolixBase) or "https://raw.githubusercontent.com/Synergay/xenmon/main/Solix%20HUB/"

local function fetch(p)
	local ok, body = pcall(game.HttpGet, game, BASE..p)
	if not ok then error("[Solix] HTTP failed for "..p..": "..tostring(body), 0) end
	if #body < 60 and (body:find("404") or body:find("Not Found")) then
		error("[Solix] 404 for "..p.." — check repo path/branch. URL: "..BASE..p, 0)
	end
	return body
end

local function load(p)
	local src = fetch(p)
	local fn, err = loadstring(src, p)
	if not fn then error("[Solix] compile error in "..p..": "..tostring(err), 0) end
	return fn()
end

local Library = load("SolixMain.luau")

local mods = { "Image", "Loading", "Watermark", "Resizable", "Settings" }
for _, m in ipairs(mods) do
	local ok, err = pcall(function() load("Modules/"..m..".luau")(Library) end)
	if not ok then warn("[Solix] "..m.." failed: "..tostring(err)) end
end

getgenv().Library = Library
return Library
