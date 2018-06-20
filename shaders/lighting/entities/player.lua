player = {}

function player:create(x, y, w, h)
	self.__index = self
	player.friction = 6
	player.gravity = 2500
	return setmetatable({
		x=x or  0,
		y=y or  0,
		w=w or 20,
		h=h or 20,
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
	local x1 = t.x
	local y1 = t.y
	local x2 = t.x+t.w
	local y2 = t.y
	local x3 = t.x
	local y3 = t.y+t.h
	local x4 = t.x+t.w
	local y4 = t.y+t.h
	local centerx = t.x+t.w/2
	local centery = t.y+t.h/2
	local gradient1 = (y1 - self.centery) / (x1 - self.centerx)
	local gradient2 = (y2 - self.centery) / (x2 - self.centerx)
	local gradient3 = (y3 - self.centery) / (x3 - self.centerx)
	local gradient4 = (y4 - self.centery) / (x4 - self.centerx)
	-- love.graphics.print("gradient 1 = "..gradient1,0,15)
	-- love.graphics.print("gradient 2 = "..gradient2,0,30)
	-- love.graphics.print("gradient 3 = "..gradient3,0,45)
	-- love.graphics.print("gradient 4 = "..gradient4,0,60)
	
	--TOP HALF
	if self.centery < centery and self.centerx < centerx then      --NW
		if gradient2 < 0 then
			love.graphics.line(self.centerx, self.centery, x1,y1)
		else
			love.graphics.line(self.centerx, self.centery, x2,y2)
		end
	elseif self.centery < centery and self.centerx > centerx then  --NE
		if gradient1 < 0 then
			love.graphics.line(self.centerx, self.centery, x1,y1)
		else
			love.graphics.line(self.centerx, self.centery, x2,y2)
		end
	elseif self.centery > centery and self.centerx > centerx then  --SE
		if gradient2 > 0 then
			love.graphics.line(self.centerx, self.centery, x2,y2)
		else
			love.graphics.line(self.centerx, self.centery, x4,y4)
		end
	elseif self.centery > centery and self.centerx < centerx then  --SW
		if y1 * gradient1 > y3 * gradient3 then
			love.graphics.line(self.centerx, self.centery, x3,y3)
		else
			love.graphics.line(self.centerx, self.centery, x1,y1)
		end
	end

	--BOTTOM HALF
	if self.centery < centery and self.centerx < centerx then      --NW
		if x1 * gradient1 > x3 * gradient3 then
			love.graphics.line(self.centerx, self.centery, x1,y1)
		else
			love.graphics.line(self.centerx, self.centery, x3,y3)
		end
	elseif self.centery < centery and self.centerx > centerx then  --NE
		if x2 * gradient2 < x4 * gradient4 then
			love.graphics.line(self.centerx, self.centery, x2,y2)
		else
			love.graphics.line(self.centerx, self.centery, x4,y4)
		end
	elseif self.centery > centery and self.centerx > centerx then  --SE
		if gradient3 > 0 then
			love.graphics.line(self.centerx, self.centery, x3,y3)
		else
			love.graphics.line(self.centerx, self.centery, x4,y4)
		end
	elseif self.centery > centery and self.centerx < centerx then  --SW
		if gradient4 > 0 then
			love.graphics.line(self.centerx, self.centery, x3,y3)
		else
			love.graphics.line(self.centerx, self.centery, x4,y4)
		end
	end
end