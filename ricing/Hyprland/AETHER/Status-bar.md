# Status Bar Architecture & Module Directory

<p align="center">
  <img src="./screenshots/AETHER_status_bar.png" alt="Updated A.E.T.H.E.R. status bar" width="100%">
</p>


The _A.E.T.H.E.R._ status bar is built with _Waybar_ and designed as a modular, pill-based interactive interface. 
Modules are organized logically from left to right, combining real-time metric indicators, quick action controls, and hardware dispatchers.


<br>

---

## Left Modules: System Navigation & Workspaces

* **Application Launcher (`Apps`)**
  * **Function**: Serves as the primary system application launcher trigger.
  * **Interactions**: Left-click launches the desktop application launcher menu.
  * **Visuals**: Highlighted with a distinct neon gradient pill and hover glow effect.

* **Keybindings Cheat-Sheet (`󰌌`)**
  * **Function**: Provides instant access to system-wide shortcuts.
  * **Interactions**: Left-click opens an interactive TUI keybindings table inside an isolated terminal window.
  * **Tooltip**: Displays "Keybindings Cheat-Sheet" on hover.

* **Workspace Switcher**
  * **Function**: Displays active and populated Hyprland workspaces.
  * **Interactions**: Left-click a workspace pill to switch directly to it; scroll up or down anywhere on the workspace container to cycle sequentially through workspaces.
  * **Visuals**: Highlights active workspaces with a solid primary fill and halo glow.


<br>

---

## Center Module: Contextual Window Management

* **Active Window Title**
  * **Function**: Displays the title of the currently focused window.
  * **Behavior**: Automatically truncates overly long window titles. The module completely collapses and hides when the current workspace contains no active windows.


<br>

---

## Right Modules & Hardware Control Groups

### 1. Standalone Indicators

* **Privacy Sentinel**
  * **Function**: Monitors real-time hardware access for privacy-sensitive nodes (microphones and webcams).
  * **Behavior**: Dynamically appears in red only when an application actively captures audio or video feeds.

* **Idle Inhibitor**
  * **Function**: Toggles the system auto-suspend and display sleep behavior.
  * **Interactions**: Left-click toggles between active (eye open: screen forced on) and inactive (eye closed: normal sleep timer) modes.
  * **Tooltip**: Indicates "Always-on screen" or "Auto suspend".

* **MPRIS Media Controller**
  * **Function**: Detects active media playback across browsers and standalone media players.
  * **Interactions**: Left-click toggles Play/Pause; right-click skips to the next track.
  * **Tooltip**: Displays active player identity, track status, artist, and album metadata.

---

### 2. Consolidated Module Groups

| Module Group | Component | Functionality & Gestures | Tooltip & Alerts |
| :--- | :--- | :--- | :--- |
| **Hardware Monitors** | **Disk (`custom/disk`)** | Shows percentage of root partition used. Left-click triggers an immediate storage usage recalculation. | Tooltip displays exact used vs. total disk space (e.g., `185G / 460G`). |
| | **Memory (`memory`)** | Monitors total RAM utilization percentage in real-time. | Native _Waybar_ memory statistics tooltip. |
| | **_CPU_ (`cpu`)** | Displays overall CPU usage load percentage. | None (clean layout). |
| | **Temperature (`temperature`)** | Tracks thermal sensors. Colors shift dynamically and flash when temperature exceeds 80°C. | None (clean layout). |
| **Hardware Controls** | **Audio (`pulseaudio`)** | Scroll up/down to adjust system volume by 2%; left-click toggles Mute; right-click opens the graphical volume control mixer. | Displays active audio output device and current volume level. |
| | **Backlight (`backlight`)** | Scroll up/down to adjust screen brightness by 5%; left-click decreases, right-click increases brightness. | None (clean layout). |
| **Power Management** | **Battery (`battery`)** | Tracks charge levels and state. Animates red when critical (<15%) and turns green when charging. | Tooltip displays calculated remaining battery life/time to full charge. |
| | **Power Profile (`power-profiles-daemon`)** | Scroll up/down to switch system profiles (*Power Saver* , *Balanced* , *Performance* ). | Tooltip shows current profile name and system driver. |
| **Connectivity** | **Wi-Fi (`network`)** | Left-click toggles Wi-Fi radio state On/Off; right-click opens the interactive network selection menu. | Tooltip displays active interface, local IP, and gateway addresses. |
| | **Bluetooth (`bluetooth`)** | Left-click toggles Bluetooth radio On/Off; right-click opens the Bluetooth device manager. | Tooltip lists connected devices, MAC addresses, and device battery levels. |

---

### 3. System Utility & End Modules

* **System Tray**
  * **Function**: Hosts passive system applet icons (such as NetworkManager, Blueman, or background sync services).
  * **Behavior**: Automatically collapses and hides when no system applets are running.

* **Clock & Calendar Badge**
  * **Function**: Primary timekeeper module displaying 12-hour format with AM/PM indicators.
  * **Interactions**: Left-click toggles the main time display to alternative date formats (e.g., `DD/MM/YYYY`).
  * **Tooltip**: Hovering reveals a formatted calendar overlay for the current month.

* **Power Operations (`⏻`)**
  * **Function**: Quick access button for session and power management.
  * **Interactions**: Left-click launches the full-screen system power menu (logout, reboot, shutdown, suspend lock).
  * **Visuals**: Highlighted in red with a glow effect that intensifies on hover.
