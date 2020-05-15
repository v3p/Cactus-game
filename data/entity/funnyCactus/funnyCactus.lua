local funnyCactus = {}

function funnyCactus:load(param)
	self.type = "funnyCactus"
	self.obsolete = false
	self.width = math.floor(drawSize * 0.5)
	self.height = drawSize * 0.4
	self.x = config.display.width * 1.5
	self.y = param.ground - self.height
	self.yVel = 0
	self.xVel = -param.obstacleSpeed
	self.speed = -param.obstacleSpeed
	self.gameSpeed = param.gameSpeed
	self.gravity = true
	self.collected = false

	self.quad = entity.quad[18]

	light:new(self.x, self.y, self.height * 7, {1, 1, 0}, self, self.width / 2, self.height / 2, true)
end

function funnyCactus:update(dt)
	self.xVel = self.speed * self.gameSpeed

	if self.x < -(config.display.width / 2) then
		self.obsolete = true
	end
end

function funnyCactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(entity.atlas, self.quad, math.floor(self.x - (drawSize * 0.25) ), math.floor(self.y - drawSize * 0.6), 0, drawSize / assetSize, drawSize / assetSize)
end

function funnyCactus:col(c)
	self:colResponse(c)
end

function funnyCactus:colResponse(c)
	if c.other.type ~= "GROUND" then
		state:getState():startTrip()
		state:getState().player.grounded = true
		--state:getState().player:jump(state:getState().player.jumpHeight * 0.5, true)
		state:getState().player:pickup(entity.atlas, ui.quad[18])
		self.obsolete = true
	end
end

return funnyCactus