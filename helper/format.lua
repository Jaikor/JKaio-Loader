local format = {}
format.format_time = function(time)
    local time = tonumber(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    return string.format("%d Days %02d Hours %02d Minutes %02d Seconds",days,hours,minutes,seconds)
end

format.char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
  end
  
format.urlencode = function(url)
    if url == nil then
      return
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", format.char_to_hex)
    url = url:gsub(" ", "+")
    return url
end
  
format.hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end
  
format.urldecode = function(url)
    if url == nil then
      return
    end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", format.hex_to_char)
    return url
end

return format

