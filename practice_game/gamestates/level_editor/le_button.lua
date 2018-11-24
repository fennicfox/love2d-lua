le_button = {}

function le_button:create(x, y, colour, bck_c1, bck_c2, font, fontSize, text, command)
    local tW = love.graphics.newFont(font, fontSize):getWidth(text)
    local tH = love.graphics.newFont(font, fontSize):getHeight(text)
    self.__index = self
	local metatable = setmetatable({
			x 			   = x or 400,
			y 			   = y or 300,
			colour 		   = colour, 
            bckColour      = bck_c1,
			bckColourInit  = bck_c1,
			newBckColour   = bck_c2,
			text 		   = text or 'T',
			textWidth 	   = tW,
            textHeight 	   = tH,
            titleFont 	   = love.graphics.newFont(font, fontSize),
			sfx1 		   = love.audio.newSource('sfx/hover.ogg', 'static'),
			sfx2 		   = love.audio.newSource('sfx/click.ogg', 'static'),
			hoverSound 	   = false,
            command 	   = command,
            box_wh         = math.max(tW, tH) -- Making square button so it gets the size of the text and makes the button square 
    }, self)
	return metatable
end

function le_button:show()
    
    -- Outputs the box
    love.graphics.setColor(self.bckColour)
    love.graphics.rectangle("fill", self.x, self.y, self.box_wh, self.box_wh)

    -- Border around the button
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("line", self.x, self.y, self.box_wh, self.box_wh)

    -- Outputs the text 
	love.graphics.setColor(self.colour)
    love.graphics.setFont(self.titleFont)
    love.graphics.print(self.text, ((self.x+(self.box_wh/2))-(self.textWidth/2)), ((self.y+(self.box_wh/2))-(self.textHeight/2)))
    
    -- if mouse hovering over box then play sound and highlight background
    if mousex > self.x and 
                    mousex < self.x+self.box_wh and 
                    mousey > self.y and 
                    mousey < self.y+self.box_wh then
		self.bckColour = self.newBckColour
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
		self.bckColour  = self.bckColourInit
	end
end

function le_button:changePos(x, y)
	self.x = x
	self.y = y
end

function le_button:getBoxHeight()
    return self.box_wh
end

function le_button:getBoxWidth()
    return self.box_wh
end

function le_button:mouseIsHovering()
    if mousex > self.x and 
                    mousex < self.x+self.box_wh and 
                    mousey > self.y and 
                    mousey < self.y+self.box_wh then
        return true
    else
        return false
    end
end