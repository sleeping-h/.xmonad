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
        terminal      = "konsole"
        , normalBorderColor  = "black"
        , focusedBorderColor  = myBlue        
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , borderWidth         = 0
        , startupHook         = myStartupHook
        , logHook             = myLogHook
        , layoutHook          = myLayoutHook
        , handleEventHook     = fullscreenEventHook
	}`additionalKeys` myKeys

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 0.8

myWorkspaces :: [String]

myWorkspaces =  ["1:term","2:code","3:www","4:misc","5:vm"] ++ map show [6..9]

myBlue = "#b0d2ff"

-- Color of current window title in xmobar.
xmobarTitleColor = myBlue

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = myBlue

myStartupHook :: X ()

myStartupHook = do
    spawn "bash ~/.xmonad/startup.sh"

myLayoutHook = tiled ||| Mirror tiled ||| Full
  where
    tiled = spacing 5 $ gaps [(U,15)] $ Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2
                              
	
myKeys = [
           ((mod4Mask, xK_Right), nextScreen) 
         , ((mod4Mask .|. controlMask, xK_Left ), prevScreen)
	 , ((mod4Mask, xK_KP_Add), spawn "amixer set Master 10%+")
	 , ((mod4Mask, xK_KP_Subtract), spawn "amixer set Master 10%-")
         , ((mod1Mask, xK_space), spawn "bash ~/.xmonad/layout.sh")
         ]
                   


main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaults {
	logHook =  dynamicLogWithPP $ defaultPP {
            ppOutput = System.IO.hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
          , ppSep = "  "
          , ppWsSep = " "
          , ppLayout = \_ -> ""
          , ppHiddenNoWindows = showNamedWorkspaces
      } 
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""

