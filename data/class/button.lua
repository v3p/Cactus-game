local button = {
	smoothFactor = 6,
	scale = 1.5
}
local bm = {__index = button}

function button.new(quad, x, y, onClick, tag)
	onClick = onClick or false
	tag = tag or ""
	local oy = config.display.height * 1.8
	if y < config.display.height * 0.5 then
		oy = -(config.display.height * 1.8)
	end
	t = {
		quad = quad,
		x = x,
		y = y,
		_x = x,
		_y = y,
		onScreen = false,
		offY = oy,
		mouse = false,
		onClick = onClick,
		tag = tag
	}
	t.y = t.offY
	return setmetatable(t, bm)
end

function button:show()
	self.onScreen = true
end

function button:hide()
	self.onScreen = false
end

function button:setQuad(quad)
	self.quad = quad
end

function button:update(dt)
	if self.onScreen then
		self.y = self.y + math.floor(self._y - self.y) * (self.smoothFactor * dt)
	else
		self.y = self.y + math.floor(self.offY - self.y) * (self.smoothFactor * dt)
	end

	self.mouse = false
	if fmath.pointInRect(love.mouse.getX(), love.mouse.getY(), self.x, self.y, (drawSize * self.scale), (drawSize * self.scale)) then
		self.mouse = true
	end
end

function button:click(x, y, key)
	if self.mouse then
		if self.onClick then
			if type(self.onClick) == "function" then
				self.onClick(self)
			end
		end
	end
end

function button:draw()
	if self.y < config.display.height then
		setColor(255, 255, 255, 200)
		if self.mouse then
			setColor(255, 255, 255, 255)
		end
		love.graphics.draw(atlas, self.quad, math.floor(self.x), math.floor(self.y), 0, (drawSize * self.scale) / assetSize, (drawSize * self.scale) / assetSize)
	end
end

return button