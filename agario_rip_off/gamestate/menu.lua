button = {}

function button.spawn(type, text)
	table.insert(button, {x = 0, y = 0, text = text})
end

function button.update(dt)
	local font = love.graphics.setNewFont("Android.ttf", 100)
	for i, v in ipairs(button) do
		if v.type == "center" then
			local font_width = font:getWidth(v.text) --gets the width of the argument in pixels for this font
			local font_height = font:getHeight(v.text) --gets the height of the argument in pixels for this font
			v.x = love.graphics.getWidth()/2-font_width/2
			v.y = (love.graphics.getHeight()/(table.getn(button)))+((i-1)*font_height)
		end
	end
end

function button.draw()
	for i, v in ipairs(button) do
		love.graphics.setColor(255,255,255)
		love.graphics.print(v.text, v.x, v.y)
	end
end