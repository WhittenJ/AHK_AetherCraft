#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

; Check the version of this script against the latest version available. If the
; latest version is greater than this version, prompt to download. If yes, then
; download the new AHK file, replace this one with the new version, and then 
; relaunch this script.

; This script can be used for any other script.  It just needs 4 things:
; 1) It needs an .ini file to read.  The file must contain the URL of the lastestversion.txt, a version number, and the location of the zip file.
;		For example,
;
;		IniLocation = %A_ScriptDir%\%A_ScriptName%.ini
;
;		IniWrite, "https://raw.githubusercontent.com/WhittenJ/AHK-AetherCraft/master/latestversion.txt", %IniLocation%, ScriptOptions, UpdateURL
;		IniWrite, "3.0.3", %IniLocation%, ScriptOptions, Version
;		IniWrite, "https://github.com/WhittenJ/AHK-AetherCraft/archive/refs/tags/", %IniLocation%, ScriptOptions, PackageURL
;
; 2) It needs a .txt file that just contains the most recent version number.
;		For example, latestversion.txt only contains "3.0.0" (without quotes).
; 3) 7-zip needs to be installed and able to be used at the command prompt.
; 4) Create a release on Github with a tag that exactly matches the version number.
;		- This is only required if you are using GitHub for your "PackageURL"

; Check if 7-zip is installed
RunWait, 7z.exe,, Hide UseErrorLevel

if (ErrorLevel = 0)
	GoSub VersionCheck
else
	{
	MsgBox, 4, Error, 7-zip not installed.  Automatic version update failed.  Do you want to disable Automatic Update?
	IfMsgBox Yes
		IniWrite, 0, %IniLocation%, ScriptOptions, AutoUpdate
	}
	
Return
	
; Main part of the script.
; Get the CurrentVersion the user is running and get the LatestVersion from the VersionURL.
; Compare the two and update if the VersionURL version is higher than the CurrentVersion.
VersionCheck:
	; Get update url and current version
	IniRead VersionURL,%IniLocation%,ScriptOptions,UpdateURL
	IniRead CurrentVersion,%IniLocation%,ScriptOptions,Version
	
	if (VersionURL = "ERROR" || CurrentVersion = "ERROR")
	{
		MsgBox, "Unable to read initialization settings. No version check performed."
	}
	
	; Get the latest version num from the server
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", VersionURL, true)
	whr.Send()
	; Using 'true' above and the call below allows the script to remain responsive.
	whr.WaitForResponse()
	
	LatestVersion := RegExReplace(SubStr(whr.ResponseText, 1, 10),"`n")
	
	if (ErrorLevel = 1 || !LatestVersion)
	{
		MsgBox, Failed to retrieve latest version number from `n%VersionURL%`nPlease check your network connection and try again.
		Return
	}
	else
	{
		match := compareVersions(LatestVersion,CurrentVersion)

		if (match != 0)
		{
			MsgBox, 52, , A newer version of %A_ScriptName% is available. Do you want to Update and Reload the script?
			IfMsgBox Yes
				GoSub Update
			else ; Version numbers match or the CurrentVersion is newer than the VersionURL version.
				Return
		}
		Return
	}
	Return

; We're here, so it must have been determined that a newer version exists.
; Download the LatestVersion.zip file, unzip it and overwrite any existing files.
Update:	
	; Download the LatestVersion zip file
	IniRead PackageURL,%IniLocation%,ScriptOptions,PackageURL
	URLDownloadToFile %PackageURL%%LatestVersion%.zip, %A_Temp%\%LatestVersion%.zip
	
	; 7z command
	CMD = e -y -o%A_ScriptDir% %A_Temp%\%LatestVersion%.zip
	
	RunWait 7z.exe %CMD%,, Hide UseErrorLevel
	
	if (ErrorLevel = 0)
	{
		Dir := StrSplit(A_ScriptDir, "\")
		Dir := Dir.Pop()
		
		; Delete the zip file and extracted folder it created.
		; Chances are these will be need to be modified if not grabbed from Github
		FileDelete %A_Temp%\%LatestVersion%.zip
		FileRemoveDir, %A_ScriptDir%\%Dir%-%LatestVersion%
		
		; Update .ini file with LatestVersion
		IniWrite, %LatestVersion%, %IniLocation%, ScriptOptions, Version
		
		; Inform the user they're all set.
		MsgBox, %A_ScriptName% has been updated.  It will now reload to the latest version.
		
		Reload
	} 
	else 
	{
		; If we got here, it means 7z has failed for some reason.
		MsgBox An error occurred during the update process. No update was performed.
		Return
	}
	Return

	
; Compare software versions
;
; Compares software versions by splitting the software version string and
; comparing each digit seperately. If the remoteVersion substring is
; larger than the localVersion substring, the match variable is incremented.
;
; A return value of 0 means the versions are equal.
;
; Return	int	number of digits that are different between the local and 
;				remote version numbers
compareVersions(remoteVersion,localVersion)
{
	remoteArray := StrSplit(remoteVersion, ".")
	localArray := StrSplit(localVersion, ".")	
	match = 0
	
	Loop % remoteArray.Length()
	{
		this_r := remoteArray[A_Index]
		this_l := localArray[A_Index]
		
		if (this_r > this_l)
			++match
	}
	
	Return match
}
