local utf8 = require("utf8")

local orignal_text = ""
local after_text = ""
local text = orignal_text
local pressed = false
local FONT = love.graphics.getFont()
local inputs = {}

local cursor_x = 0
local cursor_y = 0
local cursor_w = 1
local cursor_h = FONT:getHeight("W")
local list_y   = 0
local cursor_show = true
local cursor_blink_speed = 0.5
local cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
local cursor_letter_index = text:len()
local selected_text_x = cursor_x
local selected_text_i = cursor_letter_index
local selected_text_w = 0
local key_shifting = false -- If user is holding down shift
local previous_click_time = 0
local doubleclicktime = 0.2
local doubleclicked = false
local txtbox_mbDown = false
love.keyboard.setKeyRepeat(true) -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.

typing = {}
function typing:create(x, y, w, h)
	self.__index = self
	local metatable = setmetatable({
		x = x,
		y = y,
		w = w,
		h = h,
		text,
		displaying_text
	}, self)
	return metatable
end

function typing:draw()
	local display_text = self:scroll_along_limiter(text)
	-- Box drawing
	love.graphics.setColor(0.25,0.25,0.25,1)
	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(0.5,0.5,0.5,1)
	love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
	
	-- Drawing the selected text
	love.graphics.setColor(0,0,1,1)
	love.graphics.rectangle("fill",selected_text_x,cursor_y,selected_text_w, cursor_h)
	love.graphics.setColor(1,1,1,1)
	
	--settings the camera to what i'm drawing in the future if you can't fit what's on the page.
	if cursor_y >= love.graphics.getHeight() then
		love.graphics.push()
		love.graphics.translate(-0, -((cursor_y+14)-love.graphics.getHeight()))
	end
	
	-- Prints the text
	love.graphics.printf(display_text, self.x+1, cursor_y, love.graphics.getWidth())
	
	--moves the camera down when you write more than the page can contain.
	if cursor_y >= love.graphics.getHeight() then
		love.graphics.pop()
	end
	
	--the cursor
	if cursor_show then
		love.graphics.rectangle("fill", cursor_x, cursor_y, cursor_w, cursor_h)
	end
end

function love.textinput(t)
	if selection_isSelected() then
		selection_delete()
	end
	text = string_insert(text, cursor_letter_index, t)
	cursor_letter_index = cursor_letter_index + 1
	selected_text_i = cursor_letter_index
end

function love.update()
	--print("Selected x: "..selected_text_x)
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
	if love.keyboard.isDown("lshift") then
		key_shifting = true 
	else
		key_shifting = false
	end
	if not love.keyboard.isDown("lctrl") and key == "backspace" and (cursor_letter_index > 0 or selected_text_i > 1) then
		cursor_bckSpc()
	elseif love.keyboard.isDown("lctrl") and key == "backspace" and (cursor_letter_index > 0 or selected_text_i > 1)  then
		cursor_bckSpcJump()
	elseif key == "left" and love.keyboard.isDown("lctrl") then
		cursor_leftJump()
	elseif key == "left" then
		cursor_left()
	elseif key == "right" and love.keyboard.isDown("lctrl") then
		cursor_rightJump()
	elseif key == "right" then
		cursor_right()
	elseif key == "delete" and love.keyboard.isDown("lctrl") then
		cursor_deleteJump()
	elseif key == "delete" then
		cursor_delete()
	elseif key == "return" then
		enter(text)
	elseif key == "f1" then
		print(cursor_letter_index, selected_text_i)
	elseif love.keyboard.isDown('lctrl') and key == "a" then
		selection_all()
	elseif love.keyboard.isDown('lctrl') and key == "c" then
		selection_copy()
	elseif love.keyboard.isDown('lctrl') and key == "v" then
		text_insert(love.system.getClipboardText())
	end
	cursor_reset()
	selection_update()
end

function love.keyreleased(key)
	if key == "lshift" then
		txtbox_mbDown = false
		selection_update()
	end
end

-- The text to be displayed in the input box
function typing:scroll_along_limiter(t)
	if ((self.x + 1) + FONT:getWidth(t)) >= ((self.x + 1) + self.w) then
		return scroll_along_limiter(t:sub(2, t:len()))
	else
		return t
	end
end

function cursor_blink()
	cursor_x = (box_x+1)+FONT:getWidth(scroll_along_limiter(text):sub(1,cursor_letter_index))
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
	table.insert(inputs, {text = t, y = list_y})
	list_y = list_y + 14
	text = orignal_text
	cursor_letter_index = orignal_text:len()
	selected_text_i = cursor_letter_index
end

function typing:mouseDown()
	pressed = true
	txtbox_mbDown = self:selected()
	cursor()
	selected_text_x = getCursorX(cursor_letter_index)
	selected_text_i = cursor_letter_index
	if (love.timer.getTime() - doubleclicktime < previous_click_time) and txtbox_mbDown then
		selection_all()
		doubleclicked = true
	end
	previous_click_time = love.timer.getTime()
end

function typing:mouseUp()
	pressed = false
	if txtbox_mbDown then
		txtbox_mbDown = false
	end
	if doubleclicked then
		doubleclicked = false
	end
end

-- Whether this text box is selected or not
function typing:selected()
	local mx = love.mouse.getX() 
	local my = love.mouse.getY()
	if mx > self.x and mx < self.x+self.w and my > self.y and my < self.y+self.h and pressed then
		return true
	else
		return false
	end
end

