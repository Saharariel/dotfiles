-- OpenWhispr keybinds (converted from openwhispr-binds.conf for Hyprland >= 0.57)
-- If you delete this file, also remove the matching require line from hyprland.lua.
hl.bind("CTRL + ALT + M", hl.dsp.exec_cmd("dbus-send --session --type=method_call --dest=com.openwhispr.App /com/openwhispr/App com.openwhispr.App.Toggle"))
