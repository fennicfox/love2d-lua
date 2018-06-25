button = {}

function button:create(x, y, colour, newColour, font, fontSize, text, command)
	self.__index = self
	local metatable = setmetatable({
			x 			= 	x or 400,
			y 			= 	y or 300,
			colour 		= 	colour, --array {1.0, 1.0, 1.0}
			colourInit 	= 	colour,
			newColour	= 	newColour or colour, --array {1.0, 1.0, 1.0}
			text 		= 	text or 'default text',
			textWidth 	= 	0,
			textHeight 	= 	0,
			titleFont 	= 	love.graphics.newFont(font, fontSize),
			sfx1 		= 	love.audio.newSource('sfx/hover.ogg', 'static'),
			sfx2 		= 	love.audio.newSource('sfx/click.ogg', 'static'),
			hoverSound 	= 	false,
			command 	=   command
	}, self)
	return metatable
end

function button:show()
	love.graphics.setColor(self.colour)
	love.graphics.setFont(self.titleFont)
	love.graphics.print(self.text, self.x-(self.textWidth/2), self.y-(self.textHeight/2))
	self.textWidth  = self.titleFont:getWidth(self.text)
	self.textHeight = self.titleFont:getHeight(self.text)
	if mousex > self.x-(self.textWidth/2) and mousex < self.x+(self.textWidth/2) and mousey > self.y-(self.textHeight/4) and mousey < self.y+(self.textHeight/2) then
		self.colour = self.newColour
		if not self.hoverSound then
			self.hoverSound = true
			self.sfx1:play()
		end
		if mpressed then
			self.sfx2:play()
			self.command()
		end
	else
		self.hoverSound = false
		self.colour     = self.colourInit
	end
end

function button:changePos(x, y)
	self.x = x
	self.y = y
end
