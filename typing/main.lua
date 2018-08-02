local utf8 = require("utf8")
local orignal_text = "C:/Users/Default User>"
local text = orignal_text
local y = 0
local pressed = false
local FONT = love.graphics.getFont()
local inputs = {}
local cursor_x = 0
local cursor_y = 0
local cursor_w = 1
local cursor_h = FONT:getHeight("W")
local cursor_show = true
local cursor_blink_speed = 0.5
local cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
local cursor_letter_index = text:len()
local selected_text_x = 0
local selected_text_i = 0
local selected_text_w = 0
local previous_click_time = 0
local doubleclicktime = 0.2
local doubleclicked = false
local txtbox_mbDown = false
love.keyboard.setKeyRepeat(true) -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.

local shader_selectText = love.graphics.newShader[[
	vec4 effect (vec4 color, Image image, vec2 uvs, vec2 screen_coords){
		return vec4 (1-color[0], 1-color[0], 1, 1);
	}
	
]]

function love.load()
	enter("Microsoft Windows [Version 10.0.16299.492]")
	enter("(c) 2017 Microsoft Corporation. All rights reserved.")
	enter("")
end
 
function love.textinput(t)
	text = string_insert(text, cursor_letter_index, t)
	cursor_letter_index = cursor_letter_index + 1
end
 
function love.update()
	if love.mouse.isDown(1) and txtbox_mbDown then
		if not doubleclicked then
			cursor()
		end
		selected_text_w = getSelectionWidth(selected_text_i, cursor_letter_index )
	elseif love.mouse.isDown(1) and not txtbox_mbDown then
		selected_text_w = 0
		selected_text_i = cursor_letter_index
	end
	cursor_blink()
end

function love.keypressed(key)
	if not love.keyboard.isDown("lctrl") and key == "backspace" and cursor_letter_index > 0 then
		cursor_letter_index = cursor_letter_index - 1
		text = string_remove(text, cursor_letter_index)
	elseif love.keyboard.isDown("lctrl") and key == "backspace" and cursor_letter_index > 0 then
		for i = 0, cursor_letter_index do
			if cursor_letter_index <= 0 then
				cursor_letter_index = 0
				break
			end
			text = string_remove(text, cursor_letter_index-1)
			cursor_letter_index = cursor_letter_index - 1
			if text:sub(cursor_letter_index, cursor_letter_index) == " " then
				break
			end
		end
	elseif key == "left" and love.keyboard.isDown("lctrl") then
		for i = 0, cursor_letter_index do
			if cursor_letter_index > 0 then cursor_letter_index = cursor_letter_index - 1 end
			if text:sub(cursor_letter_index, cursor_letter_index) == " " then break end
		end
	elseif key == "right" and love.keyboard.isDown("lctrl") then
		for i = cursor_letter_index, text:len() do
			if cursor_letter_index < text:len() then cursor_letter_index = cursor_letter_index + 1 end
			if text:sub(cursor_letter_index, cursor_letter_index) == " " then break end
		end
	elseif key == "left" then
		if cursor_letter_index > 0 then cursor_letter_index = cursor_letter_index - 1 end
	elseif key == "right" then
		if cursor_letter_index < text:len() then cursor_letter_index = cursor_letter_index + 1 end
	elseif key == "delete" and love.keyboard.isDown("lctrl") then
		for i = cursor_letter_index, text:len() do
			if text:sub(cursor_letter_index+1, cursor_letter_index+1) == " " then
				text = string_remove(text, cursor_letter_index)
				break
			end
			text = string_remove(text, cursor_letter_index)
		end
	elseif key == "delete" then
		if cursor_letter_index < text:len() then text = string_remove(text, cursor_letter_index) end
	elseif key == "return" then
		enter(text)
	elseif love.keyboard.isDown('lctrl') and key == "a" then
		selection_all()
	elseif love.keyboard.isDown('lctrl') and key == "c" then
		selection_copy()
	elseif love.keyboard.isDown('lctrl') and key == "v" then
		text = text..love.system.getClipboardText( )
		cursor_letter_index = cursor_letter_index + love.system.getClipboardText( ):len()
	end

	cursor_reset()
