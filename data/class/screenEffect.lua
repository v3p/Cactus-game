--Screen effects.

local screenEffect = {
	_flash = {
		time = 16,
		alpha = 0,
		color = {1, 1, 1, 1}
	},
	_shake = {
		_time = 0,
		time = 0,
		magnitude = 10
	},
	_ripple = {
		list = {}
	}
}

function screenEffect:ripple(x, y, time, radius, color, flash)
	time = time or 5
	radius = radius or drawSize * 2
	color = color or {1, 1, 1}
	flash = flash or false

	self._ripple.list[#self._ripple.list + 1] = {
		x = x,
		y = y,
		time = time,
		radius = radius,
		currentRadius = 0,
		alpha = 1,
		color = color,
		light = false
	}
end

function screenEffect:flash(time, color)
	time = time or 16
	color = color or {1, 1, 1, 1}
	self._flash.time = time
	self._flash.color = color
	self._flash.alpha = 1
end	

function screenEffect:shake(time, magnitude)
	time = time or 0.2
	magnitude = magnitude or lg.getWidth() * 0.001

	self._shake.time = time
	self._shake._time = time
	self._shake.magnitude = magnitude
end

function screenEffect:update(dt)
	--FLASH
	if self._flash.alpha > 0.01 then
		self._flash.alpha = self._flash.alpha + (0 - self._flash.alpha) * self._flash.time * dt
	else
		self._flash.alpha = 0
	end

	--SHAKE
	if self._shake.time > 0 then
		self._shake.time = self._shake.time - dt
		self._shake.magnitude = self._shake.magnitude * fmath.normal(self._shake.time, 0, self._shake._time)
		if self._shake.time < 0 then
			self._shake.time = 0
		end
	end

	--RIPPLE
	for i,v in ipairs(self._ripple.list) do
		v.currentRadius = v.currentRadius + (v.radius - v.currentRadius) * v.time * dt
		v.alpha = v.alpha + (0 - v.alpha) * v.time * dt

		if v.alpha < 0.01 then
			table.remove(self._ripple.list, i)
		end
	end
end

function screenEffect:push()
	if self._shake.time > 0 then
		local dx = math.random(-self._shake.magnitude, self._shake.magnitude)
		local dy = math.random(-self._shake.magnitude, self._shake.magnitude)
		love.graphics.translate(dx, dy)
	end
end

function screenEffect:draw()
	if self._flash.alpha > 0 then
		love.graphics.setColor(self._flash.color[1], self._flash.color[2], self._flash.color[3], self._flash.alpha)
		love.graphics.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())
	end

	if #self._ripple.list > 0 then
		local bmode = love.graphics.getBlendMode()
		love.graphics.setBlendMode("add")
		for i,v in ipairs(self._ripple.list) do
			love.graphics.setColor(v.color[1], v.color[2], v.color[3], v.alpha)
			love.graphics.circle("fill", v.x, v.y, v.currentRadius)
		end
		love.graphics.setBlendMode(bmode)
	end
end

return screenEffect

