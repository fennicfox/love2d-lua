require "snake"
require "food"
require "camera"

playing = {}
snakes  = {}
s = nil

function playing.load()
    s = snake:load()
    s:feed(50)

    for i = 0, 100 do
        food:load(math.random( -1000, 1000), math.random( -1000, 1000), math.random(), math.random(), math.random())
    end
end

function playing.update( dt )
    
    s:update( dt )
    for i, v in ipairs( food ) do
        s:collide_food(v)
    end
end

function playing.draw()
    camera:set()

    food.draw()

    camera:setPosition(
        s.head.x-(love.graphics.getWidth()/2), 
        s.head.y-(love.graphics.getHeight()/2)
    )

    s:draw()
    for i, v in ipairs( snake ) do
        
    end
    
    camera:unset()
end