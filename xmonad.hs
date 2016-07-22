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

defaults = defaultConfig {
        terminal      = "konsole"
        , normalBorderColor  = "black"
        , focusedBorderColor  = "#b0d2ff"        
        , workspaces          = myWorkspaces
        , modMask             = mod4Mask
        , borderWidth         = 2
        , layoutHook          = myLayoutHook
        , manageHook          = myManageHook
        , handleEventHook     = fullscreenEventHook
	}`additionalKeys` myKeys

myWorkspaces :: [String]
myWorkspaces =  ["1:term","2:code","3:www","4:misc","5:vm"] ++ map show [6..9]

-- tab theme default
myTabConfig = defaultTheme {
   activeColor          = "#6666cc"
  , activeBorderColor   = "#000000"
  , inactiveColor       = "#666666"
  , inactiveBorderColor = "#000000"
  , decoHeight          = 10
 }

-- Color of current window title in xmobar.
xmobarTitleColor = "#b0d2ff"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#b0d2ff"

myLayoutHook = spacing 6 $ gaps [(U,15)] $ toggleLayouts (noBorders Full) $
  smartBorders $ (tiled ||| Mirror tiled ||| tabbed shrinkText myTabConfig)
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    delta = 3/100
    ratio = 1/2
                              
myManageHook :: ManageHook
	
myManageHook = composeAll . concat $
	[ [className =? c --> doF (W.shift "3:www")	| c <- myWeb]
	, [className =? c --> doF (W.shift "2:code")	| c <- myDev]
	, [className =? c --> doF (W.shift "1:term")	| c <- myTerm]
	, [className =? c --> doF (W.shift "5:vm")	| c <- myVMs]
	, [manageDocks]
	]
	where
	myWeb = ["Chromium"]
	myDev = ["kate","vim","sublime-text"]
	myTerm = ["konsole","xterm","tilda"]
	myVMs = ["VirtualBox"]
	
	--KP_Add KP_Subtract
myKeys = [
           ((mod4Mask, xK_Right), nextScreen) 
         , ((mod4Mask .|. controlMask, xK_Left ), prevScreen)
         , ((mod4Mask, xK_g), goToSelected defaultGSConfig)
	 , ((mod4Mask, xK_KP_Add), spawn "amixer set Master 10%+ && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
	 , ((mod4Mask, xK_KP_Subtract), spawn "amixer set Master 10%- && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe")
         ]
                   


main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar.hs"
	xmonad $ defaults {
	logHook =  dynamicLogWithPP $ defaultPP {
            ppOutput = System.IO.hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
          , ppSep = "   "
          , ppWsSep = "  "
          , ppLayout  = (\ x -> case x of
              "Spacing 6 Mosaic"                      -> "[:]"
              "Spacing 6 Mirror Tall"                 -> "[M]"
              "Spacing 6 Hinted Tabbed Simplest"      -> "[|]"
              "Spacing 6 Full"                        -> "[ ]"
              "Spacing 6 Tall"                        -> "[T]"
              _                                       -> x )
          , ppHiddenNoWindows = showNamedWorkspaces
      } 
} where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""

