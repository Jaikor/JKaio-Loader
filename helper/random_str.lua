local random = module.load(header.id, 'helper/mt19937ar')

local random_str = {}
random_str.chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-={}|[]`~'
random_str.mt = nil

random_str.random = function()
    if random_str.mt == nil then
        random_str.mt = random.new()
        random_str.mt:init_genrand(os.time(os.date("!*t"))+os.clock())
    end

    local length = random_str.mt:random(512,4096)
    local randomString = ''    
    
    charTable = {}
    for c in random_str.chars:gmatch"." do
        table.insert(charTable, c)
    end
    
    for i = 1, length do
        randomString = randomString .. charTable[math.random(1, #charTable)]
    end
    
    return randomString
end

return random_str