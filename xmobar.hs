Config { 
    font = "xft:DejaVu Sans Mono:size=9:bold:antialias=true"
    bgColor = "#252525",
    fgColor = "#ffffff",
    position = Static { xpos = 0, ypos = 0, width = 1366, height = 16 },
    lowerOnStart = True,
    commands = [
         Run DynNetwork [
             "-t"    ,"<dev>"
            ,"-H"   ,"200"
            ,"-L"   ,"10"
            ,"-h"   ,"#FFB6B0"
            ,"-l"   ,"#CEFFAC"
            ,"-n"   ,"#FFFFCC"
            , "-c"  , " "
            , "-w"  , "2"
            , "-S"  , "True"
            ] 10
        ,Run Date "%Y.%m.%d %H:%M:%S" "date" 10
        ,Run MultiCpu [ "--template" , "<autototal>"
            , "--Low"      , "50"         -- units: %
            , "--High"     , "85"         -- units: %
            , "--low"      , "gray"
            , "--normal"   , "darkorange"
            , "--high"     , "darkred"
            , "-c"         , " "
            , "-w"         , "3"
        ] 10
        ,Run PipeReader "/tmp/.volume-pipe" "vol"
        ,Run Battery [ "--template" , "Batt: <left>%"
                     , "--Low"      , "15"        -- units: %
                     , "--High"     , "70"        -- units: %
                     , "--low"      , "#ef5880"
                     , "--normal"   , "#c06aeb"
                     , "--high"     , "#b0d2ff" 
                     ] 10
        ,Run Kbd [("ru", "ru"), ("us", "us")]
        ,Run StdinReader
    ],
    sepChar = "%",
    alignSep = "}{",
    template = " %StdinReader% }{ %kbd% | %multicpu% | %dynnetwork% | %battery% | <fc=#b0d2ff>%date%</fc> "
}
