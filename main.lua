NAME = "Cactus Game 2"
SUBTITLE = "Return of the cacti"
VERSION = "0.01"

lg = love.graphics
lw = love.window
fs = love.filesystem

function love.load()
	--LÖVE Setup
	love.filesystem.setIdentity("Cactus Game 2")
	love.graphics.setDefaultFilter("nearest", "nearest")

	--Checking platform
	local os = love.system.getOS()
	platform = "pc"
	if os == "Android" or os == "iOS"then
		platform = "mobile"
	end
	--platform = "mobile"

	--This needs to go.
	useShader = false

	--Loading Classes
	require "data.class.util"
	requireFolder("data/class")


	--loading States
	state:loadStates("data/state")

	--Setting up / Loading config file
	local w, h = 960, 540
	if platform == "mobile" then
		w, h = love.window.getDesktopDimensions()
	end
	config = {
		display = {
			width = w,
			height = h,
			fullscreen = false,
			display = 1,
			lights = true,
			windowTitle = NAME.." ["..VERSION.."]",
			useShaders = true,
			useChromaticAberrationShader = true
		},
		controls = {
			jump = "k",
			pause = "p",
			slide = "l",

			--DEV MODE
			toggleDevMode = "f1",
			toggleConsole = "f2",
			toggleShowCollisions = "f3",
			toggleStats = "f4",
			toggleUIBounds = "f5"
		},
		stats = {
			topDistance = {value = 0, name = "Top distance", unit = "meters"},
			totalDistance = {value = 0, name = "Total distance", unit = "meters"},
			jumps = {value = 0, name = "Jumps", unit = false},
			deaths = {value = 0, name = "Deaths", unit = false},
			drugsTaken = {value = 0, name = "Drugs taken", unit = false},
			timeSliding = {value = 0, name = "Time sliding", unit = "seconds"},
		},
		game = {
			unlockedSkins = 7,
			currentSkin = 1,
			dayNightCycle = false,
			night = true
		},
		sound = {
			volume = 1,
			music = true,
			soundFX = true
		},
		devMode = {
			enabled = false,
			showCollisions = true,
			showStats = true,
			showUIBounds = true
		}
	}

	--fs.remove("config.lua")	

	--Creating config file
	if love.filesystem.getInfo("config.lua") then
		config = fs.load("config.lua")()
	else
		saveConfig()
	end

	config.game.unlockedSkins = 11

	--Creating screenshot folder
	if not love.filesystem.getInfo("screenshot") then
		love.filesystem.createDirectory("screenshot")
	end

	--disable devmode on mobile 
	if platform == "mobile" then
		config.devMode.enabled = false
	end

	--Creating Window
	love.window.setMode(config.display.width, config.display.height, {resizable = true, fullscreen = config.display.fullscreen, display = config.display.display, usedpiscale = false})
	love.window.setTitle(config.display.windowTitle)

	--Loading Assets
	assetSize = 16
	drawSize = math.floor(config.display.height * 0.11)
	vignette = love.graphics.newImage("data/art/img/vignette.png")
	loadFont()

	--atlas = love.graphics.newImage("data/art/img/atlas.png")


	console:init(0, 0, config.display.width, config.display.height, true, font.console)
	console:setVisible(false)

	--Loading sounds
	sound:load("data/art/snd")
	
    sound:setVolume("ui1", 0.5)
    sound:setVolume("ui2", 0.5)
    sound:setVolume("explode", 0.5)
	sound:setLoop("run", true)
	sound:setLoop("main_theme", true)
	--sound:setLoop("game_over", true)

	--Defining Entities
	entity:load()
	entity:loadEntities("data/entity")

	--Defining Shaders

	wave = shader.new([[
	extern number strength;
	extern vec2 screen;
	extern highp float time;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		tc.y = tc.y + sin(  (tc.x * 30.0) + (time * 10.0) ) * (screen.y * 0.0004) * strength;
		return Texel(tex, tc) * color;
	}

	]])

	wave:send("screen", {config.display.width * 0.1, config.display.height * 0.1})
	wave:send("strength", 1)

	color = shader.new([[
	extern number time;
	extern number strength;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		vec4 pixel = Texel(tex, tc);

		pixel.r = pixel.r + ( (sin(time * 2.0) * 0.5) * strength);
		pixel.g = pixel.g + ( (cos(time * 2.0) * 0.5) * strength);
		return pixel * 1.1;
	}

	]])
	
	bw = shader.new([[
	extern number amt;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		vec4 pixel = Texel(tex, tc);
        number avg = (pixel.r + pixel.g + pixel.b) / 3.0;
        pixel.r = pixel.r + (avg - pixel.r) * amt;
        pixel.g = pixel.g + (avg - pixel.g) * amt;
        pixel.b = pixel.b + (avg - pixel.b) * amt;
		return pixel * color;
	}

	]])

	bw:send("amt", 1)

	rgbSplit = shader.new([[
	extern vec2 dir;
	vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
	{
		return color * vec4(Texel(tex, tc - dir).r, Texel(tex, tc).g, Texel(tex, tc + dir).b, 1.0);
	}

	]])

	--Togglin shaderz
	rgbSplit:setEnabled(config.display.useChromaticAberrationShader)

	--Togglin muzik
	setMusic()
	setSoundFX()

	light:load()
	ui:load()

	state:setState("game")
	sound:play("main_theme")
	sound:setVolume("main_theme", 0.6)
	sound:setVolume("game_over", 0.6)


	sound:setVolume("hit", 0.2)
	--sound:setPitch("game_over", 1.5)

