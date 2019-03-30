function shape(s)
	local n1 = s:find(":")
	return s:sub(0,n1-1)
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f)
		return true
	else
		return false
	end
end

function get_level_details(s)
	local new_string = s:sub(s:find(":")+1,s:len())
	local details = {}
	details[0] = shape(s)
	for i = 1, 7 do
		local n1 = new_string:find(":")
		if n1 ~= nil then
			details[i] =  new_string:sub(0,n1-1)
			new_string = new_string:sub(new_string:find(":")+1,new_string:len())
		else
			details[i] = new_string
			return details
		end
	end
end
