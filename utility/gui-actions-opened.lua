--local Logging = require("utility/logging")
local GuiActionsOpened = {}
--local GuiUtil = require("utility/gui-util")
MOD = MOD or {}
MOD.guiOpenedActions = MOD.guiOpenedActions or {}

--Called from the root of Control.lua
GuiActionsOpened.MonitorGuiOpenedActions = function()
    script.on_event(defines.events.on_gui_opened, GuiActionsOpened._HandleGuiOpenedAction)
end

--Called from OnLoad() from each script file.
--When actionFunction is triggered actionData argument passed: {actionName = actionName, playerIndex = playerIndex, entity = entity, data = data_passed_on_event_register, eventData = raw_factorio_event_data}
GuiActionsOpened.LinkGuiOpenedActionNameToFunction = function(actionName, actionFunction)
    if actionName == nil or actionFunction == nil then
        error("GuiActions.LinkGuiOpenedActionNameToFunction called with missing arguments")
    end
    MOD.guiOpenedActions[actionName] = actionFunction
end

--Called to register a specific entities GUI being opened to a named action.
GuiActionsOpened.RegisterEntityForGuiOpenedAction = function(entity, actionName, data)
    if entity == nil or actionName == nil then
        error("GuiActions.RegisterEntityForGuiOpenedAction called with missing arguments")
    end
    global.UTILITYGUIACTIONSENTITYGUIOPENED = global.UTILITYGUIACTIONSENTITYGUIOPENED or {}
    global.UTILITYGUIACTIONSENTITYGUIOPENED[entity.unit_number] = {actionName = actionName, data = data}
end

--Called when desired to remove a specific entities GUI opened from triggering its action.
GuiActionsOpened.RemoveEntityForGuiOpenedAction = function(entity)
    if entity == nil then
        error("GuiActions.RemoveEntityGuiOpenedAction called with missing arguments")
    end
    if global.UTILITYGUIACTIONSENTITYGUIOPENED == nil then
        return
    end
    global.UTILITYGUIACTIONSENTITYGUIOPENED[entity.unit_number] = nil
end

--In future this may support items and other things. Structure should support this ok.
GuiActionsOpened._HandleGuiOpenedAction = function(rawFactorioEventData)
    if global.UTILITYGUIACTIONSENTITYGUIOPENED == nil then
        return
    end
    local entityOpened = rawFactorioEventData.entity
    if entityOpened == nil then
        return
    end
    local entitySelectedUnitNumber = entityOpened.unit_number
    local guiOpenedDetails = global.UTILITYGUIACTIONSENTITYGUIOPENED[entitySelectedUnitNumber]
    if guiOpenedDetails ~= nil then
        local actionName = guiOpenedDetails.actionName
        local actionFunction = MOD.guiOpenedActions[actionName]
        local actionData = {actionName = actionName, playerIndex = rawFactorioEventData.player_index, entity = entityOpened, data = guiOpenedDetails.data, eventData = rawFactorioEventData}
        if actionFunction == nil then
            error("ERROR: Entity GUI Opened Handler - no registered action for name: '" .. tostring(actionName) .. "'")
            return
        end
        actionFunction(actionData)
    else
        return
    end
end

return GuiActionsOpened
