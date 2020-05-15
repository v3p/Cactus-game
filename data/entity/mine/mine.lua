local mine = {}

function mine:load(param)
	self.type = "mine"
	self.obsolete = false
	self.width = math.floor(drawSize)
	self.height = drawSize * 0.5
	self.x = config.display.width * 1.5
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true
	self.grounded = true

	self.jumpDistance = config.display.width * 0.16

	self.animation = animation.new(entity.atlas, {entity.quad[11], entity.quad[12]}, 3)

	light:new(self.x, self.y, self.height * 5, {1, 0.2, 0.2}, self, self.width / 2)

	self.distanceFromPlayer = 0
end

function mine:explode()
	self.obsolete = true

	state:getState().player:jumpAir()

	screenEffect:shake(3, 5)
	local hue = 50
	local stages = 6
	for i=1, stages do
		hue = hue - (hue / stages)
		local r, g, b, a = hsl(hue, 255, 126, 255)
		screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, (drawSize / 2) * i, {r, g, b, a})
	end

	sound:play("explode")
end

function mine:update(dt)
	self.xVel = self.speed * self.gameSpeed
	if self.x < -(config.display.width / 2) then
		self.obsolete = true
	end


	if self.grounded then
		self.animation:update(dt)
	end

	--Exploding
	if not state:getState().ended then
		self.distanceFromPlayer = fmath.distance(self.x, self.y, state:getState().player.x, state:getState().player.y)
		self.animation:setFps(fmath.normal(self.distanceFromPlayer, lg.getWidth(), 0) * 6)

		if self.distanceFromPlayer < 100 then
			self:explode()
		end
	end
end

function mine:draw()
	love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.draw(entity.atlas, self.quad[self.animFrame], math.floor(self.x - (drawSize * 0.1)) , math.floor(self.y), 0, drawSize / assetSize, drawSize / assetSize)
	self.animation:draw(math.floor(self.x) , math.floor(self.y - self.height), drawSize / assetSize, drawSize / assetSize)

	--lg.setFont(font.tiny)
	--lg.print(math.floor(self.distanceFromPlayer), self.x, self.y - 32)
end

function mine:colResponse()
	screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, convertColor(228, 61, 61, 255))
end

function mine:col(c)
	if c.other.type == "PLAYER" then
		self:explode()
	end
end

return mine