local game = {}

function game:load()
	self.text = {
		pc = {
			start = "click to start\n("..config.controls.jump..")",
			pause = "click to pause\n("..config.controls.pause..")",
			resume = "click to resume\n("..config.controls.jump..")",
			reset = "click to restart\n("..config.controls.jump..")",
			info = "Press '"..config.controls.jump.."' or click to jump"
		},
		mobile = {
			start = "tap to start",
			pause = "tap to pause",
			resume = "tap to resume",
			reset = "tap to reset",
			info = "tap to jump"
		}
	}

	self.title = {
		y = -(config.display.height * 0.5),
		targetY = config.display.height * 0.2,
		offY = -(config.display.height * 0.5)
	}

	self.hud = {
		x = -(config.display.width * 0.5),
		targetX = -(config.display.width * 0.5),
		offX = -(config.display.width * 0.5)
	}

	self.canvas = {
		entity = love.graphics.newCanvas(config.display.width, config.display.height, "hdr"),
		gui = love.graphics.newCanvas(config.display.width, config.display.height, "hdr")
	}

	self.first = true

	self:reset()

	--sound:play("music")

end

function game:reset()
	physics:load()
	--Creating World
	self.ground = {
		x = 0,
		y = math.floor(config.display.height * 0.8),
		width = config.display.width * 2,
		height = config.display.height - math.floor(config.display.height * 0.8),
		color = {227, 210, 150, 255},
		type = "GROUND"
	}
	self.sky = verticalGradient(config.display.width, config.display.height - (config.display.height - self.ground.y), {117, 172, 198}, {178, 220, 243})

	--GAME VARIABLES
	--State
	self.started = false
	self.paused = false
	self.ended = false
	self.newHighScore = false
	self.distance = 0
	self.lives = 0

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

	self.startText = text.new(self.text[platform].start, 0, config.display.height * 0.85, {32, 32, 32, 255}, font.small, "center", true, self.textClick, "start")
	self.pauseText = text.new(self.text[platform].pause, 0, config.display.height * 0.85, {32, 32, 32, 255}, font.small, "center", true, self.textClick, "pause")
	self.resumeText = text.new(self.text[platform].resume, 0, config.display.height * 0.85, {32, 32, 32, 255}, font.small, "center", true, self.textClick, "resume")
	self.resetText = text.new(self.text[platform].reset, 0, config.display.height * 0.85, {32, 32, 32, 255}, font.small, "center", true, self.textClick, "reset")
	self.distanceText = text.new(0, config.display.width * 0.08, config.display.height * 0.02, {240, 240, 240, 255}, font.large, "left")
	self.livesText = text.new(self.lives, config.display.width * 0.08, config.display.height * 0.12, {240, 240, 240, 255}, font.large, "left")
	self.statsText = text.new("top distance: "..config.game.topDistance.."\ntotal distance: "..config.game.totalDistance, config.display.width * 0.01, config.display.height * 0.02, {240, 240, 240, 255}, font.small, "left")
	self.highScoreText = text.new("new high score!", 0, config.display.height * 0.3, {247, 205, 37, 255}, font.small, "center")
	self.gameOverText = text.new("You lost!", 0, config.display.height * 0.1, {222, 76, 76, 255}, font.large, "center")
	self.infoText = text.new(self.text[platform].info, 0, config.display.height * 0.7, {240, 240, 240, 255}, font.tiny, "center")

	self.startText:show()
	self.statsText:show()
	self.infoText:show()
	self.pauseText:hide()
	self.resumeText:hide()
	self.resetText:hide()
	self.distanceText:hide()
	self.highScoreText:hide()
	self.gameOverText:hide()
	self.livesText:hide()

	self.title.targetY = config.display.height * 0.2

	self.screenShake = {
		tick = 0,
		duration = 0.1,
		magnitude = config.display.width * 0.005
	}

	if not self.first then
		sound:play("ui1")
	end
	if self.first then
		self.first = false
	end
end

function game:start()
	self.started = true
	self.player:run()

	self.startText:hide()
	self.statsText:hide()
	self.infoText:hide()
	self.pauseText:show()
	self.distanceText:show()
	self.livesText:show()
	self.title.targetY = self.title.offY
	self.hud.targetX = config.display.width * 0.01
	sound:play("ui1")
	sound:play("run")
end

function game:shake()
	self.screenShake.tick = self.screenShake.duration
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
	self.livesText:hide()

	--High score
	if self.distance > config.game.topDistance then
		self.newHighScore = true
		config.game.topDistance = math.floor(self.distance * 100) / 100
		self.highScoreText:show()
	end
	config.game.totalDistance = config.game.totalDistance + math.floor(self.distance * 100) / 100

	self.hud.targetX = self.hud.offX

	ini.save("config.ini", config)
	sound:play("hit")
	sound:stop("run")
end

function game:pause()
	if self.started and not self.lost then
		self.paused = true
		self.pauseText:hide()
		self.infoText:show()
		self.resumeText:show()
		sound:play("ui2")
		sound:stop("run")
	end
end

function game:resume()
	self.paused = false
	self.pauseText:show()
	self.infoText:hide()
	self.resumeText:hide()
	sound:play("ui1")
	sound:play("run")
end

function game:addLife()
	self.lives = self.lives + 1
	self.livesText:setText(self.lives)
	sound:play("life")
end

