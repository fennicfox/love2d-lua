local utf8 = require("utf8")

local released = false
local pressing = false
local press    = false
local focused_input = nil
local FONT = love.graphics.getFont()

local switch = false

local cursor_x = 0
local cursor_y = 0
local cursor_w = 1
local cursor_h = FONT:getHeight("W")
local list_y   = 0
local cursor_show = true
local cursor_blink_speed = 0.5
local cursor_blink_finish = love.timer.getTime() + cursor_blink_speed
local cursor_letter_index = 0
local selected_text_x = cursor_x
local selected_text_i = cursor_letter_index
local selected_text_w = 0
local key_shifting = false -- If user is holding down shift
local previous_click_time = 0
local DOUBLECLICKTIME = 0.2
local doubleclicked = false
local txtbox_mbDown = false -- If the first mb1 was inside of the box (used for dragging text)
local id = 1
love.keyboard.setKeyRepeat(true) -- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.

typing = {}
function typing:create(x, y, w, h)
	self.__index = self
	local metatable = setmetatable({
		x = x,
		y = y,
		w = w,
		h = h,
		x_default = x,
		y_default = y,
		text = "",
		returnedtext = "",
		focus = false,
		id = id,
		func_called = false
	}, self)
	id = id + 1
	table.insert( typing, metatable )
	return metatable
end

function typing:update(dt)
	if self:selected() then
		self.focus = true
		self:mouseDown()
		focused_input = getTypingIndex(self)
		txtbox_mbDown = true
		cursor_y = self.y
		cursor_reset()
	elseif press then
		self.focus = false
	end
	if self.focus then
		if press and not doubleclicked then
			cursor()
		end
		unfocus()
		self.focus = true
		focused_input = getTypingIndex(self)
		cursor_blink()
		if love.mouse.isDown(1) and txtbox_mbDown then
			if not doubleclicked then
				cursor()
			end
			selected_text_w = getSelectionWidth(selected_text_i, cursor_letter_index )
		elseif love.mouse.isDown(1) and not txtbox_mbDown then
			selected_text_w = 0
			selected_text_i = cursor_letter_index
		end
	end
end

function typing:draw()
	FONT = love.graphics.getFont()

	-- Box drawing
	love.graphics.setColor(0.25,0.25,0.25,1)
	love.graphics.rectangle("fill", self.x-3, self.y, self.w, self.h)
	love.graphics.setColor(0.5,0.5,0.5,1)
	love.graphics.rectangle("line", self.x-3, self.y, self.w, self.h)

	if self.focus then
		-- Drawing the selection
		love.graphics.setColor(0,0,1,1)
		love.graphics.rectangle("fill",selected_text_x,cursor_y,selected_text_w, cursor_h)

		--the cursor
		if cursor_show then
			love.graphics.setColor(1,1,1,1)
			love.graphics.rectangle("fill", cursor_x, cursor_y, cursor_w, cursor_h)
		end
	end

	love.graphics.setColor(1,1,1,1)
	-- Prints the text
	love.graphics.printf(self.text, self.x, self.y, self.x+self.w)

end

function love.textinput(str)
	for i = 1, #typing do
		if str..typing[i].text == boxTypingLimit(str..typing[i].text, typing[i].w) and typing[i].focus then
			if selection_isSelected() then
				selection_delete()
			end
			typing[i].text = string_insert(typing[i].text, cursor_letter_index, str)
			cursor_letter_index = cursor_letter_index + str:len()
			selected_text_i = cursor_letter_index
		end
	end
end

function typing:keyPressed(key)
	if switch then
		switch = false
	elseif self.focus then
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
			unfocus()
			return
		elseif key == "tab" then
			self:switch()
		elseif love.keyboard.isDown('lctrl') and key == "a" then -- selects all
			selection_all()
		elseif love.keyboard.isDown('lctrl') and key == "c" then -- copy
			selection_copy()
		elseif love.keyboard.isDown('lctrl') and key == "v" then -- paste
			local str = tostring(love.system.getClipboardText())
			if str:len() > boxTypingLimit(self.text:sub(1, math.min(cursor_letter_index, selected_text_i))..str..self.text:sub(math.max(cursor_letter_index+1, selected_text_i+1)),self.w) then
				self:text_insert(str)
			end
		end
		self.func_called = true
		self.returnedtext = self.text
		cursor_reset()
		selection_update()
	end
