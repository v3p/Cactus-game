local game = {}

local gameOverLines = {
	"wasted",
	"you fucked up",
	"you got fucked up",
	"you got dead",
	"lol u suck",
	"better luck next time",
	"R.I.P",
	"u dead",
	"that looked like it hurt",
	"stings doesn't it?",
	"you're dead",
	"great job",
	"hahahahahahahaha"
}

--Screen creation
function game:createStartup()
	--UI
	ui:clear()

	--Panel
	self.mainPanel = ui:newPanel({0, 0, 0, 0.4}, 0, 0, lg.getWidth() / 2, lg.getHeight(), "top")
	ui:center(self.mainPanel, true, false)
	ui:hide(self.mainPanel, true)
	ui:setScreen(self.mainPanel, "main")

		--Title
	local titleQuad = ui:newQuad(0, 16, 77, 32)
	--ui:newImage(quad, x, y, scale, hideDirection)
	self.title = ui:newImage(false, ui.atlas, titleQuad, 0, lg.getHeight() * 0.1, (drawSize / assetSize) * 1.4, "left")

	ui:center(self.title, true, false)
	ui:hide(self.title, true)
	ui:setScreen(self.title, "main")

	--Start button
	--ui:newButton(func, text, x, y, width, height, hideDirection)
	self.startButton = ui:newButton(startButton, "Start", font.small, 0, lg.getHeight() * 0.6, drawSize * 5, drawSize * 2, "right")

	ui:setFont(self.startButton, font.large)

	ui:center(self.startButton, true, false)
	ui:hide(self.startButton, true)
	ui:setScreen(self.startButton, "main")

	--Exit button
	self.exitButton = ui:newImage(exitButton, ui.atlas, ui.quad[4], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.exitButton, true)
	ui:setScreen(self.exitButton, "main")

	--settings button
	self.settingsButton = ui:newImage(settingsButton, ui.atlas, ui.quad[5], drawSize * 0.1, drawSize * 0.1, (drawSize / assetSize) * 1.6, "top")

	ui:hide(self.settingsButton, true)
	ui:setScreen(self.settingsButton, "main")
	
	--skins
	self.skinsButton = ui:newImage(skinsButton, ui.atlas, ui.quad[7], drawSize * 0.1, drawSize * 1.8, (drawSize / assetSize) * 1.6, "top")

	ui:hide(self.skinsButton, true)
	ui:setScreen(self.skinsButton, "main")
	
	--ststs
	self.statsButton = ui:newImage(statsButton, ui.atlas, ui.quad[8], drawSize * 0.1, drawSize * 3.5, (drawSize / assetSize) * 1.6, "top")

	ui:hide(self.statsButton, true)
	ui:setScreen(self.statsButton, "main")

	--Credits
	self.creditsButton = ui:newImage(creditsButton, ui.atlas, ui.quad[16], drawSize * 0.1, drawSize * 5.2, (drawSize / assetSize) * 1.6, "top")

	ui:hide(self.creditsButton, true)
	ui:setScreen(self.creditsButton, "main")

	--Help button
	self.helpButton = ui:newImage(helpButton, ui.atlas, ui.quad[32], drawSize * 2, drawSize * 0.1, (drawSize / assetSize) * 1.6, "top")

	ui:hide(self.helpButton, true)
	ui:setScreen(self.helpButton, "main")

	--Creating the settings screen
	self:createSettings()
	self:createSkinSelection()
	self:createStats()
	self:createCredits()
	self:createHelp()
end

