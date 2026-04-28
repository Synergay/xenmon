# Solix HUB

Roblox executor UI library (eclipse-derived) with optional add-on modules.

## Quick start

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Loader.lua"))()

local Library = getgenv().Library

-- optional loading screen
local L = Library:Loading({
    Title = "Solix",
    Subtitle = "Loading components..",
    Steps = {
        { Text = "Fetching assets..", Wait = 0.2 },
        { Text = "Building UI..", Wait = 0.2 },
        { Text = "Done", Wait = 0.1 },
    },
    OnDone = function() print("loaded") end
})

local Window = Library:Window({ Name = "Solix" })
local Page = Window:Page({ Name = "Main", Columns = 2 })
local Section = Page:Section({ Name = "Visuals", Side = "Left", Collapsible = true, Resizable = true })

Section:Toggle({ Name = "Example", Default = false, Callback = function(v) print(v) end })
Section:Image({ Image = "https://i.imgur.com/4M7IWwP.png", Height = 90 })
Section:Banner({ Title = "Heads up", Subtitle = "Banner with icon support", Image = 6034818372 })

local WM = Library:WatermarkX({ Name = "Solix", Anchor = "TopRight", Format = "{name} | {fps} fps | {ping} ms" })
Library.__wm = WM

Library:SettingsPage(Window)
```

## Repo layout

```
SolixHUB/
├── Loader.lua          loadstring entry — pulls main + modules
├── SolixMain.luau      core library (returns Library on require/loadstring)
├── README.md
└── Modules/
    ├── Image.luau      Section:Image / Section:Banner / Library:ResolveImage
    ├── Loading.luau    Library:Loading({ Steps | Duration })
    ├── Watermark.luau  Library:WatermarkX (anchor + format tokens)
    ├── Resizable.luau  Page:Section({ Collapsible = true, Resizable = true })
    └── Settings.luau   Library:SettingsPage(Window)
```

## Modules

### Image

- `Section:Image{ Image, Height, ScaleType, Tooltip, Rounded }` — accepts rbxassetid (number/string), http URL (cached to disk), or registered name from `Library.Images`.
- `Section:Banner{ Title, Subtitle, Image, Height }` — icon + text card.
- `Library:ResolveImage(src)` — returns a usable rbxassetid from any of the above.

### Loading

- `Library:Loading({ Title, Subtitle, Image, Duration, Steps, OnDone })`
- `Steps` is an array of `{ Text, Wait, Action }` tables, raw strings, or functions `(L) -> ()`.
- Returns object with `:SetProgress(0..1, text)`, `:SetSubtitle`, `:SetTitle`, `:Finish(cb)`.

### Watermark

- `Library:WatermarkX({ Name, Format, Anchor, TickRate, Visible })`
- Anchors: `TopRight`, `TopLeft`, `TopCenter`, `BottomRight`, `BottomLeft`.
- Format tokens: `{name} {fps} {ping} {user} {time} {place}`.
- Draggable, theme-aware, single throttled RenderStepped (default 0.5s).

### Resizable

- Wraps `Page:Section`. Add `Collapsible = true` for a chevron button, `Resizable = true` for a vertical drag handle on the bottom edge. `MinHeight` / `MaxHeight` optional.

### Settings

- `Library:SettingsPage(Window, { Name? })` — auto-builds a page with menu rebind, tween speed, watermark toggle, save/load config, unload, theme dropdown.

## Patches included in `SolixMain.luau`

- Tooltip: removed per-frame `TweenService:Create` allocation; uses throttled `InputChanged` and direct `Position` assignment. Hover state guard prevents stale fires.
- Drag: replaced per-frame tween with direct `Position`. `Input.Changed` connection now disconnects on `End`.
- Resize: same — direct `Size` assignment, `Input.Changed` cleanup.

## Notes

- Set `getgenv().SolixBase` before running `Loader.lua` if you want a non-default base URL (handy for local testing via `rconsole` host or branches).
- The library exposes `Library:CreateInstance(class, props)` and `Library.__Instances` / `Library.__Tween` so external modules can build themed UI without touching internals.
