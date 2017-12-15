#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#IfWinActive, Diablo III
#SingleInstance force
SetDefaultMouseSpeed, 4
CoordMode, Pixel, Client
CoordMode, Mouse, Client

global ParagonPoints1 := [0, 0, 0, 0]	; -1 = infinite points, [Mainstat, Vitality, Movement, Ressource]
,ParagonPoints2 := [0, 0, 0, 0]
,ParagonPoints3 := [0, 0, 0, 0]
,D3ScreenResolution
,ScreenMode
,NativeDiabloHeight := 1440
,NativeDiabloWidth := 3440
,LowParaPause


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
	GetClientWindowInfo("Diablo III", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
	
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
	
	WinActivate, Diablo III
	WinWaitActive, Diablo III
	Send, {p}
	MouseGetPos x, y 
	First:
	PixelGetColor, ParagonMenuOpen, ParagonMenu[1], ParagonMenu[2]
	If (ParagonMenuOpen = ParagonMenu[4])
	{
		MouseClick, Left, ParagonCore[1], ParagonCore[2]
		MouseClick, Left, ParagonReset[1], ParagonReset[2]
		Sleep, 80
		ParagonClicker(MovementPoints, Movement, "Limited")
		ParagonClicker(RessourcePoints, Ressource, "Limited")
		ParagonClicker(VitalityPoints, Vitality)
		ParagonClicker(MainstatPoints, Mainstat)
		If (LowParaPause <= 2)
			Sleep, 20
		LowParaPause := 0
		MouseClick, Left, ParagonAccept[1], ParagonAccept[2]
	}
	Else 
		GoTo, First
	Send, {Space}
	MouseMove %x%, %y%
	Return
}

ParagonClicker(ByRef Points, ByRef Position, Type := "Default")
{
	If (Points != 0)
	{
		++LowParaPause 
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
			If (Points >= 50) && (Type == "Limited")
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
	GetClientWindowInfo("Diablo III", DiabloWidth, DiabloHeight, DiabloX, DiabloY)
	
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
