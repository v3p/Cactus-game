local goodCactus = {}

function goodCactus:load(param)
	self.type = "goodCactus"
	self.obsolete = false
	self.width = math.floor(drawSize * 0.5)
	self.height = drawSize * 0.4
	self.x = config.display.width
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true
	self.collected = false

	self.quad = love.graphics.newQuad(51, 34, assetSize, assetSize, atlas:getWidth(), atlas:getHeight())
end

function goodCactus:update(dt)
	self.xVel = self.speed * self.gameSpeed

	if self.x < -self.width then
		self.obsolete = true
	end
end

function goodCactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(atlas, self.quad, math.floor(self.x - (drawSize * 0.25) ), math.floor(self.y - drawSize * 0.6), 0, drawSize / assetSize, drawSize / assetSize)
end

function goodCactus:col(c)
	self:colResponse(c)
end

function goodCactus:colResponse(c)
	if c.other.type ~= "GROUND" then
		game:addLife()
		game.player.grounded = true
		game.player:jump(game.player.jumpHeight * 0.5, true)
		popup:new(heart, config.display.width / 2, config.display.height / 2)
		self.obsolete = true
	end
end

return goodCactus