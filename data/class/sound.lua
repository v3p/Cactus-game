local sound = {
	type = {},
	globalVolume = 1
}

function sound:load(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' does not exist")
	else
		for i, file in ipairs(fs.getDirectoryItems(path)) do
			if getFileType(file) == ".ogg" then
				local name = string.gsub(file, ".ogg", "")
				self.type[name] = {
					src = love.audio.newSource(path.."/"..file, "static"),
					vol = 1,
					delay = false,
					enabled = true
				}
			end
		end
	end
end

function sound:new(fileName, name)
	self.type[name] = {
		src = love.audio.newSource(fileName, "static"),
		vol = 1,
		enabled = true
	}
end

function sound:setEnabled(name, e)
	self.type[name].enabled = e
end

function sound:play(name, delay)
	if self.type[name].enabled then
		delay = delay or false
		if not delay then
			if self.type[name].src:isPlaying() and not self.type[name].src:isLooping() then
				self.type[name].src:stop()
			end
			self.type[name].src:play()
		else
			self.type[name].delay = delay
		end
	end
end

function sound:stop(name)
	self.type[name].src:stop()
end

function sound:stopAll()
	for k,v in pairs(self.type) do
		v.src:stop()
	end
end

function sound:setVolume(name, vol)
	self.type[name].vol = vol
	self.type[name].src:setVolume(self.type[name].vol)
end

function sound:setLoop(name, loop)
	self.type[name].src:setLooping(loop)
end

function sound:setPitch(name, pitch)
	self.type[name].src:setPitch(pitch)
end

function sound:setMasterVolume(vol)
	self.globalVolume = vol
	for k,v in pairs(self.type) do
		v.src:setVolume(v.vol * vol)
	end
end

function sound:update(dt)
	for k,v in pairs(self.type) do
		if v.delay then
			v.delay = v.delay - dt
			if v.delay < 0 then
				v.delay = false
				self:play(k)
			end
		end
	end
end

return sound