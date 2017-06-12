local player = {}

function player:load(param)
	--Basics
	self.type = "PLAYER"
	self.width = math.floor(drawSize * 0.4)
	self.height = drawSize * 0.85
	self.x = config.display.width * 0.15
	self.y = param.ground - self.height
	self.jumpHeight = drawSize * 16
	self.gravity = true

	self.gameSpeed = param.gameSpeed

	self.xVel = 0
	self.yVel = 0

	self.distanceToGround = 0

	--Image
	--self.img = love.graphics.newImage("data/entity/player/player.png")
	self.quad = {
		love.graphics.newQuad(0, 0, assetSize, assetSize, atlas:getWidth(), atlas:getHeight()),
		love.graphics.newQuad(17, 0, assetSize, assetSize, atlas:getWidth(), atlas:getHeight()),
		love.graphics.newQuad(34 , 0, assetSize, assetSize, atlas:getWidth(), atlas:getHeight()),
		love.graphics.newQuad(51, 0, assetSize, assetSize, atlas:getWidth(), atlas:getHeight())
	}

	--Animation
	self.animFrame = 1
	self.animFPS = 10
	self.animTick = 0
	self.akdsfjgh = 0

	--State
	self.grounded = true
	self.moving = false

	self.colItem = "none"

	self.flashAlpha = 0
	self.flashSpeed = 4
end

function player:flash()
	self.flashAlpha = 126
end

function player:run()
	self.moving = true
end

function player:stop()
	self.moving = false
end

function player:jump(height, silent)
	height = height or self.jumpHeight
	silent = silent or false
	if self.grounded then
		self.yVel = -height
		self.grounded = false
		if not silent then sound:play("whoosh") end
		sound:stop("run")
	end
end

--==[[ CALLBACK ]]==--

function player:update(dt)
	--ANIMATION

	local fps = self.animFPS * self.gameSpeed
	if self.moving then
		if self.grounded then
			self.animTick = self.animTick + dt
			if self.animTick > (1 / fps) then
				self.animFrame = self.animFrame + 1
				if self.animFrame > 4 then
					self.animFrame = 1
				end
				self.animTick = 0
			end
		else
			self.animFrame = 2
			self.animTick = 1 / self.animFPS
		end
	end

	if self.grounded then
		sound:play("run")
	end

	self.distanceToGround = math.abs( (self.y + self.height) - game.ground.y)

	--self.y = self.y + math.floor(self._y - self.y) * (self.smoothFactor * dt)
	self.flashAlpha = self.flashAlpha + math.floor(0 - self.flashAlpha) * (self.flashSpeed * dt)

end

function player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	local yOffset = -(drawSize * 0.15)
	if not self.grounded then
		yOffset = 0--drawSize * 0.2
	end
	love.graphics.draw(atlas, self.quad[self.animFrame], self.x - (drawSize * 0.3), self.y + yOffset, 0, drawSize / assetSize, drawSize / assetSize)
	
	if self.flashAlpha > 0 then
		love.graphics.setColor(255, 0, 0, self.flashAlpha)
		love.graphics.draw(atlas, self.quad[self.animFrame], self.x - (drawSize * 0.3), self.y + yOffset, 0, drawSize / assetSize, drawSize / assetSize)
	end
	--[[
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setFont(font.tiny)
	love.graphics.print(self.distanceToGround, self.x, self.y - 24)
	]]
	
end

function player:col(c)
	if c.other.type == "cactus" then
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
			c.other.obsolete = true
		end
	elseif c.other.type == "goodCactus" then
		c.other:colResponse(c)
	end
end

return player