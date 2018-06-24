button = {}

function button.spawn(x, y, text)
	table.insert(button, {x = x, y = y, text = text})

end

function button.draw()
	for i, v in ipairs(button) do
		love.graphics.setColor(255,255,255)
		love.graphics.print(v.text, v.x, v.y)
	end
end