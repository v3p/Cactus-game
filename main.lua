function love.load()
	--LÖVE Setup
	love.filesystem.setIdentity("Cactus Game")
	love.graphics.setDefaultFilter("nearest", "nearest")

	if not love.filesystem.exists("screenshot") then
		love.filesystem.createDirectory("screenshot")
	end

	local os = love.system.getOS()
	platform = "pc"
	if os == "Android" or os == "iOS"then
		platform = "mobile"
	end

	useShader = false

	--Loading Classes
	ini = require "data.class.ini"
	fmath = require "data.class.fmath"
	button = require "data.class.button"
	entity = require "data.class.entity"
	bump = require "data.class.bump"
	physics = require "data.class.physics"
	text = require "data.class.text"

	--loading States
	game = require "data.state.game"

	--Setting up / Loading config file
	local w, h = 1280, 720
	if platform == "mobile" then
		w, h = love.window.getDesktopDimensions()
	end
	config = {
		display = {
			width = w,
			height = h,
			fullscreen = false,
			display = 1,
			windowTitle = "Cactus Game"
		},
		controls = {
			jump = "space",
			pause = "p"
		},
		game = {
			topDistance = 0,
			totalDistance = 0
		}
	}

	if love.filesystem.exists("config.ini") then
		config = ini.load("config.ini")
	else
		ini.save("config.ini", config)
	end

	--Creating Window
	love.window.setMode(config.display.width, config.display.height, {resizable = true, fullscreen = config.display.fullscreen, display = config.display.display})
	love.window.setTitle(config.display.windowTitle)

	--Loading Assets
	assetSize = 16
	drawSize = math.floor(config.display.height * 0.1)
	vignette = love.graphics.newImage("data/art/img/vignette.png")
	title = love.graphics.newImage("data/art/img/title.png")
	loadFont()

	--Defining Entities
	entity:new(require("data.entity.player.player"), "player")
	entity:new(require("data.entity.cactus.cactus"), "cactus")
	entity:new(require("data.entity.mutantCactus.mutantCactus"), "mutantCactus")

	game:load()

	debugMode = false
end

function loadFont()
	--love.graphics.setLineWidth(math.floor(config.display.width * 0.004))
	love.graphics.setLineWidth(1)
	font = {
		small = love.graphics.newFont("data/art/font/pixelmix.ttf", math.floor(config.display.width * 0.03)),
		large = love.graphics.newFont("data/art/font/pixelmix.ttf", math.floor(config.display.width * 0.04))
	}
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end

function love.resize(w, h)
	config.display.width = w
	config.display.height = h
	drawSize = math.floor(config.display.height * 0.1) --0.15
	loadFont()
	game:resize()
end

function love.keypressed(key)
	if key == "escape" then love.event.push("quit") end
	game:keypressed(key)

	if key == "f1" then
		debugMode = not debugMode
	elseif key == "f2" then
		screenshot()
	end
end

function love.mousepressed(x, y, key)
	game:mousepressed(x, y, key)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	game:touchpressed(id, x, y, dx, dy, pressure)
end

function verticalGradient(width, height, ...)
	local canvas = love.graphics.newCanvas(width, height)
	local vertices = {}
	for i,v in ipairs({...}) do
		local y = (height  / (#{...} - 1)) * (i - 1)
		vertices[#vertices + 1] = {
			0, y,
			0, 0,
			v[1], v[2], v[3]
			}
		vertices[#vertices + 1] = {
			width, y,
			0, 0,
			v[1], v[2], v[3]
			}
	end
	local mesh = love.graphics.newMesh(vertices, "strip", "dynamic")
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, 0, 0)
	love.graphics.setCanvas()
	return canvas
end

function screenshot()
	local s = love.graphics.newScreenshot()
	local n = os.date("%x")
	s:encode("png", "screenshot/"..os.time()..".png")
end