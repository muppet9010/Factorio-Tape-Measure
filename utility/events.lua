local Utils = require("utility/utils")
--local Logging = require("utility/logging")

local Events = {}
MOD = MOD or {}
MOD.events = MOD.events or {}
MOD.customEventNameToId = MOD.customEventNameToId or {}
MOD.filteredEvents = MOD.filteredEvents or {}

--Called from the root of Control.lua for vanilla events and custom events.
Events.RegisterEvent = function(eventName, filterName, filterData)
    if eventName == nil then
        error("Events.RegisterEvent called with missing arguments")
    end
    local eventId
    if Utils.GetTableKeyWithValue(defines.events, eventName) ~= nil then
        eventId = eventName
        if filterName ~= nil then
            local filteredEventHandler = function(eventData)
                eventData.filterName = filterName
                Events._HandleFilteredEvent(eventData)
            end
            script.on_event(eventId, filteredEventHandler, filterData)
            return
        end
    elseif MOD.customEventNameToId[eventName] ~= nil then
        eventId = MOD.customEventNameToId[eventName]
    elseif type(eventName) == "number" then
        eventId = eventName
    else
        eventId = script.generate_event_name()
        MOD.customEventNameToId[eventName] = eventId
    end
    script.on_event(eventId, Events._HandleEvent)
end

--Called from the root of Control.lua for custom inputs (key bindings) as their names are handled specially.
Events.RegisterCustomInput = function(actionName)
    if actionName == nil then
        error("Events.RegisterCustomInput called with missing arguments")
    end
    script.on_event(actionName, Events._HandleEvent)
end

--Called from OnLoad() from each script file. Handles all event types and custom inputs.
Events.RegisterHandler = function(eventName, handlerName, handlerFunction, filterName)
    if eventName == nil or handlerName == nil or handlerFunction == nil then
        error("Events.RegisterHandler called with missing arguments")
    end
    local eventId
    if MOD.customEventNameToId[eventName] ~= nil then
        eventId = MOD.customEventNameToId[eventName]
    elseif filterName ~= nil then
        eventId = eventName
        MOD.filteredEvents[eventId .. filterName] = MOD.filteredEvents[eventId .. filterName] or {}
        MOD.filteredEvents[eventId .. filterName][handlerName] = handlerFunction
        return
    else
        eventId = eventName
    end
    MOD.events[eventId] = MOD.events[eventId] or {}
    MOD.events[eventId][handlerName] = handlerFunction
end

--Called when needed
Events.RemoveHandler = function(eventName, handlerName, filterName)
    if eventName == nil or handlerName == nil then
        error("Events.RemoveHandler called with missing arguments")
    end
    if filterName ~= nil then
        if MOD.filteredEvents[eventName .. filterName] == nil then
            return
        end
        MOD.filteredEvents[eventName .. filterName][handlerName] = nil
    else
        if MOD.events[eventName] == nil then
            return
        end
        MOD.events[eventName][handlerName] = nil
    end
end

--inputName used by custom_input , with eventId used by all other events
Events._HandleEvent = function(eventData)
    local eventId, inputName = eventData.name, eventData.input_name
    if MOD.events[eventId] ~= nil then
        for _, handlerFunction in pairs(MOD.events[eventId]) do
            handlerFunction(eventData)
        end
    elseif MOD.events[inputName] ~= nil then
        for _, handlerFunction in pairs(MOD.events[inputName]) do
            handlerFunction(eventData)
        end
    end
end

Events._HandleFilteredEvent = function(eventData)
    local eventId = eventData.name
    local filterName = eventData.filterName
    if MOD.filteredEvents[eventId .. filterName] == nil then
        return
    end
    for _, handlerFunction in pairs(MOD.filteredEvents[eventId .. filterName]) do
        handlerFunction(eventData)
    end
end

--Called when needed, but not before tick 0 as they are ignored
Events.RaiseEvent = function(eventData)
    eventData.tick = game.tick
    local eventName = eventData.name
    if defines.events[eventName] ~= nil then
        script.raise_event(defines.events[eventName], eventData)
    elseif MOD.customEventNameToId[eventName] ~= nil then
        local eventId = MOD.customEventNameToId[eventName]
        script.raise_event(eventId, eventData)
    elseif type(eventName) == "number" then
        script.raise_event(eventName, eventData)
    else
        error("WARNING: raise event called that doesn't exist: " .. eventName)
    end
end

--Called from anywhere, including OnStartup in tick 0. This won't be passed out to other mods however, only run within this mod.
Events.RaiseInternalEvent = function(eventData)
    eventData.tick = game.tick
    local eventName = eventData.name
    if defines.events[eventName] ~= nil then
        Events._HandleEvent(eventData)
    elseif MOD.customEventNameToId[eventName] ~= nil then
        eventData.name = MOD.customEventNameToId[eventName]
        Events._HandleEvent(eventData)
    elseif type(eventName) == "number" then
        Events._HandleEvent(eventData)
    else
        error("WARNING: raise event called that doesn't exist: " .. eventName)
    end
end

return Events
