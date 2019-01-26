local Utils = require("utility/utils")
local Logging = {}

function Logging.PositionToString(position)
	if position == nil then return "nil position" end
	return "(" .. position.x .. ", " .. position.y ..")"
end

Logging.tablesLogged = {}
function Logging.TableContentsToString(target_table, name, indent, stop_traversing)
	indent = indent or 1
	local indentstring = string.rep(" ", (indent * 4))
	local table_id = string.gsub(tostring(target_table), "table: ", "")
	Logging.tablesLogged[table_id] = "logged"
	local table_contents = ""
	if Utils.GetTableLength(target_table) > 0 then
		for k,v in pairs(target_table) do
			local key, value
			if type(k) == "string" or type(k) == "number" or type(k) == "boolean" then
				key = '"' ..tostring(k) .. '"'
			elseif type(k) == "nil" then
				key = '"nil"'
			elseif type(k) == "table" then
				local sub_table_id = string.gsub(tostring(k), "table: ", "")
				if stop_traversing == true then
					key = '"CIRCULAR LOOP TABLE'
				else
					local sub_stop_traversing = nil
					if Logging.tablesLogged[sub_table_id] ~= nil then
						sub_stop_traversing = true
					end
					key = '{\r\n' .. Logging.TableContentsToString(k, name, indent + 1, sub_stop_traversing) .. '\r\n' .. indentstring .. '}'
				end
			elseif type(k) == "function" then
				key = '"' .. tostring(k) .. '"'
			else
				key = '"unhandled type: ' .. type(k) .. '"'
			end
			if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
				value = '"' .. tostring(v) .. '"'
			elseif type(v) == "nil" then
				value = '"nil"'
			elseif type(v) == "table" then
				local sub_table_id = string.gsub(tostring(v), "table: ", "")
				if stop_traversing == true then
					value = '"CIRCULAR LOOP TABLE'
				else
					local sub_stop_traversing = nil
					if Logging.tablesLogged[sub_table_id] ~= nil then
						sub_stop_traversing = true
					end
					value = '{\r\n' .. Logging.TableContentsToString(v, name, indent + 1, sub_stop_traversing) .. '\r\n' .. indentstring .. '}'
				end
			elseif type(v) == "function" then
				value = '"' .. tostring(v) .. '"'
			else
				value = '"unhandled type: ' .. type(v) .. '"'
			end
			if table_contents ~= "" then table_contents = table_contents .. ',' .. '\r\n' end
			table_contents = table_contents .. indentstring .. tostring(key) .. ':' .. tostring(value)
		end
	else
		table_contents = indentstring .. '"empty"'
	end
	if indent == 1 then
		Logging.tablesLogged = {}
		return '"' .. name .. '":{' .. '\r\n' .. table_contents .. '\r\n' .. '}'
	else
		return table_contents
	end
end

function Logging.Log(text)
	if game ~= nil then
		game.write_file("Biter_Attack_Waves_logOutput.txt", tostring(text) .. "\r\n", true)
	end
end

function Logging.LogPrint(text)
	if game ~= nil then
		game.print(tostring(text))
	end
	Logging.Log(text)
end

return Logging
