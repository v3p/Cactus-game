--This cotnains the assload of callbacks for the ui elements. I put it here to declutter game.lua

--USER INTERFACE
function buttonFeedback(e)
	screenEffect:ripple(e.x + e.width / 2, e.y + e.height / 2, 8, drawSize, convertColor(46, 117, 56), false)
end
--Button callbacks
function startButton(e)
	state:getState():start()
	sound:play("ui2")
end

function resetButton(e)
	state:getState():load(false)
	sound:play("ui2")
end

function exitButton(e)
	love.event.push("quit")
	sound:play("ui1")
end

function backButton(e)
	ui:hideScreen("settings")
	ui:hideScreen("skin")
	ui:hideScreen("stats")
	ui:hideScreen("credits")
	ui:hideScreen("help")
	ui:showScreen("main")
	ui:hideScreen("ingame")


	buttonFeedback(e)
	sound:play("ui2")

	if state:getState().tutorial then
		state:getState():lose()
	end
end

--[[
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
]]

function settingsButton(e)
	ui:hideScreen("main")
	ui:showScreen("settings")
	buttonFeedback(e)
	sound:play("ui1")
end

function toggleShaders(e)
	config.display.useShaders = e.checked
end

function toggleCA(e)
	config.display.useChromaticAberrationShader = e.checked
	rgbSplit:setEnabled(config.display.useChromaticAberrationShader)
end

function toggleMusic(e)
	config.sound.music = e.checked
	setMusic()
end

function toggleSFX(e)
	config.sound.soundFX = e.checked
	setSoundFX()
end

function toggleDev(e)
    config.devMode.enabled = e.checked
end

function toggleDayNight(e)
	config.game.dayNightCycle = e.checked

	state:getState().toggleNight.enabled = not e.checked
end

function toggleNight(e)
	config.game.night = e.checked
	if e.checked then
		e.text = "Night"
	else
		e.text = "Day"
	end
end

function skinsButton(e)
	ui:hideScreen("main")
	ui:showScreen("skin")
	buttonFeedback(e)
	sound:play("ui1")
end

function statsButton(e)
	ui:hideScreen("main")
	ui:showScreen("stats")
	buttonFeedback(e)
	sound:play("ui1")
end

function creditsButton(e)
	ui:hideScreen("main")
	ui:showScreen("credits")
	buttonFeedback(e)
	sound:play("ui1")
end

function helpButton(e)
	ui:hideScreen("main")
	ui:showScreen("help")
	buttonFeedback(e)
	sound:play("ui1")

	--state:getState().player:show()
	state:getState().tutorial = true
	state:getState():start()
end

function lastButton(e)
	local game = state:getState()
	local change = true
	config.game.currentSkin = config.game.currentSkin - 1
	if config.game.currentSkin < 1 then 
		config.game.currentSkin = 1
		change = false
	end

	if change then
		game.player:setSkin(config.game.currentSkin)

		local q = 1 + (game.player.currentSkin - 1) * 8
		game.preview.quad = game.player.quad[q]

		local name = game.player.skinNames[game.player.currentSkin]
		game.skinName.text = name

		screenEffect:ripple(lg.getWidth() / 2, lg.getHeight() / 2, 12, drawSize * 3, {1, 1, 1}, false)
	end

	--
	buttonFeedback(e)
	sound:play("ui1")
end

function nextButton(e)
	local game = state:getState()
	local change = true
	config.game.currentSkin = config.game.currentSkin + 1
	if config.game.currentSkin > config.game.unlockedSkins then 
		config.game.currentSkin = config.game.unlockedSkins
		change = false
	end
	
	if change then
		game.player:setSkin(config.game.currentSkin)

		local q = 1 + (game.player.currentSkin - 1) * 8
		game.preview.quad = game.player.quad[q]

		local name = game.player.skinNames[game.player.currentSkin]
		game.skinName.text = name

		screenEffect:ripple(lg.getWidth() / 2, lg.getHeight() / 2, 12, drawSize * 3, {1, 1, 1}, false)
	end
	buttonFeedback(e)
	sound:play("ui1")
end

function loveLogo(e)
	love.system.openURL("https://love2d.org/")
	buttonFeedback(e)
	sound:play("ui1")
end