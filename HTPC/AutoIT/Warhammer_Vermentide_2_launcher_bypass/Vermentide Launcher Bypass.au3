#include <ImageSearch2015.au3>

run("C:\Program Files (x86)\Steam\steamapps\common\Warhammer Vermintide 2\launcher\Launcher.exe")
WinWait("[Class:HwndWrapper]", "", 5)

$x = 0
$y = 0
$waitTime = 2
$picture = "picture.png"

$result = _WaitForImageSearch($picture, $waitTime, 1, $x, $y, 0, 0)

if $result =1 Then
	MouseMove($x, $y, 20)
	MouseClick($MOUSE_CLICK_LEFT)
Else
	ToolTip("Error!")
	Sleep(1000)
EndIf
Exit