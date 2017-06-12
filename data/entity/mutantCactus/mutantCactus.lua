local mutantCactus = {}

function mutantCactus:load(param)
	self.type = "CACTUS"
	self.obsolete = false
	self.width = math.floor(drawSize * 0.8)
	self.height = drawSize
	self.jumpHeight = drawSize * 16
	self.x = config.display.width
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true
	self.grounded = true

	self.jumpDistance = config.display.width * 0.15

	self.quad = love.graphics.newQuad(0, 17, assetSize, assetSize, atlas:getWidth(), atlas:getHeight())

	--Animation
	self.animFrame = 1
	self.animFPS = 12
	self.animTick = 0
end

function mutantCactus:jump(height)
	height = height or self.jumpHeight
	if self.grounded then
		self.yVel = -height
		self.grounded = false
		sound:play("whoosh")
	end
end

function mutantCactus:update(dt)
	self.xVel = self.speed * self.gameSpeed
	if self.x < -self.width then
		self.obsolete = true
	end

	--[[
	if self.grounded then
		self.animTick = self.animTick + dt
		if self.animTick > (1 / self.animFPS) then
			self.animFrame = self.animFrame + 1
			if self.animFrame > 4 then
				self.animFrame = 1
			end
			self.animTick = 0
		end
	else
		self.animFrame = 1
	end
	]]

	--Hopping over player
	if self.x > game.player.x then
		if fmath.distance(self.x, 0, game.player.x, 0) < self.jumpDistance then
			self:jump()
		end
	end
end

function mutantCactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(atlas, self.quad, math.floor(self.x - (drawSize * 0.1)) , math.floor(self.y), 0, drawSize / assetSize, drawSize / assetSize)
end

function mutantCactus:col(c)
	if c.other.type == "PLAYER" then
		if game.lives < 1 then
			game:lose()
		else
			game.lives = game.lives - 1
			game.livesText:setText(game.lives)
			game.player.grounded = true
			game.player:jump(game.player.jumpHeight * 0.5, true)
			game.player:flash()
			game:shake()
			sound:play("hit")
			self.obsolete = true
		end
	end
end

return mutantCactus