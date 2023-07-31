	https://www.autoitscript.com/forum/topic/148005-imagesearch-usage-explanation/page/4/
  	https://www.autoitscript.com/forum/applications/core/interface/file/attachment.php?id=48056


ImageSearch2015 Script

Run ImageSearch2015.au3 with Admin Rights once, add Line:

    #RequireAdmin
    
You can delete after it has run once as administrator.

Change Line ~15 from True to False:

    #Region TESTING/Example
    Local $bTesting = False; Change to TRUE to turn on testing/example

Edit Line ~66: Delete Exit 


    ...
     Else
		cr("! $result=" & $result, 1)
		cr("+" & "notepad dissapeared!")
	EndIf
	#EndRegion Test if application vanished
	cr()
	cr("!Test finished")
    EndIf
    Exit


AutoIt ImageSearch2015 is now set up and rdy to be used
