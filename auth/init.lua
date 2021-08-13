local log = module.load(header.id,'helper/log')
local format = module.load(header.id,'helper/format')
local json = module.load(header.id,'message_encoding/json')
local messagepack = module.load(header.id,'message_encoding/messagepack')
local easy_aes = module.load(header.id,'auth/easy_aes')
local random_str = module.load(header.id, 'helper/random_str')
local base64 = module.load(header.id, 'lockbox/util/base64')
local base64_d = module.load(header.id, 'lockbox/util/base64_d')
local file = module.load(header.id, 'helper/file')
local sha256 = module.load(header.id, 'lockbox/digest/sha2_256')
local crc32 = module.load(header.id, 'lockbox/digest/crc32')
local stream = module.load(header.id, 'lockbox/util/stream')

local auth = {}

auth.validate_http_status = function(http_status)
    http_status = tonumber(http_status)
    if (http_status ~= 301 and http_status ~= 200 and http_status ~= 100) then
        log.print("The auth encountered an error contacting the auth server.\nIf the issue persists, please contact an admin\nHTTP Error: " .. tostring(http_status), LEVEL_ERR)
        DIEDIEDIE()
        DieDieDie()
        DIeDIeDIe()
        DiEDiEDiE()
        dIEdIEdIE()
        return false
    end
    return true
end

auth.hb_enc = nil
auth.hbid_keyfile = nil

auth.chunksize = 1*1024*1024 -- 1 MB
auth.chunktable = {}
auth.current_chunk = -1
auth.is_downloading = false
auth.download_finished = false
auth.download = ""
auth.download_raw = ""
auth.chunks = 0
auth.script_size = 0

auth.load = function()
    
    local script_binary_s = base64_d.decode(auth.download)

    local buffer_size = #script_binary_s
    local buffer = memory.new('unsigned char', buffer_size)  
    for i=1, buffer_size do
        buffer[i-1] = script_binary_s:byte(i)
    end
    
    local hx, err = module.read_shard_buffer(header.id, buffer, buffer_size)
    if not hx then
        log.print(err)
        return
    end

    module.load_shard_buffer(header.id, buffer, buffer_size, hx)
end

auth.downloadchunk = function(http_status, message)
    if(auth.validate_http_status(http_status) == false)then
        return
    end
    auth.download_raw  = auth.download_raw .. message
    local decoded = easy_aes.fromhex(message)
    auth.download = auth.download .. decoded
    auth.current_chunk = auth.current_chunk +1

    
    if auth.current_chunk > auth.chunks then
        auth.download_finished = true
        
        --Write cache
        local f = io.open(hanbot.path .. "\\".. header.script_id .. ".lf", "wb")
        f:write(auth.download_raw)
        f:close()
        
        auth.load()
    end
    auth.is_downloading = false
end

auth.on_draw = function()
    if auth.current_chunk <= 0 then
        return
    end
    if auth.download_finished == false then
        local w = graphics.width
        local h = graphics.height
        local w_center = w/2

        local rect_width = w/3
        local rect_x_start = w_center - rect_width/2

        local bar_height = 20

        graphics.draw_text_2D("Updating " ..auth.remote_name, 30, rect_x_start, h/1.3-20, 0xFFFFFFFF)
        graphics.draw_rectangle_2D(rect_x_start, h/1.3, rect_width, 20, 3, 0xFFFFFFFF)

        local p = ((auth.current_chunk-1)/auth.chunks)
        local g = p*255
        local r = 255-g
        local bar_color = graphics.argb(255, r, g, 0)
        local rect_x_end = rect_x_start + rect_width*p
        graphics.draw_line_2D(rect_x_start, h/1.3+bar_height/2, rect_x_end, h/1.3+bar_height/2, bar_height, bar_color)
    end

    if auth.is_downloading == false and auth.download_finished == false then
        local cc = auth.chunktable[auth.current_chunk]
        auth.is_downloading = true
        network.easy_post(
            auth.downloadchunk,
            header.auth_url .. "/api/auth/authVX/downloader.php",
            "sid=" .. header.script_id .. "&hbid=" .. auth.hbid_keyfile .. "&from=" .. cc.from .. "&to=" .. cc.to
        )
    end
