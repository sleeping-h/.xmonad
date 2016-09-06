Config { 
    font = "xft:DejaVu Sans Mono:size=9:book:antialias=true",
    bgColor = "#1d1d1d",
    fgColor = "#eeeeee",
    position = Static { xpos = 0, ypos = 0, width = 1366, height = 16 },
    lowerOnStart = True,
    commands = [
         Run DynNetwork [
             "-t"    ,"<dev>"
--            , "-c"  , " "
  --          , "-w"  , "2"
    --        , "-S"  , "True"
            ] 10
        ,Run Date "<fc=#b0d2ff>%a %b %d </fc>%H:%M" "date" 10 
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
        ,Run Com "bash" ["-c", ".xmonad/battery.sh"] "battery" 10
        ,Run Kbd [("ru", "ru"), ("us", "en")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = " %StdinReader% }{ <fc=#b0d2ff> %kbd%</fc> <icon=/home/sleeping/.xmonad/icons/spkr_01.xbm/> %vol% <icon=/home/sleeping/.xmonad/icons/cpu.xbm/>%multicpu%  <icon=/home/sleeping/.xmonad/icons/wifi_02.xbm/> (%dynnetwork%) <icon=/home/sleeping/.xmonad/icons/bat_low_01.xbm/> %battery%  %date% "
}

