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

	--Image
	self.img = love.graphics.newImage("data/entity/player/player.png")
	self.quad = {
		love.graphics.newQuad(0, 0, assetSize, assetSize, self.img:getWidth(), self.img:getHeight()),
		love.graphics.newQuad(assetSize, 0, assetSize, assetSize, self.img:getWidth(), self.img:getHeight()),
		love.graphics.newQuad(assetSize * 2, 0, assetSize, assetSize, self.img:getWidth(), self.img:getHeight()),
		love.graphics.newQuad(assetSize * 3, 0, assetSize, assetSize, self.img:getWidth(), self.img:getHeight())
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
end

function player:run()
	self.moving = true
end

function player:stop()
	self.moving = false
end

function player:jump()
	if self.grounded then
		self.yVel = -self.jumpHeight
		self.grounded = false
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
end

function player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	local yOffset = -(drawSize * 0.15)
	if not self.grounded then
		yOffset = 0--drawSize * 0.2
	end
	love.graphics.draw(self.img, self.quad[self.animFrame], self.x - (drawSize * 0.3), self.y + yOffset, 0, drawSize / assetSize, drawSize / assetSize)
	
	--[[
	love.graphics.setFont(font.small)
	love.graphics.print(self.akdsfjgh, self.x, self.y - 16)
	]]
end

function player:col(c)
	if c.other.type == "CACTUS" then
		game:lose()
	end
end

return player