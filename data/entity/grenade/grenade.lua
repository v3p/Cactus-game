local grenade = {}

function grenade:load(param)
	--Basics
	self.type = "grenade"
	self.width = math.floor(drawSize * 0.25)
	self.height = drawSize * 0.25


	self.x = param.x
	self.y = param.y

	self.gravity = true

	self.xVel = param.xVel
	self.yVel = param.yVel

	self.distanceToGround = 0
	self.animation = animation.new(entity.atlas, {entity.quad[25]}, 1)
end
--==[[ CALLBACK ]]==--

function grenade:update(dt)
	
end

function grenade:draw()
	love.graphics.setColor(1, 1, 1, 1)

	self.animation:draw(self.x - (self.width / 2), self.y - self.height, (drawSize / 2) / assetSize, (drawSize / 2) / assetSize)
end

function grenade:colResponse(c)
	if c.other.type ~= "PLAYER" then
		self.obsolete = true
	elseif c.other.type == "cactus" then
		c.other.obsolete = true
	end
end

function grenade:col(c)
	if c.other.type ~= "PLAYER" then
		self.obsolete = true
	end
end

return grenade