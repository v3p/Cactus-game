local imposterCactus = {}

function imposterCactus:load(param)
	self.type = "goodCactus"
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

	self.quad = entity.quad[17]

	light:new(self.x, self.y, self.height * 7, {1, 0, 0}, self, self.width / 2, self.height / 2)
end

function imposterCactus:update(dt)
	self.xVel = self.speed * self.gameSpeed

	if self.x < -(config.display.width / 2) then
		self.obsolete = true
	end
end

function imposterCactus:draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(entity.atlas, self.quad, math.floor(self.x - (drawSize * 0.25) ), math.floor(self.y - drawSize * 0.6), 0, drawSize / assetSize, drawSize / assetSize)
end

function imposterCactus:col(c)
	self:colResponse(c)
end

function imposterCactus:colResponse(c)
	if c.other.type ~= "GROUND" then
		state:getState():addLife()
		state:getState().player.grounded = true
		--state:getState().player:jump(state:getState().player.jumpHeight * 0.5, true)
		state:getState().player:pickup(ui.atlas, ui.quad[26])
		self.obsolete = true
	end
end

return imposterCactus