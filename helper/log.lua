local t = module.load(header.id,'helper/table')

local log = {}
log.LEVEL_LOG = 0
log.LEVEL_WARN = 1
log.LEVEL_ERR = 2
log.print = function(msg, level, chat_print)
    local msg_type = type(msg)
    if(msg_type == "table")then
        msg = t.dump(msg)
    end

    local printResult
    local is_console = console ~= nil
    if level == log.LEVEL_LOG then
        printResult = "[JK_AUTH\\Loader] " .. tostring(msg)
        if is_console then
            console.set_color(2)   
        end
    elseif level == log.LEVEL_WARN then
        printResult = "[JK_AUTH\\Loader\\Warn] " .. tostring(msg)
        if is_console then
            console.set_color(6)
        end
    elseif level == log.LEVEL_ERR then
        if is_console then
            console.set_color(4)
        end
        printResult = "[JK_AUTH\\Loader\\Err] " .. tostring(msg)
    else
        console.set_color(74)
        printResult = "[JK_AUTH\\Loader\\FATAL] " .. tostring(msg)
    end
    print(printResult)
    if chat_print then
        chat.print(printResult)
    end
    if is_console then
        console.set_color(0)
    end

    if level == log.LEVEL_ERR then
        diediedie()
    end
end

return log