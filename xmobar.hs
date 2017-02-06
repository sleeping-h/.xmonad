Config { 
    font = "xft:DejaVu Sans Mono:size=9:book:antialias=true",
    bgColor = "#1d1d1d",
    fgColor = "#ccaa88",
    position = Static { xpos = 0, ypos = 0, width = 1368, height = 16 },
    lowerOnStart = True,
    commands = [
         Run Date "<fc=#b0d2ff>%a %b %d </fc><fc=#ccaa88>%H:%M</fc>" "date" 10 
        ,Run Cpu ["--template" , "<total>%", "-w", "2"] 10
        ,Run Com "bash" ["-c", ".xmonad/getvolume.sh"] "vol" 10
        ,Run Com "bash" ["-c", ".xmonad/network.sh"] "network" 30
        ,Run Com "bash" ["-c", ".xmonad/battery.sh"] "battery" 10
        ,Run Com "bash" ["-c", ".xmonad/music.sh"] "music" 10
        ,Run Kbd [("ru", "ru"), ("us", "en")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = " %StdinReader% }{<fc=#aaaaaa>%music%</fc> <fc=#b0d2ff> %kbd%</fc> <fc=#cc9933><icon=/home/sleeping/.xmonad/icons/spkr.xbm/> %vol% </fc><fc=#74dea7><icon=/home/sleeping/.xmonad/icons/cpu.xbm/> %cpu% </fc> <fc=#ccaa88>%network%</fc>  <fc=#cc9933><icon=/home/sleeping/.xmonad/icons/battery.xbm/> %battery%</fc>  %date% "
}