end


auth.auth_return = function(http_status, message)
    if(auth.validate_http_status(http_status) == false)then
        return
    end
	
    local d = json.parse(message)
    local remote_hash = d["h"]

    if file.exists(hanbot.path .. "\\" .. header.script_id .. ".lf") then
        local f = io.open(hanbot.path .. "\\" .. header.script_id .. ".lf")
        local file_content = f:read("*all")
        f:close()
        local crc32 = crc32.hash(file_content)
        if crc32 == remote_hash then
            auth.download = easy_aes.fromhex(file_content)
            auth.load()
            return
        end
        return
    end

    auth.script_size = tonumber(d["l"])
    auth.remote_name = d["name"]

    for i=0,auth.script_size,auth.chunksize do
        auth.chunktable[#auth.chunktable+1] = {
            from = i,
            to = i+auth.chunksize-1
        }
    end
    auth.chunks = #auth.chunktable
    auth.chunktable[auth.chunks].to = auth.script_size

    log.print(auth.chunktable, log.LEVEL_LOG)

    cb.add(cb.draw, auth.on_draw)
    auth.current_chunk = 1
end

auth.do_auth = function(remote)
    local key_file = io.open(hanbot.path .. "\\jk_auth2.key", "rb")
	if key_file == nil then
		log.print("Keyfile not found, aborting", log.LEVEL_ERR)
	end
    local keyfile_content = key_file:read("*all")
    local k,v = messagepack.unpacker(keyfile_content)()

    auth.hbid_keyfile = v[1]
    auth.hb_enc = v[2][1]
    
    local random_string1 = random_str:random()
    local random_string2 = random_str:random()
    local random_string3 = random_str:random()
    local random_string4 = random_str:random()

    local request = {}
    request["remote"] = remote
    request["key"] = v
    request["unix_time"] = os.time()
    
    request["id"] = header.id
    request["name"] = header.name
    request["scriptid"] = header.script_id
    request["shardurl"] = easy_aes.tohex(header.auth_url)

    local j = json.stringify(request)
    
    local encrypted = easy_aes.tohex(easy_aes.encrypt(j, auth.hb_enc..auth.hb_enc, auth.hbid_keyfile))
    network.easy_post(
        auth.auth_return,
        header.auth_url .. "/api/auth/authVX/authVX.php",
        "v="..encrypted .. "&iv=" .. auth.hbid_keyfile
    )
end

auth.post_pre_check_auth = function(http_status, message)
    if(auth.validate_http_status(http_status) == false)then
        return
    end
    
    local SCRIPTS = json.parse(message)
    
    local remote = nil

    for i = 1, #SCRIPTS do
        remote = SCRIPTS[i]
        break
    end

    if(remote["is_amber"] == 1)then
        return
    end

    local remaining_time = tonumber(remote["remaining"])
    if remaining_time == 3020399 then
        log.print("Thank you for purchasing a permanent license <3", log.LEVEL_LOG, true)
    elseif remaining_time == 3020400 then
        log.print("Thank you for using this free script", log.LEVEL_LOG, true)
    elseif remaining_time == 3020500 then
        log.print("Your free trial of " .. remote["sname"] .. " has started !", log.LEVEL_LOG, true)
    elseif remaining_time < 0 then
        log.print(" ================= ", log.LEVEL_WARN, true)
        log.print("Your key for " .. remote["sname"] .. " has expired", log.LEVEL_WARN, true)
        log.print(" ================= ", log.LEVEL_WARN, true)
        return
    else
        log.print("Your trial expires in: " .. format.format_time(remaining_time), log.LEVEL_LOG, true)
    end

    auth.do_auth(remote)
end

auth.start_pre_check_auth = function()
    network.easy_post(
        auth.post_pre_check_auth,
        header.auth_url .. "/api/script/get.php?scriptid=" .. tostring(header.script_id) .. "&lite=true&hbid=" ..hanbot.hwid,
        ""
    )
end

auth.init = function()
    log.print("Auth init", log.LEVEL_LOG)
    auth.start_pre_check_auth()
end

return auth