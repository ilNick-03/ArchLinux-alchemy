-- modules/monitors.lua

-- Copyright (C) 2026, Nicolas Scalese
---  Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html



---- ################
---- ### MONITORS ###
---- ################
------ See:  https://wiki.hypr.land/Configuring/Basics/Monitors/


hl.monitor({
    output    =  "";                 -- Automatic monitor selection
    -- output    =  "eDP-1";            -- User-defined monitor name 

    ---  Monitor Resolution & Refresh Rate  (default + example configurations)
    mode      = "preferred",         -- Automatic
    -- mode      =  "1920x1080@144",    -- 144Hz : gaming, workstation
    -- mode      =  "1920x1080@60",     -- 60Hz : default, compatibility, energy saving

    -- position = "auto",
    position  =  "0x0",   

    ---  Interface Zoom (use one of these)
    scale     =  1.00,
    -- scale     =  1.25,
    -- scale     =  1.33;
    -- scale     =  1.50;
    -- scale     =  2.00;

    ---  Optional ICC color profile for accurate display color calibration
    -----   The user needs to specify the monitor name above
    -- icc       =  home_dir .. "/.local/share/icc/your_color_correction_profile.icc",    
    -- icc       =  "/usr/share/color/icc/colord/your_color_correction_profile.icc",

    ---  Monitor bit depth
    -- bitdepth  =   8    -- Standard
    -- bitdepth  =  10    -- HDR / EDR  for gaming/workstation
})
