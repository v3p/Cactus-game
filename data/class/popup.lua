local popup = {array = {}}

function popup:new(atlas, quad, x, y, size)
	size = size or drawSize
	self.array[#self.array + 1] = {
		atlas = atlas,
		quad = quad,
		x = x,
		y = y,
		size = size,
		scale = 0,
		scaleSpeed = config.display.height * 0.05,
		alpha = 255,
		alphaSpeed = 255
	}
end

function popup:update(dt)
	for i,v in ipairs(self.array) do
		--v.scale = v.scale + v.scaleSpeed * dt
		v.alpha = v.alpha - v.alphaSpeed * dt
		v.y = v.y - v.scaleSpeed * dt
		if v.alpha < 0 then
			v.alpha = 0
			table.remove(self.array, i)
		end
	end
end

function popup:draw()
	--love.graphics.setBlendMode("add")
	for i,v in ipairs(self.array) do
		setColor(255, 255, 255, v.alpha)
		love.graphics.draw(v.atlas, v.quad, v.x , v.y, 0, v.size / assetSize + v.scale, v.size / assetSize + v.scale, assetSize / 2, assetSize / 2)
		--love.graphics.circle("line", v.x, v.y, assetSize * v.scale)
	end
	--love.graphics.setBlendMode("alpha")
end


return popup