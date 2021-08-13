local lockbox = {}

lockbox.cipher = {}
lockbox.cipher.aes256 = module.load(header.id,'lockbox/cipher/aes256')

lockbox.cipher.mode = {}
lockbox.cipher.mode.ctr = module.load(header.id,'lockbox/cipher/mode/ctr')

lockbox.digest = {}
lockbox.digest.sha2_256 = module.load(header.id,'lockbox/digest/sha2_256')

lockbox.padding = {}
lockbox.padding.zero = module.load(header.id,'lockbox/padding/zero')
lockbox.padding.pkcs7 = module.load(header.id,'lockbox/padding/pkcs7')

lockbox.util = {}
lockbox.util.array = module.load(header.id,'lockbox/util/array')
lockbox.util.base64 = module.load(header.id,'lockbox/util/base64')
lockbox.util.bit = module.load(header.id,'lockbox/util/bit')
lockbox.util.queue = module.load(header.id,'lockbox/util/queue')
lockbox.util.stream = module.load(header.id,'lockbox/util/stream')

local log = module.load(header.id,'helper/log')

local easy_aes = {}
function easy_aes.fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end

function easy_aes.tohex(str)
    return (str:gsub('.', function (c)
        return string.format('%02X', string.byte(c))
    end))
end

easy_aes.encrypt = function(plaintext, key, iv)    
    if key:len() ~= 64 then
        log.print("Encryption failed [INVALID KEY LEN]", log.LEVEL_ERR)
        return
    end
    if iv:len() ~= 32 then
        log.print("Encryption failed [INVALID IV LEN]", log.LEVEL_ERR)
        return
    end
    local key = lockbox.util.array.fromHex(key)
    local iv = lockbox.util.array.fromHex(iv)
    local plaintext = lockbox.util.array.fromHex(easy_aes.tohex(plaintext))
    local cipher = lockbox.cipher.mode.ctr.Cipher()
            .setKey(key)
            .setBlockCipher(lockbox.cipher.aes256)
            .setPadding(lockbox.padding.zero);

    local cipherOutput = cipher
                        .init()
                        .update(lockbox.util.stream.fromArray(iv))
                        .update(lockbox.util.stream.fromArray(plaintext))
                        .finish()
                        .asBytes();

    return lockbox.util.base64.fromArray(cipherOutput)
end

easy_aes.decrypt = function(crypttext, key, iv)
    local key = lockbox.util.array.fromHex(key)
    local iv = lockbox.util.array.fromHex(iv)
    local decipher = lockbox.cipher.mode.ctr.Decipher()
            .setKey(key)
            .setBlockCipher(lockbox.cipher.aes256)
            .setPadding(lockbox.padding.zero);

    local plainOutput = decipher
                        .init()
                        .update(lockbox.util.stream.fromArray(iv))
                        .update(lockbox.util.stream.fromHex(crypttext))
                        .finish()
                        .asHex();

    return easy_aes.fromhex(plainOutput)
end

return easy_aes