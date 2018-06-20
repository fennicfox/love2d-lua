player = {}

function player:create(x, y, w, h)
	self.__index = self
	player.friction = 6
	player.gravity = 2500
	return setmetatable({
		x=x or  0,
		y=y or  0,
		w=w or 100,
		h=h or 100,
		centerx   = x + (w or 100/2),
		centery   = y + (h or 100/2),
		speed     = 1500,
		xvel      = 0,
		yvel      = 0,
		jumpspeed = 100000
	}, self)
end

function player:update(dt)
	self.centerx = self.x + (self.w/2)
	self.centery = self.y + (self.h/2)
	if love.keyboard.isDown('a') then self.xvel = self.xvel - (self.speed * dt) end
	if love.keyboard.isDown('d') then self.xvel = self.xvel + (self.speed * dt) end
	if love.keyboard.isDown('w') then self.yvel = self.yvel - (self.speed * dt) end
	if love.keyboard.isDown('s') then self.yvel = self.yvel + (self.speed * dt) end
end

function player:physics(dt)
	self.x = self.x + self.xvel * dt
	self.y = self.y + self.yvel * dt
	self.xvel = self.xvel * (1 - math.min(dt*player.friction, 1))
	self.yvel = self.yvel * (1 - math.min(dt*player.friction, 1))
end

function player:draw()
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h, 3, 3)
end

function player:draw_rays(t)
	local gradient = (t.y - self.centery) / (t.x - self.centerx)
	local x1 = t.x
	local y1 = t.y
	local x2 = t.x+t.w
	local y2 = t.y
	local x3 = t.x
	local y3 = t.y+t.h
	local x4 = t.x+t.w
	local y4 = t.y+t.h

	love.graphics.line(self.centerx, self.centery, t.x,t.y)
	love.graphics.line(self.centerx, self.centery, (t.x+t.w), (t.y+t.h))
end