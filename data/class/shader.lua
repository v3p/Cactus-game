local shader = {
	type = {},
}
local sm = {__index = shader}

function shader:load(path)
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' does not exist")
	else
		requireFolder(path, self.type)
	end
end

function shader.new(code)
	local s = {
		shader = love.graphics.newShader(code),
		canvas = love.graphics.newCanvas(),
		enabled = true
	}
	return setmetatable(s, sm)
end

function shader:setEnabled(e)
	self.enabled = e
end

function shader:draw(func)
	if config.display.useShaders then
		if self.enabled then
			local oldCanvas = love.graphics.getCanvas()
			love.graphics.setCanvas(self.canvas)
			love.graphics.clear()
			func()
			love.graphics.setCanvas(oldCanvas)

			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.setShader(self.shader)
			love.graphics.draw(self.canvas)
			love.graphics.setShader()
		else
			func()
		end
	else
		func()
	end
end

function shader:send(name, val)
	self.shader:send(name, val)
end

function shader:resize(w, h)
	self.canvas = love.graphics.newCanvas(w, h)
end

return shader