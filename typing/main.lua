local utf8 = require("utf8")
 
function love.load()
	orignal_text = "Type away! -- "
    text = orignal_text
	y = 0
    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
    love.keyboard.setKeyRepeat(true)
end
 
function love.textinput(t)
    text = text .. t
end
 
function love.keypressed(key)
    if not love.keyboard.isDown("lctrl") and key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
			-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				text = text:sub(1, byteoffset - 1)
				print(byteoffset)
		end
	elseif love.keyboard.isDown("lctrl") and key == "backspace" then
		print(true)
		for i = 0, text:len() do
			local byteoffset = utf8.offset(text, -1)
			if byteoffset then
				print(text:sub(byteoffset))
				if text:sub(byteoffset) == " " then
					text = text:sub(1,-2)
					break
				else
					text = text:sub(1,-2)
				end
			end
		end
	end
	if key == "return" then
		table.insert(inputs, {text = text, y = y})
		y = y + 14
		text = orignal_text
	end
end
 
function love.draw()
	if y >= love.graphics.getHeight() then
		love.graphics.push()
		love.graphics.translate(-0, -((y+14)-love.graphics.getHeight()))
	end
	for i, v in ipairs(inputs) do
		love.graphics.printf(v.text, 0, v.y, love.graphics.getWidth())
	end
	love.graphics.printf(text, 0, y, love.graphics.getWidth())
	if y >= love.graphics.getHeight() then
		love.graphics.pop()
	end
end

inputs = {}
