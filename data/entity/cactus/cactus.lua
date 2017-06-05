local cactus = {}

function cactus:load(param)
	self.type = "CACTUS"
	self.obsolete = false
	self.width = math.floor(drawSize * 0.78)
	self.height = drawSize * 0.9
	self.x = config.display.width
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true

	self.img = love.graphics.newImage("data/entity/cactus/cactus.png")
end

function cactus:update(dt)
	self.xVel = self.speed * self.gameSpeed

	if self.x < -self.width then
		self.obsolete = true
	end
end

function cactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.img, math.floor(self.x - (drawSize * 0.1) ), math.floor(self.y - (drawSize * 0.12)), 0, drawSize / assetSize, drawSize / assetSize)
end

function cactus:col(c)
	if c.other.type == "PLAYER" then
		game:lose()
	end
end

return cactus