end

function typing:keyReleased(key)
	if focused_input ~= nil then
		if key == "lshift" then
			txtbox_mbDown = false
			selection_update()
		end
	end
end

function typing:setInput(str)
	self.text = boxTypingLimit(tostring(str), self.w)
end

function typing:getInput(str)
	return self.text
end

function typing:focus(str)
	return self.focus
end

-- The text to be displayed in the input box
function typing:scroll_along_limiter(t)
	if ((self.x + 1) + FONT:getWidth(t)) >= ((self.x + 1) + self.w) then
		return self:scroll_along_limiter(t:sub(2, t:len()))
	else
		return t
	end
end

function typing:mouseDown()
	released = true
	txtbox_mbDown = self:selected()
	self.focus = txtbox_mbDown
	if self.focus then
		cursor()
	end
	selected_text_x = self:getCursorX(cursor_letter_index)
	selected_text_i = cursor_letter_index
	if (love.timer.getTime() - DOUBLECLICKTIME < previous_click_time) and txtbox_mbDown and self.focus then
		selection_all()
		doubleclicked = true
	end
	previous_click_time = love.timer.getTime()
end

function typing:mouseUp()
	released = false
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
	if mx > self.x and mx < self.x+self.w and my > self.y and my < self.y+self.h and press then
		return true
	else
		return false
	end
end

