--A minimal light system.

local light = {}

function light:load()
	self.array = {}
	self.canvas = love.graphics.newCanvas()
	self.shadowColor = {0.3, 0.3, 0.5, 1}
	self.radius = drawSize * 2
	self.texture = self:createTexture(drawSize * 4, math.floor(drawSize * 2))
end

function light:setAmbient(amb)
	self.shadowColor = {amb, amb, amb, 1}
end

-- *Only x and y are required, Rest is optional.
function light:new(x, y, radius, color, follow, followOffsetX, followOffsetY, flicker)
	if config.display.lights then
		--Defaults
		radius = radius or self.radius
		color = color or {1, 1, 1, 1}
		follow = follow or false
		followOffsetX = followOffsetX or 0
		followOffsetY = followOffsetY or 0
		flicker = flicker or false

		self.array[#self.array + 1] = {
			x = x,
			y = y,
			radius = radius * 2,
			color = color,
			follow = follow,
			followOffsetX = followOffsetX,
			followOffsetY = followOffsetY,
			brightness = 1,
			targetBrightness = 1,
			remove = false,
			flicker = flicker,
			flickerFrequency = 0.001
		}
		self.array.id = #self.array
		return self.array[#self.array]
	end
end

function light:update(dt)
	if config.display.lights then
		for i,v in ipairs(self.array) do
			v.brightness = v.brightness + (v.targetBrightness - v.brightness) * 10 * dt
			if v.follow then
				local sx, sy = v.follow.x, v.follow.y
				v.x = sx + v.followOffsetX
				v.y = sy + v.followOffsetY
				v.remove = v.follow.obsolete
			end
			--Flicker
			if v.flicker then
				if math.random() < v.flickerFrequency then
					v.brightness = math.random()
				end
			end
		end

		for i,v in ipairs(self.array) do
			if v.remove then table.remove(self.array, i) end
		end
	end
end

function light:updateMap()
	--Updating
	local oc = love.graphics.getCanvas()
	local bm = love.graphics.getBlendMode()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()

	love.graphics.setColor(self.shadowColor)
	love.graphics.rectangle("fill", 0, 0, self.canvas:getWidth(), self.canvas:getHeight())

	love.graphics.setBlendMode("add")

	for i,v in ipairs(self.array) do
		love.graphics.setColor(v.color[1], v.color[2], v.color[3], v.brightness)
		love.graphics.draw(self.texture, v.x, v.y, 0, v.radius / self.texture:getWidth(), v.radius / self.texture:getHeight(), self.texture:getWidth() / 2, self.texture:getHeight() / 2)
	end

	love.graphics.setCanvas(oc)
	love.graphics.setBlendMode(bm)
end

function light:setBrightness(i, b)
	self.array[i].brightness = b
end

function light:setColor(id, color)
	self.array[id].color = color
end

function light:draw()
	if config.display.lights then
		--if camera:isMoving() then *Only updates lights when camera moves.
			light:updateMap()
		--end

		--Drawing
		love.graphics.setColor(1, 1, 1, 1)
		local bm = love.graphics.getBlendMode()
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.draw(self.canvas)
		love.graphics.setBlendMode(bm)
	end

end

function light:createTexture(radius, segments)
	local texture = love.graphics.newCanvas(radius * 2, radius * 2)
	local oldCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(texture)
	for i=1, segments do
		love.graphics.setColor(1, 1, 1,  (1 / (segments / 2) ) )
 		love.graphics.circle("fill", radius, radius, (radius / segments) * i )
	end

	love.graphics.setCanvas(oldCanvas)

	return texture
end

return light