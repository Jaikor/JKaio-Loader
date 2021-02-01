local crypto = module.load(header.id,'crypto')
local json = module.load(header.id,'json')
local mp = module.load(header.id,'mp')

--[[
    README (for users):
        If you read this, the script developer has failed to read his readme, please report that to him, thank you

    README (for devs):
        You can use this script either as an reference to integrate JKAuth into your own loader or as an standalone.

        1) Register your Script(s) at auth.jkshop.gg
        2) Fill in the script ID's below
        3) Compile this script as an shard and upload it to Hanbot's market
        4) Load it ingame to see if the loader is working correctly

        AUTHOR_NAME : Your name
        SCRIPT_ID   : JK Auth script id, you will find that on the developer dashboard
--]]

--[[
]]--
local AUTHOR_NAME = "Scarjit"
local SCRIPT_ID = 53
--[[
Example:
local AUTHOR_NAME = "JKAuth-Team"
local SCRIPT_ID = 36
--]]

--TODO remove later
--AUTHOR_NAME = "DEV_LOADER"
--SCRIPT_ID = 37

--[[
    You don't need to change anything below here,
    but if you do, you are responsible for any problems which result from those changes.
--]]

 
local function str_split (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function log_file(msg)
    local file = io.open (hanbot.path .. "//jk_auth_loader.log", "a")
    file:write(msg)
    file:write("\n")
    file:close()
end 

local function log_online(msg)
    network.easy_post(
        function(a, b, c)
        end,
        "http://127.0.0.1:34056",
        "log=" .. tostring(msg)
    )
end

local LEVEL_LOG = 0
local LEVEL_WARN = 1
local LEVEL_ERR = 2
local function auth_print(msg, level, chat_print)
    local printResult
    local is_console = console ~= nil
    if level == LEVEL_LOG then
        printResult = "[JK_AUTH\\Loader] " .. tostring(msg)
        if is_console then
            console.set_color(2)   
        end
    elseif level == LEVEL_WARN then
        printResult = "[JK_AUTH\\Loader\\Warn] " .. tostring(msg)
        if is_console then
            console.set_color(6)
        end
    elseif level == LEVEL_ERR then
        if is_console then
            console.set_color(4)
        end
        printResult = "[JK_AUTH\\Loader\\Err] " .. tostring(msg)
    else
        console.set_color(74)
        printResult = "[JK_AUTH\\Loader\\FATAL] " .. tostring(msg)
    end
    log_file(printResult)
    --log_online(printResult)
    print(printResult)
    if chat_print then
        chat.print(printResult)
    end
    if is_console then
        console.set_color(0)
    end

    if level == LEVEL_ERR then
        diediedie()
    end
end

--[[
    Main
--]]
local JKAUTH_URL = "https://auth.jkshop.gg"
local cb_sdl, auth, cb_bnt_default, cb_btn_c, cb_btn_nc, cb_auth_check, cb_chk_script, chk_version, cb_dl_f, check_hash,update_hb_id, loader_m
local wrote_manifest = false
local downloads_needed = 0
local downloads_finished = 0

local function translatron(string_id)
    local language = loader_m.language:get()
    if language == 1 then
        language = "english"
    elseif language == 2 then
        language = "spanish"
    elseif language == 3 then
        language = "portuguese"
    elseif language == 4 then
        language = "chinese"
    elseif language == 5 then
        language = "german"
    end

    local str_tbl = {
        time_fmt = {
                    english = "%d Days %02d Hours %02d Minutes %02d Seconds",
                    german = "%d Tage %02d Stunden %02d Minuten %02d Sekunden",
                    spanish = "%d D��as %02d Horas %02d Minutos %02d Segundos",
                    portuguese = "%d Dias %02d Horas %02d Minutos %02d Segundos",
                    chinese = "%d�� %02dСʱ %02d���� %02d��"
        },
        downloaded = {
                english = "Downloaded",
                german = "Heruntergeladen:",
                spanish = "Descargado ",
                portuguese = "Descarregado",
                chinese = "������",
        },
        out_of = {
                    english = "out of",
                    german = "Verbleibend",
                    spanish = "de",
                    portuguese = "de",
                    chinese = "None",
        },
        upd_finished = {
                    english = "Update finished",
                    german = "Update abgeschlossen",
                    spanish = "Actualizaci��n finalizada",
                    portuguese = "Atualiza????o conclu��da",
                    chinese = "�������",
        },
        err_script_dl = {
                    english = "Couldn't download script list",
                    german = "Script liste konnte nicht heruntergeladen werden",
                    spanish = "No pod��a descargar la lista de guiones",
                    portuguese = "N??o foi poss��vel fazer o download da lista de scripts",
                    chinese = "�޷����ؽű��б�",
        },
        exp_perm = {
                    english = "Thank you for buying a permanent license",
                    german = "Vielen Dank f��r den Kauf einer permanenten Lizenz",
                    spanish = "Gracias por comprar una licencia permanente",
                    portuguese = "Obrigado por comprar uma licen??a permanente",
                    chinese = "��л�������ð�",
        },
        exp_free = {
                    english = "Thank you for using this free script",
                    german = "Vielen Dank f��r die Verwendung dieses kostenlosen Skripts",
                    spanish = "Gracias por usar este script gratuito",
                    portuguese = "Obrigado por usar este roteiro gratuito",
                    chinese = "��лʹ����Ѱ�",
        },
        exp_trial_start = {
                    english = "Trial started, have fun!",
                    german = "Die Probezeit hat begonnen, viel Spa??!",
                    spanish = "El juicio comenz��, ??divi��rtete!",
                    portuguese = "O julgamento come??ou, divirtam-se!",
                    chinese = "���ð������ɹ���ף����Ϸ��죡",
        },
        exp_key_expired = {
                    english = "Key or Trial expired",
                    german = "Schl��ssel oder Testversion abgelaufen",
                    spanish = "La llave o el juicio expir��",
                    portuguese = "Chave ou Julgamento expirado",
                    chinese = "�����ڵ��ڻ����Ķ����ѵ���",
        },
        exp_key_running = {
                    english = "Your key expires in:",
                    german = "Ihr Schl��ssel l??uft in ab:",
                    spanish = "Su llave expira en:",
                    portuguese = "Sua chave expira dentro:",
                    chinese = "���Ķ��ĵ���ʱ�䣺",
        },
        loading_shard = {
                    english = "Loading shard",
                    german = "Laden von Shard",
                    spanish = "Cargando el Shard",
                    portuguese = "Carregamento de Shard",
                    chinese = "��������ű�",
        },
        by = {
                    english = "by",
                    german = "von",
                    spanish = "por",
                    portuguese = "at��",
                    chinese = "ͨ��",
        },
        error_loading_shard_header = {
                    english = "Error loading shard header: ",
                    german = "Fehler beim laden des Shards",
                    spanish = "Error al cargar la cabeza del Shard: ",
                    portuguese = "Erro no carregamento de Shard: ",
                    chinese = "���ؽű�ʱ����",
        },
        error_already_authing = {
                    english = "Already trying to auth, please reload hanbot to try again !",
                    german = "Versucht bereits zu authentifizieren, bitte laden Sie hanbot neu, um es erneut zu versuchen !",
                    spanish = "Ya estoy tratando de autorizarlo, por favor recarga el Hanbot para intentarlo de nuevo.",
                    portuguese = "J�� tentando fazer o auth, por favor recarregue o hanbot para tentar novamente!",
                    chinese = "�Ѿ����Խ���������֤�������¼���hanbot����һ�Σ�",
        },
        err_hb_update = {
                    english = "Couldn't update hanbot id",
                    german = "Konnte hanbot-id nicht aktualisieren",
                    spanish = "No pude actualizar la identificaci��n del Hanbot",
                    portuguese = "N??o foi poss��vel atualizar a identifica????o do hanbot",
                    chinese = "�޷�����hanbot ID",
        },
        err_auto_update_not_supported = {
                    english = "Autoupdating not supported, please re-download your jk_auth.key file",
                    german = "Autoupdate nicht unterst��tzt, bitte lade die jk_auth.key Datei erneut herunter",
                    spanish = "La auto-actualizaci��n no est�� soportada, por favor vuelve a descargar tu archivo jk_auth.key",
                    portuguese = "Atualiza????o autom��tica n??o suportada, por favor, recarregue seu arquivo jk_auth.key",
                    chinese = "��֧���Զ����£���������������jk auth.key�ļ�",
        },
        checking_update = {
                    english = "Checking for updates��",
                    german = "Suche nach updates",
                    spanish = "Buscando actualizaciones...",
                    portuguese = "Verifica????o de atualiza????es...",
                    chinese = "���ڼ�����",
        },
        err_version_info = {
                    english = "Couldn't download version info",
                    german = "Versionsinformationen konnten nicht heruntergeladen werden",
                    spanish = "No pod��a descargar la informaci��n de la versi��n",
                    portuguese = "N??o foi poss��vel baixar as informa????es da vers??o",
                    chinese = "�޷����ذ汾��Ϣ",
        },
        jk_manifest_missing = {
                    english = "jk_manifest.json missing, re-downloading all files",
                    german = "jk_manifest.json fehlt, erneutes Herunterladen aller Datein",
                    spanish = "jk_manifest.json desaparecido, volviendo a descargar todos los archivos",
                    portuguese = "jk_manifest.json desaparecido, recarregando todos os arquivos",
                    chinese = "jk_manifest.json��ʧ���������������ļ�",
        },
        dll_missing = {
                    english = "dll missing, re-downloading",
                    german = "dll fehlt, wird heruntergeladen",
                    spanish = "dll desaparecido, volviendo a descargar",
                    portuguese = "dll em falta, recarregamento",
                    chinese = "dll��ʧ����������",
        },
        updating_dll = {
                    english = "Updating dll from ",
                    german = "Aktualisierung der dll von",
                    spanish = "Actualizando el dll de ",
                    portuguese = "Atualiza????o do dll de ",
                    chinese = "����DLL��",
        },
        to = {
                    english = "to",
                    german = "zu",
                    spanish = "a",
                    portuguese = "a",
                    chinese = "��",
        },
        corrupt_dll_or_outdated = {
                    english = "dll file corrupt or outdated, re-downloading",
                    german = "dll Datei korrupt oder veraltet, wird erneut heruntergeladen",
                    spanish = "archivo dll corrompido o anticuado, volver a descargar",
                    portuguese = "arquivo dll corrompido ou desatualizado, recarregamento",
                    chinese = "dll�ļ��𻵻��ʱ������������",
        },
        update_failed = {
                    english = "Update failed",
                    german = "Update fehlgeschlagen",
                    spanish = "La actualizaci��n fracas��",
                    portuguese = "Atualiza????o falhou",
                    chinese = "����ʧ��",
        },
        bytes_downloaded = {
                    english = "Bytes downloaded:",
                    german = "Bytes heruntergeladen",
                    spanish = "Bytes descargados:",
                    portuguese = "Bytes baixados:",
                    chinese = "�����ص��ֽ�����",
        },
        auth_upd_hash_fail = {
                    english = "Auth??update??failed,??please??contact??Support",
                    german = "Auth Update fehlgeschlagen, bitte kontaktiere den Support",
                    spanish = "La actualizaci��n autom��tica fall��, por favor contacte con el soporte",
                    portuguese = "A atualiza????o autom��tica falhou, favor contatar o Suporte",
                    chinese = "��֤����ʧ�ܣ�����ϵ֧��",
        },
        first_start = {
                    english = "First??start,??please??download??the??jk_auth.key??file??and??place??it??in??the??'hanbot\\league??of??legends'??folder",
                    german = "Bitte lade zun??chst die jk_auth.key herunter und lege is in den Ordner 'hanbot\\league of legends'",
                    spanish = "Primero comienza, por favor descarga el archivo jk_auth.key y col��calo en la carpeta 'hanbot\\Nleague of legends'.",
                    portuguese = "Primeiro, fa??a o download do arquivo jk_auth.key e coloque-o na pasta 'hanbot' de lendas",
                    chinese = "���ȣ�������jk_auth.key�ļ������������``hanbot\\league of legends''�ļ�����",
        },
        menu_time_before_auth = {
                    english = "Time before authing (sec)",
                    german = "Zeit vor dem Authentisieren (sec)",
                    spanish = "Tiempo antes de la autopsia (seg.)",
                    portuguese = "Tempo antes da autua????o (seg)",
                    chinese = "��֤ǰʱ�䣨�룩",
        },
        menu_time_tooltip_1 = {
                    english = "Increase above option",
                    german = "Erh??he die Zeit",
                    spanish = "Aumentar la opci��n anterior",
                    portuguese = "Aumentar a op????o acima ",
                    chinese = "��������ѡ��",
        },
        menu_time_tooltip_2 = {
                    english = "if the script crashes",
                    german = "falls das Skript abst��rzt",
                    spanish = "si el gui��n se bloquea",
                    portuguese = "se o roteiro falhar",
                    chinese = "����ű�����",
        },
    }

    if str_tbl[string_id] == nil then
        return "UNKNOWN STRING"
    end

    if str_tbl[string_id][language] == nil or str_tbl[string_id][language] == "None" then
        return "TRANSLATION MISSING"
    end

    return str_tbl[string_id][language]
end

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

local function disp_time(time)
    local time = tonumber(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    return string.format(translatron("time_fmt"),days,hours,minutes,seconds)
end

local idf = io.open(hanbot.path .. "\\hanbot_user.txt", "w")
idf:write(hanbot.user)
idf:close()

chk_version = function (remote,local_ver)
    local remote_split = str_split(remote, ".")
    local local_split = str_split(local_ver, ".")
    
    local remote_maj = tonumber(remote_split[1])
    local remote_min = tonumber(remote_split[2])
    local remote_bld = tonumber(remote_split[3])

    local local_maj = tonumber(local_split[1])
    local local_min = tonumber(local_split[2])
    local local_bld = tonumber(local_split[3])

    if remote_maj > local_maj then
        return true
    elseif remote_maj == local_maj then
      if remote_min > local_min then
          return true
      elseif remote_min == local_min then
        if remote_bld > local_bld then  
          return true
        end
      end
    end
    return false
end

cb_dl_f = function()
    auth_print(translatron("downloaded") .. " " .. downloads_finished .. translatron("out_of") .. " " .. downloads_needed, LEVEL_LOG)
    if wrote_manifest and downloads_finished == downloads_needed then
        auth_print(translatron("upd_finished"), LEVEL_LOG)
        core.reload()
    end
end

--[[
    Actually relevant stuff
--]]
local VERSION = "1.8.0"
local auth_attempted = false
local using_v2 = false

cb.add(
    cb.error,
    function(msg)
        log_online(msg)
    end
)

cb_sdl = function(a, b)
    a = tonumber(a)
    if (a ~= 301 and a ~= 200) then
        auth_print(translatron("err_script_dl") ..  "[" .. tostring(a) .. "]", LEVEL_ERR)
        return
    end
    SCRIPTS = json.decode(b)
    for i = 1, #SCRIPTS do
        local sx = SCRIPTS[i]
        cb_auth_check()
        auth(sx["id"], sx["sname"], sx["remaining"])
    end
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end

 
auth = function(id, sname, expire_date)
    if id == nil then
        return
    end
    if expire_date == 3020399 then
        auth_print(translatron("exp_perm"), LEVEL_LOG, true)
    elseif expire_date == 3020400 then
        auth_print(translatron("exp_free"), LEVEL_LOG, true)
    elseif expire_date == 3020500 then
        auth_print(translatron("exp_trial_start"), LEVEL_LOG, true)
    elseif expire_date < 0 then
        auth_print(" ================= ", LEVEL_WARN, true)
        auth_print(translatron("exp_key_expired"), LEVEL_WARN, true)
        auth_print(" ================= ", LEVEL_WARN, true)
        return
    else
        auth_print(translatron("exp_key_running") .. disp_time(expire_date), LEVEL_LOG, true)
    end

    local jk_auth_module = null
    if using_v2 then
        jk_auth_module = module.jk_api(hanbot.path .. "\\" .. "jk_auth_v2")
    else
        jk_auth_module = module.jk_api(hanbot.path .. "\\" .. "jk_auth")
    end
    local shard = jk_auth_module.AuthScript(tonumber(id))
    auth_print(translatron("loading_shard") .. " [" .. sname .. "] ".. translatron("by") .. " " .. AUTHOR_NAME .. "...", LEVEL_LOG, true)
    jk_auth_module = nil
    local hx, err = module.read_shard_buffer(sname, shard.data, shard.size)
    if not hx then
        auth_print(translatron("error_loading_shard_header") .. tostring(err), LEVEL_ERR)
        return
    end
    module.load_shard_buffer(header.id, shard.data, shard.size, hx)
    return shard
end

cb_auth_check = function()
    if auth_attempted then
        auth_print(translatron("error_already_authing"), LEVEL_WARN)
        return
    end
    auth_attempted = true
end

local function cb_xxx(arg1, arg2, arg3)    
    if (arg1 ~= 301 and arg1 ~= 200) then
        auth_print(translatron("err_hb_update") .. " [" .. tostring(arg1) .. "]", LEVEL_WARN)
    end 
    network.easy_post(
        cb_sdl,
        JKAUTH_URL .. "/api/script/get.php?scriptid=" .. tostring(SCRIPT_ID) .. "&lite=true&hbid=" ..hanbot.user,
        ""
    )
end

update_hb_id = function()
    local f = io.open(hanbot.path .. "\\jk_auth.key", "r")
    local jx = f:read("*all")
    local jk_auth = json.decode(jx)
    if (jk_auth["xkey"]) then
        network.easy_post(
            cb_xxx,
            JKAUTH_URL .. "/api/user/keyfile/update_hbid.php",
            "hb_id=" .. hanbot.user .. "&api_key=" .. jk_auth["xkey"]
        )
    else
        auth_print(translatron("err_auto_update_not_supported"), LEVEL_WARN)
        network.easy_post(
            cb_sdl,
            JKAUTH_URL .. "/api/script/get.php?scriptid=" .. tostring(SCRIPT_ID) .. "&lite=true&hbid=" ..hanbot.user,
            ""
        )
    end
end

update_hb_id_v2 = function()
    local f = io.open(hanbot.path .. "\\jk_auth2.key", "rb")
    local jx = f:read("*all")
    local k,v = mp.unpacker(jx)()

    local hbid_keyfile = v[1]
    local hb_enc = v[2][1]
    local hb_mac = v[2][1]

    if hb_enc then
        network.easy_post(
            cb_xxx,
            JKAUTH_URL .. "/api/user/keyfile/update_hbid2.php",
            "hb_id=" .. hanbot.user .. "&api_key=" .. hb_enc .. "&api_key2=" .. hb_mac
        )
    else        
        auth_print(translatron("err_auto_update_not_supported"), LEVEL_WARN)
        network.easy_post(
            cb_sdl,
            JKAUTH_URL .. "/api/script/get.php?scriptid=" .. tostring(SCRIPT_ID) .. "&lite=true&hbid=" ..hanbot.user,
            ""
        )
    end
end

check_hash = function (vhash, version)
    local f = nil
    if version == 1 then
        f = io.open(hanbot.path .. "\\jk_auth_v2.dll", "rb")
    else
        f = io.open(hanbot.path .. "\\jk_auth.dll", "rb")
    end
    if f == nil then
        return false
    end
    local fc = f:read("*all")
    local shax = crypto.sha.sha3_512()
    shax(fc)
    local shav = shax()
    if shav ~= vhash then
        auth_print(version, LEVEL_WARN)
        auth_print(vhash, LEVEL_WARN)
        auth_print(shav, LEVEL_WARN)
        return false
    end
    return true
end  

cb_chk_script = function(a, b)
    auth_print(translatron("checking_update"), LEVEL_LOG)
    a = tonumber(a)
    if (a ~= 301 and a ~= 200) then
        auth_print(translatron("err_version_info"), LEVEL_ERR)
        return
    end

    local download_default = false

    SERVER_VERSIONS = json.decode(b)
    local manifest = nil
    if not file_exists(hanbot.path .. "\\jk_manifest.json") then
        auth_print(translatron("jk_manifest_missing"), LEVEL_WARN)
        download_default = true
        download_experimental = true
    else
        local manifest_file = io.open(hanbot.path .. "\\jk_manifest.json", "r")
        manifest = json.decode(manifest_file:read("*all"))
        if not file_exists(hanbot.path .. "\\jk_auth.dll") then
            auth_print(translatron("dll_missing"), LEVEL_LOG)
            download_default = true
        elseif chk_version(SERVER_VERSIONS["default"]["version"], manifest["default"]["version"]) then
            auth_print(
                translatron("updating_dll") .. " " ..
                    manifest["default"]["version"] .. " "..translatron("to").." " .. SERVER_VERSIONS["default"]["version"], LEVEL_LOG
            )
            download_default = true
        end
        if not check_hash(SERVER_VERSIONS["default"]["hash"], 0) then
            download_default = true
            auth_print(translatron("corrupt_dll_or_outdated"), LEVEL_LOG)
        end
        if not file_exists(hanbot.path .. "\\jk_auth_v2.dll") then
            auth_print(translatron("dll_missing"), LEVEL_LOG)
            download_experimental = true
        elseif not manifest["v2"] then
            download_experimental = true
        elseif chk_version(SERVER_VERSIONS["v2"]["version"], manifest["v2"]["version"]) then
            auth_print(
                translatron("updating_dll") .. " " ..
                    manifest["v2"]["version"] .. " "..translatron("to").." " .. SERVER_VERSIONS["v2"]["version"], LEVEL_LOG
            )
            download_experimental = true
        end
        if not check_hash(SERVER_VERSIONS["v2"]["hash"], 1) then
            download_experimental = true
            auth_print(translatron("corrupt_dll_or_outdated"), LEVEL_LOG)
        end
    end
    if download_default then
        downloads_needed = downloads_needed + 1
        network.easy_download(
            function(code,b,c)
                if tonumber(code) ~= 200 then
                    auth_print(translatron("update_failed").. " (" .. tostring(code) .. ")", LEVEL_ERR)
                    auth_print(translatron("bytes_downloaded") .. tostring(c))
                    return
                end
                downloads_finished = downloads_finished + 1
                cb_dl_f()
                if not check_hash(SERVER_VERSIONS["default"]["hash"], 0) then
                    auth_print(translatron("auth_upd_hash_fail"), LEVEL_ERR)
                end
            end,
            JKAUTH_URL .. "/downloads/jk_auth.dll",
            hanbot.path .. "\\jk_auth.dll"
        )
    else
        loader_m:header("version_dll", "Dll Version (V1): " .. tostring(manifest["default"]["version"]))
    end
    if download_experimental then
        downloads_needed = downloads_needed + 1
        network.easy_download(
            function(code,b,c)
                if tonumber(code) ~= 200 then
                    auth_print(translatron("update_failed").. " (" .. tostring(code) .. ")", LEVEL_ERR)
                    auth_print(translatron("bytes_downloaded") .. tostring(c))
                    return
                end
                downloads_finished = downloads_finished + 1
                cb_dl_f()
                if not check_hash(SERVER_VERSIONS["v2"]["hash"], 1) then
                    auth_print(translatron("auth_upd_hash_fail"), LEVEL_ERR)
                end
            end,
            JKAUTH_URL .. "/downloads/jk_auth_v2.dll",
            hanbot.path .. "\\jk_auth_v2.dll"
        )        
    else
        loader_m:header("version_dll_v2", "Dll Version: (V2) " .. tostring(manifest["v2"]["version"]))
    end
    local m = io.open(hanbot.path .. "\\jk_manifest.json", "w")
    m:write(b)
    m:close()
    wrote_manifest = true

    if downloads_needed == 0 then
        if loader_m.use_v2:get() == 1 then
            if
                file_exists(hanbot.path .. "\\jk_auth.key") or file_exists(hanbot.path .. "\\jk_auth.key.txt") or
                    file_exists(hanbot.path .. "\\jk_auth.txt")
            then
                update_hb_id()
            else
                auth_print(
                    translatron("first_start"), LEVEL_LOG
                )
            end
        else
            using_v2 = true
            auth_print("using v2", LEVEL_LOG)
            if
                file_exists(hanbot.path .. "\\jk_auth2.key") or file_exists(hanbot.path .. "\\jk_auth2.key.txt") or
                    file_exists(hanbot.path .. "\\jk_auth2.txt")
            then
                update_hb_id_v2()
            else
                auth_print("no v2 file")
            end
        end
    end
end

loader_m = menu('loader_menu_53', "[JKAuth Loader Settings] " .. tostring(VERSION))
loader_m:dropdown('language', "Language/Idioma/����/Sprache", 1, {
    "English",
    "Espa??ol",
    "Portugu��s",
    "����",
    "Deutsch"
})
loader_m:header('spacer_1', " -- ")
loader_m:dropdown('use_v2', translatron("v2selector"), 1, {
    "DLL V1",
    "DLL V2 (experimental)"
})


network.easy_post(cb_chk_script, JKAUTH_URL .. "/downloads/version.json")
