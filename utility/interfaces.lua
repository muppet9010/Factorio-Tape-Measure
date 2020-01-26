--local Logging = require("utility/logging")

local Interfaces = {}
MOD = MOD or {}
MOD.interfaces = MOD.interfaces or {}

--Called from OnLoad() from each script file.
function Interfaces.RegisterInterface(interfaceName, interfaceFunction)
    MOD.interfaces[interfaceName] = interfaceFunction
end

--Called when needed.
function Interfaces.Call(interfaceName, ...)
    if MOD.interfaces[interfaceName] ~= nil then
        return MOD.interfaces[interfaceName](...)
    else
        error("WARNING: interface called that doesn't exist: " .. interfaceName)
    end
end

return Interfaces
