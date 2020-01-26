local Utils = require("utility/utils")
--local Logging = require("utility/logging")

local Events = {}
MOD = MOD or {}
MOD.events = MOD.events or {}
MOD.customEventNameToId = MOD.customEventNameToId or {}
MOD.filteredEvents = MOD.filteredEvents or {}

--Called from the root of Control.lua
function Events.RegisterEvent(eventName, filterName, filterData)
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

--Called from OnLoad() from each script file.
function Events.RegisterHandler(eventName, handlerName, handlerFunction, filterName)
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
function Events.RemoveHandler(eventName, handlerName, filterName)
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

function Events._HandleEvent(eventData)
    local eventId = eventData.name
    if MOD.events[eventId] == nil then
        return
    end
    for _, handlerFunction in pairs(MOD.events[eventId]) do
        handlerFunction(eventData)
    end
end

function Events._HandleFilteredEvent(eventData)
    local eventId = eventData.name
    local filterName = eventData.filterName
    if MOD.filteredEvents[eventId .. filterName] == nil then
        return
    end
    for _, handlerFunction in pairs(MOD.filteredEvents[eventId .. filterName]) do
        handlerFunction(eventData)
    end
end

--Called when needed
function Events.RaiseEvent(eventData)
    eventData.tick = game.tick
    local eventName = eventData.name
    if defines.events[eventName] ~= nil then
        script.raise_event(eventName, eventData)
    elseif MOD.customEventNameToId[eventName] ~= nil then
        local eventId = MOD.customEventNameToId[eventName]
        script.raise_event(eventId, eventData)
    elseif type(eventName) == "number" then
        script.raise_event(eventName, eventData)
    else
        error("WARNING: raise event called that doesn't exist: " .. eventName)
    end
end

return Events
