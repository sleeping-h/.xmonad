Config { 
    font = "xft:DejaVu Sans Mono:size=9:book:antialias=true",
    bgColor = "#202034",
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
        ,Run Date "%Y.%m.%d %H:%M:%S" "date" 10
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
    template = " %StdinReader% }{  %kbd% | %vol% | %multicpu% | %dynnetwork% | %battery% | <fc=#b0d2ff>%date%</fc> "
}

