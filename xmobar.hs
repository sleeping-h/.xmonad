Config { 
    font = "xft:DejaVu Sans Mono:size=9:book:antialias=true",
    bgColor = "#1d1d1d",
    fgColor = "#eeeeee",
--	iconOffset = 0,
    position = Static { xpos = 0, ypos = 0, width = 1366, height = 16 },
    lowerOnStart = True,
    commands = [
        ,Run Date "<fc=#b0d2ff>%a %b %d </fc>%H:%M" "date" 600 
		,Run MultiCpu [ "--template" , "<autototal>"
            , "--Low"      , "50"         -- units: %
            , "--High"     , "85"         -- units: %
            , "--low"      , "#888888"
            , "--normal"   , "#c06aeb"
            , "--high"     , "#ef5880"
            , "-c"         , " "
            , "-w"         , "3"
        ] 10
        ,Run Com "bash" ["-c", ".xmonad/getvolume.sh"] "vol" 10
        ,Run Com "bash" ["-c", ".xmonad/network.sh"] "network" 10 
        ,Run Com "bash" ["-c", ".xmonad/battery.sh"] "battery" 10
        ,Run Kbd [("ru", "ru"), ("us", "en")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = " %StdinReader% }{ <fc=#b0d2ff> %kbd%</fc> <fc=#f6e8b9><icon=/home/sleeping/.xmonad/icons/spkr_01.xbm/></fc> %vol% <fc=#74dea7><icon=/home/sleeping/.xmonad/icons/cpu.xbm/></fc>%multicpu%  %network% <icon=/home/sleeping/.xmonad/icons/bat_low_01.xbm/> %battery%  %date% "
}
