player = {}

local keybound = {
	left = 'a',
	right = 'd',
	jump = 'w',
	restart = 'r'
}

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
		wall_is_above = false,
	}, self)
end


function player:update(dt)
	if love.keyboard.isDown(keybound.left) and not self:box_to_left(dt) then 
		self.xvel = self.xvel - (self.speed * dt) 
	end
	self:box_to_left(dt)
	if love.keyboard.isDown(keybound.right) and not self:box_to_right(dt) then 
		self.xvel = self.xvel + (self.speed * dt) 
	end
	self:box_to_right(dt)

	self:box_below(dt)
	self:box_above(dt)
	if self.on_ground and love.keyboard.isDown(keybound.jump) and not self.wall_is_above then 
		self.yvel = self.yvel - self.jumpspeed
	elseif not self.on_ground then
		self.yvel = self.yvel + (player.gravity * dt)
	end
	
end

function player:box_to_left(dt)
	for i, v in ipairs(scenary) do
		if ((self.x >= v.x+v.w) and (self:whats_next_xstep(dt) <= v.x+v.w)) and (self.y+self.h > v.y and self.y < v.y+v.h) then
			self.x=v.x+v.w
			self.xvel=0
			return true
		end
	end
	return false
end

function player:box_to_right(dt)
	for i, v in ipairs(scenary) do
		if ((self.x+self.w <= v.x) and (self:whats_next_xstep(dt)+self.w >= v.x)) and (self.y+self.h > v.y and self.y < v.y+v.h) then
			self.x=v.x-self.w
			self.xvel=0
			return true
		end
	end
	return false
end

function player:box_above(dt)
	for i, v in ipairs(scenary) do
		if (((self.y >= v.y+v.h) and (self:whats_next_ystep(dt) <= v.y+v.h)) or (self.y - 1 <= v.y+v.h) and self.y >= v.y) and (self.x+self.w > v.x and self.x < v.x+v.w) and (self.yvel <= 0) then
			self.yvel=0
			self.wall_is_above = true
			return
		end
	end
	self.wall_is_above = false
end

function player:box_below(dt)
	for i, v in ipairs(scenary) do
		if (self.y+self.h <= v.y and self:whats_next_ystep(dt)+self.h >= v.y ) and (self.x+self.w > v.x and self.x < v.x+v.w) then
			self.yvel = 0
			self.on_ground = true
			self.y = v.y-self.h
			return
		end
	end
	self.on_ground = false
end

function player:whats_next_xstep(dt)
	return self.x + self.xvel * dt
end

function player:whats_next_ystep(dt)
	return self.y + ( self.yvel + (player.gravity * dt)) * dt
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
	love.graphics.print("Wall touch ceiling:   "..tostring(self.wall_is_above),0,20)
end