function game:spawnObstacle()
	--Deciding type
	local r = math.random()
	local type = "cactus"
	if r < 0.2 then
		r = math.random()
		if r > 0.1 then
			type = "mutantCactus"
		else
			type = "goodCactus"
		end
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
	if debugMode then
		if love.keyboard.isDown("f3") then
			dt = dt / 4
		end
	end

	if self.screenShake.tick > 0 then
		self.screenShake.tick = self.screenShake.tick - dt
		if self.screenShake.tick < 0 then
			self.screenShake.tick = 0
		end
	end

	self.title.y = self.title.y + math.floor(self.title.targetY - self.title.y) * (6 * dt)
	self.hud.x = self.hud.x + math.floor(self.hud.targetX - self.hud.x) * (6 * dt)

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
			self.gameSpeed = self.gameSpeed + 0.05
			self.player.gameSpeed = self.gameSpeed
			self.gameSpeedTick = 0
		end

		game:updateObstacles(dt)
		physics:update(dt)
		entity:update(dt)
	end

	popup:update(dt)

	--Updating Text Objects
	self.distanceText:setText(math.floor(self.distance * 100) / 100)

	self.startText:update(dt)
	self.infoText:update(dt)
	self.pauseText:update(dt)
	self.resumeText:update(dt)
	self.resetText:update(dt)
	self.distanceText:update(dt)
	self.statsText:update(dt)
	self.highScoreText:update(dt)
	self.gameOverText:update(dt)
	self.livesText:update(dt)


	--Sound killer
	if self.ended or self.paused then
		sound:stop("run")
	end
end

--==[[ DRAWING ]]==--

function game:drawGame()
	love.graphics.setCanvas(self.canvas)

	--Entities
	entity:draw()
	love.graphics.setCanvas()
end

function game:drawUI()
	self.startText:draw()
	self.infoText:draw()
	self.pauseText:draw()
	self.resumeText:draw()
	self.resetText:draw()
	self.distanceText:draw()
	self.statsText:draw()
	self.highScoreText:draw()
	self.gameOverText:draw()
	self.livesText:draw()

	popup:draw()

	--UI Images
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(atlas, title, (config.display.width / 2) - ( (titleWidth * drawSize * 0.1) / 2), self.title.y, 0, drawSize * 0.1, drawSize * 0.1)

	--distance
	love.graphics.draw(atlas, distance, self.hud.x, config.display.height * 0.005, 0, drawSize / assetSize, drawSize / assetSize)
	--Heart
	love.graphics.draw(atlas, heart, self.hud.x + (config.display.width * 0.005), config.display.height * 0.1, 0, drawSize / assetSize, drawSize / assetSize)
end

function game:draw()

	--Entity
	love.graphics.setCanvas(self.canvas.entity)
	love.graphics.clear()
	entity:draw()
	--UI
	love.graphics.setCanvas(self.canvas.gui)
	love.graphics.clear()
	self:drawUI()

	love.graphics.setCanvas()

	if self.screenShake.tick > 0 then
		love.graphics.push()
		love.graphics.translate(math.random(-self.screenShake.magnitude, self.screenShake.magnitude), math.random(-self.screenShake.magnitude, self.screenShake.magnitude))
	end

	--Sky
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.sky)

	--Ground
	love.graphics.setColor(self.ground.color)
	love.graphics.rectangle("fill", 0, self.ground.y, config.display.width, config.display.height - self.ground.y)

	love.graphics.setBlendMode("alpha", "premultiplied")
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas.entity)

	if self.screenShake.tick > 0 then
		love.graphics.pop()
	end

	--Vignette
	love.graphics.setColor(255, 255, 255, 100)
	love.graphics.draw(vignette, 0, 0, 0, config.display.width / vignette:getWidth(), config.display.height / vignette:getHeight())
	
	--Shadow
	love.graphics.setColor(0, 0, 0, 30)
	love.graphics.draw(self.canvas.gui, math.floor( -(config.display.width * 0.003)), 0)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas.gui)
	love.graphics.setBlendMode("alpha")

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
	if platform == "mobile" then
		self:input(x, y, "press")
	end
end

function game:touchreleased(id, x, y, dx, dy, pressure)
	if platform == "mobile" then
		self:input(x, y, "release")
	end
end

function game:mousepressed(x, y, key)
	if platform == "pc" then
		self:input(x, y, "mouse")
	end

	--popup:new(heart, config.display.width / 2, config.display.height / 2)
end

function game:input(x, y, t)
	if self.takeInput then
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
		end
		]]

		if y < self.ground.y then
			if t == "press" or t == "mouse" then
				if self.started and not self.paused and not self.ended then
					self.player:jump()
				end
			end
		else
			if t == "release" or t == "mouse" then
				self.startText:click(x, y, key)
				self.pauseText:click(x, y, key)
				self.resumeText:click(x, y, key)
				self.resetText:click(x, y, key)
				self.distanceText:click(x, y, key)
				self.statsText:click(x, y, key)
				self.highScoreText:click(x, y, key)
				self.gameOverText:click(x, y, key)
			end
		end
	end
end

function game.textClick(t)
	if t.tag == "start" then
		game:start()
	elseif t.tag == "pause" then
		game:pause()
	elseif t.tag == "resume" then
		game:resume()
	elseif t.tag == "reset" then
		game:reset()
	end
end

return game