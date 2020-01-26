local Gui = require("scripts/gui")
local Measure = require("scripts/measure")
local Events = require("utility/events")
local GuiActions = require("utility/gui-actions")

--TODO: add migration script to replace any held measureig tools

local function CreateGlobals()
    Measure.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
    Measure.OnLoad()
    Gui.OnLoad()
end

local function OnSettingChanged(event)
    Gui.OnSettingChanged(event)
end

local function OnStartup()
    CreateGlobals()
    OnSettingChanged(nil)
    OnLoad()

    Gui.OnStartup()
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
script.on_load(OnLoad)

Events.RegisterEvent(defines.events.on_player_joined_game)
Events.RegisterEvent(defines.events.on_player_selected_area)
Events.RegisterEvent(defines.events.on_mod_item_opened)
Events.RegisterCustomAction("tape_measure_tool-get_tape_measure")
Events.RegisterCustomAction("tape_measure_tool-dispose_tape_measure")

GuiActions.RegisterButtonActions()
