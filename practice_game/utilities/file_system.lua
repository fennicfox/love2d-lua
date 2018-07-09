--fsystem vars
fsystem = {}
local title   = "Level List"
local colour  = {1, 1, 1, 1}
local Hcolour = {0.3, 0.3, 0.3, 1}
local boxHcolour  = {0.4, 0.4, 0.4, 0.5}
local boxcolour = {0.2, 0.2, 0.2, 0.5}
local fsystemFONT = love.graphics.newFont('font/SourceSansPro-Light.ttf', 32)
local maxTextWidth = 0

--scroll vars
local scroll_maxDepth = 0
local scroll_y = 0
local scroll_speed = 100000


--fsystem functions
function fsystem.create(text)
    --truncating the text
    local trunc_text = text:sub(-text:len(),-5)
    trunc_text = trunc_text:sub(-255,20)
    if trunc_text:len() > 20 then
        trunc_text = trunc_text:sub(-255,20).."..."
    end
    
    --adding the object to the table
	local object = setmetatable({
        x = 0,
        y = 0,
        text =  trunc_text,
        full_text = text,
        colour = colour,
        boxcolour = boxcolour
	}, self)
    table.insert(fsystem, object)
    maxTextWidth = getMaxTextWidth()
end

function fsystem_update(dt)
    local x = 0
    local y = 0
    for i, v in ipairs(fsystem) do
        --if window resizes, this should scale accordingly
        v.x = ((love.graphics.getWidth()/2) - (fsystemFONT:getWidth(v.text)/2))
        y = y + 50
        v.y = y

        if (mousex > (10) and mousey > (v.y)) and (mousex < (love.graphics.getWidth()-20) and mousey < v.y+42) then
            v.boxcolour = boxHcolour
        else
            v.boxcolour = boxcolour
        end
    end
    scroll_maxDepth = y-love.graphics.getHeight()
    scroll_update(dt)
end

function fsystem_draw()
    love.graphics.setFont(fsystemFONT)
    love.graphics.setColor(1,1,1,1)
    love.graphics.line(0,44,love.graphics.getWidth(),44)
    love.graphics.print(title, ((love.graphics.getWidth()/2) - (fsystemFONT:getWidth(title)/2)), 2)
    camera:set()
    for i, v in ipairs(fsystem) do
        --box
        love.graphics.setColor(v.boxcolour)
        love.graphics.rectangle("fill", 10, v.y, (love.graphics.getWidth()-20), 42, 10, 10)

        --text
        love.graphics.setColor(v.colour)
        love.graphics.print(v.text, v.x, v.y)
    end
    camera:unset()
end

function getMaxTextWidth()
    local mw = 0
    for i, v in ipairs(fsystem) do
        if fsystemFONT:getWidth(v.text) > mw then
            mw = fsystemFONT:getWidth(v.text)
        end
    end
    return mw
end

function findAllLevels() 
    print("files: ")
    for file in io.popen([[dir "practice_game\levels\" /b]]):lines() do
        print(file)
        fsystem.create(file)
    end
    print()
end






--scrolling functions
function scroll_update(dt)
    --print(scroll_y)
    print("camera")
    print(camera.x, camera.y, camera.xvel, camera.yvel)
    print("scroll")
    print(scroll_y, scroll_speed, scroll_maxDepth)
    local scroll_y = 0
    camera.friction = 10
    if mwheelup and camera.y > 0 then
        scroll_y = -scroll_speed
    elseif mwheeldown and camera.y < scroll_maxDepth then 
        scroll_y = scroll_speed
    end
    camera:move(0, scroll_y, dt)


    if camera.y < 0 then
        camera.y = 0
    elseif camera.y > scroll_maxDepth then
        camera.y = scroll_maxDepth 
    end
end