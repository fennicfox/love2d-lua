player = {}

function player:create(x, y, w, h, r, g, b, a)
	self.__index = self
	player.friction = 6
	player.gravity = 2500
	return setmetatable({
		x		  = x or  0,
		y		  = y or  0,
		w		  = w or 20,
		h		  = h or 20,
		r         = r or 1,
		g         = g or 1,
		b         = b or 1,
		a         = a or 1,
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
	love.graphics.setColor(self.r,self.g,self.b,self.a)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
end

function player:get_xy()
	return {self.x, self.y}
end

function player:draw_rays(t)
	local w = love.graphics.getWidth()
	local x1 = t.x
	local y1 = t.y
	local x2 = t.x+t.w
	local y2 = t.y
	local x3 = t.x
	local y3 = t.y+t.h
	local x4 = t.x+t.w
	local y4 = t.y+t.h
	local cx = self.centerx             
	local cy = self.centery             
	local centerx = t.x+t.w/2           
	local centery = t.y+t.h/2           
	local gradient1 = gradient_calculator(x1,y1,cx,cy) --x1,y1,x2,y2
	local gradient2 = gradient_calculator(x2,y2,cx,cy) --x1,y1,x2,y2
	local gradient3 = gradient_calculator(x3,y3,cx,cy) --x1,y1,x2,y2
	local gradient4 = gradient_calculator(x4,y4,cx,cy) --x1,y1,x2,y2
	-- love.graphics.print("gradient 1 = "..gradient1,0,0)
	-- love.graphics.print("gradient 2 = "..gradient2,0,15)
	-- love.graphics.print("gradient 3 = "..gradient3,0,30)
	-- love.graphics.print("gradient 4 = "..gradient4,0,45)
	-- love.graphics.print("end line x  = "..w,0,60)  --x = my + c
	-- love.graphics.print("end line y  = "..w*gradient2,0,75) --y = mx + c
	-- love.graphics.print("x2             = "..x2,0,90)  --x = my + c
	-- love.graphics.print("y2             = "..y2,0,105) --y = mx + c
	-- love.graphics.print("player x     = "..cx,0,120)
	-- love.graphics.print("player y     = "..cy,0,135)
	if love.mouse.isDown(2) then
		print("gradient 2 = "..gradient2)
		print("x2             = "..x2)  --x = my + c
		print("y2             = "..y2) --y = mx + c
	end
	
	--problems with gradients
	--this might help
	--https://www.desmos.com/calculator
	--https://www.youtube.com/watch?v=luz27XsnLz4
	
	-- c = y - mx
	-- c = x - my
	
	-- x = my + c
	-- y = mx + c
	
	-- 8.3333333 = 10-(0.166666667*10)
	-- x = (0.166666667*10)+8.3333333
	love.graphics.setLineWidth(0.01)
	--love.graphics.setColor(1,0,0)
	--TOP HALF
	if cy < centery and cx < centerx then      --NW
		if gradient2 < 0 then
			--love.graphics.line(cx, cy, x1,y1)
			love.graphics.line(x1, y1, w, (w*gradient1)+(cy-(gradient1*cx)))
		else
			--love.graphics.line(cx, cy, x2, y2)
			love.graphics.line(x2, y2, w, (w*gradient2)+(cy-(gradient2*cx)))
		end
	elseif cy < centery and cx > centerx then  --NE
		if gradient1 < 0 then
			--love.graphics.line(cx, cy, x1,y1)
			love.graphics.line(x1, y1, 0, (0*gradient1)+(cy-(gradient1*cx)))
		else
			--love.graphics.line(cx, cy, x2,y2)
			love.graphics.line(x2, y2, 0, (0*gradient2)+(cy-(gradient2*cx)))
		end
	elseif cy > centery and cx > centerx then  --SE
		if gradient2 > 0 then
			--love.graphics.line(cx, cy, x2,y2)
			love.graphics.line(x2, y2, 0, (0*gradient2)+(cy-(gradient2*cx)))
		else
			--love.graphics.line(cx, cy, x4,y4)
			love.graphics.line(x4, y4, w, (w*gradient4)+(cy-(gradient4*cx)))
		end
	elseif cy > centery and cx < centerx then  --SW
		if y1 * gradient1 > y3 * gradient3 then
			--love.graphics.line(cx, cy, x3,y3)
			love.graphics.line(x3, y3, 0, (0*gradient3)+(cy-(gradient3*cx)))
		else
			--love.graphics.line(cx, cy, x1,y1)
			love.graphics.line(x1, y1, w, (w*gradient1)+(cy-(gradient1*cx)))
		end
	end

	--BOTTOM HALF
	if cy < centery and cx < centerx then      --NW
		if x1 * gradient1 > x3 * gradient3 then
			--love.graphics.line(cx, cy, x1,y1)
			love.graphics.line(x1, y1, 0, (0*gradient1)+(cy-(gradient1*cx)))
		else
			--love.graphics.line(cx, cy, x3,y3)
			love.graphics.line(x3, y3, w, (w*gradient3)+(cy-(gradient3*cx)))
		end
	elseif cy < centery and cx > centerx then  --NE
		if x2 * gradient2 < x4 * gradient4 then
			--love.graphics.line(cx, cy, x2,y2)
			love.graphics.line(x2, y2, w, (w*gradient2)+(cy-(gradient2*cx)))
		else
			--love.graphics.line(cx, cy, x4,y4)
			love.graphics.line(x4, y4, 0, (0*gradient4)+(cy-(gradient4*cx)))
		end
	elseif cy > centery and cx > centerx then  --SE
		if gradient3 > 0 then
			--love.graphics.line(cx, cy, x3,y3)
			love.graphics.line(x3, y3, 0, (0*gradient3)+(cy-(gradient3*cx)))
		else
			--love.graphics.line(cx, cy, x4,y4)
			love.graphics.line(x4, y4, 0, (0*gradient4)+(cy-(gradient4*cx)))
		end
	elseif cy > centery and cx < centerx then  --SW
		if gradient4 > 0 then
			--love.graphics.line(cx, cy, x3,y3)
			love.graphics.line(x3, y3, w, (w*gradient3)+(cy-(gradient3*cx)))
		else
			--love.graphics.line(cx, cy, x4,y4)
			love.graphics.line(x4, y4, w, (w*gradient4)+(cy-(gradient4*cx)))
		end
	end
end

function gradient_calculator(x1, y1, x2, y2)
	return ((y2-y1)/(x2-x1))
end