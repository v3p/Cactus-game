local popup = {array = {}}

function popup:new(quad, x, y)
	self.array[#self.array + 1] = {
		quad = quad,
		x = x,
		y = y,
		scale = 0,
		scaleSpeed = config.display.height * 0.01,
		alpha = 255,
		alphaSpeed = 255
	}
end

function popup:update(dt)
	for i,v in ipairs(self.array) do
		v.scale = v.scale + v.scaleSpeed * dt
		v.alpha = v.alpha - v.alphaSpeed * dt
		if v.alpha < 0 then
			v.alpha = 0
			table.remove(self.array, i)
		end
	end
end

function popup:draw()
	--love.graphics.setBlendMode("add")
	for i,v in ipairs(self.array) do
		love.graphics.setColor(255, 255, 255, v.alpha)
		love.graphics.draw(atlas, v.quad, v.x , v.y, 0, drawSize / assetSize + v.scale, drawSize / assetSize + v.scale, assetSize / 2, assetSize / 2)
		--love.graphics.circle("line", v.x, v.y, assetSize * v.scale)
	end
	--love.graphics.setBlendMode("alpha")
end


return popup