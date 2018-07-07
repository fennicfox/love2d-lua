fsystem = {}
local colour  = {0.2, 0.2, 0.2, 1}
local Hcolour = {0.3, 0.3, 0.3, 1}
local boxcolour  = {0.1, 0.1, 0.1, 0.5}
local boxHcolour = {0.2, 0.2, 0.2, 0.5}
local fsystemFONT = love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
local maxTextWidth = 0

function fsystem:create(mtext,x,y)
	self.__index = self
	local object = setmetatable({
        x = x or 0,
        y = y or 0,
        colour = colour,
        boxcolour = boxHcolour
	}, self)
    table.insert(fsystem, object)
    return object
end

function fsystem_update(dt)
    maxTextWidth = getMaxTextWidth()
    for i, v in ipairs(fsystem) do
        if (mousex > (v.x-10) and mouse > (v.y-10)) and (mousex < v.x+maxTextWidth and mousey < v.y+fsystemFONT:getHeight(v.text)) then
            v.colour = Hcolour
            boxcolour = boxHcolour
        else
            v.colour = colour
            boxcolour = boxcolour
        end
    end
end

function fsystem_draw()
    love.graphics.setFont(fsystemFONT)
    for i, v in ipairs(fsystem) do
        love.graphics.setColor(v.boxcolour)
        love.graphics.rectangle("fill",v.x-10, v.y-10, v.x+maxTextWidth, v.y+fsystemFONT:getHeight(v.text))
        love.graphics.setColor(v.colour)
        love.graphics.print(v.text, v.x, v.y)
    end
end

function getMaxTextWidth()
    local mw = 0
    for i, v in ipairs(fsystem) do
        if fsystemFONT:getWidth(v.text) > maxWidth then
            maxWidth = fsystemFONT:getWidth(v.text)
        end
    end
    return maxWidth
end

function findAllLevels()
    local f = io.popen("dir \"practice_game\"")
    if f then
        print(f:read("*a"))
    else
        print("failed to read")
    end
end