function typing:switch()
	for i = self.id, #typing do
		local index = (i % #typing)+1
		if typing[index] ~= nil then
			unfocus()
			typing[index].focus = true
			cursor_y = typing[index].y
			focused_input = index
			switch = true
			selection_all()
			cursor_reset()
			break
		end
	end
end

function typing:setCoords(x, y)
	self.x = x
	self.y = y
	cursor_letter_index = self.text:len()
	selected_text_i = self.text:len()
end

function typing:setSize(w, h)
	self.w = w
	self.h = h
	cursor_letter_index = self.text:len()
	selected_text_i = self.text:len()
end

-- Returns the truncated text
function boxTypingLimit(str, w)
	if FONT:getWidth(str) > w then
		return boxTypingLimit(str:sub(0,str:len()-1), w)
	else
		return str
	end
end

function find_box_len(str, w, c)
	if str == boxTypingLimit(str, w) then
		return find_box_len(str..c, w)
	else
		return str:len()
	end
end

function cursor_blink()
	cursor_x = (typing[focused_input].x)+FONT:getWidth(typing[focused_input]:scroll_along_limiter(typing[focused_input].text):sub(1,cursor_letter_index))
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

function getTypingIndex(x)
	for i = 1, #typing do
		if typing[i] == x then
			return i
		end
	end
	return nil
end

-- Moves the cursor based on the click and makes sure it hits in the box
function cursor()
	local mx = love.mouse.getX()
	local my = love.mouse.getY()
	for t = 1, #typing do
		if typing[t].focus then
			for i = 0, typing[t].text:len() do
				local prev_char = FONT:getWidth(typing[t].text:sub(i,i)) / 2
				local next_char = FONT:getWidth(typing[t].text:sub(i+1,i+1)) / 2
				if mx >= typing[t].x+FONT:getWidth(typing[t].text:sub(0,i))-prev_char and mx <= typing[t].x+FONT:getWidth(typing[t].text:sub(1,i))+next_char and (my >= typing[t].y and my <= typing[t].y+typing[t].h or txtbox_mbDown) then
					cursor_letter_index = i
					cursor_y = typing[t].y
					cursor_reset()
					return
				end
			end
			cursor_letter_index = typing[t].text:len()
			cursor_y = typing[t].y
			cursor_reset()
			return
		end
	end
	if not txtbox_mbDown then
		unfocus()
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
		if typing[focused_input].text:sub(cursor_letter_index, cursor_letter_index) == " " then break end
	end
	if not key_shifting then
		selection_reset()
	else
		txtbox_mbDown = true
	end
end

-- Moves the cursor right
function cursor_right()
	if cursor_letter_index < typing[focused_input].text:len() then cursor_letter_index = cursor_letter_index + 1 end
	if not key_shifting then
		selection_reset()
	else
		txtbox_mbDown = true
	end
end

-- Jumps the cursor right
function cursor_rightJump()
	for i = cursor_letter_index, typing[focused_input].text:len() do
		if cursor_letter_index < typing[focused_input].text:len() then cursor_letter_index = cursor_letter_index + 1 end
		if typing[focused_input].text:sub(cursor_letter_index, cursor_letter_index) == " " then break end
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
		typing[focused_input].text = string_remove(typing[focused_input].text, cursor_letter_index)
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
			typing[focused_input].text = string_remove(typing[focused_input].text, cursor_letter_index-1)
			cursor_letter_index = cursor_letter_index - 1
			selected_text_i = cursor_letter_index
			if typing[focused_input].text:sub(cursor_letter_index, cursor_letter_index) == " " then
				break
			end
		end
	end
end

function cursor_delete()
	if selection_isSelected() then
		selection_delete()
	else
		if cursor_letter_index < typing[focused_input].text:len() then typing[focused_input].text = string_remove(typing[focused_input].text, cursor_letter_index) end
	end
end

function cursor_deleteJump()
	if selection_isSelected() then
		selection_delete()
	else
		for i = cursor_letter_index, typing[focused_input].text:len() do
			if typing[focused_input].text:sub(cursor_letter_index+1, cursor_letter_index+1) == " " then
				typing[focused_input].text = string_remove(typing[focused_input].text, cursor_letter_index)
				break
			end
			typing[focused_input].text = string_remove(typing[focused_input].text, cursor_letter_index)
		end
	end
end

function typing:getCursorX(clw)
	return self.x+FONT:getWidth(self.text:sub(1,clw))
end

-- returns the selection width (cursor letter index, selected_text_i)
function getSelectionWidth(clw, s)
	if clw > s then
		return -FONT:getWidth(typing[focused_input].text:sub(s+1,clw))
	else
		return FONT:getWidth(typing[focused_input].text:sub(clw+1,s))
	end
end

function selection_all()
	selected_text_x = typing[focused_input].x
	selected_text_i = 0
	selected_text_w = FONT:getWidth(typing[focused_input].text)
	cursor_letter_index = typing[focused_input].text:len()
end

function selection_copy()
	if cursor_letter_index > selected_text_i then
		love.system.setClipboardText( typing[focused_input].text:sub(selected_text_i+1,cursor_letter_index))
	else
		love.system.setClipboardText( typing[focused_input].text:sub(cursor_letter_index+1, selected_text_i))
	end
end

function selection_delete()
	if selection_isSelected() then
		typing[focused_input].text = typing[focused_input].text:sub(1, math.min(cursor_letter_index, selected_text_i))..typing[focused_input].text:sub(math.max(cursor_letter_index+1, selected_text_i+1), typing[focused_input].text:len()+1)
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
		selected_text_x = (typing[focused_input].x+1)+FONT:getWidth(typing[focused_input].text:sub(0,math.min(cursor_letter_index, selected_text_i)))
		selected_text_w = FONT:getWidth(selection_text_selected())
	else
		selected_text_w = 0
	end
end

function selection_text_selected()
	return typing[focused_input].text:sub(math.min(cursor_letter_index, selected_text_i)+1, math.max(cursor_letter_index, selected_text_i))
end

function typing:text_insert(str)
	self:setInput(self.text:sub(1, math.min(cursor_letter_index, selected_text_i))..str..self.text:sub(math.max(cursor_letter_index+1, selected_text_i+1), self.text:len()+1))
	cursor_letter_index = math.min(cursor_letter_index, selected_text_i)+str:len()
	selected_text_i = cursor_letter_index
	selected_text_w = 0
end

function unfocus()
	for i = 1, #typing do
		typing[i].focus = false
	end
	focused_input = nil
end

function mouse()
	if love.mouse.isDown(1) and not pressing then
		press = true
		released = false
	end
	if not love.mouse.isDown(1) and pressing then
		press = false
		released = true
	end
	if love.mouse.isDown(1) then
		pressing = true
	else
		pressing = false
	end
end

function mouse_reset()
	if released or press then
		if press then
			press = false
		elseif released then
			released = false
		end
	end
end