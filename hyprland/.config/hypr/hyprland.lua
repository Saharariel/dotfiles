-- Hyprland config (Lua, Hyprland >= 0.57)
-- Converted from the legacy hyprland.conf when Hyprland 0.57 dropped hyprlang configs.
-- Wiki: https://wiki.hypr.land/configuring/

require("openwhispr-binds")


------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-3", mode = "highres", position = "auto-left",  scale = 1.25 })
hl.monitor({ output = "DP-2", mode = "highres", position = "auto-right", scale = 1, transform = 3 })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "vicinae toggle"
local browser     = "flatpak run com.brave.Browser"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & hyprpaper & hypridle & dunst &")
    hl.exec_cmd("GSK_RENDERER=cairo swayosd-server 2>/dev/null")
    hl.exec_cmd("/usr/libexec/pam_kwallet_init") -- KDE Wallet unlock with SDDM
    -- Polkit agent for GUI password prompts. Bazzite ships KDE's, but its
    -- autostart entry is KDE-only, so start it here.
    hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")
    hl.exec_cmd("vicinae server")                -- exclude this if using uwsm
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- Permission changes require a Hyprland restart.

-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 2,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true, -- Keep splits fixed so togglesplit can change their direction
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
        vrr                     = 2, -- Adaptive sync only for fullscreen windows (games); both monitors support 48-165Hz
    },

    input = {
        kb_layout  = "us,il",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

-- Animations (same values as the old config)
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


---------------
---- INPUT ----
---------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

local function key(combo)
    return mainMod .. " + " .. combo
end

hl.bind(key("Return"), hl.dsp.exec_cmd(terminal))
hl.bind(key("Q"),      hl.dsp.window.close())
hl.bind(key("M"),      hl.dsp.exit())
hl.bind(key("E"),      hl.dsp.exec_cmd(fileManager))
hl.bind(key("V"),      hl.dsp.exec_cmd("vicinae vicinae://launch/clipboard/history"))
hl.bind(key("Space"),  hl.dsp.exec_cmd(menu))
hl.bind(key("P"),      hl.dsp.window.pseudo())          -- dwindle
hl.bind(key("J"),      hl.dsp.layout("togglesplit"))     -- dwindle
hl.bind(key("L"),      hl.dsp.exec_cmd(browser))
hl.bind(key("T"),      hl.dsp.exec_cmd("hyprlock"))
hl.bind(key("R"),      hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/launch.sh"))
hl.bind(key("Home"),   hl.dsp.exec_cmd("systemctl hibernate"))

-- Screenshot: area to clipboard
hl.bind(key("SHIFT + S"), hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Move focus with mainMod + arrow keys
hl.bind(key("left"),  hl.dsp.focus({ direction = "left" }))
hl.bind(key("right"), hl.dsp.focus({ direction = "right" }))
hl.bind(key("up"),    hl.dsp.focus({ direction = "up" }))
hl.bind(key("down"),  hl.dsp.focus({ direction = "down" }))

-- Alt Tab: previous workspace
hl.bind("ALT + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Switch workspaces with mainMod + [0-9], move window with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local k = i % 10 -- workspace 10 is key 0
    hl.bind(key(k),              hl.dsp.focus({ workspace = i }))
    hl.bind(key("SHIFT + " .. k), hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(key("mouse_down"), hl.dsp.focus({ workspace = "e+1" }))
hl.bind(key("mouse_up"),   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(key("mouse:272"), hl.dsp.window.drag(),   { mouse = true })
hl.bind(key("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Mute keys
hl.bind("XF86AudioMute",    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- Media keys (requires playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Volume and brightness with the swayosd popup
local focusedMonitor = [["$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"]]
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --monitor " .. focusedMonitor .. " --output-volume raise"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --monitor " .. focusedMonitor .. " --output-volume lower"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Workspaces 1-4 on the main monitor, 5-7 on the vertical one
for i = 1, 4 do hl.workspace_rule({ workspace = tostring(i), monitor = "DP-3" }) end
for i = 5, 7 do hl.workspace_rule({ workspace = tostring(i), monitor = "DP-2" }) end

-- Discord on workspace 5
hl.window_rule({
    name      = "discord-workspace",
    match     = { class = "^(discord)$" },
    workspace = "5",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drag",
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
