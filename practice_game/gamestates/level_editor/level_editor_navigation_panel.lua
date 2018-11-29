require 'utilities.typing'

local panel_w           = 250
local panel_h           = love.graphics.getHeight()
local panel_open        = false
local panel_incrementor = 0
local panel_speed       = 1000

function navigation_panel_load()
    inputs = {}
    labels = {}
    
    table.insert(labels, {
        text = "X:", 
        x = 20, 
        y = 40
    })
    local f = love.graphics.getFont()
    table.insert(inputs, {
        name = "X",
        box  = typing:create(20, 60, 128, f:getHeight()+1),
        func = function(text) 
            if editor_graphics.selected ~= nil then 
                editor_graphics.selected.x = tonumber(text)
            end 
        end
    })
end

function navigation_panel_update(dt)
    if panel_open then
        panel_incrementor = math.min(panel_incrementor + (panel_speed * dt), 250)
        panel_w = panel_incrementor
    else
        panel_incrementor = math.max(panel_incrementor - (panel_speed * dt), 0)
        panel_w = panel_incrementor
    end
    mouse()
    for i, v in ipairs(inputs) do
        if v.name == "X" and not v.box.focus and editor_graphics.selected ~= nil then
            v.box:setInput(editor_graphics.selected.x)
        end
        if v.box.func_called then
            v.func(v.box.returnedtext)
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
    if panel_w > 0 then
        panel_h = love.graphics.getHeight()
        love.graphics.setColor(0, 0, 0, 0.9)
        love.graphics.rectangle("fill",0,0,panel_w,panel_h)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.line(panel_w,0,panel_w,panel_h)
        love.graphics.setFont(graphFont)
        love.graphics.print(panel_state, ((screen_left)-250)+5, 5)

        for i, v in ipairs(inputs) do
            v.box:draw()
        end

        for i, v in ipairs(labels) do
            love.graphics.setColor(1,1,1,1)
            love.graphics.print(v.text, v.x, v.y)
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