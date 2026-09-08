-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


local bar_height = 40
local cfg_gaps_out = 0
local cfg_border_size = 1

------------------
---- MONITORS ----
------------------
local mon_x = 2560
local mon_y = 1440

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
local function def_monitor (t_mon_x, t_mon_y)
  hl.monitor({
      output   = "DP-3",
      mode     = t_mon_x .. "x" .. t_mon_y .. "@144",
      position = "auto",
      scale    = "auto",
  })
end

def_monitor(mon_x, mon_y)

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
    render = {
    },
    cursor = {
        no_hardware_cursors = true,
    }
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "alacritty"
local fileManager = "dolphin"
local menu        = "fuzzel"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
  hl.exec_cmd("noctalia")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_THEME", "capitaine-cursors")
hl.env("XCURSOR_THEME", "capitaine-cursors")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.window_rule({
  match = { class= ".*" };
  float = true,
})

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = cfg_gaps_out,

        border_size = cfg_border_size,

        col = {
            active_border   = { colors = { "rgb(b8bb26)", "rgb(fabd2f)" }, angle = 45 },
            inactive_border = "rgb(665c54)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "master",
    },

    decoration = {
        rounding       = 1,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 20,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 10.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 9, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 8,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2.8, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 3, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 3, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 6, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 7, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 3,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 3, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 2.8, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 3, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 2.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 3, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 14,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
	mfact = 0.5
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 0,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- ########## SNAP TO HALF SCREEN ##########

-- Snap active floating window to left half
local function snap_left()
    os.execute("hyprctl dispatch resizeactive exact 50% 100%")
    os.execute("hyprctl dispatch moveactive exact 0 0")
end

-- Snap active floating window to right half
local function snap_right()
    os.execute("hyprctl dispatch resizeactive exact 50% 100%")
    os.execute("hyprctl dispatch moveactive exact 50% 0")
end

-- Snap active floating window to top half
local function snap_top()
    os.execute("hyprctl dispatch resizeactive exact 100% 50%")
    os.execute("hyprctl dispatch moveactive exact 0 0")
end

-- Snap active floating window to bottom half
local function snap_bottom()
    os.execute("hyprctl dispatch resizeactive exact 100% 50%")
    os.execute("hyprctl dispatch moveactive exact 0 50%")
end


local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + W", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
--
-- Focus with arrow keys + raise
hl.bind(mainMod .. " + H", function()
    hl.dispatch(hl.dsp.focus({ direction = "left" }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind(mainMod .. " + L", function()
    hl.dispatch(hl.dsp.focus({ direction = "right" }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind(mainMod .. " + K", function()
    hl.dispatch(hl.dsp.focus({ direction = "up" }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind(mainMod .. " + J", function()
    hl.dispatch(hl.dsp.focus({ direction = "down" }))
    hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

hl.bind("ALT + TAB", hl.dsp.exec_cmd("noctalia msg window-switcher"))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + S",         hl.dsp.exec_cmd("flameshot full"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("flameshot gui"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + SHIFT + M", function ()
    local ws = hl.get_workspace("special:minimized")
    
    -- Check if the special workspace exists AND actually has windows in it
    if ws and ws.windows > 0 then
        -- Toggle it visible so we can target it, then bring windows to current workspace
        hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
        hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    else
        -- No windows are minimized: send the active window to the scratchpad
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end)

hl.bind(mainMod .. " + RETURN", hl.dsp.layout("swapwithmaster master"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.layout("swapnext loop"))

hl.bind(mainMod .. " + SHIFT + ALT + LEFT", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + ALT + RIGHT", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + ALT + UP", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + ALT + DOWN", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + LEFT", function()
  hl.dispatch(hl.dsp.window.resize({ x = mon_x*0.5-cfg_border_size-cfg_gaps_out, y = mon_y-bar_height-cfg_border_size*2-cfg_gaps_out*2 }))
  hl.dispatch(hl.dsp.window.move({ x = cfg_border_size+cfg_gaps_out, y = bar_height+cfg_border_size }))
end)
hl.bind(mainMod .. " + SHIFT + RIGHT", function()
  hl.dispatch(hl.dsp.window.resize({ x = mon_x*0.5-cfg_border_size-cfg_gaps_out, y = mon_y-bar_height-cfg_border_size*2-cfg_gaps_out*2 }))
  hl.dispatch(hl.dsp.window.move({ x = mon_x*0.5+cfg_border_size, y = bar_height+cfg_border_size }))
end)
hl.bind(mainMod .. " + SHIFT + DOWN", function()
  hl.dispatch(hl.dsp.window.resize({ x = mon_x-cfg_border_size*2-cfg_gaps_out*2, y = mon_y*0.5-cfg_border_size-cfg_gaps_out }))
  hl.dispatch(hl.dsp.window.move({ x = cfg_gaps_out+cfg_border_size, y = mon_y*0.5 }))
end)
hl.bind(mainMod .. " + SHIFT + UP", function()
  hl.dispatch(hl.dsp.window.resize({ x = mon_x-cfg_border_size*2-cfg_gaps_out*2, y = mon_y*0.5-bar_height }))
  hl.dispatch(hl.dsp.window.move({ x = cfg_gaps_out+cfg_border_size, y = bar_height+cfg_border_size }))
end)
hl.bind(mainMod .. " + M", function()
  hl.dispatch(hl.dsp.window.resize({ x = mon_x-cfg_gaps_out*2-cfg_border_size*2, y = mon_y-bar_height-cfg_border_size*2-cfg_gaps_out*2 }))
  hl.dispatch(hl.dsp.window.move({ x = cfg_gaps_out+cfg_border_size, y = bar_height+cfg_border_size}))
end)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + C", hl.dsp.window.center())

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


hl.window_rule({ match = { class = "firefox" }, persistent_size = true })


-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- For Noctalia Color templates
require("noctalia").apply_theme()
