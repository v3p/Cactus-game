local player = {}

function player:load(param)
	--Basics
	self.type = "PLAYER"
	self.width = math.floor(drawSize * 0.4)
	self.height = drawSize * 0.85

	self.opacity = 0
	self.target_opacity = 0

	self.slideWidth = drawSize * 0.85
	self.slideHeight = math.floor(drawSize * 0.4)

	self.x = config.display.width * 0.15
	self.y = param.ground - self.height

	--Jump shit
	self.jumpForce = drawSize * 12
	self.jumpTime = 0.15
	self.jumpTimer = 0
	self.jumping = false

	self.gravity = true

	self.gameSpeed = param.gameSpeed

	self.xVel = 0
	self.yVel = 0

	self.distanceToGround = 0

	--Image
	self.skinNames = {
		"dude from cactus game 1",
		"Green screen suit",
		"Carl Johnson",
		"The streaker",
		"Business casual",
		"deadpool cosplayer",
		"bat person",
		"benderman",
		"Pooper Mario",
		"gimp",
		"Vault dweller"
	}
	self.currentSkin = 1
	self.quadCount = 8

	self.atlas, self.quad = loadAtlas("data/art/img/player.png", assetSize, assetSize, 0)

	self:createAnimations()
	self.currentAnimation = "run"

	--State
	self.grounded = true
	self.moving = false
	self.sliding = false
	self.canSlide = true

	self.colItem = "none"

	self.flashAlpha = 0
	self.flashSpeed = 4

	--Slide
	self.slideTime = self.width * 0.03
	self.slideTick = 0

	--Used when tracking the "slidingTime" stat
	self.slidingTime = 0
	
	--self:setSkin()
end

function player:createAnimations()
	--Offsetting the quads to a different skin in the atlas
	--"8" is the width of the atlas in tiles.
	--this could probably be done smarter fix it dumbass.
	local quadOffset = (self.currentSkin - 1) * 8
	self.animation = {
		run = animation.new(self.atlas, {self.quad[1 + quadOffset], self.quad[2 + quadOffset], self.quad[3 + quadOffset], self.quad[4 + quadOffset]}, 12),
		jump = animation.new(self.atlas, {self.quad[2 + quadOffset]}, 1),
		slide = animation.new(self.atlas, {self.quad[5 + quadOffset]}, 1)
	}
end

function player:show()
	self.target_opacity = 1
	screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, {math.random(), math.random(), math.random()})
end

function player:hide(del)
	del = del or true
	self.target_opacity = 0
	screenEffect:ripple(self.x + (self.width / 2), self.y + (self.height / 2), 5, drawSize, convertColor(228, 61, 61, 255))
	if del then
		self.obsolete = true
	end
end

function player:setSkin(id)
	id = id or math.random(#self.skinNames)
	if id > tableLength(self.skinNames) then
		id = 0
	end
	self.currentSkin = id
	self:createAnimations()
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

function player:slide()
	if self.canSlide and self.grounded then
		self.slideTick = self.slideTime
		self.sliding = true
		self.canSlide = false
		physics:changeItem(self, self.x, self.y, self.slideWidth, self.slideHeight)


		--stats
		self.slidingTime = love.timer.getTime()
	end
end
function player:stopSlide()
	if self.sliding then
		self.sliding = false
		self.canSlide = true
		physics:changeItem(self, self.x, self.y, self.width, self.height)

		--stats
		local time = love.timer.getTime()
		config.stats.timeSliding.value = config.stats.timeSliding.value + math.floor((time - self.slidingTime) * 100) / 100
	end
end

function player:jumpAir()
	self.yVel = 0
	self.yVel = -(self.jumpForce * 2.5)
	self.grounded = false
end

function player:jump()
	if self.grounded then
		self.jumping = true
		self.grounded = false

		local snd = "jump"
		if state:getState().trip then
			snd = "jumpTrip"
		end
		sound:setPitch(snd, 0.8)
		sound:play(snd) 

		sound:stop("run")

		--Stats
		config.stats.jumps.value = config.stats.jumps.value + 1
	end
end

function player:throwGrenade()
	entity:spawn("grenade", {x = self.x + self.width, y = self.y, xVel = (drawSize * 10), yVel = - (drawSize * 16)})
end

function player:stopJump()
	self.jumping = false
	self.jumpTimer = 0
end

function player:pickup(atlas, quad)
	popup:new(atlas, quad, self.x + (self.width / 2), self.y - (self.height / 2), drawSize * 0.8)
end

--==[[ CALLBACK ]]==--

function player:update(dt)
	--Slide
	if self.sliding then
		self.slideTick = self.slideTick - dt
		if self.slideTick < 0 then
			self:stopSlide()
		end
	end

	--Jumping
	if self.jumping then
		self.yVel = -self.jumpForce
		self.jumpTimer = self.jumpTimer + dt
		if self.jumpTimer > self.jumpTime then
			self.jumping = false
			self.jumpTimer = 0
		end
	end

	--ANIMATION
	if self.moving then
		if self.grounded then
			if self.sliding then
				self.currentAnimation = "slide"
			else--RUN
				self.currentAnimation = "run"
			end
		else
			self.currentAnimation = "jump"
		end
	end

	self.animation[self.currentAnimation]:update(dt)

	if self.grounded and state:getState().started then
		sound:play("run")
	end

	self.distanceToGround = math.abs( (self.y + self.height) - world.ground.y)

	--self.y = self.y + math.floor(self._y - self.y) * (self.smoothFactor * dt)
	self.flashAlpha = self.flashAlpha + math.floor(0 - self.flashAlpha) * (self.flashSpeed * dt)
	self.opacity = self.opacity + (self.target_opacity - self.opacity) * 10 * dt
end

function player:draw()
	love.graphics.setColor(1, 1, 1, self.opacity)
	local xOffset = -(drawSize * 0.3)
	local yOffset = -(drawSize * 0.15)

	--Skin handling
	if not self.grounded then
		yOffset = 0--drawSize * 0.2
	end
	if self.sliding then
		yOffset = -(drawSize * 0.6)
		xOffset = 0
	end
		
	self.animation[self.currentAnimation]:draw(self.x + xOffset, self.y + yOffset, drawSize / assetSize, drawSize / assetSize)
	--self.animation[self.currentAnimation]:draw(self.x + xOffset, self.y + yOffset, 0, drawSize / assetSize, drawSize / assetSize)

	if self.flashAlpha > 0 then
		setColor(1, 0, 0, self.flashAlpha)
		self.animation[self.currentAnimation]:draw(self.x + xOffset, self.y + yOffset, drawSize / assetSize, drawSize / assetSize)
	end

end

function player:colResponse(c)
	state:getState():loseLife()
	self.grounded = true
	self.yVel = 0
	self:flash()

	sound:play("hit")
end

function player:col(c)
	if c.other.type == "cactus" then
		state:getState():loseLife()
		sound:play("hit")
		c.other:colResponse()
		c.other.obsolete = true
	elseif c.other.type == "mine" then
		c.other:explode()
	elseif c.other.type == "goodCactus" or c.other.type == "funnyCactus" then
		c.other:colResponse(c)
	end
end

return player