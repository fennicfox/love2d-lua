scenary = {}

function scenary:createRectangle(x, y, w, h, r, g ,b)
	local object = {
    t = "rectangle",
 	x = x,
	y = y,
	w = w,
	h = h,
	r = r,
	g = g,
	b = b
}
	table.insert(scenary, object)
	setmetatable(object, {__index = self})
	return object
end

function scenary_update(dt)

end

function scenary_draw()
    for i, v in ipairs(scenary) do
        love.graphics.setColor(v.r,v.g,v.b,1)
        love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
    end
end