function game:createSkinSelection()
		--Panel
	self.skinPanel = ui:newPanel({0, 0, 0, 0.7}, 0, 0, lg.getWidth(), lg.getHeight(), "bottom")
	ui:center(self.skinPanel, true, false)
	ui:hide(self.skinPanel, true)
	ui:setScreen(self.skinPanel, "skin")


	--back button
	self.backButton = ui:newImage(backButton, ui.atlas, ui.quad[24], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.backButton, true)
	ui:setScreen(self.backButton, "skin")


	---func, text, x, y, font, color, hideDirection)
	self.title = ui:newText(false, "Select skin", 0, lg.getHeight() * 0.01, font.small, convertColor(228, 61, 61, 255), "bottom")
	ui:center(self.title, true, false)
	ui:hide(self.title, true)
	ui:setScreen(self.title, "skin")

	--Preview
	--ui:newImage(func, atlas, quad, x, y, scale, hideDirection)
	local q = (self.player.currentSkin - 1) * 8 + 1
	self.preview = ui:newImage(nil, self.player.atlas, self.player.quad[q], 0, 0, drawSize * 0.2, "bottom")
	ui:center(self.preview, true, true)
	ui:hide(self.preview, true)
	ui:setScreen(self.preview, "skin")

	--Name
	local name = self.player.skinNames[self.player.currentSkin]
	self.skinName = ui:newText(false, name, 0, lg.getHeight() * 0.7, font.small, convertColor(228, 61, 61, 255), "bottom")
	ui:center(self.skinName, true, false)
	ui:hide(self.skinName, true)
	ui:setScreen(self.skinName, "skin")

	--Last button
	self.lastButton = ui:newImage(lastButton, ui.atlas, ui.quad[22], lg.getWidth() * 0.3, 0, (drawSize / assetSize) * 1.6, "left")

	ui:center(self.lastButton, false, true)
	ui:hide(self.lastButton, true)
	ui:setScreen(self.lastButton, "skin")

	--Next button
	self.nextButton = ui:newImage(nextButton, ui.atlas, ui.quad[23], lg.getWidth() * 0.6, 0, (drawSize / assetSize) * 1.6, "right")

	ui:center(self.nextButton, false, true)
	ui:hide(self.nextButton, true)
	ui:setScreen(self.nextButton, "skin")
end

function game:createStats()
	--ui:clear()
	--Panel
	self.settingsPanel = ui:newPanel({0, 0, 0, 0.4}, 0, 0, lg.getWidth() / 2, lg.getHeight(), "bottom")
	ui:center(self.settingsPanel, true, false)
	ui:hide(self.settingsPanel, true)
	ui:setScreen(self.settingsPanel, "stats")


	--back button
	self.backButton = ui:newImage(backButton, ui.atlas, ui.quad[6], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.backButton, true)
	ui:setScreen(self.backButton, "stats")


	---func, text, x, y, font, color, hideDirection)
	self.subtitle = ui:newText(false, "Statistics", 0, lg.getHeight() * 0.01, font.small, convertColor(228, 61, 61, 255), "bottom")
	ui:center(self.subtitle, true, false)
	ui:hide(self.subtitle, true)
	ui:setScreen(self.subtitle, "stats")

	local statString = ""
	for i,v in pairs(config.stats) do
		statString = statString..v.name.." = "..v.value
		if v.unit then
			statString = statString.." "..v.unit
		end
		statString = statString.."\n"
	end


	--Stats
	self.stats = ui:newText(false, statString, 0, lg.getHeight() * 0.1, font.tiny, convertColor(61, 228, 61, 255), "bottom")
	ui:center(self.stats, true, false)
	ui:hide(self.stats, true)
	ui:setScreen(self.stats, "stats")
end

