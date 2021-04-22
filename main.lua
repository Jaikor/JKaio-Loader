local update = {}
update.update = module.load(header.id,'update/update')

local auth = {}
auth.auth = module.load(header.id, 'auth/init')

update.update.UpdateOrGenerateV2File(auth.auth.init)