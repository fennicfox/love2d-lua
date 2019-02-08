scenary = {}
scenary.collision = {}

function scenary:create(x, y, w, h, r, g, b, a)
    self.__index = self
    local object = {
        x=x,
        y=y,
        w=w,
        h=h,
        r=r,
        g=g,
        b=b,
        a=a
    }
    table.insert( scenary, object )
    return setmetatable(object, {__index = self})
end

function scenary:update(dt)
    for i, v in ipairs(scenary.collision) do
        if v.x+v.w > self.x 
        and v.x < self.x+self.w
        and v.y+v.h > self.y
        and v.y < self.y+self.h then
            v.xvel = -(v.xvel+-1)
            v.yvel = -(v.yvel+-1)
        end
    end
end

function scenary:draw()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end