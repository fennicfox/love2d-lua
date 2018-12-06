scenary = {}

function scenary:create(x, y, w, h, r, g, b, a)
    self.__index = self
	return setmetatable({
		x=x,
		y=y,
		w=w,
        h=h,
        r=r,
        g=g,
        b=b,
        a=a
	}, self)
end

function scenary:update(dt)
    
end

function scenary:draw()
    love.graphics.setColor(self.r, self.g, self.b, self.a)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end