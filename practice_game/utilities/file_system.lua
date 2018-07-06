fsystem = {}

function fsystem:create()
	self.__index = self
	local object = setmetatable({

	}, self)
	return object
end

function fsystem_update(dt)
    for i, v in ipairs(fsystem) do

    end
end

function fsystem_draw()
    for i, v in ipairs(fsystem) do

    end
end

