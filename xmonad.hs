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
--import XMonad.Layout.Spacing
import XMonad.Layout.LayoutHints
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Gaps


defaults = defaultConfig {
          terminal            = "konsole"
        , normalBorderColor   = "#292929"
        , focusedBorderColor  = "#554400"--"#034365"        
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , startupHook         = myStartupHook
        , layoutHook          = myLayoutHook
        , borderWidth         = 1 
        , handleEventHook     = fullscreenEventHook
	}`additionalKeys` myKeys 

myWorkspaces :: [String]

myWorkspaces = ["one","two","three","four","five","six","seven","eight","nine"] 

xmobarCurrentWorkspaceColor = "#ccaa88"
xmobarTitleColor = "#bbbbbb"--"#cc9933"

myStartupHook :: X ()

myStartupHook = setWMName "XMonad" 

myLayoutHook = gaps [(U,16)] $ toggleLayouts (Full) $
    smartBorders $ resizable ||| Mirror tiled ||| spiral (89/144)
  where
    tiled = Tall 1 (3/100) (1/2)
    resizable = ResizableTall 1 (3/100) (1/2) []

myKeys = [
          ((mod4Mask, xK_Right), moveTo Next NonEmptyWS) 
        , ((mod4Mask, xK_Left), moveTo Prev NonEmptyWS)
        , ((mod4Mask, xK_Up), moveTo Next EmptyWS)
        , ((mod4Mask, xK_a), sendMessage MirrorShrink)
        , ((mod4Mask, xK_z), sendMessage MirrorExpand)
        , ((mod4Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS) 
        , ((mod4Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
	    , ((0, 0x1008FF13), spawn "amixer set Master 3%+")
	    , ((0, 0x1008FF11), spawn "amixer set Master 3%-")
	    , ((0, 0x1008FF12), spawn "amixer set Master 0")
	    , ((0, 0x1008FF14), spawn "ncmpcpp toggle")
	    , ((0, 0x1008FF16), spawn "ncmpcpp prev") 
	    , ((0, 0x1008FF17), spawn "ncmpcpp next")
	    , ((0, 0x1008FF02), spawn "xbacklight -inc 10")
	    , ((0, 0x1008FF03), spawn "xbacklight -dec 10")
	    , ((mod4Mask, xK_y), spawn "konsole")
	    , ((mod4Mask, xK_d), spawn "dolphin")
	    , ((mod4Mask, xK_c), spawn "chromium")
        , ((mod1Mask, xK_space), spawn "bash ~/.xmonad/keyboard_layout.sh")
		, ((controlMask, xK_Print), spawn "sleep 0.2; scrot `date +%s`.png -s -z -e 'mv $f ~/screenshots'") 
		, ((0, xK_Print), spawn "scrot `date +%s`.png -z -e 'mv $f ~/screenshots'") 
         ]

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaults {
	logHook =  dynamicLogWithPP $ defaultPP {
            ppOutput = System.IO.hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 70
          , ppCurrent = xmobarColor "#070707" xmobarCurrentWorkspaceColor . pad
          --, ppCurrent = xmobarColor "#070707" xmobarCurrentWorkspaceColor . wrap "<icon=/home/sleeping/.xmonad/icons/wifi.xbm/>" "<icon=/home/sleeping/.xmonad/icons/wifi.xbm/>"
          , ppVisible = xmobarColor "#070707" xmobarCurrentWorkspaceColor . wrap "║" "║"
          , ppSep = "  "
          , ppWsSep = "  "
          , ppLayout = \_ -> ""
         -- , ppHiddenNoWindows = showNamedWorkspaces
      } 
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""

