#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#IfWinActive, Diablo III
SetDefaultMouseSpeed, 4
CoordMode, Pixel, Client
CoordMode, Mouse, Client

global ParagonPoints1 := [-1, 0, 50, 0]	; -1 = infinite points, [Mainstat, Vitality, Movement, Ressource]
, ParagonPoints2 := [0, -1, 50, 0]
, ParagonPoints3 := [0, 0, 50, 50]
, D3ScreenResolution
, ScreenMode
	
Numpad1::
ParagonPointSpender(ParagonPoints1[1], ParagonPoints1[2], ParagonPoints1[3], ParagonPoints1[4])
Return

Numpad2::
ParagonPointSpender(ParagonPoints2[1], ParagonPoints2[2], ParagonPoints2[3], ParagonPoints2[4])
Return

Numpad3::
ParagonPointSpender(ParagonPoints3[1], ParagonPoints3[2], ParagonPoints3[3], ParagonPoints3[4])
Return

ParagonPointSpender(ByRef MainstatPoints, ByRef VitalityPoints, ByRef MovementPoints, ByRef RessourcePoints)
{
	WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
	If (D3ScreenResolution != DiabloWidth*DiabloHeight)
	{	   
		global Mainstat := [2140, 446]
		, Vitality := [2140, 570]
		, Movement := [2140, 690]
		, Ressource := [2140, 815]		
		, ParagonMenu := [2323, 1138, 0x000000]
		, ParagonReset := [1720, 980]
		, ParagonAccept := [1550, 1090]
		, ParagonCore := [1250, 140]
		
		ScreenMode := isWindowFullScreen("Diablo III")
		ConvertCoordinates(Mainstat)
		ConvertCoordinates(Vitality)
		ConvertCoordinates(Ressource)
		ConvertCoordinates(Movement)
		ConvertCoordinates(ParagonMenu)
		ConvertCoordinates(ParagonReset)
		ConvertCoordinates(ParagonAccept)
		ConvertCoordinates(ParagonCore)
	}
	
	WinActivate, Diablo III
	WinWaitActive, Diablo III
	Send, {p}
	MouseGetPos x, y 
	First:
	PixelGetColor, ParagonMenuOpen, ParagonMenu[1], ParagonMenu[2]
	If (ParagonMenuOpen = ParagonMenu[3])
	{
		MouseClick, Left, ParagonCore[1], ParagonCore[2]
		MouseClick, Left, ParagonReset[1], ParagonReset[2]
		Sleep, 150
		ParagonClicker(MovementPoints, Movement)
		ParagonClicker(RessourcePoints, Ressource)
		ParagonClicker(VitalityPoints, Vitality)
		ParagonClicker(MainstatPoints, Mainstat)
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
		If (Points = -1)
		{
			Start:
			Send, {Ctrl Down}
			MouseClick, Left, Position[1], Position[2], 40
			Send, {Ctrl Up}
			PixelSearch, , , Position[1], Position[2], Position[1], Position[2], 0x4AABE4, 10
			If (ErrorLevel = 0)
				GoTo, Start
		}
		Else
		{ 
			StringLeft, Points10, Points, 1
			StringRight, Points1, Points, 1
			Send, {Shift Down}
			MouseClick, Left, Position[1], Position[2], Points10
			Send, {Shift Up}
			MouseClick, Left, Position[1], Position[2], Points1
		}
	}
}

ConvertCoordinates(ByRef Array)
{
	WinGetPos, , , DiabloWidth, DiabloHeight, Diablo III
	D3ScreenResolution := DiabloWidth*DiabloHeight
 	
 	If (ScreenMode == false)
 	{
		DiabloWidth := DiabloWidth-16
		DiabloHeight := DiabloHeight-39
	}
	
  Array[1] := Round(Array[1]*DiabloHeight/1440+(DiabloWidth-3440*DiabloHeight/1440)/2, 0)
	Array[2] := Round(Array[2]*(DiabloHeight/1440), 0)
}

isWindowFullScreen(WinID)
{
   ;checks if the specified window is full screen
	
	winID := WinExist( winTitle )
	If ( !winID )
		Return false

	WinGet style, Style, ahk_id %WinID%
	WinGetPos ,,,winW,winH, %winTitle%
	; 0x800000 is WS_BORDER.
	; 0x20000000 is WS_MINIMIZE.
	; no border and not minimized
	Return ((style & 0x20800000) or winH < A_ScreenHeight or winW < A_ScreenWidth) ? false : true
}