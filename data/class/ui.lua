local ui = {
	list = {},
	atlas = false
}

function ui:load()
	self.atlas, self.quad = loadAtlas("data/art/img/ui.png", assetSize, assetSize, 0)
	self.smoof = 6
	self.smoofSnap = 1
end


--UTILITY SHIT
function ui:clear()
	self.list = {}
end

function ui.getTextDimensions(text, font)
	local width = font:getWidth(text)
	local height = (font:getAscent() - font:getDescent())

	return width, height
end

function ui:printCenter(font, text, x, y, width, height)
	local textWidth, textHeight = ui.getTextDimensions(text, font)

	lg.setFont(font)
	lg.print(text, x + (width / 2) - (textWidth / 2), y + (height / 2) - (textHeight / 2))
end

--Wrapper for lg.newQuad because it makes shit simpler
function ui:newQuad(x, y, width, height)
	return lg.newQuad(x, y, width, height, self.atlas:getWidth(), self.atlas:getHeight())
end

function ui:getHidePosition(hideDirection, x, y, width, height)
	local hideX, hideY = x, y
	if hideDirection == "top" then
		hideY = -(height * 2)
	elseif hideDirection == "bottom" then
		hideY = lg.getHeight() + (height * 2)
	elseif hideDirection == "left" then
		hideX = -(width * 2)
	elseif hideDirection == "right" then
		hideX = lg.getWidth() + (width * 2)
	end

	return hideX, hideY
end

--ELEMENT CREATING SHIT