function cursor()
	local mx = love.mouse.getX() 
	local my = love.mouse.getY()
	for t = 1, #typing do
		for i = 0, text:len() do
			local prev_char = FONT:getWidth(text:sub(i,i)) / 2
			local next_char = FONT:getWidth(text:sub(i+1,i+1)) / 2
			if mx >= typing[t].x+FONT:getWidth(text:sub(0,i))-prev_char and mx <= typing[t].x+FONT:getWidth(text:sub(1,i))+next_char and (my >= typing[t].y and my <= typing[t].y+typing[t].h or txtbox_mbDown) then
				cursor_letter_index = i
				cursor_reset()
				break
			end
		end
	end
end

-- Moves the cursor left
function cursor_left()
	if cursor_letter_index > 0 then cursor_letter_index = cursor_letter_index - 1 end
	if not key_shifting then
		selection_reset()
	else
		txtbox_mbDown = true
	end
end

-- Jumps the cursor left
function cursor_leftJump()
	for i = 0, cursor_letter_index do
		if cursor_letter_index > 0 then cursor_letter_index = cursor_letter_index - 1 end
		if text:sub(cursor_letter_index, cursor_letter_index) == " " then break end
	end
	if not key_shifting then
		selection_reset()
	else
		txtbox_mbDown = true
	end
end

-- Moves the cursor right
function cursor_right()
	if cursor_letter_index < text:len() then cursor_letter_index = cursor_letter_index + 1 end
	if not key_shifting then
		selection_reset()
	else
		txtbox_mbDown = true
	end
end

-- Jumps the cursor right
function cursor_rightJump()
	for i = cursor_letter_index, text:len() do
		if cursor_letter_index < text:len() then cursor_letter_index = cursor_letter_index + 1 end
		if text:sub(cursor_letter_index, cursor_letter_index) == " " then break end
	end
	if not key_shifting then
		selection_reset()
	else
		txtbox_mbDown = true
	end
end

function cursor_bckSpc()
	if selection_isSelected() then
		selection_delete()
	else
		cursor_letter_index = cursor_letter_index - 1
		selected_text_i = cursor_letter_index
		text = string_remove(text, cursor_letter_index)
	end
end

function cursor_bckSpcJump()
	if selection_isSelected() then
		selection_delete()
	else
		for i = 0, cursor_letter_index do
			if cursor_letter_index <= 0 then
				cursor_letter_index = 0
				break
			end
			text = string_remove(text, cursor_letter_index-1)
			cursor_letter_index = cursor_letter_index - 1
			selected_text_i = cursor_letter_index
			if text:sub(cursor_letter_index, cursor_letter_index) == " " then
				break
			end
		end
	end
end

function cursor_delete()
	if selection_isSelected() then
		selection_delete()
	else
		if cursor_letter_index < text:len() then text = string_remove(text, cursor_letter_index) end
	end
end

function cursor_deleteJump()
	if selection_isSelected() then
		selection_delete()
	else
		for i = cursor_letter_index, text:len() do
			if text:sub(cursor_letter_index+1, cursor_letter_index+1) == " " then
				text = string_remove(text, cursor_letter_index)
				break
			end
			text = string_remove(text, cursor_letter_index)
		end
	end
end

function getCursorX(clw)
	return box_x+FONT:getWidth(text:sub(1,clw))
end

-- returns the selection width (cursor letter index, selected_text_i)
function getSelectionWidth(clw, s)
	if clw > s then
		return -FONT:getWidth(text:sub(s+1,clw))
	else
		return FONT:getWidth(text:sub(clw+1,s))
	end
end

function selection_all()
	selected_text_x = box_x+1
	selected_text_i = 0
	selected_text_w = FONT:getWidth(scroll_along_limiter(text))
	cursor_letter_index = text:len()
end

function selection_copy()
	if cursor_letter_index > selected_text_i then
		love.system.setClipboardText( text:sub(selected_text_i+1,cursor_letter_index))
	else
		love.system.setClipboardText( text:sub(cursor_letter_index+1, selected_text_i))
	end
end

function selection_delete()
	if selection_isSelected() then
		text = text:sub(1, math.min(cursor_letter_index, selected_text_i))..text:sub(math.max(cursor_letter_index+1, selected_text_i+1), text:len()+1)
	end
	selected_text_w = 0
	if cursor_letter_index > selected_text_i then
		cursor_letter_index = selected_text_i
	else
		selected_text_i = cursor_letter_index
	end
end

function selection_reset()
	selected_text_w = 0
	selected_text_i = cursor_letter_index
end

function selection_isSelected()
	if math.max(cursor_letter_index, selected_text_i) - math.min(cursor_letter_index, selected_text_i) > 0 then
		return true
	else
		return false
	end
end

function selection_update()
	if selection_text_selected():len() >= 1 and cursor_letter_index ~= selected_text_i then
		selected_text_x = (box_x+1)+FONT:getWidth(text:sub(0,math.min(cursor_letter_index, selected_text_i)))
		print(selection_text_selected())
		selected_text_w = FONT:getWidth(selection_text_selected())
	else
		selected_text_w = 0
	end 
end

function selection_text_selected()
	return text:sub(math.min(cursor_letter_index, selected_text_i)+1, math.max(cursor_letter_index, selected_text_i))
end 

function text_insert(str)
	text = text:sub(1, math.min(cursor_letter_index, selected_text_i))..str..text:sub(math.max(cursor_letter_index+1, selected_text_i+1), text:len()+1)
	cursor_letter_index = math.min(cursor_letter_index, selected_text_i)+str:len()
	selected_text_i = cursor_letter_index
	selected_text_w = 0
end