editor_graphics = {}
editor_graphics.w = 50
editor_graphics.h = 50
editor_state = "main"

local shapes = {}
local shape_selected = 1
local grid_spacing = 50
local grid = true
local grid_lock = true
local grid_lock_size = 5

table.insert(shapes, "rectangle")
table.insert(shapes, "triangle")


function editor_graphics:createRectangle(x, y, w, h, r, g ,b)
	local object = {
	s = "rectangle",
 	x = x,
	y = y,
	w = w,
	h = h,
	r = r,
	g = g,
	b = b
}
	table.insert(editor_graphics, object)
  	setmetatable(object, {__index = self})
  	return object
end

function level_editor_update(dt) -- love.graphics.polygon( mode, vertices )
	if editor_state == "main" then
		if mpressed then 
			editor_graphics:createRectangle(round(mousex-(tonumber(editor_graphics.w)/2), tonumber(grid_lock_size)), round(mousey-tonumber((editor_graphics.h)/2), grid_lock_size), tonumber(editor_graphics.w), tonumber(editor_graphics.h), 1, 1, 1)
		end
	
		if mwheelup then
			if shape_selected == #shapes then shape_selected = 1
			else shape_selected = shape_selected + 1 end
		elseif mwheeldown then
			if shape_selected == 1 then shape_selected = #shapes
			else shape_selected = shape_selected - 1 end
		end
	
		if kpressed then
			if pressedk == 'g' then
				if grid then 
					grid = false 
				else 
					grid = true 
				end
			elseif pressedk == 'b' then
				if grid then 
					grid_lock = false 
				else 
					grid_lock = true 
				end 
			elseif pressedk == 'x' then
				for i, v in ipairs(editor_graphics) do
					if mousex > v.x and mousex < v.x+v.w and mousey > v.y and mousey < v.y + v.h then
						table.remove(editor_graphics, i)
					end
				end
			elseif pressedk == 'escape' then 
				editor_state = "menu"
				level_editor_menu_load( )
			elseif pressedk == '-' then
				if editor_graphics.w ~= 6.25 and editor_graphics.h ~= 6.25 then editor_graphics.w = editor_graphics.w - 6.25 editor_graphics.h = editor_graphics.h - 6.25     end
			elseif pressedk == '=' then
				if editor_graphics.w ~= 100 and editor_graphics.h ~= 100 then editor_graphics.w = editor_graphics.w + 6.25 editor_graphics.h = editor_graphics.h + 6.25 end
			elseif pressedk == '[' then
				if grid_spacing ~= 12.5   then grid_spacing = grid_spacing - 12.5												   								  end
			elseif pressedk == ']' then
				if grid_spacing ~= 100    then grid_spacing = grid_spacing + 12.5												   								  end
			elseif pressedk == "." then
				local file = io.open("practice_game/level.oli", "a")
				for i, v in ipairs(editor_graphics) do
					print(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
					file:write(v.s..":"..tostring(v.x)..":"..tostring(v.y)..":"..tostring(v.w)..":"..tostring(v.h)..":"..tostring(v.r)..":"..tostring(v.g)..":"..tostring(v.b))
				end
				file:close()
			end
		end
	elseif editor_state == "menu" then
		level_editor_menu_update( dt )
	end
end


function level_editor_draw()
	if editor_state == "main" then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(graphFont)
		love.graphics.print("Frames Per Second: "..math.floor(tostring(love.timer.getFPS( ))), (love.graphics.getWidth()-130), 5)	--x and y of player and food
		love.graphics.print("Grid Spacing: "..tostring(grid_spacing), 5, 5)
		love.graphics.print("Width: "..tostring(editor_graphics.w), 5, 20)
		love.graphics.print("Height: "..tostring(editor_graphics.h), 5, 35)
		love.graphics.print("Shape: "..tostring(shapes[shape_selected]), 5, 50)
		love.graphics.setColor(0.2, 0.2, 0.2, 0.47)
		love.graphics.rectangle('fill', round(mousex-(tonumber(editor_graphics.w)/2), tonumber(grid_lock_size)), round(mousey-tonumber((editor_graphics.h)/2), grid_lock_size), tonumber(editor_graphics.w), tonumber(editor_graphics.h))
		love.graphics.setColor(0.4,0.4,0.4,0.47)
		love.graphics.setLineWidth( 1 )
		if grid then -- if the grid bool is true then draw the grid!
			for i=0, love.graphics.getWidth()/10 do
				love.graphics.line(i*grid_spacing, 0, grid_spacing*i, love.graphics.getHeight()) -- vertical lines
			end
			for i=0, love.graphics.getHeight()/10 do
				love.graphics.line(0, i*grid_spacing, love.graphics.getWidth(), grid_spacing*i) -- horizontal lines
			end
		end
		if #editor_graphics > 0 then
			for i, v in ipairs(editor_graphics) do
				love.graphics.setColor(v.r, v.g, v.b)
				love.graphics.rectangle('fill', v.x, v.y, v.w, v.h)
			end
		end
	elseif editor_state == "menu" then
		level_editor_menu_draw()
	end
end