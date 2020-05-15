local physics = {}

function physics:load()
	self.gravity = math.floor(config.display.height * 8)
	self.maxVel = math.floor(config.display.height * 5)
	self.world = bump.newWorld(64)
end

function physics:add(entity)
	if entity then
		if entity.x and entity.y and entity.width and entity.height then
			self.world:add(entity, entity.x, entity.y, entity.width, entity.height)
		end
	end
end

function physics:update(dt)
	for k,v in pairs(entity.array) do
		if v.gravity then
			v.yVel = v.yVel + self.gravity * dt
			if v.yVel > self.maxVel then
				v.yVel = self.maxVel
			end

			local nx = v.x + v.xVel * dt
			local ny = v.y + v.yVel * dt
			local fx, fy, col, len = self.world:move(v, nx, ny)

			if #col > 0 then
				for o,b in ipairs(col) do
					if b.normal.y == -1 then
						if not v.grounded then
							v.grounded = true
							v.yVel = 0
						end
					end
					if v.col then
						if type(v.col) == "function" then
							v:col(b)
						end
					end
				end
			end
			v.x = fx
			v.y = fy

		else
			error("Physics object missing 'gravity' boolean")
		end
	end
end

function physics:changeItem(v, x, y, w, h)
	if self.world:hasItem(v) then
		self.world:update(v, x, y ,w , h)
	end
end

function physics:draw()
	local items, len = self.world:getItems()
	lg.setColor(1, 0, 0, 1)
	for i,v in ipairs(items) do
		local x, y, w, h = self.world:getRect(v)
		lg.rectangle("line", x, y, w, h)
	end
end






return physics