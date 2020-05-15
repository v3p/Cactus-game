local cactus = {}

function cactus:load(param)
	self.type = "cactus"
	self.obsolete = false
	self.width = math.floor(drawSize * 0.78)
	self.height = drawSize * 0.9
	self.x = config.display.width * 1.5
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true

	self.quad = entity.quad[1]

	light:new(self.x, self.y, self.height * 5, {0, 0.5, 0}, self)
end

function cactus:update(dt)
	self.xVel = self.speed * self.gameSpeed

	if self.x < -(config.display.width / 2) then
		self.obsolete = true
	end
end

function cactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(entity.atlas, self.quad, math.floor(self.x - (drawSize * 0.1) ), math.floor(self.y - (drawSize * 0.12)), 0, drawSize / assetSize, drawSize / assetSize)
end

function cactus:colResponse()
	screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, convertColor(228, 61, 61, 255))
end

function cactus:col(c)
	if c.other.type == "PLAYER" then
		if state:getState().lives < 1 then
			state:getState():lose()
		else
			c.other:colResponse()
			self.obsolete = true
			screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, convertColor(228, 61, 61, 255))
		end
	end
end

return cactus