local babyMutantCactus = {}

function babyMutantCactus:load(param)
	self.type = "cactus"
	self.obsolete = false
	self.width = math.floor(drawSize * 0.2)
	self.height = drawSize * 0.5
	self.jumpHeight = drawSize * 14
	self.x = config.display.width * 1.5
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true
	self.grounded = true

	self.jumpDistance = config.display.width * 0.16

	self.animation = animation.new(entity.atlas, {entity.quad[4], entity.quad[5]}, 3)

	light:new(self.x, self.y, self.height * 5, {0, 0.5, 0}, self)
	light:new(self.x, self.y, self.height * 0.6, {1, 0, 0.5}, self, self.width / 2, self.height * 0.2)
end

function babyMutantCactus:jump(height)
	height = height or self.jumpHeight
	if self.grounded then
		self.yVel = -height
		self.grounded = false
		local snd = "jump"
		if state:getState().trip then
			snd = "jumpTrip"
		end
		sound:play(snd)
	end
end

function babyMutantCactus:update(dt)
	self.xVel = self.speed * self.gameSpeed
	if self.x < -(config.display.width / 2) then
		self.obsolete = true
	end


	if self.grounded then
		self.animation:update(dt)
	end

	--Hopping over player
	if not state:getState().ended then
		if self.x > state:getState().player.x then
			if fmath.distance(self.x, 0, state:getState().player.x, 0) < self.jumpDistance then
				self:jump()
			end
		end
	end
end

function babyMutantCactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	--love.graphics.draw(entity.atlas, self.quad[self.animFrame], math.floor(self.x - (drawSize * 0.1)) , math.floor(self.y), 0, drawSize / assetSize, drawSize / assetSize)
	self.animation:draw(math.floor(self.x - self.width * 2) , math.floor(self.y - self.height), drawSize / assetSize, drawSize / assetSize)
end

function babyMutantCactus:colResponse()
	screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, convertColor(228, 61, 61, 255))
end

function babyMutantCactus:col(c)
	if c.other.type == "PLAYER" then
		if state:getState().lives < 1 then
			state:getState():lose()
		else
			c.other:colResponse()
			screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, convertColor(228, 61, 61, 255))
			self.obsolete = true
		end
	end
end

return babyMutantCactus