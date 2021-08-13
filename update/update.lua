local update = {}
local file = module.load(header.id,'helper/file')
local log = module.load(header.id,'helper/log')
local message_encoding = {}
message_encoding.messagepack = module.load(header.id,'message_encoding/messagepack')

update.StartHanbotIDUpdate = function(callback)
    log.print("Updating V2 key", log.LEVEL_LOG)
    local key_file = io.open(hanbot.path .. "\\jk_auth2.key", "rb")
    local keyfile_content = key_file:read("*all")
    local k,v = message_encoding.messagepack.unpacker(keyfile_content)()

    local hbid_keyfile = v[1]
    local hb_enc = v[2][1]
    local hb_mac = v[2][1]

    if hb_enc then
        network.easy_post(
            callback,
            header.shard_url .. "/api/user/keyfile/update_hbid2.php",
            "hanbot_id=" .. hbid_keyfile .. "&new_hanbot_id=" .. hanbot.hwid
        )
    else        
        log.print("Your keyfile is corrupted !", log.LEVEL_ERR)
    end
end

update.PrepareV2Migration = function(callback)
    log.print("Generating V2 key", log.LEVEL_LOG)
    network.easy_post(
        callback,
        header.shard_url .. "/api/user/keyfile/update_hbid2.php",
        "hanbot_id=" .. hanbot.hwid .. "&new_hanbot_id=" .. hanbot.hwid .. "&force_key=true"
    )
end

update.UpdateOrGenerateV2File = function(callback)
    if
        file.exists(hanbot.path .. "\\jk_auth2.key") or
        file.exists(hanbot.path .. "\\jk_auth2.key.txt") or
        file.exists(hanbot.path .. "\\jk_auth2.txt")
    then
        update.StartHanbotIDUpdate(callback)
    else
        update.PrepareV2Migration(callback)
    end
end

return update