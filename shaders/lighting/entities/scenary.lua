scenary = {}

function scenary:create(x, y, w, h, r, g, b, a)
    self.__index = self
	return setmetatable({
		x=x,
		y=y,
		w=w or 40,
        h=h or 40,
        r=r or 1,
        g=g or 1,
        b=b or 1,
        a=a or 1
	}, self)
end

function scenary:update(dt)
    
end

function scenary:draw()
    love.graphics.setColor(self.r,self.g,self.b,self.a)
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
    
end