local ini = {}

function ini.load(fileName)
	if love.filesystem.exists(fileName) then
		local iniTable = {}
		local section
		for line in love.filesystem.lines(fileName) do
			local key, value
			local isKey = true

			--Section
			local sect, count = string.gsub(line, "[%[%]]", "")
			if count > 0 then
				section = sect
				iniTable[section] = {}
				isKey = false
			end

			--Keys
			if isKey then
				local k = {}
				local _, count = string.gsub(line, "([^%=]+)", function(c) k[#k+1] = c end)
				if count > 0 then
					key = k[1]
					value = k[2]
					if tonumber(value) then
						value = tonumber(value)
					elseif tostring(value) then
						if value == "true" then
							value = true
						elseif value == "false" then
							value = false
						end
					end
				end
			end

			--Adding to table
			if key and value or value == false then
				if section then
					iniTable[section][key] = value
				else
					iniTable[key] = value
				end
			end
		end

		return iniTable
	else
		return false
	end
end

function ini.save(fileName, t)
	--Creating string
	local s = ""
	for key, val in pairs(t) do
		if type(val) == "table" then
			s = s.."["..key.."]\r\n"
			for k,v in pairs(val) do
				s = s..k.."="..tostring(v).."\r\n"
			end
		end
	end

	--Saving file
	local file = love.filesystem.newFile(fileName, "w")
	if file then
		file:write(s)
		file:close()
	end
end

return ini