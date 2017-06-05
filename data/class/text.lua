local text = {
	smoothFactor = 6,
}
local tm = {__index = text}

function text.new(text, x, y, color, font, align)
	local oy = config.display.height * 1.5
	if y < config.display.height * 0.5 then
		oy = -(config.display.height * 0.5)
	end
	t = {
		text = text,
		x = x,
		y = y,
		_x = x,
		_y = y,
		color = color,
		font = font,
		align = align,
		onScreen = false,
		offY = oy
	}
	t.y = t.offY
	return setmetatable(t, tm)
end

function text:show()
	self.onScreen = true
end

function text:hide()
	self.onScreen = false
end

function text:setText(t)
	self.text = t
end

function text:update(dt)
	if self.onScreen then
		self.y = self.y + math.floor(self._y - self.y) * (self.smoothFactor * dt)
	else
		self.y = self.y + math.floor(self.offY - self.y) * (self.smoothFactor * dt)
	end
end

function text:draw()
	if self.y < config.display.height then
		love.graphics.setFont(self.font)

		--Shadow
		love.graphics.setColor(0, 0, 0, 64)
		love.graphics.printf(self.text, math.floor(self.x), math.floor(self.y) + math.floor(config.display.height * 0.01), config.display.width, self.align)

		--Text
		love.graphics.setColor(self.color)
		love.graphics.printf(self.text, math.floor(self.x), math.floor(self.y), config.display.width, self.align)
	end
end

return text