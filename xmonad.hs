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
--import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.DecorationMadness
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.Spiral
import XMonad.Layout.LayoutHints
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Gaps


defaults = defaultConfig {
        terminal              = "konsole"
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

xmobarCurrentWorkspaceColor = "#b0d2ff"
xmobarTitleColor = "#cc9933"

myStartupHook :: X ()

myStartupHook = spawn "feh  --bg-fill ~/.xmonad/wallpaper.jpg"

myLayoutHook = gaps [(U,16)] $ toggleLayouts (Full) $
    smartBorders $ tiled ||| Mirror tiled ||| spiral (89/144)
  where
    tiled = Tall 1 (3/100) (1/2)

myKeys = [
          ((mod4Mask, xK_Right), moveTo Next NonEmptyWS) 
        , ((mod4Mask, xK_Left), moveTo Prev NonEmptyWS)
        , ((mod4Mask, xK_Up), moveTo Next EmptyWS)
        , ((mod4Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS) 
        , ((mod4Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
	    , ((mod4Mask, xK_F9), spawn "amixer set Master 3%+")
	    , ((mod4Mask, xK_F8), spawn "amixer set Master 3%-")
	    , ((mod4Mask, xK_F3), spawn "xbacklight -inc 10")
	    , ((mod4Mask, xK_F2), spawn "xbacklight -dec 10")
        , ((mod1Mask, xK_space), spawn "bash ~/.xmonad/layout.sh")
		, ((controlMask, xK_Print), spawn "sleep 0.2; scrot `~/.xmonad/rename.sh` -s -z -e 'mv $f ~/screenshots'") 
		, ((0, xK_Print), spawn "scrot `~/.xmonad/rename.sh` -z -e 'mv $f ~/screenshots'") 
         ]

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaults {
	logHook =  dynamicLogWithPP $ defaultPP {
            ppOutput = System.IO.hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""  
          , ppSep = "  "
          , ppWsSep = "  "
          , ppLayout = \_ -> ""
         -- , ppHiddenNoWindows = showNamedWorkspaces
      } 
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""

