local file = {}

file.exists = function(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

file.size = function(path)
	if file.exists(path) then
		local f = io.open(path, "rb")
		local size = f:seek("end")
		f:close()
		return size
	else
		return -1
	end
end

return file