end

function setMusic()
	--Togglin muzik
	sound:setEnabled("main_theme", config.sound.music)
	sound:setEnabled("game_over", config.sound.music)

	if config.sound.music then
		sound:play("main_theme")
	else
		sound:stop("main_theme")
		sound:stop("game_over")
	end
end

function setSoundFX()
	sound:setEnabled("run", config.sound.soundFX)
	sound:setEnabled("death", config.sound.soundFX)
	sound:setEnabled("hit", config.sound.soundFX)
	sound:setEnabled("jump", config.sound.soundFX)
	sound:setEnabled("jumpTrip", config.sound.soundFX)
	sound:setEnabled("life", config.sound.soundFX)
	sound:setEnabled("trip", config.sound.soundFX)
	sound:setEnabled("ui1", config.sound.soundFX)
	sound:setEnabled("ui2", config.sound.soundFX)
end

function loadFont()
	--love.graphics.setLineWidth(math.floor(config.display.width * 0.004))
	love.graphics.setLineWidth(1)
	font = {
		micro = love.graphics.newFont("data/art/font/joystix_monospace.ttf", math.floor(config.display.width * 0.012)),
		tiny = love.graphics.newFont("data/art/font/joystix_monospace.ttf", math.floor(config.display.width * 0.019)),
		small = love.graphics.newFont("data/art/font/joystix_monospace.ttf", math.floor(config.display.width * 0.04)),
		large = love.graphics.newFont("data/art/font/joystix_monospace.ttf", math.floor(config.display.width * 0.06)),
		console = love.graphics.newFont("data/art/font/VCR_OSD_MONO.ttf", math.floor(config.display.width * 0.019))
	}
end

function love.update(dt)
	if console:getVisible() then
		console:update(dt)
	else	
		state:update(dt)
		light:update(dt)
		light:updateMap()
		screenEffect:update(dt)
	end
end

function love.draw()
	screenEffect:push()

	state:draw()

	--DEV MODE
	if config.devMode.enabled then

		if config.devMode.showCollisions then
			physics:draw()
		end

		if config.devMode.showUIBounds then
			ui:drawBounds()
		end

		if config.devMode.showStats then
			local stats = love.graphics.getStats()

			lg.setColor(0, 0, 0, 0.8)
			lg.rectangle("fill", 0, 0, lg.getWidth() / 3, lg.getHeight() * 0.3)

			lg.setColor(1, 1, 0, 1)
			lg.setFont(font.micro)
			lg.print("FPS: "..love.timer.getFPS()..
					 --"\nFrameTime: "..love.timer.getDelta()..
					 "\nDetected Platform: "..platform..
					 "\nSpawned Entities: "..entity:count()..
					 "\nDraw Calls: "..stats.drawcalls..
					 "\nCanvas Switch: "..stats.canvasswitches..
					 "\nTexture Memory: "..(math.floor((stats.texturememory / 1024 / 1024) * 100) / 100).."mb"..
					 "\nCreated UI Elements: "..#ui.list..
					 "\nGame speed: "..state:getState().gameSpeed, 12, 12)
		end
	end

	screenEffect:draw()


	console:draw()
end

function love.resize(w, h)
	w = w or lg.getWidth()
	h = h or lg.getHeight()
	config.display.width = w
	config.display.height = h
	drawSize = math.floor(config.display.height * 0.1) --0.15
	loadFont()
	state:resize(w, h)
	console:resize(w, h)
	wave:send("screen", {config.display.width * 0.1, config.display.height * 0.1})
	wave:resize(w, h)
	color:resize(w, h)
end

function love.textinput(t)
	console:textinput(t)
end

function love.quit()
	saveConfig()
end

function fullscreen()
	if not lw.getFullscreen then
		love.window.setMode(0, 0, {fullscreen = true, display = config.display.display, usedpiscale = false})
		love.resize()
	else
		love.window.setMode(0, 0, {resizable = true, fullscreen = false, display = config.display.display, usedpiscale = false})
		love.resize()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("quit") 
	elseif key == "f" then
		screenshot()
	end

	if console:getVisible() then
		console:keypressed(key)
	else
		state:keypressed(key)
	end

	--devMode controls
	if key == config.controls.toggleDevMode then
			config.devMode.enabled = not config.devMode.enabled
	elseif key == config.controls.toggleConsole then
		console:setVisible(not console:getVisible())
	elseif key == config.controls.toggleShowCollisions then
		config.devMode.showCollisions = not config.devMode.showCollisions
	elseif key == config.controls.toggleStats then
		config.devMode.showStats = not config.devMode.showStats
	elseif key == config.controls.toggleUIBounds then
		config.devMode.showUIBounds = not config.devMode.showUIBounds
	end
end

function love.keyreleased()
	state:keyreleased()
end

function love.mousepressed(x, y, key)
	state:mousepressed(x, y, key)
	--screenEffect:ripple(x, y, time, radius, color, flash)
end

function love.wheelmoved(x, y)
	if console:getVisible() then
		console:wheelmoved(x, y)
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	state:touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	state:touchreleased(id, x, y, dx, dy, pressure)
end


function screenshot()
	love.graphics.captureScreenshot("screenshot/"..os.time()..".png")
end

function openURL(url)
	love.system.openURL(url)
end

function saveConfig()
	fs.write("config.lua", tableToString(config))
end








