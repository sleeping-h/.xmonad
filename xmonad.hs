-- Core
import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
--import IO (Handle, hPutStrLn)
import qualified System.IO
import XMonad.Actions.CycleWS (nextScreen,prevScreen)
import Data.List
 
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

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.DragPane
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.DecorationMadness
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Layout.LayoutHints

import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.FadeInactive

defaults = defaultConfig {
        terminal              = "konsole"
        , normalBorderColor   = "#333333"
        , focusedBorderColor  = "#666666"        
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , startupHook         = myStartupHook
        , layoutHook          = myLayoutHook
        , borderWidth         = 1 
        , handleEventHook     = fullscreenEventHook
	}`additionalKeys` myKeys


myWorkspaces :: [String]

myWorkspaces =  ["one","two","three","four","five"] ++ map show [6..9]

myBlue = "#b0d2ff"

-- Color of current window title in xmobar.
xmobarTitleColor = myBlue

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = myBlue

myStartupHook :: X ()

myStartupHook = spawn "feh  --bg-fill ~/.xmonad/wallpaper.jpg"

myLayoutHook = tiled ||| Mirror tiled ||| Full ||| spiral (89/144)
  where
    tiled = smartBorders $ gaps [(U,16)] $ Tall nmaster delta ratio 
    nmaster = 1
    delta = 3/100
    ratio = 1/2


myKeys = [
          ((mod4Mask, xK_Right), moveTo Next NonEmptyWS) 
        , ((mod4Mask, xK_Left), moveTo Prev NonEmptyWS)
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
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "" ""
          , ppSep = "  "
          , ppWsSep = "  "
          , ppLayout = \_ -> ""
         -- , ppHiddenNoWindows = showNamedWorkspaces
      } 
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""

