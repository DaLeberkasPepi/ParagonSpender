;========================================================================
;
; ParagonSpender v!.0.0
;
; spends Paragon with 3 possible Paragon Setups
;
; Created by DaLeberkasPepi
;   https://github.com/DaLeberkasPepi
;
; Last Update: 2018-03-03 24:00 GMT+1
;
;========================================================================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#IfWinActive, ahk_class D3 Main Window Class
#SingleInstance force
SetDefaultMouseSpeed, 4
CoordMode, Pixel, Client
CoordMode, Mouse, Client

global D3ScreenResolution
,NativeDiabloHeight := 1440
,NativeDiabloWidth := 3440
,#ctrls = 3

IfNotExist, Hotkeys.ini
	FileAppend,
(
[Settings]
[Hotkeys]
1=Numpad1
2=Numpad2
3=Numpad3
), Hotkeys.ini

Loop % #ctrls 
{
	GUI, Add, Text, xm y+10, Hotkey for #%A_Index% Paragon Setup:
	
	IniRead, savedHK%A_Index%, Hotkeys.ini, Hotkeys, %A_Index%, %A_Space%	;Check for saved hotkeys in INI file.
	
	IniRead, ParagonMain%A_Index%, Hotkeys.ini, Settings, ParagonMain%A_Index%, %A_Space%
	IniRead, ParagonVitality%A_Index%, Hotkeys.ini, Settings, ParagonVitality%A_Index%, %A_Space%
	IniRead, ParagonMovement%A_Index%, Hotkeys.ini, Settings, ParagonMovement%A_Index%, %A_Space%
	IniRead, ParagonRessource%A_Index%, Hotkeys.ini, Settings, ParagonRessource%A_Index%, %A_Space%
	
	If savedHK%A_Index%                                      				;Activate saved hotkeys if found.
		Hotkey,% savedHK%A_Index%, Label%A_Index%                			;Remove tilde (~) and Win (#) modifiers...
	
	StringReplace, noMods, savedHK%A_Index%, ~                 				;They are incompatible with hotkey controls (cannot be shown).
	StringReplace, noMods, noMods, #,,UseErrorLevel           	   			;Add hotkey controls and show saved hotkeys.
	GUI, Add, Hotkey, x+5 vHK%A_Index% gGuiLabel, %noMods%        			;Add checkboxes to allow the Windows key (#) as a modifier...
	GUI, Add, CheckBox, x+5 vCB%A_Index% Checked%ErrorLevel%, Win	|		;Check the box if Win modifier is used.
	
	GUI, Add, Text, x+5, Main:
	GUI, Add, Edit, x+5 w33 Limit4 gSubmit vParagonMain%A_Index%, % ParagonMain%A_Index%
	GUI, Add, Text, x+5, Vit:
	GUI, Add, Edit, x+5 w33 Limit4 gSubmit vParagonVitality%A_Index%, % ParagonVitality%A_Index%
	GUI, Add, Text, x+5, Mov:
	GUI, Add, Edit, x+5 w33 Limit4 Number gSubmit vParagonMovement%A_Index%, % ParagonMovement%A_Index%
	GUI, Add, Text, x+5, Res:
	GUI, Add, Edit, x+5 w33 Limit4 Number gSubmit vParagonRessource%A_Index%, % ParagonRessource%A_Index%
} 
Return

~F1::
	GUI, Show , ,ParagonSpender v1.0.0 Hotkeys
Return

GuiClose:
	GUI, Hide
	IfWinExist, ahk_class D3 Main Window Class
		WinActivate, ahk_class D3 Main Window Class
Return

Submit:
	Loop % #ctrls 
	{
		GUIControlGet, ParagonMain%A_Index%
		GUIControlGet, ParagonVitality%A_Index%
		GUIControlGet, ParagonMovement%A_Index%
		GUIControlGet, ParagonRessource%A_Index%
		
		IniWrite, % ParagonMain%A_Index%, Hotkeys.ini, Settings, ParagonMain%A_Index%
		IniWrite, % ParagonVitality%A_Index%, Hotkeys.ini, Settings, ParagonVitality%A_Index%
		IniWrite, % ParagonMovement%A_Index%, Hotkeys.ini, Settings, ParagonMovement%A_Index%
		IniWrite, % ParagonRessource%A_Index%, Hotkeys.ini, Settings, ParagonRessource%A_Index%
	}
Return

~ESC::Reload
Return


Label1:		;Hotkey for #1 Paragon Setup
	IfWinNotActive, ParagonSpender Hotkeys
	{
		ParagonPointSpender(ParagonMain1, ParagonVitality1, ParagonMovement1, ParagonRessource1)
	}
Return

Label2:		;Hotkey for #2 Paragon Setup
	IfWinNotActive, ParagonSpender Hotkeys
	{
		ParagonPointSpender(ParagonMain2, ParagonVitality2, ParagonMovement2, ParagonRessource2)
	}
Return

Label3:		;Hotkey for #3 Paragon Setup
	IfWinNotActive, ParagonSpender Hotkeys
	{
		ParagonPointSpender(ParagonMain3, ParagonVitality3, ParagonMovement3, ParagonRessource3)
	}
Return

ParagonPointSpender(ByRef MainstatPoints, ByRef VitalityPoints, ByRef MovementPoints, ByRef RessourcePoints)
{
	StartTime := A_TickCount
	
	GetClientWindowInfo("ahk_class D3 Main Window Class", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
	
	If (D3ScreenResolution != DiabloWidth*DiabloHeight)
	{
		global Mainstat := [2140, 446, 1]
		, Vitality := [2140, 570, 1]
		, Movement := [2140, 690, 1]
		, Ressource := [2140, 815, 1]
		, ParagonMenu := [2323, 1138, 1, 0x000000]
		, ParagonReset := [1720, 980, 1]
		, ParagonAccept := [1550, 1090, 1]
		, ParagonCore := [1250, 140, 1]
		
		ConvertCoordinates(Mainstat)
		ConvertCoordinates(Vitality)
		ConvertCoordinates(Ressource)
		ConvertCoordinates(Movement)
		ConvertCoordinates(ParagonMenu)
		ConvertCoordinates(ParagonReset)
		ConvertCoordinates(ParagonAccept)
		ConvertCoordinates(ParagonCore)
	}
	
	WinActivate, ahk_class D3 Main Window Class
	WinWaitActive, ahk_class D3 Main Window Class
	Send, {p}
	MouseGetPos x, y 
	First:
	PixelGetColor, ParagonMenuOpen, ParagonMenu[1], ParagonMenu[2]
	If (ParagonMenuOpen = ParagonMenu[4])
	{
		MouseClick, Left, ParagonCore[1], ParagonCore[2]
		MouseClick, Left, ParagonReset[1], ParagonReset[2]
		Sleep, 80
		ParagonClicker(MovementPoints, Movement)
		ParagonClicker(RessourcePoints, Ressource)
		
		If (MainstatPoints > VitalityPoints)
		{
			ParagonClicker(MainstatPoints, Mainstat)
			ParagonClicker(VitalityPoints, Vitality)
		}
		
		Else
		{
			ParagonClicker(VitalityPoints, Vitality)
			ParagonClicker(MainstatPoints, Mainstat)
		}
		
		TimeBuffer := 400 - (A_TickCount - StartTime)
		If (TimeBuffer > 0)
			Sleep % TimeBuffer
		
		MouseClick, Left, ParagonAccept[1], ParagonAccept[2]
	}
	Else 
		GoTo, First
	Send, {Space}
	MouseMove %x%, %y%
	Return
}

ParagonClicker(ByRef Points, ByRef Position)
{
	If (Points != 0)
	{ 
		If (Points == -1)
		{
			Start:
			Send, {Ctrl Down}
			MouseClick, Left, Position[1], Position[2], 50
			Send, {Ctrl Up}
			PixelSearch, , , Position[1], Position[2], Position[1], Position[2], 0x4AABE4, 10
			If (ErrorLevel = 0)
				GoTo, Start
		}			
		Else
		{
			If (Points >= 50)
			{
				Send, {Ctrl Down}
				MouseClick, Left, Position[1], Position[2]
				Send, {Ctrl Up}
			}
 			Points100 := Floor(Points/100)
			Points10 := Floor((Points-Points100*100)/10)
			Points1 := Floor(Points-Points100*100-Points10*10)
			If (Points100 >= 1)
			{
				Send, {Ctrl Down}
				MouseClick, Left, Position[1], Position[2], Points100
				Send, {Ctrl Up}
			}
			If (Points10 >= 1)
			{
				Send, {Shift Down}
				MouseClick, Left, Position[1], Position[2], Points10
				Send, {Shift Up}
			}
			MouseClick, Left, Position[1], Position[2], Points1
		}
	}
}

ConvertCoordinates(ByRef Array)
{
	GetClientWindowInfo("ahk_class D3 Main Window Class", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
	
	D3ScreenResolution := DiabloWidth*DiabloHeight
	
	Position := Array[3]

	;Pixel is always relative to the middle of the Diablo III window
	If (Position == 1)
  	Array[1] := Round(Array[1]*DiabloHeight/NativeDiabloHeight+(DiabloWidth-NativeDiabloWidth*DiabloHeight/NativeDiabloHeight)/2, 0)

	;Pixel is always relative to the left side of the Diablo III window or just relative to the Diablo III windowheight
	If Else (Position == 2 || Position == 4)
		Array[1] := Round(Array[1]*(DiabloHeight/NativeDiabloHeight), 0)

	;Pixel is always relative to the right side of the Diablo III window
	If Else (Position == 3)
		Array[1] := Round(DiabloWidth-(NativeDiabloWidth-Array[1])*DiabloHeight/NativeDiabloHeight, 0)

	Array[2] := Round(Array[2]*(DiabloHeight/NativeDiabloHeight), 0)
}

GetClientWindowInfo(ClientWindow, ByRef ClientWidth, ByRef ClientHeight, ByRef ClientX, ByRef ClientY)
{
	hwnd := WinExist(ClientWindow)
	VarSetCapacity(rc, 16)
	DllCall("GetClientRect", "uint", hwnd, "uint", &rc)
	ClientWidth := NumGet(rc, 8, "int")
	ClientHeight := NumGet(rc, 12, "int")

	WinGetPos, WindowX, WindowY, WindowWidth, WindowHeight, %ClientWindow%
	ClientX := Floor(WindowX + (WindowWidth - ClientWidth) / 2)
	ClientY := Floor(WindowY + (WindowHeight - ClientHeight - (WindowWidth - ClientWidth) / 2))
}

GuiLabel:
	If %A_GuiControl% in +,^,!,+^,+!,^!,+^!    ;If the hotkey contains only modifiers, return to wait for a key.
		return
	If InStr(%A_GuiControl%,"vk07")            ;vk07 = MenuMaskKey (see below)
		GuiControl,,%A_GuiControl%, % lastHK      ;Reshow the hotkey, because MenuMaskKey clears it.
	Else
		validateHK(A_GuiControl)
return

validateHK(GuiControl) 
{
	global lastHK
	Gui, Submit, NoHide
	lastHK := %GuiControl%                     ;Backup the hotkey, in case it needs to be reshown.
	num := SubStr(GuiControl,3)                ;Get the index number of the hotkey control.
	If (HK%num% != "") 						   ;If the hotkey is not blank...
	{                       
		StringReplace, HK%num%, HK%num%, SC15D, AppsKey      ;Use friendlier names,
		StringReplace, HK%num%, HK%num%, SC154, PrintScreen  ;  instead of these scan codes.
		If CB%num%                                ;  If the 'Win' box is checked, then add its modifier (#).
			HK%num% := "#" HK%num%
		If !RegExMatch(HK%num%,"[#!\^\+]")        ;  If the new hotkey has no modifiers, add the (~) modifier.
			HK%num% := "~" HK%num%                   ;    This prevents any key from being blocked.
		checkDuplicateHK(num)
	}
	If (savedHK%num% || HK%num%)               ;Unless both are empty,
		setHK(num, savedHK%num%, HK%num%)         ;  update INI/GUI
}

checkDuplicateHK(num)
{
	global #ctrls
	Loop,% #ctrls
	If (HK%num% = savedHK%A_Index%) 
	{
		dup := A_Index
		Loop,6 
		{
			GuiControl,% "Disable" b:=!b, HK%dup%   ;Flash the original hotkey to alert the user.
			Sleep,200
		}
		GuiControl,,HK%num%,% HK%num% :=""       ;Delete the hotkey and clear the control.
		break
	}
}

setHK(num,INI,GUI) 
{
	If INI                           ;If previous hotkey exists,
		Hotkey, %INI%, Label%num%, Off  ;  disable it.
	If GUI                           ;If new hotkey exists,
		Hotkey, %GUI%, Label%num%, On   ;  enable it.
	IniWrite,% GUI ? GUI:null, Hotkeys.ini, Hotkeys, %num%
	savedHK%num%  := HK%num%
}

#MenuMaskKey vk07                 ;Requires AHK_L 38+
#If ctrl := HotkeyCtrlHasFocus()
	*AppsKey::                       ;Add support for these special keys,
	*BackSpace::                     ;  which the hotkey control does not normally allow.
	*Delete::
	*Enter::
	*Escape::
	*Pause::
	*PrintScreen::
	*Space::
	*Tab::
	modifier := ""
	If GetKeyState("Shift","P")
		modifier .= "+"
	If GetKeyState("Ctrl","P")
		modifier .= "^"
	If GetKeyState("Alt","P")
		modifier .= "!"
	Gui, Submit, NoHide             ;If BackSpace is the first key press, Gui has never been submitted.
	If (A_ThisHotkey == "*BackSpace" && %ctrl% && !modifier)   ;If the control has text but no modifiers held,
		GuiControl,,%ctrl%                                       ;  allow BackSpace to clear that text.
	Else                                                     ;Otherwise,
		GuiControl,,%ctrl%, % modifier SubStr(A_ThisHotkey,2)  ;  show the hotkey.
	validateHK(ctrl)
	return
#If

HotkeyCtrlHasFocus() 
{
	GuiControlGet, ctrl, Focus       ;ClassNN
	If InStr(ctrl,"hotkey") 
	{
		GuiControlGet, ctrl, FocusV     ;Associated variable
	Return, ctrl
	}
}