local entity = {
	type = {},
	array = {}
}

--==[ BACK END ]==--
local function copy(original)
	local t = {}
	for k, v in pairs(original) do
		if type(v) == 'table' then
			v = copy(v)
		end
		t[k] = v
	end
	return t
end

--==[ FRONT END ]==--
function entity:new(data, name)
	self.type[name] = data
end

function entity:spawn(name, param, id)
	id = id or #self.array + 1
	param = param or {id = id}
	self.array[id] = copy(self.type[name])
	if self.array[id].load then
		if type(self.array[id].load) == "function" then
			self.array[id]:load(param)
		end
	end
	physics:add(self.array[id])
	return self.array[id]
end

function entity:destroy(id)
	if self.array[id] then
		--Checking for physics object
		if physics.world:hasItem(self.array[id]) then
			physics.world:remove(self.array[id])
		end

		self.array[id] = nil
		print("destroy")
	end
end

function entity:clear()
	self.array = {}
end

function entity:count()
	local c = 0
	for k,v in pairs(self.array) do
		c = c + 1
	end
	return c
end

--==[ CALLBACK ]==--
function entity:update(dt)
	for k,v in pairs(self.array) do
		if v.update then
			if type(v.update) == "function" then
				v:update(dt)
			end
		end

		--Removing obsolete entities
		if v.obsolete then
			if physics.world:hasItem(v) then
				physics.world:remove(v)
			end
			table.remove(self.array, k)
		end
	end
end

function entity:draw()
	for k,v in pairs(self.array) do
		if v.update then
			if type(v.draw) == "function" then
				v:draw()
			end
		end
	end
end

return entity
