#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#pragma version=2.0 // last edited Scot W 03/05/2016
StrConstant kPackageName = "DemoDataAcq"
StrConstant kPackageName2 = "DemoDataAcq2"

Function autosavebut (ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked			// 1 if selected, 0 if not
	If (checked==1)
		StartautosaveBTask()
	elseif(checked==0)
		StopautosaveBTask()
	Endif
End


Function startbackbut(str):ButtonControl
	string str
	execute "StartBackgroundTask()"
End

Function stopbackbut(str):ButtonControl
	string str
	execute "StopBackgroundTask()"
End

Function StartBackgroundTask()
	Variable secondsBetweenRuns = 1
	Variable periodInTicks = 60 * secondsBetweenRuns
	Button backcontrol, win=StartGame,proc=stopbackbut,title="STOP DISPLAY", fColor=(65280,0,0)
	CtrlNamedBackground $kPackageName, proc=DataAcqTask, period=periodInTicks, start
End

Function StopBackgroundTask()
	Button backcontrol, win=StartGame,proc=startbackbut,title="START DISPLAY", fColor=(0,0,65280)
	CtrlNamedBackground $kPackageName, stop
End

Function DataAcqTask(s)				// This is the function that will be called periodically by the background task
	STRUCT WMBackgroundStruct &s
	NVAR cellvoltage, cellcurrent
	//cellvoltage=abs(enoise(2))
	//cellcurrent=abs(enoise(2))
	
	cellvoltage=getvoltage()
	cellcurrent=getcurrent()
	DoUpdate
	
	return 0	// Continue background task
End

Function StartautosaveBTask()
	Variable secondsBetweenRuns = 60
	Variable periodInTicks = 60 * secondsBetweenRuns
	CtrlNamedBackground $kPackageName2, proc=Autosavetask, period=periodInTicks, start
End

Function StopautosaveBTask()
	CtrlNamedBackground $kPackageName2, stop
End

Function Autosavetask(s)				// This is the function that will be called periodically by the background task
	STRUCT WMBackgroundStruct &s
	SaveExperiment
	return 0	// Continue background task
End