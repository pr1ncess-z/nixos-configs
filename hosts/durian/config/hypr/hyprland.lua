--
-- ~/.config/hypr/hyprland.lua (bare metal)
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

local terminal = "alacritty"
local menu     = "fuzzel --show drun"

hl.on("hyprland.start", function()
  hl.exec_cmd("waybar")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("wl-paste --watch cliphist store")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Gaming performance settings (bare metal only)
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    layout = "dwindle",
    allow_tearing = true,         -- ← ENABLE for FPS games
  },
  decoration = {
    rounding = 5,
  },
  animations = { enabled = false },
  render = {
    direct_scanout = true,        -- ← ENABLE lower latency
  },
})

hl.config({
  input = {
    kb_layout = "us",
    follow_mouse = 1,
  },
})

local M = "SUPER"

hl.bind(M .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(M .. " + Q",         hl.dsp.exit())
hl.bind(M .. " + W",         hl.dsp.window.close())
hl.bind(M .. " + R",         hl.dsp.exec_cmd(menu))
hl.bind(M .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(M .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(M .. " + S",         hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
hl.bind(M .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

for i = 1, 10 do
  local key = i % 10
  hl.bind(M .. " + " .. key,         hl.dsp.focus({ workspace = i }))
  hl.bind(M .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(M .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Gaming window rules
hl.window_rule({
  name = "fullscreen-games",
  match = { class = "^steam_app_.*$" },
  fullscreen = true,
})
