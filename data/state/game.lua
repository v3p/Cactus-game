local game = {}

function game:load()
	self.text = {
		pc = {
			start = "press '"..config.controls.jump.."' to start",
			pause = "press '"..config.controls.pause.."' to pause",
			resume = "press '"..config.controls.jump.."' to resume",
			reset = "press '"..config.controls.jump.."' to try again"
		},
		mobile = {
			start = "tap to start",
			pause = "tap here to pause",
			resume = "tap to resume",
			reset = "tap to reset"
		}
	}

	self.title = {
		y = -(config.display.height * 0.5),
		targetY = config.display.height * 0.2,
		offY = -(config.display.height * 0.5)
	}

	self:reset()
end

function game:reset()
	physics:load()
	--Creating World
	self.ground = {
		x = 0,
		y = math.floor(config.display.height * 0.8),
		width = config.display.width * 2,
		height = config.display.height - math.floor(config.display.height * 0.8),
		color = {227, 210, 150, 255}
	}
	self.sky = verticalGradient(config.display.width, config.display.height - (config.display.height - self.ground.y), {117, 172, 198}, {178, 220, 243})

	--GAME VARIABLES
	--State
	self.started = false
	self.paused = false
	self.ended = false
	self.newHighScore = false
	self.distance = 0

	self.inputDelay = 1
	self.inputDelayTick = 0
	self.takeInput = true

	--settings
	self.gameSpeed = 1
	self.gameSpeedTick = 0
	self.gameSpeedTime = 10

	--Obstacles
	self.obstacleSpawnRate = 0.5
	self.obstacleSpawnTick = 0
	self.obstacleSpeed = config.display.width * 0.5

	--Creating Entities
	entity:clear()

	physics:add(self.ground)
	self.player = entity:spawn("player", {ground = self.ground.y, gameSpeed = self.gameSpeed}, "player")

	--Creating Text Objects
	--self.testText = text.new("It's just a test bro", 0, config.display.height * 0.4, {0, 0, 0, 255}, font.small, "center")

	self.startText = text.new(self.text[platform].start, 0, config.display.height * 0.85, {16, 16, 16, 255}, font.small, "center")
	self.pauseText = text.new(self.text[platform].pause, 0, config.display.height * 0.85, {16, 16, 16, 255}, font.small, "center")
	self.resumeText = text.new(self.text[platform].resume, 0, config.display.height * 0.85, {16, 16, 16, 255}, font.small, "center")
	self.resetText = text.new(self.text[platform].reset, 0, config.display.height * 0.85, {16, 16, 16, 255}, font.small, "center")
	self.distanceText = text.new(0, 0, config.display.height * 0.1, {240, 240, 240, 255}, font.large, "center")
	self.statsText = text.new("top distance: "..config.game.topDistance.."\ntotal distance: "..config.game.totalDistance, config.display.width * 0.01, config.display.height * 0.02, {240, 240, 240, 255}, font.small, "left")
	self.highScoreText = text.new("new high score!", 0, config.display.height * 0.3, {46, 244, 65, 255}, font.small, "center")
	self.gameOverText = text.new("You lost!", 0, config.display.height * 0.1, {229, 72, 72, 255}, font.large, "center")

	self.startText:show()
	self.statsText:show()
	self.pauseText:hide()
	self.resumeText:hide()
	self.resetText:hide()
	self.distanceText:hide()
	self.highScoreText:hide()
	self.gameOverText:hide()

	self.canvas = love.graphics.newCanvas(config.display.width, config.display.height)

	self.title.targetY = config.display.height * 0.2
end

function game:start()
	self.started = true
	self.player:run()

	self.startText:hide()
	self.statsText:hide()
	self.pauseText:show()
	self.distanceText:show()
	self.title.targetY = self.title.offY
end

function game:lose()
	--Input Delay
	self.takeInput = false
	self.inputDelayTick = self.inputDelay

	self.ended = true

	self.gameOverText:setText("You lost!\n"..math.floor(self.distance * 100) / 100)

	self.resetText:show()
	self.gameOverText:show()
	self.pauseText:hide()
	self.distanceText:hide()

	--High score
	if self.distance > config.game.topDistance then
		self.newHighScore = true
		config.game.topDistance = math.floor(self.distance * 100) / 100
		self.highScoreText:show()
	end
	config.game.totalDistance = config.game.totalDistance + math.floor(self.distance * 100) / 100

	ini.save("config.ini", config)
end

function game:pause()
	if self.started and not self.lost then
		self.paused = true
		self.pauseText:hide()
		self.resumeText:show()
	end
end

function game:resume()
	self.paused = false
	self.pauseText:show()
	self.resumeText:hide()
end

