-- modules/keybindings-map.lua

-- Copyright (C) 2026, Nicolas Scalese
---  Licensed under the GNU GPL v3 or later. Info:  https://www.gnu.org/licenses/gpl-3.0.html


-- ===============================================================================
---- CENTRALIZED KEYBINDING REGISTRY & METADATA CACHE
---- Wrapper module that hooks into 'hl.bind'. Caches key combos and descriptions
---- inside a structured Lua table and exports a clean JSON file.
-- ===============================================================================


local M = {}

-- The "Famous" Table: Stores every registered bind as a structured object
M.registry = {}


--- Registers a keybinding and stores it in the internal registry
-- @param keys string: The key combination (e.g., "SUPER + SHIFT + A")
-- @param dispatcher function/string: The action to execute
-- @param opts table: Optional flags (locked, repeating, description, etc.)
function M.bind(keys, dispatcher, opts)
    opts = opts or {}
    
    -- 1. Store key combo and clean description in the internal registry
    table.insert(M.registry, {
        keys = keys,
        description = opts.description or "No description provided"
    })

    -- 2. Pass clean options to native Hyprland binding
    return hl.bind(keys, dispatcher, opts)
end


--- Exports the internal registry as a clean JSON file to /tmp
function M.export_json()
    local file = io.open("/tmp/hypr_binds.json", "w")
    if not file then return end
    
    file:write("[\n")
    for i, item in ipairs(M.registry) do
        local k = item.keys:gsub('"', '\\"')
        local d = item.description:gsub('"', '\\"')
        file:write(string.format('  {"keys": "%s", "description": "%s"}%s\n', k, d, (i < #M.registry and "," or "")))
    end
    file:write("]\n")
    file:close()
end


return M
