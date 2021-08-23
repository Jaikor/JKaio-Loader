local file = module.load(header.id,'helper/file')
local log = module.load(header.id,'helper/log')

local MIN_SCAN_ID = 0
local MAX_SCAN_ID = 512

local lock = {}
lock.sleep = 0
lock.ownpath = hanbot.path .. "\\" .. header.script_id .. ".lock"

lock.load = function(cb)
	log.print("lock.load", log.LEVEL_LOG)
	for i=MIN_SCAN_ID,MAX_SCAN_ID,1 do
		local xlock = hanbot.path .. "\\" .. i .. ".lock"
		local xlock_size = file.size(xlock)
		if xlock_size > 0 then
			local f = io.open(xlock, "wb")
			f:write("")
			f:close()
		end
    end
	log.print("dropped all locks", log.LEVEL_LOG)
	
	lock.cb = cb
	
	lock.sleep()
end

lock.sleep = function()
	log.print("lock.sleep", log.LEVEL_LOG)
	local x = os.clock()+0.5+math.random()*2
	log.print("Current Time: " .. tostring(os.clock()), log.LEVEL_LOG)
	log.print("Waiting until: " .. tostring(x), log.LEVEL_LOG)
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
	log.print("lock.try", log.LEVEL_LOG)
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
	log.print("lock.lock", log.LEVEL_LOG)
	local f = io.open(lock.ownpath, "wb")
	f:write("LOCKED !")
	f:close()
end

lock.unlock = function()
	log.print("lock.unlock", log.LEVEL_LOG)
	local f = io.open(lock.ownpath, "wb")
	f:write("")
	f:close()
end

cb.add(cb.tick, lock.tick)

return lock