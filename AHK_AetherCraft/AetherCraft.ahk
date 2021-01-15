; Originally created by Staren Alloria.
; Improvements by Lovo'tan Khatshri.

#Persistent ; Keeps script permanently running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force ; Ensures that there is only a single instance of this script running.
#InstallKeybdHook
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Table of Contents:
; 1. Ctrl+S or Ctrl+R - Reload Script.  Only works in NotePad++
; 2. Ctrl+H - Shows the ReadMe file.
; 3. F6  - Scan Market Board.  Ensure the Hand is showing on the first item before hitting F6.
; 3. F10 - Launch Craft GUI.
; 4. F12 - Stop Any Script.

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

#If (WinActive("ahk_class Notepad++") && WinActive("ahk_exe Notepad++.exe"))
 
~^s::
^r::
; Ctrl+S OR Ctrl+R - Saves and reloads script.
TrayTip, Reloading updated script, %A_ScriptName%
SetTimer, RemoveTrayTip, 1500
Sleep, 1750
Reload
Return
 
#If

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

^!h::
; Ctrl+Alt+h - Show Help (the Readme file)
FileRead, Readme, %A_ScriptDir%\Readme.md
Gui, Add, Text,, %Readme%
Gui, Show
Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

f6::
; F12 - Market Board Scan
Gui, Add, Text,, Total Items (Blank = 100):	; Label for total items
Gui, Add, Text,, Confirm Button (Blank = Numpad0):   ; Label for the button used to confirm things in the game.
Gui, Add, Edit, vTotal ym  ; The ym option starts a new column of controls.
Gui, Add, Edit, vConfirm ; Confirm button
Gui, Add, Button, gScan, &Scan ; The function Scan will be run when the Scan button is pressed.
Gui, Show,, Macro Settings
Return

Scan:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	arg1 := "ahk_parent"
	Game := "ahk_exe ffxiv_dx11.exe"
	GameTitle := "FINAL FANTASY XIV"
	
	; Variables
	Delay = 400 ; in milliseconds, increase this number to go slower.
	Breakloop := false
	
	If !Total
		Total = 100 ; Max number of items in list.  Do not change.
	If !Confirm
		Confirm := "Numpad0" ; Default Confirm button.  Change to your keybinding if you want.
		
	; KeyBinds
	; These are the default FFXIV.  Under Keybinds -> System -> Top few keybindings
	; Either change these here or to what's listed here.  These are the arrow keys: Up, Down, Right.
	goUp := "Up" ; Move Cursor up/Cycle up through Party List
	goDown := "Down" ; Move Cursor down/Cycle down through Party List
	goRight := "Right" ; Move Cursor/Target Cursor Right
	goEsc := "Esc" ; Close All UI Components
	
	; Let user know the script is starting
	WinActivate, %GameTitle%
	Sleep, Delay
	Send, /
	Sleep, Delay * .5
	Send, echo Scanning by AHK started. <se.13> {enter}
	Sleep, Delay
	
	Loop, %Total% ; Main loop to scan Market Board
	{
	; Check for user to break
	If Breakloop
		Break
	; ControlSend, Parent of Window, {Button to Send}, Actual Window to Send to
	ControlSend, %arg1%, {%Confirm%}, %Game% ; Enter into the Item Detail
	Sleep, Delay
	If Breakloop
		Break
	ControlSend, %arg1%, {%goUp%}, %Game% ; Go up in item Window, Step 1 of 2
	Sleep, Delay
	If Breakloop
		Break		
	ControlSend, %arg1%, {%goRight%}, %Game% ; Go right in item Window, Step 2 of 2
	Sleep, Delay
	If Breakloop
		Break
	ControlSend, %arg1%, {%Confirm%}, %Game% ; Open Item History
	Sleep, Delay
	If Breakloop
		Break
	ControlSend, %arg1%, {%goEsc%}, %Game% ; Leave Item History
	Sleep, Delay
	If Breakloop
		Break
	ControlSend, %arg1%, {%goEsc%}, %Game% ; Leave Item
	Sleep, Delay
	If Breakloop
		Break
	ControlSend, %arg1%, {%goDown%}, %Game% ; Go to Next Item
	Sleep, Delay
	}
	
	; Let user know the script is finished
	WinActivate, %GameTitle%
	Sleep, Delay
	Send, /
	Sleep, Delay * .5
	If (Breakloop)
		Send, echo Scanning stopped by user. <se.11>
	Else
		Send, echo Scanning by AHK completed. <se.1>
	Send, {enter}
	
Gui, Destroy
Return

; ////////////////////////////////////////////////////////////////////////////////////////////////////////////

f10::
; f10 - Display crafting window
Gui, Add, Text,, Total Crafts:	; Label for total crafts
Gui, Add, Text,, Macro Duration(sec):	; Label for how long macro takes to run
Gui, Add, Text,, Macro button (eg, Numpad0):  ; Label for which button the crafting macro resides on
Gui, Add, Text,, Confirm Button:   ; Label for the button used to confirm things in the game.
Gui, Add, Edit, vTotal ym  ; The ym option starts a new column of controls.
Gui, Add, Edit, vTime ; Time, in seconds to craft once.
Gui, Add, Edit, vButton ; Macro button
Gui, Add, Edit, vConfirm ; Confirm button
Gui, Add, Button, gCraft, &Craft ; The function Craft will be run when the Craft button is pressed.
Gui, Show,, Macro Settings
Return

Craft:
	Gui, Submit  ; Save the input from the user to each control's associated variable.
	arg1 := "ahk_parent"
	Game := "ahk_exe ffxiv_dx11.exe"
	GameTitle := "FINAL FANTASY XIV"
	
	; Variables
	SleepTime := (Time * 1000)
	Delay = 1500 ; in milliseconds, increase this number to go slower.
	Breakloop := false
	
	If !Confirm
		Confirm := "Numpad0" ; Default Confirm button.  Change to your keybinding if you want.
	
	; Let user know the script is starting
	WinActivate, %GameTitle%
	Sleep, Delay
	Send, /
	Sleep, Delay * .5
	Send, echo Crafting by AHK started. <se.13> {enter}
	Sleep, Delay
	
	Loop, %Total%
	{
	; Check for user to break
	If Breakloop
		Break
	ControlSend, %arg1%, {%Confirm%}, %Game% ; Summon the hand
	Sleep, Delay
	ControlSend, %arg1%, {%Confirm%}, %Game% ; Select the recipe
	Sleep, Delay
	ControlSend, %arg1%, {%Confirm%}, %Game% ; Starts crafting
	Sleep, Delay*2 ; Wait for us to sit down
	
	If Breakloop
		Break
	ControlSend, %arg1%, {%Button%}, %Game% ; Hit your crafting macro button
	If Breakloop
		Break
		
	Sleep, %SleepTime% ; Wait for crafting macro to finish
	}
	
	; Let user know the script is finished
	WinActivate, %GameTitle%
	Sleep, Delay
	Send, /
	Sleep, Delay * .5
	If (Breakloop)
		Send, echo Crafting stopped by user. <se.11>
	Else
		Send, echo Crafting by AHK completed. <se.1>
	Send, {enter}
	
Gui, Destroy
Return

f12::
; Breaks crafting loop
Breakloop := true
TrayTip,, Stopping... Please wait. ,, 18
Return

; Removes any popped up tray tips.
RemoveTrayTip:
	SetTimer, RemoveTrayTip, Off 
	TrayTip 
Return 