end
 
function love.draw()
	--love.graphics.setShader(shader_selectText)
	love.graphics.setColor(0,0,1,1)
	love.graphics.rectangle("fill",selected_text_x,y,selected_text_w, cursor_h)
	love.graphics.setColor(1,1,1,1)

	--settings the camera to what i'm drawing in the future if you can't fit what's on the page.
	if y >= love.graphics.getHeight() then
		love.graphics.push()
		love.graphics.translate(-0, -((y+14)-love.graphics.getHeight()))
	end
	--love.graphics.setShader()

	--prints all of the words.
	for i, v in ipairs(inputs) do love.graphics.printf(v.text, 0, v.y, love.graphics.getWidth()) end
	
	--prints the text
	love.graphics.printf(text, 0, y, love.graphics.getWidth())
	
	--moves the camera down when you write more than the page can contain.
	if y >= love.graphics.getHeight() then
		love.graphics.pop()
	end

	--the cursor
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
	local p1 = str:sub(1, -(str:len()-(index-1)))
	local p2 = str:sub(index+1, str:len())
	return p1..char..p2
end

function string_remove(str, index)
	local p1 = str:sub(0, -(str:len()-(index-1)))
	local p2 = str:sub(index+2, str:len())
	return p1..p2
end

function enter(t)
	table.insert(inputs, {text = t, y = y})
	y = y + 14
	text = orignal_text
	cursor_letter_index = orignal_text:len()
end

function love.mousepressed(x, y)
	pressed = true
	txtbox_mbDown = selected()
	cursor()
	selected_text_x = getCursorX(cursor_letter_index)
	selected_text_i = cursor_letter_index
	if (love.timer.getTime() - doubleclicktime < previous_click_time) and txtbox_mbDown then
		selection_all()
		doubleclicked = true
	end
	previous_click_time = love.timer.getTime()
end

function love.mousereleased(x, y)
	pressed = false
	if txtbox_mbDown then
		txtbox_mbDown = false
	end
	if doubleclicked then
		doubleclicked = false
	end
end

function selected()
	local mx = love.mouse.getX() 
	local my = love.mouse.getY()
	if mx > 0 and mx < FONT:getWidth(text) and my > y and my < y+cursor_h and pressed then
		return true
	end
	return false
end

function cursor()
	local mx = love.mouse.getX() 
	local my = love.mouse.getY()
	for i = 0, text:len() do
		local prev_char = FONT:getWidth(text:sub(i,i)) / 2
		local next_char = FONT:getWidth(text:sub(i+1,i+1)) / 2
		if mx >= FONT:getWidth(text:sub(0,i))-prev_char and mx <= FONT:getWidth(text:sub(1,i))+next_char and (my >= cursor_y and my <= cursor_y+cursor_h or txtbox_mbDown) then
			cursor_letter_index = i
			cursor_reset()
			break
		end
	end
end

function getCursorX(clw)
	return FONT:getWidth(text:sub(1,clw))
end

function getSelectionWidth(clw, s)
	if clw > s then
		return -FONT:getWidth(text:sub(s+1,clw))
	else
		return FONT:getWidth(text:sub(clw+1,s))
	end
end

function selection_all()
	selected_text_x = 0
	selected_text_i = 0
	selected_text_w = FONT:getWidth(text)
	cursor_letter_index = text:len()
end

function selection_copy()
	if cursor_letter_index > selected_text_i then
		love.system.setClipboardText( text:sub(selected_text_i+1,cursor_letter_index))
	else
		love.system.setClipboardText( text:sub(cursor_letter_index+1, selected_text_i))
	end
end