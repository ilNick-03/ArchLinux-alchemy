-- modules/winrules.lua

-- Copyright (C) 2026, Nicolas Scalese
---  Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html



---- ##############################
---- ### WINDOWS AND WORKSPACES ###
---- ##############################
------ See:  https://wiki.hypr.land/Configuring/Basics/Window-Rules/
------ See:  https://wiki.hypr.land/Configuring/Basics/Dispatchers/#workspace




-- ===============================================================================
-- [1]   COMPOSITOR CORE & PROTOCOLS
-- ===============================================================================

----------------------------------------------------------------------------------
-- [1.1] Low-Level Event Mitigations
----------------------------------------------------------------------------------

--- Ignore maximize requests from all apps. You'll probably like this.
local suppressMaximizeRule = hl.window_rule({
    name             =  "suppress-maximize-events",
    match            =  { class = ".*" },

    suppress_event   =  "maximize"
})
-- suppressMaximizeRule:set_enabled(false)

--- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class        =  "^$",
        title        =  "^$",
        xwayland     =  true,
        float        =  true,
        fullscreen   =  false,
        pin          =  false,
    },

    no_focus         =  true
})


----------------------------------------------------------------------------------
-- [1.2] Layer & Native Dispatcher Rules
----------------------------------------------------------------------------------

--- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name             =  "no-anim-overlay",
--     match            =  { namespace = "^my-overlay$" },
--     no_anim          =  true,
-- })
-- overlayLayerRule:set_enabled(false)

--- Hyprland-run windowrule
hl.window_rule({
    name             =  "move-hyprland-run",
    match            =  { class = "hyprland-run" },

    move             =  "20 monitor_h-120",
    float            =  true
})




-- ===============================================================================
-- [2]   ENVIRONMENT & LAYOUT BEHAVIORS
-- ===============================================================================

----------------------------------------------------------------------------------
-- [2.1] Floating Dialogs & Overlays
----------------------------------------------------------------------------------

-- ... [2.1.1] System Utilities & Security .......................................

--- Display some windows as "floating" (we don't want them fullscreen, nor tiling)
hl.window_rule({
    name             =  "floating-window-on-default",
    
    match = {
        class = "^(blueman-manager|nm-connection-editor|pavucontrol|org.pulseaudio.pavucontrol)"
    },

    -- Set behavior: float them and keep them centered
    float            =  true,
    center           =  true,
    
    -- Set a consistent window size for a "dialog" look
    size             =  { 650, 450 },    -- Format: { width, height }

    -- Keeps the manager on top of other tiled windows
    pin              =  true
})

--- Custom rule for your "Authentication Agent"
hl.window_rule({
    name             =  "auth-agent-float",
    match = {
        class        =  "^(xfce-polkit)$"
    },

    -- Set behavior: float them and keep them centered
    float            =  true,
    center           =  true,
    size             =  { 650, 230 },    -- Formato: { width, height }

    -- Keeps the authentication window always on top of other tiled windows
    pin              =  true
})


-- ... [2.1.2] A.E.T.H.E.R. Native Tools .........................................

--- Custom rule for the 'A.E.T.H.E.R.' startup logo
hl.window_rule({
    name             =  "aether-logo-floating",
    match            =  { class = "^(aether_logo)" },

    float            =  true,
    center           =  true,
    size             =  { 750, 490 },    -- Optimized size for the ASCII box
    pin              =  false
})

--- Display the "activity manager" as a "floating" window
hl.window_rule({
    name             =  "process-monitor-float",
    match            =  { class  = "^(floating_monitor)" },
    
    float            =  true,           -- Behavior
    size             =  { 900, 800 }    -- Format: { width, height }
})

--- Display the "keybindings table" as a "floating" window
hl.window_rule({
    name             =  "keybindings-table-float",
    match            =  { class  = "^(floating_bindsmap)" },
    
    float            =  true,           -- Behavior
    size             =  { 880, 800 }    -- Format: { width, height }
})


----------------------------------------------------------------------------------
-- [2.2] Surface Rendering & Clarity Overrides
----------------------------------------------------------------------------------

-- ... [2.2.1] Media & Content Creation Apps .....................................

--- Some applications require full visual clarity (no transparency/blur)
hl.window_rule({
    name             =  "apps-solid-view",
    
    match = {
        class        =  "^(darktable|org.darktable.darktable|imv|mpv|obsidian|md.Obsidian|obs-studio|soffice|libreoffice.*|okular|org.kde.okular)"
    },
    
    -- Ensure windows are 100% opaque and disable background blurring
    opaque           =  true,
    no_blur          =  true
})




-- ===============================================================================
-- [3]   UI & DECORATION REFINEMENTS
-- ===============================================================================

----------------------------------------------------------------------------------
-- [3.1] Tray Menus & Unnamed Popups
----------------------------------------------------------------------------------

--- Final fix for nm-applet sharp edges
hl.window_rule({
    name             =  "nm-applet-menu-refinement",
    match            = { class = "^(nm-applet)$" },
    
    rounding         =  16,
    opacity          =   0.85,
    border_size      =   3,
    no_shadow        =  false,
    no_blur          =  false
})

--- Aggressive rule for unnamed GTK popups/menus
hl.window_rule({
    name             =  "global-gtk-popup-fix",
    match = {
        class        =  "^$",    -- Matches windows with no class (common for context menus)
        float        =  true
    },

    rounding         =  16,
    opacity          =   0.85,
    no_blur          =  false    -- Enable blur for a premium look
})
