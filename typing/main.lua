local utf8 = require("utf8")
 
function love.load()
	orignal_text = "C://Users//Default User >"
	orignal_text=orignal_text:gsub("//","\\")
    text = orignal_text
	y = 0
    -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
	love.keyboard.setKeyRepeat(true)
	FONT = love.graphics.getFont()
	inputs = {}
	cursor_x = 0
	cursor_y = 0
	cursor_w = 1
	cursor_h = FONT:getHeight("W")
	cursor_show = true
	cursor_blink_speed = 0.5
	cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
	cursor_letter_width = FONT:getWidth("W")
	cursor_letter_index = text:len()
	enter("Microsoft Windows [Version 10.0.16299.492]")
	enter("(c) 2017 Microsoft Corporation. All rights reserved.")
	enter("")
end
 
function love.textinput(t)
	text = string_insert(text, cursor_letter_index, t)
	cursor_letter_index = cursor_letter_index + 1
end
 
function love.update()
	cursor_blink()
end

function love.keypressed(key)
	if not love.keyboard.isDown("lctrl") and key == "backspace" and cursor_letter_index > 0 then
		cursor_letter_index = cursor_letter_index - 1
		text = string_remove(text, cursor_letter_index)
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
		if cursor_letter_index > 0 then cursor_letter_index = cursor_letter_index - 1 end
		cursor_reset() 
	elseif key == "right" then
		if cursor_letter_index < text:len() then cursor_letter_index = cursor_letter_index + 1 end
		cursor_reset()
	elseif key == "return" then
		enter(text)
	end
	print(cursor_letter_index)
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
	cursor_x = FONT:getWidth(text:sub(1,cursor_letter_index))
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

function string_insert(str, index, char)
	p1 = str:sub(1, -(str:len()-(index-1)))
	p2 = str:sub(index+1, str:len())
	return p1..char..p2
end

function string_remove(str, index)
	p1 = str:sub(0, -(str:len()-(index-1)))
	p2 = str:sub(index+2, str:len())
	return p1..p2
end

function enter(t)
	table.insert(inputs, {text = t, y = y})
	y = y + 14
	text = orignal_text
	cursor_letter_index = orignal_text:len()
end