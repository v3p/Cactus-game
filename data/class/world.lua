local world = {}

function world:load()
	--Loading atlas
	self.atlas, self.quad = loadAtlas("data/art/img/environment.png", assetSize, assetSize, 0)

	--World center. The sun & moon revolve around this point
	self.centerX = lg.getWidth() / 2
	self.centerY = lg.getHeight()

	self.orbitRadius = lg.getHeight()

	--Sun
	self.sun = {
		x = 0,
		y = 0,
		angle = 0,
		light = false
	}

	--Moon
	self.moon = {
		x = 0,
		y = 0,
		angle = 0
	}

	self.stars = self:generateStars(100)

	--Clouds
	self.cloud = {
		timer = 0,
		spawnRate = 10, --how many seconds between a cloud spawn
		speed = {10, 20},
		height = {0, lg.getHeight() * 0.3},
		img = {
			love.graphics.newQuad(16, 0, 48, 16, self.atlas:getWidth(), self.atlas:getHeight()),
			love.graphics.newQuad(64, 0, 32, 16, self.atlas:getWidth(), self.atlas:getHeight()),
			love.graphics.newQuad(32, 32, 32, 16, self.atlas:getWidth(), self.atlas:getHeight()),
			love.graphics.newQuad(64, 32, 64, 16, self.atlas:getWidth(), self.atlas:getHeight())
		},
		list = {}
	}

	--Spawning initial clouds 
	for i=1, 8 do
		self:spawnCloud(math.random(lg.getWidth()))
	end

	self.sky = {
		day = verticalGradient(config.display.width, config.display.height, {109 / 255, 160 / 255, 224 / 255}, {187 / 255, 237 / 255, 251 / 255}),
		night = verticalGradient(config.display.width, config.display.height, {22 / 255, 29 / 255, 36 / 255}, {59 / 255, 87 / 255, 113 / 255})
	}

	--ground
	self.ground = {
		x = 0,
		y = math.floor(config.display.height * 0.7),
		width = config.display.width * 2,
		height = config.display.height - math.floor(config.display.height * 0.6),
		color = {219, 212, 135, 255},
		type = "GROUND",
		texture = false
	}

	self.piramid = {
		quad = lg.newQuad(0, 48, 64, 64, self.atlas:getWidth(), self.atlas:getHeight()),
		x = math.random(lg.getWidth()),
		y = self.ground.y - (drawSize * 1.5),
		speed = 50
	}

	self.mountains = {
		quad = lg.newQuad(0, 80, 128, 16, self.atlas:getWidth(), self.atlas:getHeight()),
		x = 0,
		y = self.ground.y - (drawSize),
		speed = 20
	}
	--These are used for the looping function
	self.ground.x1 = 0
	self.ground.x2 = self.ground.width

	self:creatGroundTexture()
	physics:add(self.ground)

	self.time = math.pi
	self.timeScale = 0.03
end

function world:creatGroundTexture()
	local width = math.ceil(self.ground.width / drawSize)
	local height = math.floor(self.ground.height / drawSize)
	local groundImg = lg.newCanvas(self.ground.width, self.ground.height)

	local oldCanvas = lg:getCanvas()
	lg.setCanvas(groundImg)
	for y=1, height do
		for x=1, width do
			local quad = 18
			if y > 1 then
				quad = 17
			end
			lg.draw(self.atlas, self.quad[quad], drawSize * (x - 1), drawSize * (y - 1), 0, drawSize / assetSize, drawSize / assetSize)
		end
	end

	---Darkness
	local gradient = verticalGradient(self.ground.width, self.ground.height, {1, 1, 1, 1}, {0.1, 0.1, 0.1, 1})
	local bm = lg.getBlendMode()
	lg.setBlendMode("multiply", "premultiplied")
	lg.draw(gradient)
	lg.setBlendMode(bm)

	lg:setCanvas(oldCanvas)

	self.ground.texture = groundImg
end

function world:spawnCloud(x, y)
	x = x or lg.getWidth()
	y = y or math.random(self.cloud.height[1], self.cloud.height[2])

	self.cloud.list[#self.cloud.list + 1] = {
		x = x,
		y = y,
		img = math.random(#self.cloud.img),
		speed = math.random(self.cloud.speed[1], self.cloud.speed[2]),
		obsolete = false
	}

end

function world:generateStars(count)
	local canvas = lg.newCanvas(lg.getWidth(), lg.getHeight())
	local oldCanvas = lg.getCanvas()
	lg.setCanvas(canvas)
	lg.setColor(0, 0, 0, 1)
	lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())

	for i=1, count do
		local x = math.random(lg.getWidth())
		local y = math.random(lg.getHeight())
		local size = math.random(1, 3)
		lg.setColor(1, 1, 1, fmath.normal(y,lg.getHeight(), 0))
		lg.rectangle("fill", x, y, size, size)
	end

	lg.setCanvas(oldCanvas)

	return canvas
end

function world:createLights()
	self.sun.light = light:new(self.sun.x, self.sun.y, drawSize * 20, {1, 1, 1, 1}, self.sun)
	light:new(self.moon.x, self.moon.y, drawSize * 4, {1, 1, 1, 0.4}, self.moon)
	light:new(self.moon.x, self.moon.y, drawSize * 15, {1, 1, 1, 0.4}, self.moon)
