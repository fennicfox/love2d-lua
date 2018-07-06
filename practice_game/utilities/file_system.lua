fsystem = {}
local colour  = {0.2, 0.2, 0.2, 1}
local Hcolour = {0.3, 0.3, 0.3, 1}
local love.graphics.newFont('font/SourceSansPro-Bold.ttf', 12)
function fsystem:create(mtext,x,y)
	self.__index = self
	local object = setmetatable({
        x = x or 0
        y = y or 0
	}, self)
    table.insert(fsystem, object)
    return object
end

function fsystem_update(dt)
    for i, v in ipairs(fsystem) do
        if (mousex > v.x and mouse > v.y) and (mousex < x+)
    end
end

function fsystem_draw()
love.graphics.setFont(graphFont)
    for i, v in ipairs(fsystem) do

    end
end