--Creates image object.
--Source: Source image, quad: Quad. X & y: Position
--hideDirection: "top", "bottom", "left", "right", Decies where the object goes when hidden
function ui:newImage(func, atlas, quad, x, y, scale, hideDirection)
	func = func or false
	local _x, _y, width, height = quad:getViewport()
	width = width * scale
	height = height * scale

	local hideX, hideY = self:getHidePosition(hideDirection, x, y, width, height)
	self.list[#self.list + 1] = {
		type = "image",
		func = func,
		atlas = atlas,
		quad = quad,
		hideDirection = hideDirection,
		--Status
		hidden = false,
		offScreen = false,
		enabled = true,

		--UNSCALED DIMENSIONS!
		width = width,
		height = height,
		scale = scale,
		--Current position
		x = x,
		y = y,
		--target position
		targetX = x,
		targetY = y,
		--Visible position
		visibleX = x,
		visibleY = y,
		--Hidden position
		hiddenX = hideX,
		hiddenY = hideY,
		--
		screen = ""
	}

	return self.list[#self.list]
end

function ui:newButton(func, text, font, x, y, width, height, hideDirection)
	local hideX, hideY = self:getHidePosition(hideDirection, x, y, width, height)
	self.list[#self.list + 1] = {
		type = "button",
		func = func,
		text = text,
		hideDirection = hideDirection,
		font = font,
		--Status
		hidden = false,
		offScreen = false,
		enabled = true,

		width = width,
		height = height,
		--Current position
		x = x,
		y = y,
		--target position
		targetX = x,
		targetY = y,
		--Visible position
		visibleX = x,
		visibleY = y,
		--Hidden position
		hiddenX = hideX,
		hiddenY = hideY,

		screen = ""
	}

	return self.list[#self.list]
end

function ui:newCheckBox(func, text, x, y, scale, hideDirection)
	local font = font.tiny
	local hideX, hideY = self:getHidePosition(hideDirection, x, y, assetSize * scale, assetSize * scale)
	local textWidth = font:getWidth(text)

	self.list[#self.list + 1] = {
		type = "checkBox",
		func = func,
		checked = false,
		text = text,
		hideDirection = hideDirection,
		font = font,
		--Status
		hidden = false,
		offScreen = false,
		enabled = true,

		textWidth = textWidth,
		width = assetSize * scale + textWidth,
		height = assetSize * scale,
		scale = scale,
		--Current position
		x = x,
		y = y,
		--target position
		targetX = x,
		targetY = y,
		--Visible position
		visibleX = x,
		visibleY = y,
		--Hidden position
		hiddenX = hideX,
		hiddenY = hideY,

		screen = ""
	}

	return self.list[#self.list]
end

function ui:newText(func, text, x, y, font, color, hideDirection)
	local width, height = ui.getTextDimensions(text, font)
	local hideX, hideY = self:getHidePosition(hideDirection, x, y, width, height)
	self.list[#self.list + 1] = {
		type = "text",
		func = func,
		text = text,
		hideDirection = hideDirection,
		font = font,
		color = color,
		--Status
		hidden = false,
		offScreen = false,
		enabled = true,

		width = width,
		height = height,
		--Current position
		x = x,
		y = y,
		--target position
		targetX = x,
		targetY = y,
		--Visible position
		visibleX = x,
		visibleY = y,
		--Hidden position
		hiddenX = hideX,
		hiddenY = hideY,

		screen = ""
	}

	return self.list[#self.list]
end

function ui:newPanel(color, x, y, width, height, hideDirection)
	local hideX, hideY = self:getHidePosition(hideDirection, x, y, width, height)
	self.list[#self.list + 1] = {
		type = "panel",
		color = color,
		hideDirection = hideDirection,
		--Status
		hidden = false,
		offScreen = false,
		enabled = true,

		width = width,
		height = height,
		--Current position
		x = x,
		y = y,
		--target position
		targetX = x,
		targetY = y,
		--Visible position
		visibleX = x,
		visibleY = y,
		--Hidden position
		hiddenX = hideX,
		hiddenY = hideY,

		screen = ""
	}

	return self.list[#self.list]
end

--CONTROLLING SHIT
function ui:show(element, instant)
	instant = instant or false

	element.hidden = false
	element.targetX = element.visibleX
	element.targetY = element.visibleY

	if instant then
		element.x = element.targetX
		element.y = element.targetY
	end
end

function ui:hide(element, instant)
	instant = instant or false

	element.hidden = true
	element.targetX = element.hiddenX
	element.targetY = element.hiddenY

	if instant then
		element.x = element.targetX
		element.y = element.targetY
	end
end

function ui:center(element, x, y, move)
	move = move or false

	if x then
		element.visibleX = (lg.getWidth() / 2) - (element.width / 2)
	end
	if y then
		element.visibleY = (lg.getHeight() / 2) - (element.height / 2)
	end

	if move then
		element.x = element.visibleX
		element.y = element.visibleY
	end

	--Updating hide positions
	local hideX, hideY = self:getHidePosition(element.hideDirection, element.visibleX, element.visibleY, element.width, element.height)
	element.hiddenX = hideX
	element.hiddenY = hideY

	element.center = true
end

function ui:setEnabled(element, enabled)
	element.enabled = enabled
end

function ui:setFont(element, font)
	element.font = font
end

function ui:setScreen(element, screen)
	element.screen = screen
end

function ui:showScreen(screen)
	for i,v in ipairs(self.list) do
		if v.screen == screen then
			self:show(v)
		end
	end
end

function ui:hideScreen(screen)
	for i,v in ipairs(self.list) do
		if v.screen == screen then
			self:hide(v)
		end
	end
end

function ui:deleteScreen(screen)
	for i,v in ipairs(self.list) do
		if v.screen == screen then
			table.remove(self.list, i)
		end
	end
end

--CALLBACK SHIT

function ui:update(dt)
	for i,v in ipairs(self.list) do
		--Updating position
		v.x = v.x + (v.targetX - v.x) * self.smoof * dt
		v.y = v.y + (v.targetY - v.y) * self.smoof * dt

		if math.abs(v.x - v.targetX) < self.smoofSnap then
			v.x = v.targetX
		end
		if math.abs(v.y - v.targetY) < self.smoofSnap then
			v.y = v.targetY
		end

	end
end

function ui:draw()
	for i,v in ipairs(self.list) do

		if v.type == "image" then
			lg.setColor(1, 1, 1, 1)
			lg.draw(v.atlas, v.quad, v.x, v.y, 0, v.scale, v.scale)
		elseif v.type == "button" then
			lg.setColor(1, 1, 1, 1)
			--LEFT
			lg.draw(self.atlas, self.quad[1], v.x, v.y, 0, v.height / assetSize, v.height / assetSize)

			--RIGHT
			lg.draw(self.atlas, self.quad[3], (v.x + v.width) - v.height, v.y, 0, v.height / assetSize, v.height / assetSize)
		
			--CENTER
			local edge = (v.height / assetSize) * 3
			local gap = (v.x + v.width) - edge - (v.x + edge)
			if gap > 0 then
				lg.draw(self.atlas, self.quad[2], (v.x + edge), v.y, 0, gap / assetSize, v.height / assetSize)
			end

			--Text
			lg.setColor(1, 1, 1, 1)
			self:printCenter(v.font, v.text, v.x, v.y, v.width, v.height)
		elseif v.type == "text" then
			lg.setColor(v.color)
			lg.setFont(v.font)
			if v.center then
				lg.printf(v.text, 0, v.y, lg.getWidth(), "center")
			else
				lg.print(v.text, v.x, v.y)
			end
		elseif v.type == "panel" then
			lg.setColor(v.color)
			lg.rectangle("fill", v.x, v.y, v.width, v.height)
			lg.setColor(0, 0, 0, 1)
			lg.rectangle("line", v.x, v.y, v.width, v.height)
		elseif v.type == "checkBox" then

			lg.setColor(1, 1, 1, 1)
			if not v.enabled then
				lg.setColor(1, 1, 1, 0.4)
			end
			local quad = self.quad[14]
			if v.checked then
				quad = self.quad[15]
			end
			lg.draw(self.atlas, quad, v.x, v.y, 0, v.scale, v.scale)
			lg.setFont(v.font)
			local textHeight = v.font:getAscent() - v.font:getDescent()
			lg.print(v.text, v.x + v.width - v.textWidth, v.y + (v.height / 2) - (textHeight / 2))
		end
		--lg.setColor(1, 0, 1, 1)
		--lg.print(v.screen, v.x, v.y)
	end
end

function ui:drawBounds()
	lg.setColor(1, 0, 1, 1)
	for i,v in ipairs(self.list) do
		lg.rectangle("line", v.x, v.y, v.width, v.height)
	end
end

function ui:press(x, y)
	local pressed = false
	for i,v in ipairs(self.list) do
		if pointInRect(x, y, v.x, v.y, v.width, v.height) then
			--Checkbox Toggling
			if v.type == "checkBox" then
				if v.enabled then
					v.checked = not v.checked
				end
			end

			if type(v.func) == "function" then
				if v.enabled then
					v.func(v)
					pressed = true
				end
			end
		end
	end

	return pressed
end

function ui:release(x, y)

end

return ui