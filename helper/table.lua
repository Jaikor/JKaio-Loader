local t = {}

t.dump = function(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. t.dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

return t