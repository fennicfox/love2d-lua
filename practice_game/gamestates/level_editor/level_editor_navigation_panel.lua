require 'utilities.typing'

local PANEL_MAX_W       = 168
local PANEL_MIN_W       = 0
local panel_w           = PANEL_MAX_W
local panel_h           = love.graphics.getHeight()
local panel_open        = false
local panel_incrementor = 0
local panel_speed       = 1000
local inputs            = {}
local labels            = {}
local label_background  = {}

function navigation_panel_load()
    local f = love.graphics.getFont()
    inputs = {}
    labels = {}
    -- INSERTING LABEL BACKGROUNDS
    label_background = {}
    label_background.color = {0.2, 0.2, 0.2, 0.66}
    label_background.x_offset = 10
    label_background.y_offset = 3
    label_background.w = 148
    label_background.h = 45

    -- INSERTING LABELS
    local label_names = {"X", "Y", "W", "H"}
    local y_increment = 40
    for i = 1, #label_names do
        table.insert(labels, {
            text = label_names[i], 
            x = 20, 
            y = y_increment
        })
        y_increment = y_increment + 50
    end
    
    -- INSERTING INPUT BOXES
    table.insert(inputs, {
        name = "X",
        box  = typing:create(20, 60, 128, f:getHeight()+1),
        func = function(text) 
            if editor_graphics.selected ~= nil and text ~= nil and text ~= "" then 
                editor_graphics.selected.x = tonumber(text)
            end 
        end
    })

    table.insert(inputs, {
        name = "Y",
        box  = typing:create(20, 110, 128, f:getHeight()+1),
        func = function(text) 
            if editor_graphics.selected ~= nil and text ~= nil and text ~= "" then 
                editor_graphics.selected.y = tonumber(text)
            end 
        end
    })

    table.insert(inputs, {
        name = "W",
        box  = typing:create(20, 160, 128, f:getHeight()+1),
        func = function(text) 
            if editor_graphics.selected ~= nil and text ~= nil and text ~= "" then 
                editor_graphics.selected.w = tonumber(text)
            end 
        end
    })

    table.insert(inputs, {
        name = "H",
        box  = typing:create(20, 210, 128, f:getHeight()+1),
        func = function(text) 
            if editor_graphics.selected ~= nil and text ~= nil and text ~= "" then 
                editor_graphics.selected.h = tonumber(text)
            end 
        end
    })
end

function navigation_panel_update(dt)
    if panel_open then
        panel_incrementor = math.min(panel_incrementor + (panel_speed * dt), PANEL_MAX_W)
        panel_w = panel_incrementor
    else
        panel_incrementor = math.max(panel_incrementor - (panel_speed * dt), 0)
        panel_w = panel_incrementor
    end
    mouse()
    for i, v in ipairs(inputs) do
        local input_x = ((screen_left) - PANEL_MAX_W) + v.box.x_default
        if input_x ~= v.box.x then -- If not opening the navigator
            v.box:setCoords(input_x, v.box.y)
        end
        if not v.box.focus and editor_graphics.selected ~= nil then
            if v.name == "X" then
                v.box:setInput(editor_graphics.selected.x)
            elseif v.name == "Y" then
                v.box:setInput(editor_graphics.selected.y)
            elseif v.name == "W" then
                v.box:setInput(editor_graphics.selected.w)
            elseif v.name == "H" then
                v.box:setInput(editor_graphics.selected.h)
            end
        end
        if v.box.func_called then
            if v.box.returnedtext:len() > 0 then
                v.func(v.box.returnedtext)
            else
                v.func(0)
            end
            v.box.func_called = false
        end
        if kdown then
            v.box:keyPressed(kname)
        end
        if kpressed then
            v.box:keyReleased(pressedk)
        end
        v.box:update()
    end
    mouse_reset()
            
    screen_left = panel_w + 2
end

function navigation_panel_draw()
    local offset_window_x = ((screen_left) - PANEL_MAX_W)
    if panel_w > 0 then
        panel_h = love.graphics.getHeight()
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill",0,0,panel_w,panel_h)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.line(panel_w,0,panel_w,panel_h)
        love.graphics.setFont(graphFont)
        love.graphics.print(panel_state, ((screen_left)-PANEL_MAX_W)+5, 5)

        for i, v in ipairs(labels) do
            love.graphics.setColor(0.2,0.2,0.2,0.66)
            love.graphics.rectangle("fill", offset_window_x + (v.x-label_background.x_offset), v.y-label_background.y_offset, label_background.w, label_background.h)
        end
        for i, v in ipairs(inputs) do
            v.box:draw()
        end

        for i, v in ipairs(labels) do
            love.graphics.setColor(1,1,1,1)
            love.graphics.print(v.text, ((screen_left)-PANEL_MAX_W)+v.x, v.y)
        end
    end
end

function navigation_panel_toggle()
    if panel_open then
        panel_open = false
    else
        panel_open = true
    end
end

function navigation_panel_isOpen()
    return panel_open
end

function navigation_panel_width()
    return panel_w
end