function game:createCredits()
	--ui:clear()
	--Panel
	self.settingsPanel = ui:newPanel({0, 0, 0, 0.7}, 0, 0, lg.getWidth(), lg.getHeight(), "bottom")
	ui:center(self.settingsPanel, true, false)
	ui:hide(self.settingsPanel, true)
	ui:setScreen(self.settingsPanel, "credits")


	--back button
	self.backButton = ui:newImage(backButton, ui.atlas, ui.quad[6], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.backButton, true)
	ui:setScreen(self.backButton, "credits")


	---func, text, x, y, font, color, hideDirection)
	self.subtitle = ui:newText(false, "Credits", 0, lg.getHeight() * 0.01, font.small, convertColor(228, 61, 61, 255), "bottom")
	ui:center(self.subtitle, true, false)
	ui:hide(self.subtitle, true)
	ui:setScreen(self.subtitle, "credits")

	local creditText = [[* * *
THIRD PARTY LIBRARIES
	'Bump.lua' Used for collision detection and response.
	Made by Enrique García Cota.
* * *
FONTS
	'Joystix-monospace' Used as the main font.
	Made by Typodermic Fonts
	'VCR OSD Mono' Used in the developer console & the credits.
	Made by Riciery Leal

	Fonts acquired from 'www.dafont.com'	
* * *
	Created using the *awesome* framework, Löve (Version 11.3)
	www.love2d.org
* * *
	Everything else made by Pawel Þorkelsson.

	Thank you for playing!]]

	--Stats
	self.stats = ui:newText(false, creditText, 0, lg.getHeight() * 0.1, font.console, convertColor(228, 228, 228, 255), "bottom")
	ui:center(self.stats, true, false)
	ui:hide(self.stats, true)
	ui:setScreen(self.stats, "credits")

	--Love button
	self.loveLogo = ui:newImage(backButton, ui.atlas, ui.quad[34], lg.getWidth() - (drawSize * 1.7), lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	--ui:center(self.loveLogo, true, false)
	ui:hide(self.loveLogo, true)
	ui:setScreen(self.loveLogo, "credits")
end

--It's called help in code but its tutorial. 
function game:createHelp()
	--ui:clear()

	--back button
	self.backButton = ui:newImage(backButton, ui.atlas, ui.quad[6], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.backButton, true)
	ui:setScreen(self.backButton, "help")

	--LINES
	self.tutorialLines = {
		{pc = "Press '"..config.controls.jump.."' to jump\nThe longer you hold, The higher you jump.", mobile = "Tap the sky to jump\nThe longer you hold, The higher you jump."},
		{pc = "Press '"..config.controls.slide.."' to slide\nThe longer you hold, The further you slide.", mobile = "Tap the ground to slide\nThe longer you hold, The further you slide."},
		{pc = "This is your regular run of the mill basic ass cactus. Jump over it or you'll get dead."},
		{pc = "This is a mutant cactus. This fucker escaped from a nuclear testing facility and he's gonna jump over you."},
		{pc = "This huge motherfucker is the same as the last one but bigger. Due to it's increased mass it's gonna try to jump over you, But won't clear you. Slide under it."},
		{pc = "This is a hedgehog. Why is it in the desert? To make sure you don't leave without several spikes in your bum. Jump."},
		{pc = "This is a landmine. A historic battle took palce in this desert in WW2 and now there's a bunch of active mines all over the place. Jump."},
		{pc = "This is a mushroom. They're healthy. Eat that shit."},
		{pc = "This is a peyote cactus. It's full to the brim with mescaline. You're gonna trip balls if you eat it. But also get extra points for each cactus you clear while tripping."},
		{pc = "This world is all backwards. The longer you run, the faster you go. Also you can unlock various skins and shit. Have fun. <3"}

	}

	self.tutorialText = ui:newText(false, "this is tutirial text", 0, lg.getHeight() * 0.4, font.tiny, convertColor(61, 228, 61, 255), "top")

	ui:hide(self.tutorialText, true)
	ui:center(self.tutorialText, true, false)
	ui:setScreen(self.tutorialText, "help")

	self.continueText = ui:newText(false, "Jump to continue", 0, lg.getHeight() * 0.9, font.tiny, convertColor(228, 61, 61, 255), "bottom")

	ui:hide(self.continueText, true)
	ui:center(self.continueText, true, false)
	ui:setScreen(self.continueText, "help")
end

function game:createSettings()
	--ui:clear()
	--Panel
	self.settingsPanel = ui:newPanel({0, 0, 0, 0.4}, 0, 0, lg.getWidth(), lg.getHeight(), "bottom")
	ui:hide(self.settingsPanel, true)
	ui:setScreen(self.settingsPanel, "settings")


	--back button
	self.backButton = ui:newImage(backButton, ui.atlas, ui.quad[24], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.backButton, true)
	ui:setScreen(self.backButton, "settings")


	---func, text, x, y, font, color, hideDirection)
	self.subtitle = ui:newText(false, "SETTINGS", 0, lg.getHeight() * 0.01, font.small, convertColor(228, 61, 61, 255), "bottom")
	ui:center(self.subtitle, true, false)
	ui:hide(self.subtitle, true)
	ui:setScreen(self.subtitle, "settings")

	---TOGGLE SHADERS
	self.toggleShaders = ui:newCheckBox(toggleShaders, "Use shaders", lg.getWidth() * 0.01, lg.getHeight() * 0.15, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleShaders, true)
	ui:setScreen(self.toggleShaders, "settings")
	self.toggleShaders.checked = config.display.useShaders

	---TOGGLE CHROATIC ABERRATION
	self.toggleCA = ui:newCheckBox(toggleCA, "Use chromatic ABERRATION", lg.getWidth() * 0.01, lg.getHeight() * 0.28, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleCA, true)
	ui:setScreen(self.toggleCA, "settings")
	self.toggleCA.checked = config.display.useShaders

	---TOGGLE MUSIC
	self.toggleMusic = ui:newCheckBox(toggleMusic, "Music", lg.getWidth() * 0.01, lg.getHeight() * 0.40, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleMusic, true)
	ui:setScreen(self.toggleMusic, "settings")
	self.toggleMusic.checked = config.sound.music

		---TOGGLE SFX
	self.toggleSFX = ui:newCheckBox(toggleSFX, "Sound effects", lg.getWidth() * 0.01, lg.getHeight() * 0.52, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleSFX, true)
	ui:setScreen(self.toggleSFX, "settings")
	self.toggleSFX.checked = config.sound.soundFX
   
   --toggle devmodr
    self.toggleDev = ui:newCheckBox(toggleDev, "Developer mode", lg.getWidth() * 0.01, lg.getHeight() * 0.64, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleDev, true)
	ui:setScreen(self.toggleDev, "settings")
	self.toggleDev.checked = config.devMode.enabled

	---TOGGLE Day night
	self.toggleDayNight = ui:newCheckBox(toggleDayNight, "Day & Night cycle", lg.getWidth() * 0.5, lg.getHeight() * 0.15, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleDayNight, true)
	ui:setScreen(self.toggleDayNight, "settings")
	self.toggleDayNight.checked = config.game.dayNightCycle

	---TOGGLE Day night
	self.toggleNight = ui:newCheckBox(toggleNight, "Night", lg.getWidth() * 0.5, lg.getHeight() * 0.28, (drawSize / assetSize) * 1, "right")
	ui:hide(self.toggleNight, true)
	ui:setScreen(self.toggleNight, "settings")
	self.toggleNight.checked = config.game.night
	self.toggleNight.enabled = not config.game.dayNightCycle

