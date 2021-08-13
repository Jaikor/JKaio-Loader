local file = module.load(header.id,'helper/file')

local MIN_SCAN_ID = 0
local MAX_SCAN_ID = 512

local lock = {}
lock.sleep = 0
lock.ownpath = hanbot.path .. "\\" .. header.script_id .. ".lock"

lock.load = function(cb)
	if file.exists(lock.ownpath) then
		local f = io.open(lock.ownpath, "wb")
		f:write("")
		f:close()
	end
	lock.cb = cb
	
	lock.sleep()
end

lock.sleep = function()
	local x = os.clock()+math.random()*10
	lock.nsleep = x
end


lock.tick = function()
	if lock.nsleep == 0 then
		return
	end
	if os.clock() < lock.nsleep then
		return
	end
	lock.nsleep = 0
	
	lock.try()
end

lock.try = function()
	for i=MIN_SCAN_ID,MAX_SCAN_ID,1 do
		if i ~= header.script_id then
			local xlock = hanbot.path .. "\\" .. i .. ".lock"
			local xlock_size = file.size(xlock)
			if xlock_size > 0 then
				print("Lock file (" .. i .. ") found, waiting !")
				lock.sleep()
				return
			end
		end
    end
	lock.lock()
	lock.cb()
end

lock.lock = function()
	local f = io.open(lock.ownpath, "wb")
	f:write("LOCKED !")
	f:close()
end

lock.unlock = function()
	local f = io.open(lock.ownpath, "wb")
	f:write("")
	f:close()
end

cb.add(cb.tick, lock.tick)

return lock