end

function world:update(dt)
	local game = state:getState()
	if not game.started or game.paused then
		piramidSpeed = 0
	else
		piramidSpeed = game.gameSpeed
	end

	if state:getState().started then
		self.piramid.x = self.piramid.x - (self.piramid.speed * dt * piramidSpeed)
		self.mountains.x = self.mountains.x - (self.mountains.speed * dt * piramidSpeed)
	end

	if self.piramid.x < -(lg.getWidth() / 2) then
		self.piramid.x = math.random(lg.getWidth() * 2) + lg.getWidth()
	end

	if config.game.dayNightCycle then
		self.time = self.time + self.timeScale * dt
		if self.time > math.pi * 2 then
			self.time = 0
		end
	else
		if config.game.night then
			self.time = 0
		else
			self.time = math.pi
		end
	end

	--self.time = (math.pi * 2) * fmath.normal(love.mouse.getX(), 0, lg.getWidth())

	--Sun & Moon position
	self.moon.angle = self.time + math.pi
	self.moon.x = self.centerX + (self.orbitRadius * math.sin(self.moon.angle))
	self.moon.y = self.centerY + (self.orbitRadius * math.cos(self.moon.angle))

	self.sun.angle = self.time
	self.sun.x = self.centerX + (self.orbitRadius * math.sin(self.sun.angle))
	self.sun.y = self.centerY + (self.orbitRadius * math.cos(self.sun.angle))


	--Ambient light update
	light:setAmbient(0.6 + (fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) * 0.4))

	--Cloud spawning
	self.cloud.timer = self.cloud.timer + dt
	if self.cloud.timer > self.cloud.spawnRate then
		self:spawnCloud()
		self.cloud.timer = 0
	end

	--Cloud moving & removing
	for i,v in ipairs(self.cloud.list) do
		v.x = v.x - v.speed * dt

		if v.x < -(lg.getWidth() / 2) then
			table.remove(self.cloud.list, i)
		end
	end

	local groundSpeed = game.obstacleSpeed * game.gameSpeed

	if not game.started or game.paused then
		groundSpeed = 0
	end

	--self.speed * self.gameSpeed
	self.ground.x1 = self.ground.x1 - groundSpeed * dt
	self.ground.x2 = self.ground.x2 - groundSpeed * dt

	if self.ground.x1 < -self.ground.width then
		self.ground.x1 = self.ground.x2 + self.ground.width
	end

	if self.ground.x2 < -self.ground.width then
		self.ground.x2 = self.ground.x1 + self.ground.width
	end
end

function world:draw()
	--SKY
	lg.setColor(1, 1, 1, 1)
	lg.draw(self.sky.night)
	lg.setColor(1, 1, 1, fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius))
	lg.draw(self.sky.day)

	--Stars
	lg.setColor(1, 1, 1, fmath.normal(self.moon.y, self.orbitRadius, -self.orbitRadius))
	local bm = lg.getBlendMode()
	lg.setBlendMode("add")
	lg.draw(self.stars)
	lg.setBlendMode(bm)

	--Moon & sun
	lg.setColor(1, 1, 1, 1)
	lg.draw(self.atlas, self.quad[1], math.floor(self.moon.x), math.floor(self.moon.y), 0, drawSize / assetSize, drawSize / assetSize, assetSize / 2, assetSize / 2)
	lg.draw(self.atlas, self.quad[9], math.floor(self.sun.x), math.floor(self.sun.y), 0, drawSize / assetSize, drawSize / assetSize, assetSize / 2, assetSize / 2)

	--Clouds
	for i,v in ipairs(self.cloud.list) do
		local color = 0.4 + (fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) * 0.6)
		lg.setColor(color, color, color, 0.8)
		lg.draw(self.atlas, self.cloud.img[v.img], v.x, v.y, 0, drawSize / assetSize, drawSize / assetSize)
	end

	--Piramid
	
	local v = fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) + 0.4
    lg.setColor(v, v, v, 1)
	lg.draw(self.atlas, self.piramid.quad, math.floor(self.piramid.x), math.floor(self.piramid.y), 0, (drawSize * 1.5) / assetSize, (drawSize * 1.5) / assetSize)

	--Ground
	--setColor(self.ground.color)
	--love.graphics.rectangle("fill", 0, self.ground.y, config.display.width, config.display.height - self.ground.y)
	if self.ground.texture then
		local v = fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) + 0.4
		lg.setColor(v, v, v, 1)
		lg.draw(self.ground.texture, self.ground.x1, self.ground.y)
		lg.draw(self.ground.texture, self.ground.x2, self.ground.y)
	end

	--Sun light
	local hue = 50 * fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius)
	local light = 255 * fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) + 100
	--lg.setColor(hsl(hue, 255, light))
	--lg.rectangle("fill", 0, 0, 100, 100)

	if self.sun.light then
		self.sun.light.color = {hsl(hue, 200, light)}
	end
end

--Used to color shit based on the sun height.
function world:getNormalSunHeight()
	return fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius)
end


return world