end

function game:createIngame()
	--DISTANCE
	self.distanceLogo = ui:newImage(false, ui.atlas, ui.quad[25], lg.getWidth() * 0.01, lg.getHeight() * 0.85, (drawSize / assetSize) * 1.4, "left")
	ui:hide(self.distanceLogo, true)
	ui:setScreen(self.distanceLogo, "ingame")

	self.ingameScore = ui:newText(false, "0", lg.getWidth() * 0.11, lg.getHeight() * 0.87, font.small, {0.9, 0.9, 0.9}, "bottom")
	ui:hide(self.ingameScore, true)
	ui:setScreen(self.ingameScore, "ingame")

	--LIVES
	self.livesLogo = ui:newImage(false, ui.atlas, ui.quad[26], lg.getWidth() * 0.01, lg.getHeight() * 0.75, (drawSize / assetSize) * 1.4, "left")
	ui:hide(self.livesLogo, true)
	ui:setScreen(self.livesLogo, "ingame")

	self.ingameLives = ui:newText(false, self.lives, lg.getWidth() * 0.11, lg.getHeight() * 0.77, font.small, {0.9, 0.9, 0.9}, "bottom")
	ui:hide(self.ingameLives, true)
	ui:setScreen(self.ingameLives, "ingame")
end

function game:createEndgame()
	--Destroy
	ui:clear()

	self.resetButton = ui:newButton(resetButton, "try again", font.tiny, 0, lg.getHeight() * 0.6, drawSize * 5, drawSize * 2, "left")

	--ui:setFont(self.resetButton, font.large)

	ui:center(self.resetButton, true, false)
	ui:hide(self.resetButton, true)
	ui:setScreen(self.resetButton, "endgame")

	local line = gameOverLines[math.random(#gameOverLines)]
	if state:getState().tutorial then
		line = "haha, Didn't even pass the tutorial"
	end
	self.gameOverText = ui:newText(false, line, 0, lg.getHeight() * 0.05, font.large, {0.8, 0.2, 0.2}, "top")
	ui:center(self.gameOverText, true, false)
	ui:hide(self.gameOverText, true)
	ui:setScreen(self.gameOverText, "endgame")

	local stext = "You made it "..(math.floor(self.distance * 100) / 100).." meters"
	if self.tutorial then
		stext = ""
	end

	self.scoreText = ui:newText(false, stext, 0, lg.getHeight() * 0.45, font.small, {0.1, 0.9, 0.2}, "left")
	ui:center(self.scoreText, true, false)
	ui:hide(self.scoreText, true)
	ui:setScreen(self.scoreText, "endgame")

	self.exitButton = ui:newImage(exitButton, ui.atlas, ui.quad[4], drawSize * 0.1, lg.getHeight() - (drawSize * 1.7), (drawSize / assetSize) * 1.6, "bottom")

	ui:hide(self.exitButton, true)
	ui:setScreen(self.exitButton, "endgame")
end

--Next step of the tutoial. The tutorial should probably be done in a seperate file.
function game:nextStep()
	if not self.tutorialEntity or self.tutorialEntity.obsolete then
		self.tutorialStep = self.tutorialStep + 1

		if self.tutorialStep > #self.tutorialLines then
			self:load()

		else

			---TEXT
			local text = ""
			if platform == "pc" then
				text = self.tutorialLines[self.tutorialStep].pc
			else
				text = self.tutorialLines[self.tutorialStep].mobile
			end

			text = text or self.tutorialLines[self.tutorialStep].pc

			self.tutorialText.text = text
			
			--ENTITY

			if self.tutorialStep == 3 then
				self.tutorialEntity  = self:spawnObstacle("cactus")
			elseif self.tutorialStep == 4 then
				self.tutorialEntity  = self:spawnObstacle("mutantCactus")
			elseif self.tutorialStep == 5 then
				self.gameSpeed = 1.4
				self.tutorialEntity  = self:spawnObstacle("giantMutantCactus")
			elseif self.tutorialStep == 6 then
				self.gameSpeed = 1
				self.tutorialEntity  = self:spawnObstacle("hedgehog")
			elseif self.tutorialStep == 7 then
				self.tutorialEntity  = self:spawnObstacle("mine")
			elseif self.tutorialStep == 8 then
				self.tutorialEntity  = self:spawnObstacle("imposterCactus")
			elseif self.tutorialStep == 9 then
				self.tutorialEntity  = self:spawnObstacle("funnyCactus")
			end
		end
	end
end

function game:load(first)
	self.tutorial = false
	self.tutorialStep = 0
	self.tutorialEntity = false

	self.canvas = {
		entity = love.graphics.newCanvas(config.display.width, config.display.height),
		gui = love.graphics.newCanvas(config.display.width, config.display.height),
		shader = love.graphics.newCanvas(config.display.width, config.display.height),
		master = love.graphics.newCanvas(config.display.width, config.display.height)
	}

	self.button = {}

	self.first = first or true

	self:reset()
end

function game:reset()
	physics:load()
	light:load()
	world:load()
	world:createLights()

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
	self.time = 0

	--Obstacles
	self.obstacleSpawnRate = 0.5
	self.obstacleSpawnTick = 0
	self.obstacleSpeed = config.display.width * 0.5

	--Creating Entities
	entity:clear()

	self.player = entity:spawn("player", {ground = world.ground.y, gameSpeed = self.gameSpeed}, "player")
	self.player:setSkin(config.game.currentSkin)

	self.trip = false
	self.tripDuration = 8
	self.tripMagnitude = 1
	self.tripTick = 0
	self.tripRising = false
	self.tripRiseSpeed = 1

	if self.first then
		self.first = false
	end

	wave:send("strength", 1)
	self:setVolume()
	sound:stopAll()
	sound:play("main_theme")
	sound:setVolume("main_theme", 0.6)

	screenEffect:flash(3, {0, 0, 0})

	--UI
	self:createStartup()
	ui:showScreen("main")
end

function game:start()
	ui:hideScreen("settings")
	ui:hideScreen("skin")
	ui:hideScreen("stats")
	ui:hideScreen("credits")
	self:createIngame()
	self.started = true
	self.player:run()
	self.player:show()
	self.player.animation[self.player.currentAnimation]:start()
	sound:play("run")
	ui:hideScreen("main")

	if not self.tutorial then
		ui:showScreen("ingame")
	end
end

function game:lose()
	sound:stopAll()
	game:stopTrip()
	sound:play("game_over")
	screenEffect:shake()
	self.player:hide()

	--Input Delay
	self.takeInput = false
	self.inputDelayTick = self.inputDelay

	self.ended = true

	--High score
	if self.distance > config.stats.topDistance.value then
		self.newHighScore = true
		config.stats.topDistance.value = math.floor(self.distance * 100) / 100
	end
	config.stats.totalDistance.value = config.stats.totalDistance.value + math.floor(self.distance * 100) / 100

	saveConfig()
	--sound:setVolume("hit", 0.1)
	sound:play("hit")
	sound:play("death", 0.05)
	sound:stop("run")

	--UI
	ui:hideScreen("ingame")
	ui:deleteScreen("endgame")
	self:createEndgame()
	ui:showScreen("endgame")
	self.tutorial = false

	--Stats
	config.stats.deaths.value = config.stats.deaths.value + 1
end

function game:pause()
	if self.started and not self.lost then
		self.paused = true
		sound:stop("run")
	end
end

function game:resume()
	self.paused = false
	sound:play("run")
end

function game:addLife()
	self.lives = self.lives + 1
	self.ingameLives.text = self.lives
	sound:play("life")

	self.player:pickup(ui.atlas, ui.quad[26])
end

function game:loseLife()
	self.lives = self.lives - 1
	self.ingameLives.text = self.lives
	
	if self.lives < 0 then
		self:lose()
	end
end

function game:startTrip()
	if self.trip then
		self.tripTick = self.tripDuration
	else
		self.trip = true
		self.tripRising = true
		self.tripMagnitude = 0
		self.tripTick = self.tripDuration
	end
	sound:play("trip")

	--Stats
	config.stats.drugsTaken.value = config.stats.drugsTaken.value + 1
end

function game:stopTrip()
	self.trip = false
	self.tripRising = false
	self.tripMagnitude = 0
	self.tripTick = 0
	sound:stopAll()
end

--This is called when an enemy has been cleared
--Called from entity.lua!
function game:clearEnemy(e)
	if self.trip then
		self.distance = self.distance + 10
		self.player:pickup(ui.atlas, ui.quad[25])
	end
end

--This probably needs to go
function game:setVolume(c)
	c = c or false
	if c then
		config.sound.volume = config.sound.volume - 0.25
		if config.sound.volume < 0.25 then
			config.sound.volume = 1
		end
	end

	local realVolume = config.sound.volume
	if config.sound.volume == 0.25 then
		realVolume = 0
	end

	sound:setMasterVolume(realVolume)
end

function pickType()
	local entityType
	--Deciding type
	local types = {
		cactus = {weight = 60, minSpeed = 1},
		mutantCactus = {weight = 30, minSpeed = 1.1},
		hedgehog = {weight = 10, minSpeed = 1},
		imposterCactus = {weight = 4, minSpeed = 1.2},
		giantMutantCactus = {weight = 5, minSpeed = 1.4},
		funnyCactus = {weight = 5, minSpeed = 1.3},
		mine = {weight = 3, minSpeed = 1.5}
	}

	--Calculating sum of the weights
	local sum = 0
	for k,v in pairs(types) do
		sum = sum + v.weight
	end

	--Random number
	local r = math.random(sum)
	local rsum = 0 --running sum
	for k,v in pairs(types) do
		rsum = rsum + v.weight
		if rsum > r then
			entityType = k
			break
		end
	end

	--Terrible fix, But is plan b if the weighted random
	--function fucks up.
	if not entityType or state:getState().gameSpeed < types[entityType].minSpeed then
		entityType = "cactus"
	end

	return entityType
end
function game:spawnObstacle(type)
	type = type or pickType()
	--Spawning
	local c = entity:spawn(type, {ground = world.ground.y, obstacleSpeed = self.obstacleSpeed, gameSpeed = self.gameSpeed})
	physics.add(c)

	return c
end

--==[[ UPDATING ]]==--

function game:updateObstacles(dt)
	if self.started and not self.paused and not self.ended and not self.tutorial then
		self.obstacleSpawnTick = self.obstacleSpawnTick + (dt * self.gameSpeed)
		if self.obstacleSpawnTick > (1 / self.obstacleSpawnRate) then
			game:spawnObstacle()
			--Double Spawn
			local r = math.random()
			if r < 0.4 then
				if self.gameSpeed < 1.5 then
					self.obstacleSpawnTick = (1 / self.obstacleSpawnRate)  / 2
				else
					self.obstacleSpawnTick = (1 / self.obstacleSpawnRate) * 0.3
				end
			else
				self.obstacleSpawnTick = 0
			end
		end
	end
end

function game:update(dt)
	if self.trip then
		if self.tripRising then
			self.tripMagnitude = self.tripMagnitude + (self.tripRiseSpeed * dt)
			dt = dt / (self.tripMagnitude + 1)
			wave:send("strength", self.tripMagnitude )
			color:send("strength", self.tripMagnitude )

			if self.tripMagnitude > 1 then
				self.tripMagnitude = 1
				self.tripRising = false
			end
		else
			self.tripTick = self.tripTick - dt
			self.tripMagnitude = fmath.normal(self.tripTick, 0, self.tripDuration)
			dt = dt / (self.tripMagnitude + 1)
			wave:send("strength", self.tripMagnitude )
			color:send("strength", self.tripMagnitude )

			if self.tripTick < 0 then
				self.tripTick = 0
				self.trip = false
			end
		end
	end

	self.time = self.time + dt
	if self.time > math.pi then time = 0 end
	wave:send("time", self.time)
	color:send("time", self.time)

	--Input Delay
	if not self.takeInput then
		self.inputDelayTick = self.inputDelayTick - dt
		if self.inputDelayTick < 0 then
			self.inputDelayTick = 0
			self.takeInput = true
		end
	end

	if self.started and not self.ended and not self.paused then
		local timeScale = 1
		if self.trip then
			timeScale = timeScale * 2
		end
		self.distance = self.distance + (dt * (self.gameSpeed * timeScale) )
		self.ingameScore.text = math.floor(self.distance * 100) / 100

		self.gameSpeedTick = self.gameSpeedTick + dt
		if self.gameSpeedTick > self.gameSpeedTime then
			self.gameSpeed = self.gameSpeed + 0.05
			self.player.gameSpeed = self.gameSpeed
			self.gameSpeedTick = 0
		end

	end

	--Dead slow motion
	ui:update(dt)
	if self.ended then
		dt = dt / 8
	end

	world:update(dt)
	game:updateObstacles(dt)
	entity:update(dt)
	physics:update(dt)
	sound:update(dt)

	if self.ended then
		dt = dt * 8
	end

	popup:update(dt)

	--Sound killer
	if self.ended or self.paused then
		sound:stop("run")
	end

end

--==[[ DRAWING ]]==--


function game:drawTrip()
	love.graphics.setCanvas(self.canvas.shader)
	
	lg.translate(self.player.x, self.player.y)
	lg.scale(1 + (math.cos(self.time * 0.2) * (self.tripMagnitude * 0.01)) + (0.2 * self.tripMagnitude))
	lg.rotate(math.sin(self.time) * (self.tripMagnitude * 0.01))
	lg.translate(-(self.player.x), -(self.player.y))

	color:draw(function()

	world:draw()



	love.graphics.setBlendMode("alpha", "premultiplied")
	setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas.entity)

	light:draw()
	end)
	love.graphics.setCanvas()

	rgbSplit:send("dir", {drawSize * (self.tripMagnitude * 0.0002), 0})
	rgbSplit:draw(function() 
		wave:draw(function()
			setColor(255, 255, 255, 255)
			love.graphics.draw(self.canvas.shader)
		end)
							--popup
		popup:draw()

		--Vignette
		setColor(255, 255, 255, 100)
		love.graphics.draw(vignette, 0, 0, 0, config.display.width / vignette:getWidth(), config.display.height / vignette:getHeight())
		
		--UI Shadow
		setColor(0, 0, 0, 30)
		love.graphics.draw(self.canvas.gui, math.floor( -(config.display.width * 0.003)), 0)

		setColor(255, 255, 255, 255)
		love.graphics.draw(self.canvas.gui)
		love.graphics.setBlendMode("alpha")
	end)
end

function game:drawLose()
	love.graphics.setCanvas(self.canvas.shader)
	rgbSplit:send("dir", {drawSize * 0.00003, 0})
	rgbSplit:draw(function() 
		bw:draw(function()

			world:draw()


			love.graphics.setBlendMode("alpha", "premultiplied")
			setColor(255, 255, 255, 255)
			love.graphics.draw(self.canvas.entity)

			light:draw()
		end)
				--popup
		popup:draw()

		--Vignette
		setColor(255, 255, 255, 100)
		love.graphics.draw(vignette, 0, 0, 0, config.display.width / vignette:getWidth(), config.display.height / vignette:getHeight())
		
		--UI Shadow
		setColor(0, 0, 0, 30)
		love.graphics.draw(self.canvas.gui, math.floor( -(config.display.width * 0.003)), 0)

		setColor(255, 255, 255, 255)
		love.graphics.draw(self.canvas.gui)
		love.graphics.setBlendMode("alpha")
	end)
	love.graphics.setCanvas()

	setColor(255, 255, 255, 255)
	love.graphics.draw(self.canvas.shader)
end


function game:draw()
	--Entity 
	love.graphics.setCanvas(self.canvas.entity)
	love.graphics.clear()
	entity:draw()


	--UI
	love.graphics.setCanvas(self.canvas.gui)
	love.graphics.clear()
	ui:draw()
	love.graphics.setCanvas()


	if self.trip then
		self:drawTrip()
    elseif self.ended then
        self:drawLose()
	else
		rgbSplit:send("dir", {drawSize * 0.00003, 0})
		rgbSplit:draw(function()
			world:draw()


			love.graphics.setBlendMode("alpha", "premultiplied")
			setColor(255, 255, 255, 255)
			love.graphics.draw(self.canvas.entity)
			light:draw()

						--popup
			popup:draw()

			--Vignette
			setColor(255, 255, 255, 100)
			love.graphics.draw(vignette, 0, 0, 0, config.display.width / vignette:getWidth(), config.display.height / vignette:getHeight())
			
			--UI Shadow
			setColor(0, 0, 0, 30)
			love.graphics.draw(self.canvas.gui, math.floor( -(config.display.width * 0.003)), 0)

			setColor(255, 255, 255, 255)
			love.graphics.draw(self.canvas.gui)
			love.graphics.setBlendMode("alpha")
		end)
	end
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

			if self.tutorial then
				self:nextStep()
			end
		end

		if key == config.controls.pause then
			self:pause()
		elseif key == config.controls.slide then
			if self.started then
				self.player:slide()
			end

			if self.tutorial then
				self:nextStep()
			end
		elseif key == "up" then
			self.player:setSkin()
		end
	end

	if key == "g" then
		self.player:throwGrenade()
	end
end

function game:keyreleased()
	if self.takeInput then
		self.player:stopSlide()
		self.player:stopJump()
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
		self:input(x, y, "press")
	end
end

function game:input(x, y, t)
	if self.takeInput then
		if t == "press" then
			if not ui:press(x, y) then
				if self.started and not self.paused and not self.ended then
					if y < world.ground.y then
						self.player:jump()
					else
						self.player:slide()
					end
				end
			end

			if self.tutorial then
				self:nextStep()
			end
		elseif t == "release" then
			self.player:stopSlide()
			self.player:stopJump()
		end
	end
end















return game