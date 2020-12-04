local Gui = require("scripts/gui")
local Measure = require("scripts/measure")
local Events = require("utility/events")
local GuiActionsClick = require("utility/gui-actions-click")

--TODO: add migration script to replace any held measureig tools

local function CreateGlobals()
    Measure.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
    Measure.OnLoad()
    Gui.OnLoad()
end

local function OnStartup()
    CreateGlobals()
    OnLoad()

    Gui.OnStartup()
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
script.on_load(OnLoad)

GuiActionsClick.MonitorGuiClickActions()
