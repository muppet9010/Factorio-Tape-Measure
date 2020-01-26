--local Logging = require("utility/logging")
local GUIActions = {}
local GuiUtil = require("utility/gui-util")
MOD = MOD or {}
MOD.buttonActions = MOD.buttonActions or {}

--Called from the root of Control.lua
GUIActions.RegisterButtonActions = function()
    script.on_event(defines.events.on_gui_click, GUIActions._HandleButtonAction)
end

--Called from OnLoad() from each script file.
--When actionFunction is triggered actionData argument passed: {actionName = actionName, playerIndex = playerIndex, data = registeredButtonNameData, eventData = rawFactorioEventData}
GUIActions.RegisterActionType = function(actionName, actionFunction)
    if actionName == nil or actionFunction == nil then
        error("GUIActions.RegisterActionType called with missing arguments")
    end
    MOD.buttonActions[actionName] = actionFunction
end

--Called from OnStartup() or from some other event or trigger to register a specific button name to a named action.
GUIActions.RegisterButtonToAction = function(buttonName, buttonType, actionName, data)
    if buttonName == nil or buttonType == nil or actionName == nil then
        error("GUIActions.RegisterButtonName called with missing arguments")
    end
    buttonName = GuiUtil.GenerateName(buttonName, buttonType)
    global.UTILITYGUIACTIONSBUTTONS = global.UTILITYGUIACTIONSBUTTONS or {}
    global.UTILITYGUIACTIONSBUTTONS[buttonName] = {actionName = actionName, data = data}
end

--Called from OnStartup() or from some other event or trigger to remove a specific button name.
GUIActions.RemoveButton = function(buttonName, buttonType)
    if buttonName == nil or buttonType == nil then
        error("GUIActions.RemoveButtonName called with missing arguments")
    end
    if global.UTILITYGUIACTIONSBUTTONS == nil then
        return
    end
    buttonName = GuiUtil.GenerateName(buttonName, buttonType)
    global.UTILITYGUIACTIONSBUTTONS[buttonName] = nil
end

GUIActions._HandleButtonAction = function(rawFactorioEventData)
    if global.UTILITYGUIACTIONSBUTTONS == nil then
        return
    end
    local clickedElementName = rawFactorioEventData.element.name
    local buttonDetails = global.UTILITYGUIACTIONSBUTTONS[clickedElementName]
    if buttonDetails ~= nil then
        local actionName = buttonDetails.actionName
        local actionFunction = MOD.buttonActions[actionName]
        local actionData = {actionName = actionName, playerIndex = rawFactorioEventData.player_index, data = buttonDetails.data, eventData = rawFactorioEventData}
        if actionFunction == nil then
            error("ERROR: GUI Button Handler - no registered action for name: '" .. tostring(actionName) .. "'")
            return
        end
        actionFunction(actionData)
    else
        --Don't error as clicking on labels and flows also comes through.
        --error("ERROR: GUI Button Handler - no registered button for name: '" .. tostring(clickedElementName) .. "'")
        return
    end
end

return GUIActions
