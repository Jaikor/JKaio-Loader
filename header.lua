return {
    id = "JKSHOPAIO",
    name = "JKAIO - " ..(player and player.charName or ''),
    author = "JK",
    description = [[ 79 Champs supported: Ahri,
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
                                          Yasuo, 
                                          Yone, 
                                          Zac, 
                                          Ziggs,
                                          Zilean, 
                                          Zyra 
                    ]],

    shard_url="https://github.com/Jaikor/JKaio-rework/blob/main/JKaio-rework.shard",

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
 
