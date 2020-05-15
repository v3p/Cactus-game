local sky = {}

function sky:load()
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
		speed = {5, 20},
		height = {0, lg.getHeight() * 0.4},
		img = {
			love.graphics.newQuad(16, 0, 48, 16, self.atlas:getWidth(), self.atlas:getHeight()),
			love.graphics.newQuad(64, 0, 32, 16, self.atlas:getWidth(), self.atlas:getHeight())
		},
		list = {}
	}

	--Spawning initial clouds 
	for i=1, 5 do
		self:spawnCloud(math.random(lg.getWidth()))
	end

	self.sky = {
		day = verticalGradient(config.display.width, config.display.height, {109 / 255, 160 / 255, 224 / 255}, {187 / 255, 237 / 255, 251 / 255}),
		night = verticalGradient(config.display.width, config.display.height, {22 / 255, 29 / 255, 36 / 255}, {59 / 255, 87 / 255, 113 / 255})
	}

	self.time = math.pi
	self.timeScale = 0.03
end

function sky:spawnCloud(x, y)
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

function sky:generateStars(count)
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

function sky:createLights()
	self.sun.light = light:new(self.sun.x, self.sun.y, drawSize * 20, {1, 1, 1, 1}, self.sun)
	light:new(self.moon.x, self.moon.y, drawSize * 4, {1, 1, 1, 0.4}, self.moon)
	light:new(self.moon.x, self.moon.y, drawSize * 15, {1, 1, 1, 0.4}, self.moon)
end

function sky:update(dt)
	self.time = self.time + self.timeScale * dt
	if self.time > math.pi * 2 then
		self.time = 0
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

end

function sky:draw()
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
	lg.draw(self.atlas, self.quad[1], self.moon.x, self.moon.y, 0, drawSize / assetSize, drawSize / assetSize, assetSize / 2, assetSize / 2)
	lg.draw(self.atlas, self.quad[9], self.sun.x, self.sun.y, 0, drawSize / assetSize, drawSize / assetSize, assetSize / 2, assetSize / 2)

	--Clouds
	for i,v in ipairs(self.cloud.list) do
		local color = 0.4 + (fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) * 0.6)
		lg.setColor(color, color, color, 0.8)
		lg.draw(self.atlas, self.cloud.img[v.img], v.x, v.y, 0, drawSize / assetSize, drawSize / assetSize)
	end


	local hue = 50 * fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius)
	local light = 255 * fmath.normal(self.sun.y, self.orbitRadius, -self.orbitRadius) + 100
	--lg.setColor(hsl(hue, 255, light))
	--lg.rectangle("fill", 0, 0, 100, 100)

	if self.sun.light then
		self.sun.light.color = {hsl(hue, 200, light)}
	end
end


return sky