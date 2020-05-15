--A simple state handler. Loads, sets, calls calbacks etc. for states.

local state = {
	state = {},
	currentState = false
}

function state:loadStates(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	else
		for i,v in ipairs(love.filesystem.getDirectoryItems(path)) do
			if getFileType(v) == ".lua" then
				local name = string.gsub(v, ".lua", "")
				self.state[name] = require(path.."/"..name)
			end
		end
	end
end

function state:setState(name)
	self.currentState = self.state[name]
	self.currentState:load()
end

function state:getState()
	return self.currentState
end

function state:load(data)
	if type(self.currentState.load) == "function" then
		self.currentState:load(data)
	end
end

function state:update(dt)
	if type(self.currentState.update) == "function" then
		self.currentState:update(dt)
	end
end

function state:draw()
	if type(self.currentState.draw) == "function" then
		self.currentState:draw()
	end
end

function state:resize(w, h)
	if type(self.currentState.resize) == "function" then
		self.currentState:resize(w, h)
	end
end

function state:keypressed(key)
	if type(self.currentState.keypressed) == "function" then
		self.currentState:keypressed(key)
	end
end

function state:keyreleased(key)
	if type(self.currentState.keyreleased) == "function" then
		self.currentState:keyreleased(key)
	end
end

function state:mousepressed(x, y, key)
	if type(self.currentState.mousepressed) == "function" then
		self.currentState:mousepressed(x, y, key)
	end
end

function state:mousereleased(x, y, key)
	if type(self.currentState.mousereleased) == "function" then
		self.currentState:mousereleased(x, y, key)
	end
end

function state:textinput(t)
	if type(self.currentState.textinput) == "function" then
		self.currentState:textinput(t)
	end
end

function state:wheelmoved(x ,y)
	if type(self.currentState.wheelmoved) == "function" then
		self.currentState:wheelmoved(x, y)
	end
end

function state:quit()
	if type(self.currentState.quit) == "function" then
		self.currentState:quit()
	end
end

function state:touchpressed(id, x, y, dx, dy, pressure)
	if type(self.currentState.touchpressed) == "function" then
		self.currentState:touchpressed(id, x, y, dx, dy, pressure)
	end
end

function state:touchreleased(id, x, y, dx, dy, pressure)
	if type(self.currentState.touchreleased) == "function" then
		self.currentState:touchreleased(id, x, y, dx, dy, pressure)
	end
end


















return state