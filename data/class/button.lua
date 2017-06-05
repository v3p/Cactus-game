local button = {}
local bm = {__index = button}

function button.new(text, x, y, width, height, func, enabled)
	enabled = enabled or true
	local b = {
		text = text,
		x = x,
		y = y,
		width = width,
		height = height,
		func = func,
		called = false,
		enabled = enabled
	}
	return setmetatable(b, bm)
end

function button:update(dt)
	local mx, my = love.mouse.getPosition()
	if self.enabled then
		if love.mouse.isDown(1) then
			if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height then
				if not self.called then
					if self.func then self.func(self) end
					self.called = true
				end
			end
		else
			self.called = false
		end
	end
end

function button:draw()
	local r, g, b, a = love.graphics.getColor()
	local ls = love.graphics.getLineStyle()
	local lw = love.graphics.getLineWidth()
	love.graphics.stencil(function() love.graphics.rectangle("fill", self.x - (lw / 2), self.y - (lw / 2), self.width + lw, self.height + lw) end)
	love.graphics.setStencilTest("greater", 0)
	love.graphics.setLineStyle("rough")
	love.graphics.printf(self.text, self.x, self.y + (self.height / 2) - (love.graphics.getFont():getHeight() / 2), self.width, "center")
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	if not self.enabled then
		love.graphics.setColor(r, g, b, 126)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
	love.graphics.setColor(r, g, b, a)
	love.graphics.setLineStyle(ls)
	love.graphics.setStencilTest()
end

function button:setEnabled(enabled)
	enabled = enabled or self.enabled
	self.enabled = enabled
end

return button