return {
    id = "jkauth_loader",
    name = "[JKAuth] Loader",
    author = "JKAuth-Team",
    description = [[
      JK Auth
    ]],
  
    shard_url = "https://todo.shard",
    shard = {
      "main",
      "json",
      "mp",
      "crypto"
    },
  
    load = function()
      return true
    end,
  }
  