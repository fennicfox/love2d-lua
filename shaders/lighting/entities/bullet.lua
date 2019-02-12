bullet = {}
bullet.collision = {}
bullet.SPEED = 1000
bullet.MAX_DISTANCE = 1000
bullet.CIRCLE_RESOLUTION = 50

local function distance(x1, y1, x2, y2)
    return math.sqrt( ( x2 - x1 )^2 + ( y2 + y1 )^2 )
end

local function gradient(x1, y1, x2, y2)
    return ((y2 - y1) / (x2 - x1))
end

function bullet:create(x, y, radius, r, g, b, a)
    self.__index = self
    local angle = math.atan2((love.mouse.getY() - y), (love.mouse.getX() - x))
    local object = {
        x=x,
        y=y,
        radius=radius,
        r=r,
        g=g,
        b=b,
        a=a,
        x_vel = (bullet.SPEED * math.cos(angle)),
        y_vel = (bullet.SPEED * math.sin(angle)),
        delete = false
    }
    table.insert( bullet, object )
    print(#bullet)
    return setmetatable(object, {__index = self})
end

function bullet:update(dt)
    self.x = self.x + (self.x_vel * dt)
    self.y = self.y + (self.y_vel * dt)
    if self.x > love.graphics.getWidth() or self.x < 0 or self.y < 0 or self.y > love.graphics.getHeight() then
        self.delete = true
    end
end

function bullet:draw()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
    love.graphics.circle('fill', self.x, self.y, self.radius, bullet.CIRCLE_RESOLUTION)
end