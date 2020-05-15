local text = {
	smoothFactor = 6,
	hoverColor = {64, 64, 64, 255}
}
local tm = {__index = text}

function text.new(text, x, y, color, font, align, interactive, onClick, tag)
	interactive = interactive or false
	onClick = onClick or false
	tag = tag or ""
	local oy = config.display.height * 1.8
	if y < config.display.height * 0.5 then
		oy = -(config.display.height * 1.8)
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
		offY = oy,
		mouse = false,
		interactive = interactive,
		onClick = onClick,
		tag = tag
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

	--mouse check
	if self.interactive then
		local x, y = self.x, self.y
		local w = self.font:getWidth(self.text)
		local _h = self.font:getAscent() - self.font:getDescent()
		local w, wrap = self.font:getWrap(self.text, config.display.width)
		local h = _h * #wrap
		if self.align == "center" then
			x = (config.display.width / 2) - (w / 2)
		elseif self.align == "right" then
			x = config.display.width - (math.abs(self.x) + self.font:getWidth(self.text))
		end

		
		self.mouse = false
		if fmath.pointInRect(love.mouse.getX(), love.mouse.getY(), x, y, w, h) then
			self.mouse = true
		end
	end
end

function text:click(x, y, key)
	if self.mouse then
		if self.onClick then
			if type(self.onClick) == "function" then
				self.onClick(self)
			end
		end
	end
end

function text:draw()
	if self.y < config.display.height then
		love.graphics.setFont(self.font)

		--Shadow
		--[[
		if platform == "pc" then
			if not self.mouse then
				setColor(0, 0, 0, 64)
				love.graphics.printf(self.text, math.floor(self.x), math.floor(self.y) + math.floor(config.display.height * 0.01), config.display.width, self.align)
			end
		else]]
			--setColor(0, 0, 0, 64)
			--love.graphics.printf(self.text, math.floor(self.x), math.floor(self.y + (self.font:getAscent() - self.font:getDescent()) * 0.1), config.display.width, self.align)
		--end

		--Text
		setColor(self.color)
		if self.mouse then
			setColor(self.hoverColor)
		end
		love.graphics.printf(self.text, math.floor(self.x), math.floor(self.y), config.display.width, self.align)
		--if self.align == "center" then
		--	love.graphics.print(self.text math.floor( (config.display.width / 2) - (self.font:getWidth(self.text) / 2) ))
		--end
	end
end

return text