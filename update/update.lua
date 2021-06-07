local update = {}
local file = module.load(header.id,'helper/file')
local log = module.load(header.id,'helper/log')
local message_encoding = {}
message_encoding.messagepack = module.load(header.id,'message_encoding/messagepack')
local base64_d = module.load(header.id,'lockbox/util/base64_d')

update.cb = nil

update.cbx = function(a,b)
	if(a == 200)then
		local decoded = base64_d.decode(b)
		local key_file = io.open(hanbot.path .. "\\jk_auth2.key", "wb")		
		key_file:write(decoded)
		key_file:close()
	end
	update.cb()
end

update.StartHanbotIDUpdate = function()
	print("StartHanbotIDUpdate")
    log.print("Updating V2 key", log.LEVEL_LOG)
    local key_file = io.open(hanbot.path .. "\\jk_auth2.key", "rb")
    local keyfile_content = key_file:read("*all")
    local k,v = message_encoding.messagepack.unpacker(keyfile_content)()

    local hbid_keyfile = v[1]
    local hb_enc = v[2][1]
    local hb_mac = v[2][1]

    if hb_enc then
        network.easy_post(
            update.cbx,
            header.auth_url .. "/api/user/keyfile/update_hbid2.php",
            "hanbot_id=" .. hbid_keyfile .. "&new_hanbot_id=" .. hanbot.user .. "&force_key=true"
        )
    else        
        log.print("Your keyfile is corrupted !", log.LEVEL_ERR)
    end
end

update.PrepareV2Migration = function()
	print("PrepareV2Migration")
    log.print("Generating V2 key", log.LEVEL_LOG)
    network.easy_post(
        update.cbx,
        header.auth_url .. "/api/user/keyfile/update_hbid2.php",
        "hanbot_id=" .. hanbot.user .. "&new_hanbot_id=" .. hanbot.user .. "&force_key=true"
    )
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

update.check_if_v1_is_v2 = function()
	print("check_if_v1_is_v2")
	local key_file = io.open(hanbot.path .. "\\jk_auth.key", "rb")
    local keyfile_content = key_file:read("*all")
	
	if string.starts(keyfile_content, "----") then
		print("Found V2 in V1")
		keyfile_content = keyfile_content:gsub("----", "")
		local actual = base64_d.decode(keyfile_content)
		local f = io.open(hanbot.path .. "\\jk_auth2.key", "wb")
		f:write(actual)
		f:close()
	else
		print("No valid V2inV1 file found")
	end
end

update.UpdateOrGenerateV2File = function(callback)
	update.cb = callback
	print("UpdateOrGenerateV2File")
    if
        file.exists(hanbot.path .. "\\jk_auth2.key") or
        file.exists(hanbot.path .. "\\jk_auth2.key.txt") or
        file.exists(hanbot.path .. "\\jk_auth2.txt")
    then
        update.StartHanbotIDUpdate()
    else
		if file.exists(hanbot.path .. "\\jk_auth.key") then
			update.check_if_v1_is_v2()
		end
        update.PrepareV2Migration()
    end
end

return update