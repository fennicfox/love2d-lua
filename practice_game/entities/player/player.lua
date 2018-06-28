player = {}

function player:create(x, y, w, h, r, g, b)
	self.__index = self
	player.friction = 5
	player.gravity = 2000
	return setmetatable({
		x=x or  0,
		y=y or  0,
		w=w or 30,
		h=h or 49,
		r=r or 1,
		g=g or 1,
		b=b or 1,
		speed = 1500,
		xvel = 0,
		yvel = 0,
		jumpspeed = 900,
		on_ground = false,
		walltouch_left = false,
		walltouch_right= false,
	}, self)
end

function player:update(dt)
	self.on_ground = false
	if love.keyboard.isDown('a') and not self:box_to_left(dt) then 
		self.xvel = self.xvel - (self.speed * dt) 
	end
	self:box_to_left(dt)
	if love.keyboard.isDown('d') and not self.walltouch_right then 
		self.xvel = self.xvel + (self.speed * dt) 
	end
	if self.y+self.h >= love.graphics.getHeight() then
		self.yvel = 0
		self.y = love.graphics.getHeight()-self.h 
		if love.keyboard.isDown('w') then 
			self.yvel = self.yvel - self.jumpspeed
		end
	else
		self.yvel = self.yvel + (player.gravity * dt)
	end

	for i, v in ipairs(scenary) do
		if (self.y+self.h >= v.y and self.y <= v.y + v.h) and (self.x+self.w > v.x and self.x < v.x+v.w) then
			self.yvel = 0
			self.on_ground = true
			if self.y < 501 then
				print(self.x,self.y)
			end
			self.y = v.y-self.h 
		end
	end
	if self.on_ground and love.keyboard.isDown('w') then 
		self.yvel = self.yvel - self.jumpspeed
	elseif not self.on_ground then
		self.yvel = self.yvel + (player.gravity * dt)
	end 
end

function player:box_to_left(dt)
	for i, v in ipairs(scenary) do
		if ((self.x >= v.x+v.w) and ((self:whats_next_xstep(true, dt) <= v.x+v.w))) and (self.y+self.h > v.y and self.y < v.y+v.h) then
			self.x=v.x+v.w
			self.xvel=0
			self.walltouch_left = true
			return true
		end
	end
	self.walltouch_left = false
	return false
end

function player:box_to_right(dt)
	for i, v in ipairs(scenary) do
		if (self.x+self.w < v.x and self.xvel+self.w > v.x) and (self.y+self.h > v.y and self.y < v.y+v.h) then
			-- self.walltouch_right = true
			return false
		end
	end
	self.walltouch_right = false
	return false
end

function player:whats_next_xstep(left, dt)
	if left then
		return self.x + self.xvel * dt
	else
		return self.x - self.xvel * dt
	end
end

function player:whats_next_ystep(left, dt)
	if left then
		return self.x + self.xvel * dt
	else
		return self.x - self.xvel * dt
	end
end

function player:physics(dt)
	self.x = self.x + self.xvel * dt                              --moves the player if the velocity is not 0
	self.y = self.y + self.yvel * dt                              --moves the player if the velocity is not 0
	self.xvel = self.xvel * (1 - math.min(dt*player.friction, 1)) --slows the player down if they're moving
	self.yvel = self.yvel * (1 - math.min(dt*player.friction, 1)) --slows the player down if they're moving
	if self.xvel < 0.1 and self.xvel > -0.1 then                --hotfix for player not completely stopping when idle.
		self.xvel = 0
	end
end

function player:draw()
	love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
	love.graphics.print("On ground:          "..tostring(self.on_ground))
	love.graphics.print("Wall touch left:   "..tostring(self.walltouch_left),0,20)
	love.graphics.print("Wall touch right: "..tostring(self.walltouch_right),0,40)
end