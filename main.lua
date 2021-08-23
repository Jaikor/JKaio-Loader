local lock = module.load(header.id,'helper/lock')

function callback()
	local update = {}
	update.update = module.load(header.id,'update/update')

	local auth = {}
	auth.auth = module.load(header.id, 'auth/init')

	local log = module.load(header.id,'helper/log')

	log.print("Hanbot User ID: " .. hanbot.hwid2, log.LEVEL_LOG)
	log.print("Key download: https://auth.jkshop.gg/auth_v3/" .. hanbot.hwid2, log.LEVEL_LOG)
	local huid = io.open(hanbot.path .. "\\hanbot_user_id.txt", "wb")
	if huid ~= nil then
		huid:write(hanbot.hwid2)
		huid:close()
	end
	update.update.UpdateOrGenerateV2File(auth.auth.init)
end

lock.load(callback)