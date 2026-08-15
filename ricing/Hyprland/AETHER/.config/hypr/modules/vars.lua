-- modules/vars.lua

-- Copyright (C) 2026, Nicolas Scalese
---  Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html



---- #############################
---- ### ENVIRONMENT VARIABLES ###
---- #############################
------ See:  https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/


hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Inform apps that we are in a Wayland/Hyprland environment
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")


-- === GRAPHIC CARD ===
---  Manage your dual-GPU configuration:

---  (a) Rendering with iGPU Intel - battery saving
-- hl.env("WLR_DRM_DEVICES",           "/dev/dri/by-path/pci-0000:00:02.0-card:/dev/dri/by-path/pci-0000:01:00.0-card")
-- hl.env("LIBVA_DRIVER_NAME",         "i915")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "mesa")

---  (b) Rendering with dGPU NVIDIA - performance
-- hl.env("LIBVA_DRIVER_NAME",         "nvidia")
-- hl.env("GBM_BACKEND",               "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")


-- === MODERN THEMING STRATEGY ===
-- Force unified visual consistency across all Qt applications
hl.env("QT_QPA_PLATFORMTHEME" ,                "qt6ct")      -- Route configuration through qt6ct engine
-- hl.env("QT_STYLE_OVERRIDE" ,                   "kvantum")    -- Force Kvantum rendering engine globally
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION" ,  1)           -- Delegate window borders & titlebars to Hyprland




---- #####################################
---- ### MY PROGRAMS & OTHER VARIABLES ###
---- #####################################
------ Using Lua's global table (_G) so these are accessible in 'binds.lua' and 'autostart.lua'


-- === Set here your relevant directories ===
_G.home_dir             =  os.getenv("HOME")                 
_G.scripts_dir          =  os.getenv("HOME") .. "/.config/hypr/scripts"
-- _G.scripts_dir          =  os.getenv("HOME") .. "/scripts"  

---  Move all useful scripts mentioned in Hyprland configuration files in the same folder, 
----   or specify the full path for each individually where needed



-- === Set PROGRAMS that you use ===

---  Hyprland "extensions" ...
_G.status_bar           =  "waybar"
_G.notification_daemon  =  "dunst"
-- _G.auth_manager         =  "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"    -- GNOME agent, old and stable, X11-native, extra GTK dependencies
_G.auth_manager         =  "/usr/lib/xfce-polkit/xfce-polkit"                                -- XFCE agent, lightweight, Wayland-native
-- _G.idle_daemon          =  "hypridle"                                 -- Native, sometimes crashes (libsdbus-c++ regression)
_G.idle_daemon          =  "swayidle -w -C ~/.config/swayidle/config"    -- Stable and reliable alternative 
_G.binds_table          =  "alacritty -T \"Keybindings Table [$(date +\'%Y%m%d-%H%M%S\')]\" --class floating_bindsmap -e " .. scripts_dir .. "/hypr-binds-map.sh"
_G.apps_launcher        =  scripts_dir .. "/apps-launcher.sh"

----   ... including Clipboard Management
_G.clip_store_text      =  "zsh -c 'wl-paste --type text --watch cliphist store'"
_G.clipboard_selector   =  scripts_dir .. "/clipboard-selector.sh"
_G.clipboard_wipe       =  "cliphist wipe && pkill -x wofi ; notify-send -u low 'Clipboard Registry' 'Memory completely purged.'"

---  Terminal User Iterface (TUI) programds
_G.terminal             =  "alacritty -T \"Alacritty [$(date +\'%Y%m%d-%H%M%S\')]\" -e zsh --login -c \"tmux\""
_G.process_monitor      =  "alacritty -T \"BTOP (Process Monitor)\" --class floating_monitor -e btop"
_G.file_manager_TUI     =  "alacritty -T \"Yazi (File Manager) [$(date +\'%Y%m%d-%H%M%S\')]\" -e zsh --login -c \"tmux new-session yazi\""
_G.text_editor_TUI      =  "alacritty -T \"$EDITOR (Text Editor) [$(date +\'%Y%m%d-%H%M%S\')]\" -e zsh --login -c \"tmux new-session '$EDITOR'\""    -- Default text editor, multiple instances
-- _G.text_editor_TUI      =  "alacritty -T \"Micro (Text Editor) [$(date +\'%Y%m%d-%H%M%S\')]\" -e zsh --login -c \"tmux new-session micro\""       -- Simple & intuitive, recommended, multiple instances
_G.aether_logo          =  "alacritty --class aether_logo -t \"AETHER logo\" -e zsh -c \"sed -n '3,25p' " .. home_dir .. "/.config/hypr/hyprland.lua | less -r\""     -- See 'autostart.lua'

---  Graphical User Interface (GUI) programs
_G.file_manager_GUI     =  "thunar"
_G.browser              =  "librewolf"
_G.text_editor_GUI      =  "kate"         -- Lightweight, for casual text editing
-- _G.text_editor_GUI      =  "codium"    -- Complete IDE, good support for programming, heavyweight



-- === WALLPAPER ===  

---  The INITIAL, static WALLPAPER
local initial_WP        =  home_dir .. "/.config/hypr/splash.jpg"


--- Set the INITIAL wallpaper, and later replace the current background with a RANDOM IMAGE

----   (a) Use 'hyprpaper' ->  native way, the most efficient, 10-bit support 
_G.initial_WP_cmd       =  "zsh -c '" .. scripts_dir .. "/hypr-bg-setter.sh \"" .. initial_WP .. "\"'"
_G.random_WP_cmd        =  "zsh -c '" .. scripts_dir .. "/random-wallpaper-selector.sh | " .. scripts_dir .. "/hypr-bg-setter.sh'"

----   (b) Use 'swaybg'    ->  more stable, high-quality heavyweight image processing, generalist for Wayland desktops
-- _G.initial_WP_cmd       =  "zsh -c '" .. scripts_dir .. "/sway-bg-setter.sh \"" .. initial_WP .. "\"'"
-- _G.random_WP_cmd        =  "zsh -c '" .. scripts_dir .. "/random-wallpaper-selector.sh | " .. scripts_dir .. "/sway-bg-setter.sh'"



-- === SCREEN CAPTURING (IMAGE / VIDEO)

---  Screenshots
----  (I)   'slurp' selects a specific region of your screen
----  (II)  'grim' captures the pixel buffer
----  (III) 'imagemagick' compresses color depth down to standard 8-bit per channel to enhance compatibility across devices
local screen_shot_dir   =  home_dir .. "/Immagini/Immagini in Windows/Screenshots on Linux"
local screen_shot_name  =  "/Schermata_$(date +\'%Y%m%d_%H%M%S\').png"
_G.screen_shot          =  "grim -g \"$(slurp)\" - | magick - -depth 8 -colorspace sRGB \"" .. screen_shot_dir .. screen_shot_name .. "\" "
_G.screen_shot_ram      =  "grim -g \"$(slurp)\" - | wl-copy --type image/png"

--- Screen Recording
---- Uses 'obs-studio' and its 'obs-cmd' command line interface
_G.screen_rec_start     =  "obs-cmd recording start"
_G.screen_rec_stop      =  "obs-cmd recording stop"
_G.screen_rec_pause     =  "obs-cmd recording toggle-pause"

