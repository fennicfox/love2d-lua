function shape(s)
	n1 = s:find(":")
	return s:sub(0,n1-1)
end

function get_details()
	
end

function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return 
		true 
	else 
		return false 
	end
end