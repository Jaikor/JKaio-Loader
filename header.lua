local JKAIO = { 

    Ahri         = true,
    Alistar      = true,
    Amumu        = true,
    Anivia       = true,
    Annie        = true,
    Ashe         = true,
    Blitzcrank   = true,
    Bard         = true,
    Brand        = true,
    Braum        = true,
    Caitlyn      = true,
    Cassiopeia   = true,
    Evelynn      = true,
    Ezreal       = true,
    Fizz         = true,
    Heimerdinger = true,
    Irelia       = true,
    Janna        = true,
    JarvanIV     = true,
    Jax          = true,
    Jinx         = true,
    Kaisa        = true,
    Kalista      = true,
    Karma        = true,
    Kassadin     = true,
    Kayn         = true,
    Khazix       = true,
    Kindred      = true,
    KogMaw       = true,
    Leblanc      = true,
    LeeSin       = true,
    Leona        = true,
    Lissandra    = true,
    Lucian       = true,
    Lulu         = true,
    Lux          = true,
    Malphite     = true,
    Malzahar     = true,
    MasterYi     = true,
    Mordekaiser  = true,
    Nami         = true,
    Nasusu       = true,
    Nautilus     = true,
    Neeko        = true,
    Nocturne     = true,
    Pyke         = true,
    Rakan        = true,
    RekSai       = true,
    Renektion    = true,
    Rengar       = true,
    Riven        = true,
    Shaco        = true,
    Shyvana      = true,
    Sivir        = true,
    Skarner      = true,
    Soraka       = true,
    Swain        = true,
    Sylas        = true,
    Syndra       = true,
    Talon        = true,
    Taric        = true,
    Teemo        = true,
    Thresh       = true,
    Tristana     = true,
    TwistedFate  = true,
    Udyr         = true,
    Urgot        = true,
    Varus        = true,
    Vayne        = true,
    Veigar       = true,
    Vi           = true,
    Viego        = true,
    Warwick      = true,
    Xayah        = true,
    Xerath       = true,
    Yasuo        = true,
    Yone         = true,
    Zac          = true,
    Zed		 = true,
    Ziggs        = true,
    Zilean       = true,
    Zyra         = true 
}

return {
    id = "JKSHOPAIO",
    name = "JKAIO - " ..(player and player.charName or ''),
    author = "JK",
    description = [[ 81 Champs supported: Ahri,
                                          Alistar, 
                                          Amumu, 
                                          Anivia, 
                                          Annie, 
                                          Ashe, 
                                          Blitzcrank, 
                                          Bard, 
                                          Brand, 
                                          Braum, 
                                          Caitlyn, 
                                          Cassiopeia, 
                                          Evelynn, 
                                          Ezreal, 
                                          Fizz, 
                                          Heimerdinger, 
                                          Irelia, 
                                          Janna, 
                                          JarvanIV, 
                                          Jax, 
                                          Jinx, 
                                          Kaisa, 
                                          Kalista, 
                                          Karma, 
                                          Kassadin, 
                                          Kayn, 
                                          Khazix, 
                                          Kindred, 
                                          KogMaw, 
                                          Leblanc, 
                                          LeeSin, 
                                          Leona, 
                                          Lissandra, 
                                          Lucian, 
                                          Lulu, 
                                          Lux, 
                                          Malphite,
                                          Malzahar, 
                                          MasterYi, 
                                          Mordekaiser, 
                                          Nami, 
                                          Nasusu, 
                                          Nautilus, 
                                          Neeko, 
                                          Nocturne, 
                                          Pyke, 
                                          Rakan, 
                                          RekSai, 
                                          Renektion, 
                                          Rengar, 
                                          Riven, 
                                          Shaco, 
                                          Shyvana, 
                                          Sivir, 
                                          Skarner, 
                                          Soraka, 
                                          Swain, 
                                          Sylas, 
                                          Syndra, 
                                          Talon, 
                                          Taric, 
                                          Teemo, 
                                          Thresh, 
                                          Tristana, 
                                          TwistedFate, 
                                          Udyr, 
                                          Urgot, 
                                          Varus, 
                                          Vayne, 
                                          Veigar, 
                                          Vi,
					  Viego,
                                          Warwick, 
                                          Xayah,
					  Xerath, 
                                          Yasuo, 
                                          Yone, 
                                          Zac,
					  Zed,
                                          Ziggs,
                                          Zilean, 
                                          Zyra 
                    ]],

    shard_url="https://github.com/Jaikor/JKaio-Loader/blob/main/JKaio-loader.shard",

    icon_url = "https://puu.sh/FF3pu/ec7d7cc81d.jpg",

    discord_url="https://discord.gg/SAchatj",

        riot = true,
        flag = {
			text = "JKSHOP AIO",
			color = {
				text = 0xFFa5c5a7,
				background1 = 0x87f6fd68,
				background2 = 0x99000000  
      },
    },
    
    shard = {
      "main",
      "json",
      "mp",
      "crypto"
    },
  
   load = function()
      return (JKAIO[player.charName] == true)
    end,
  }
