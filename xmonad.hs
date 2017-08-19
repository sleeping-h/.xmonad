-- Core
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
import qualified System.IO
import Data.List
import Data.Ratio ((%))

-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell

-- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS

-- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.DecorationMadness
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.Spiral
import XMonad.Layout.Spacing
import XMonad.Layout.LayoutHints
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Gaps


defaults = defaultConfig
        { terminal            = "terminator"
        , normalBorderColor   = "#232327"
        , focusedBorderColor  = "#373755"--"#554400"--"#034365"
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , startupHook         = myStartupHook
        , layoutHook          = myLayoutHook
        , borderWidth         = 1
        , handleEventHook     = fullscreenEventHook
        } `additionalKeys` myKeys

myWorkspaces :: [String]

myWorkspaces = [ "one"  , "two"  , "three"
               , "four" , "five" , "six"
               , "seven", "eight", "nine" ]

myStartupHook :: X ()

myStartupHook = setWMName "XMonad"

myLayoutHook = gaps [(U, 17)] $ toggleLayouts (Full) $ smartBorders $
    resizable ||| resizable' ||| tiled -- ||| spiral (89/144)
  where
    tiled = avoidStruts $ Mirror $ Tall 1 (3/100) (1/2)
    resizable = avoidStruts $ ResizableTall 1 (3/100) (1/2) []
    resizable' = let x = 15 in avoidStruts $ spacing x $
                 gaps [(U, x), (D, x), (R, x), (L, x)] $
                 ResizableTall 1 (3/100) (1/2) []

myKeys = [ ((mod4Mask, xK_Right), moveTo Next NonEmptyWS)
         , ((mod4Mask, xK_Left), moveTo Prev NonEmptyWS)
         , ((mod4Mask, xK_Up), moveTo Next EmptyWS)
         , ((mod4Mask, xK_a), sendMessage MirrorShrink)
         , ((mod4Mask, xK_z), sendMessage MirrorExpand)
         , ((mod4Mask, xK_g), goToSelected defaultGSConfig)
         , ((mod4Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
         , ((mod4Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
         , ((0, 0x1008FF13), spawn "pactl set-sink-volume 1 +3%")
         , ((0, 0x1008FF11), spawn "pactl set-sink-volume 1 -3%")
         , ((0, 0x1008FF12), spawn "pactl set-sink-mute 1 toggle")
         , ((0, 0x1008FF14), spawn "mpc toggle")
         , ((0, 0x1008FF16), spawn "mpc prev")
         , ((0, 0x1008FF17), spawn "mpc next")
         , ((0, 0x1008FF02), spawn "xbacklight -inc 10")
         , ((0, 0x1008FF03), spawn "xbacklight -dec 10")
         , ((mod4Mask, xK_p), spawn "dmenu_run -nb \"#10101C\" -fn \"xft:DejaVu Sans:size=9:book:antialias=true\"")
         , ((mod4Mask, xK_y), spawn "terminator")
         , ((mod4Mask, xK_c), spawn "chromium")
         , ((controlMask, xK_Print), spawn "sleep 0.2; scrot `date +%s`.png -s -z -e 'mv $f ~/screenshots'")
         , ((0, xK_Print), spawn "scrot `date +%s`.png -z -e 'mv $f ~/screenshots'")
         ]

-- colors

xmobarFg    = "#bbbbdd"--"#cc9933"
xmobarBg    = "#10101c"
blockColor  = "#23233a"
myColor     = "#9999ff"
iconColor   = "#7777cc"
aaaaaa      = "#aaaac0"

-- icons

icon name = wrap "<icon=/home/sleeping/.xmonad/icons/" "/>" name
leftCnr   = icon "cnr_left.xbm"
rightCnr  = icon "cnr_right.xbm"
leftCnr'  = icon "cnr_left_.xbm"
rightCnr' = icon "cnr_right_.xbm"

-- xmobar

block leftIcon rightIcon fg bg fontColor =
    xmobarColor fontColor fg . wrap (wrapIcon leftIcon) (wrapIcon rightIcon)
    where wrapIcon = xmobarColor fg bg

leftBlock = block leftCnr rightCnr
rightBlock = block leftCnr' rightCnr'
colorIcon name = xmobarColor iconColor blockColor $ icon name

xmobarCommands = [ xmobarColor myColor blockColor "<fn=2>%kbd%</fn>"
                 , colorIcon "spkr.xbm" ++ " %vol%"
                 , colorIcon "cpu.xbm" ++ "%cpu%"
                 , colorIcon "battery.xbm" ++ " %battery%"
                 , xmobarColor myColor blockColor "IPv4" ++ " %network%"
                 , xmobarColor aaaaaa blockColor "%date%"
                 , xmobarColor "#ddddee" blockColor "%time%"
                 ]

xmobarRight = (foldl (++) "" . map rightBlock') xmobarCommands
    where rightBlock' = rightBlock blockColor xmobarBg aaaaaa
xmobarTemplate = "%StdinReader% }{ %music%  " ++ xmobarRight
xmobarPipe = "/usr/bin/xmobar -t \"" ++ xmobarTemplate ++ "\" ~/.xmonad/xmobar.hs"

-- main

main = spawnPipe xmobarPipe >>= \xmproc ->
    xmonad $ defaults {
        logHook =  dynamicLogWithPP $ defaultPP
          { ppOutput    = System.IO.hPutStrLn xmproc
          , ppTitle     = xmobarColor xmobarFg "" . shorten 70
          , ppCurrent   = leftBlock blockColor xmobarBg myColor
          , ppHidden    = leftBlock blockColor xmobarBg aaaaaa
          , ppVisible   = leftBlock blockColor xmobarBg "#ffffff"
          , ppSep       = "  " -- between WSs and title
          , ppWsSep     = ""
          , ppLayout    = \_ -> ""
       -- , ppHiddenNoWindows = showNamedWorkspaces
          }
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""
