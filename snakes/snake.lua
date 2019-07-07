require "snake_seg"
snake = {}
snake.DISTRIBUTION = 7
local mx = 0
local my = 0

function snake:load()
    --head = snake_seg:create( math.random(-1000,1000), math.random(-1000,1000) )
	local object = {
            head = snake_seg:create( 100, 100 ),
            speed = 0.5,
            size = 20,
            colour = { math.random(), math.random(), math.random() },
            direction = 10
    }
    print(#snake)
	table.insert(snake, object)
    setmetatable(object, { __index = self })
	return object
end

function snake:update( dt )
    mx = love.mouse.getX() + (camera.x * camera.scaleX) 
    my = love.mouse.getY() + (camera.y * camera.scaleY)
    local current = self.head
    local angle = math.atan2(
                (my - current.y), 
                (mx - current.x)
            )
    if (distance(mx, my, current.x, current.y) > current.size*2) then
        self:step_towards( current, angle )
    end

    while current.next ~= nil do
        previous = current
        current = current.next
        if (distance_snake(previous, current) > snake.DISTRIBUTION) then
            angle = math.atan2(
                (previous.y - current.y), 
                (previous.x - current.x)
            )
            self:step_towards( current, angle )
        end
    end
end

function snake:collide_food(scran)
    local d = distance(self.head.x, self.head.y, scran.x, scran.y)
    if d < self.head.size then
        scran:respawn(self.head.x, self.head.y)
        self:feed(1)
    end
end

function snake:step_towards( node, angle )
    --print(node, node.x, node.y)
    local x_vel = (self.speed * math.cos(angle))
    local y_vel = (self.speed * math.sin(angle))
    node.x = node.x + x_vel
    node.y = node.y + y_vel
end

function snake:draw( )
    local current = self.head
    while current ~= nil do
        love.graphics.setColor(self.colour)
        love.graphics.circle("fill", current.x, current.y, self.size)
        current = current.next
    end
end

function snake:respawn()
	v.x=math.random(1,1000)
    v.y=math.random(1,1000)
end

function snake:feed( amount )
    local current  = self.head
    local previous = self.head
    
    -- Sets current to the tail of the snake
    while current.next ~= nil do
        previous = current
        current = current.next
    end

    for i = 0, amount do
        local angle = 0
        if previous == current then
            angle = math.atan2(
                (current.y - my), 
                (current.x - mx)
            )
        else
            angle = math.atan2(
                (current.y - previous.y), 
                (current.x - previous.x)
            )
        end

        local x_vel = (snake.DISTRIBUTION * math.cos(angle))
        local y_vel = (snake.DISTRIBUTION * math.sin(angle))
        
        current.x = current.x + x_vel
        current.y = current.y + y_vel


        current.next = snake_seg:create( current.x, current.y )
        previous = current
        current = current.next
    end

end

function snake:print_chunks()
    local current  = self.head
    local count = 0
    -- Sets current to the tail of the snake
    while current.next ~= nil do
        current = current.next
        count = count + 1
    end
    print(count)
end

function distance_snake( node_a, node_b )
    return distance (node_a.x, node_a.y, node_b.x, node_b.y )
end

function distance( x1, y1, x2, y2 )
    return math.sqrt( math.pow(y2 - y1, 2) + math.pow(x2 - x1, 2))
end