function game:spawnObstacle()
	--Deciding type
	local r = math.random()
	local type = "cactus"
	if r < 0.2 then
		type = "mutantCactus"
	end

	--Spawning
	local c = entity:spawn(type, {ground = self.ground.y, obstacleSpeed = self.obstacleSpeed, gameSpeed = self.gameSpeed})
	physics.add(c)
end

--==[[ UPDATING ]]==--

function game:updateObstacles(dt)
	if self.started and not self.paused and not self.ended then
		self.obstacleSpawnTick = self.obstacleSpawnTick + (dt * self.gameSpeed)
		if self.obstacleSpawnTick > (1 / self.obstacleSpawnRate) then
			game:spawnObstacle()
			--Double Spawn
			local r = math.random()
			if r < 0.4 then
				self.obstacleSpawnTick = (1 / self.obstacleSpawnRate)  / 2
			else
				self.obstacleSpawnTick = 0
			end
		end
	end
end

function game:update(dt)
	self.title.y = self.title.y + math.floor(self.title.targetY - self.title.y) * (6 * dt)

	--Input Delay
	if not self.takeInput then
		self.inputDelayTick = self.inputDelayTick - dt
		if self.inputDelayTick < 0 then
			self.inputDelayTick = 0
			self.takeInput = true
		end
	end

	if self.started and not self.ended and not self.paused then
		self.distance = self.distance + (dt * self.gameSpeed)

		self.gameSpeedTick = self.gameSpeedTick + dt
		if self.gameSpeedTick > self.gameSpeedTime then
			self.gameSpeed = self.gameSpeed + 0.1
			self.player.gameSpeed = self.gameSpeed
			self.gameSpeedTick = 0
		end

		game:updateObstacles(dt)
		physics:update(dt)
		entity:update(dt)
	end

	--Updating Text Objects
	self.distanceText:setText(math.floor(self.distance * 100) / 100)

	self.startText:update(dt)
	self.pauseText:update(dt)
	self.resumeText:update(dt)
	self.resetText:update(dt)
	self.distanceText:update(dt)
	self.statsText:update(dt)
	self.highScoreText:update(dt)
	self.gameOverText:update(dt)
end

--==[[ DRAWING ]]==--

function game:drawGame()
	love.graphics.setCanvas(self.canvas)
	--Sky
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.sky)

	--Ground
	love.graphics.setColor(self.ground.color)
	love.graphics.rectangle("fill", 0, self.ground.y, config.display.width, config.display.height - self.ground.y)

	--Entities
	entity:draw()
	love.graphics.setCanvas()
end

function game:draw()
	self:drawGame()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas)

	
	love.graphics.draw(title, (config.display.width / 2) - ( (title:getWidth() * drawSize * 0.1) / 2), self.title.y, 0, drawSize * 0.1, drawSize * 0.1)

	--Vignette
	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(vignette, 0, 0, 0, config.display.width / vignette:getWidth(), config.display.height / vignette:getHeight())

	--UI
	--Drawing text objects
	self.startText:draw()
	self.pauseText:draw()
	self.resumeText:draw()
	self.resetText:draw()
	self.distanceText:draw()
	self.statsText:draw()
	self.highScoreText:draw()
	self.gameOverText:draw()

	--Debug stuff
	if debugMode then
		love.graphics.setColor(255, 0, 0, 255)
		local item = physics.world:queryRect(0, 0, config.display.width, config.display.height)
		for i,v in ipairs(item) do
			love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
		end

		love.graphics.setFont(font.small)
		love.graphics.print(love.timer.getFPS(), 12, 12)
	end
	--love.graphics.print(#entity.array)
end


function game:resize()
	self:load()
end

function game:keypressed(key)
	if self.takeInput then
		if key == config.controls.jump then
			if not self.started then
				self:start()
			elseif self.paused then
				self:resume()
			elseif self.ended then
				self:reset()
			else
				self.player:jump()
			end
		end

		if key == config.controls.pause then
			self:pause()
		end
	end
end

function game:touchpressed(id, x, y, dx, dy, pressure)
	if self.takeInput then
		if self.started and not self.paused and not self.ended then
			if y < self.ground.y then
				self.player:jump()
			else
				self:pause()
			end
		elseif not self.started then
			self:start()
		elseif self.paused then
			self:resume()
		elseif self.ended then
			self:reset()
		end
	end
end

function game:mousepressed(x, y, key)
	--[[
	if self.started and not self.paused and not self.ended then
		if y < self.ground.y then
			self.player:jump()
		else
			self:pause()
		end
	elseif not self.started then
		self:start()
	elseif self.paused then
		self:resume()
	elseif self.ended then
		self:reset()
	end
	]]
end

return game