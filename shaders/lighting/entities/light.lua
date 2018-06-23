local function scale(x, min1, max1, min2, max2)
	return min2 + ((x - min1) / (max1 - min1)) * (max2 - min2)
end
  
local function distance(x1, y1, x2, y2)
	return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
  
function radialGradient(radius)
	local data = love.image.newImageData(radius * 2, radius * 2)
	data:mapPixel(function(x, y)
		local dist = distance(radius, radius, x, y)
		return 0.62,0.6,0.1, (dist <= radius and scale(dist, 0, radius, .9, 0) or 0)
	end)
	return love.graphics.newImage(data)
end