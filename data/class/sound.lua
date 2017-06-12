local sound = {
	type = {}
}

function sound:new(fileName, name)
	self.type[name] = {
		src = love.audio.newSource(fileName, "static"),
		vol = 1
	}
end

function sound:play(name)
	self.type[name].src:play()
end

function sound:stop(name)
	self.type[name].src:stop()
end

function sound:setVolume(name, vol)
	self.type[name].src:setVolume(vol)
end

function sound:setLoop(name, loop)
	self.type[name].src:setLooping(loop)
end

function sound:setPitch(name, pitch)
	self.type[name].src:setPitch(pitch)
end

return sound