-- modules/autostart.lua

-- Copyright (C) 2026, Nicolas Scalese
---  Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html



---- #################
---- ### AUTOSTART ###
---- #################
------ See:  https://wiki.hypr.land/Configuring/Basics/Autostart/


hl.on("hyprland.start", function () 
    
    -- === Autostart necessary processes (notifications daemons, status bars, etc.)  ===
    
    ---  Force reload to ensure that GPU drivers are fully initialized
    -- hl.exec_cmd(sleep 2; hyprctl reload)

    --- Set the first wallpaper at start.
    hl.exec_cmd(initial_WP_cmd)

    --- Run the Hyprland "extensions"
    hl.exec_cmd(status_bar)
    hl.exec_cmd(notification_daemon)
    hl.exec_cmd(auth_manager)    -- Fork into background
    hl.exec_cmd(idle_daemon)     -- Start the daemon in background
    hl.exec_cmd(wifi_menu)
    hl.exec_cmd(bluetooth_menu)
    hl.exec_cmd(clip_store_text)


    -- === Execute your favorite apps at launch ==
    -- hl.exec_cmd("sleep 1    && " .. terminal)
    hl.exec_cmd("sleep 1.5  &&  " .. aether_logo)    -- See 'vars.lua'

end)



