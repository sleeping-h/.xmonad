Config { 
    font = "xft:DejaVu Sans Mono:size=9:book:antialias=true",
    bgColor = "#1d1d1d",
    fgColor = "#eeeeee",
    position = Static { xpos = 0, ypos = 0, width = 1366, height = 16 },
    lowerOnStart = True,
    commands = [
         Run Date "<fc=#b0d2ff>%a %b %d </fc>%H:%M" "date" 10 
		,Run Cpu ["--template" , "<total>%", "-w", "2"] 10
        ,Run Com "bash" ["-c", ".xmonad/getvolume.sh"] "vol" 10
        ,Run Com "bash" ["-c", ".xmonad/network.sh"] "network" 10
        ,Run Com "bash" ["-c", ".xmonad/battery.sh"] "battery" 10
        ,Run Kbd [("ru", "ru"), ("us", "en")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = " %StdinReader% }{<fc=#b0d2ff> %kbd%</fc> <fc=#cc9933><icon=/home/sleeping/.xmonad/icons/spkr_01.xbm/> %vol% </fc><fc=#74dea7><icon=/home/sleeping/.xmonad/icons/cpu.xbm/> %cpu% </fc> <fc=#f8acbc>%network%</fc> <fc=#cc9933><icon=/home/sleeping/.xmonad/icons/bat_low_01.xbm/> %battery%</fc>  %date% "
}
