local utf8 = require("utf8")
 
function love.load()
	orignal_text = "Type away! -- "
    text = orignal_text
	y = 0
    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
	love.keyboard.setKeyRepeat(true)
	FONT = love.graphics.getFont()
	inputs = {}
	cursor_x = 0
	cursor_y = 0
	cursor_w = 1
	cursor_h = FONT:getHeight("t")
	cursor_show = true
	cursor_blink_speed = 0.5
	cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
	cursor_letter_width = FONT:getWidth("t")
	cursor_letter_index = 0
end
 
function love.textinput(t)
    text = text .. t
end
 
function love.update()
	cursor_blink()
end

function love.keypressed(key)
    if not love.keyboard.isDown("lctrl") and key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)
		if byteoffset then
            -- remove the last UTF-8 character.
			-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				text = text:sub(1, byteoffset - 1)
		end
	elseif love.keyboard.isDown("lctrl") and key == "backspace" then
		for i = 0, text:len() do
			local byteoffset = utf8.offset(text, -1)
			if byteoffset then
				if text:sub(byteoffset-1, byteoffset-1) == " " then
					text = text:sub(1,-2)
					break
				else
					text = text:sub(1,-2)
				end
			end
		end
	elseif key == "left" then
		cursor_letter_index = math.min((cursor_letter_index + cursor_letter_width), FONT:getWidth(text))
		cursor_reset()
	elseif key == "right" then
		cursor_letter_index = math.max((cursor_letter_index - cursor_letter_width), 0)
		cursor_reset()
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
	if cursor_show then
		love.graphics.rectangle("fill", cursor_x, cursor_y, cursor_w, cursor_h)
	end
end

function cursor_blink()
	cursor_x = FONT:getWidth(text) - cursor_letter_index
	cursor_y = y
	if cursor_show then
		if love.timer.getTime() >= cursor_blink_finish then
			cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
			cursor_show = false
		end
	else
		if love.timer.getTime() >= cursor_blink_finish then
			cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
			cursor_show = true
		end
	end
end

function cursor_reset()
	cursor_show = true
	cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
end