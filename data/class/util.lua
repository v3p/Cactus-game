
--Tab is optional, If a table is passed, The files will be loaded into that table
--Otherwise they're loaded into the global table
function requireFolder(path, tab)
	tab = tab or _G
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' does not exist")
	else
		for i,v in ipairs(fs.getDirectoryItems(path)) do
			if getFileType(v) == ".lua" then
				local name = string.gsub(v, ".lua", "")
				tab[name] = require(path.."."..name)
			end
		end
	end
end	

function pointInRect(x, y, _x, _y, width, height)
	if x > _x and x < _x + width and y > _y and y < _y + height then
		return true
	else return false end
end

function getFileType(file)
 	return string.match(file, "%..+")
end

--TABLE STUFF
function copy(original)
	local c
	if type(original) == "table" then
		c = {}
		for key, value in pairs(original) do
			c[copy(key)] = copy(value)
		end
		setmetatable(c, copy(getmetatable(original)))
	else
		c = original
	end

	return c
end

function tableLength(tab)
	local length = 0
	for k,v in pairs(tab) do
		length = length + 1
	end
	return length
end

--This converts colors from the 0-1 range to 0-255 cause updates happened
--and i didn't feel like replacing all the setColor's in this whole thing
function setColor(r, g, b, a)
	if type(r) == "table" then
		r, g, b, a = r[1], r[2], r[3], r[4]
	end
	a = a or 255

	love.graphics.setColor(convertColor(r, g, b, a))
end

--Converts a color from the 0-255 range to 0-1
function convertColor(r, g, b, a)
	a = a or 1
	return {r / 255, g / 255, b / 255, a / 255}
end

function tableToString(tab, recursion)
	recursion = recursion or false
	local t = "return {"
	local comma = false
	local length = tableLength(tab)
	local i = 0
	if recursion then t = "{" end

	for k, v in pairs(tab) do
		i = i + 1
		local val = tostring(v)
		if type(v) == "string" then
			val = '"'..v..'"'
		elseif type(v) == "table" then
			val = tableToString(v, true)
		end

		t = t..k.." = "..val
		if i < length then
			t = t..", "
		end
	end

	t = t.."}"

	return t
end

function verticalGradient(width, height, ...)
	local oldCanvas = lg.getCanvas()
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
	setColor(255, 255, 255, 255)
	love.graphics.draw(mesh, 0, 0)
	love.graphics.setCanvas(oldCanvas)
	return canvas
end

--[[Loads a texture atlas and splits the shit into quads
function loadAtlas(path, tileWidth, tileHeight, padding)
	padding = padding or 0
	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	end

	local a = {}
	local img = love.graphics.newImage(path)
	local width = math.floor(img:getWidth() / tileWidth)
	local height = math.floor(img:getHeight() / tileHeight)
		
	local x, y = padding, padding
	for i=1, width * height do
		a[i] = love.graphics.newQuad(x, y, tileWidth, tileHeight, img:getWidth(), img:getHeight())
		x = x + tileWidth + padding
		if x > (width * tileWidth) then
			x = padding
			y = y + tileHeight + padding
		end
	end

	return img, a
end
]]

function loadAtlas(path, tileWidth, tileHeight, padding)
	padding = padding or 0

	if not love.filesystem.getInfo(path) then
		error("'"..path.."' doesn't exist.")
	end

	local quad = {}
	local atlas = love.graphics.newImage(path)
	local width = math.floor(atlas:getWidth() / tileWidth)
	local height = math.floor(atlas:getHeight() / tileHeight)

	local i = 1

	for y=0, height do
		for x=0, width do
			quad[i] = love.graphics.newQuad(x * tileWidth + padding, y * tileHeight + padding, tileWidth, tileHeight, atlas:getWidth(), atlas:getHeight())
			i = i + 1
		end
		i = i - 1
	end

	return atlas, quad
end

function hsl(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m),(g+m),(b+m),a
end
