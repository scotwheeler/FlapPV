#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#pragma version=3.0 // last edited Scot W 03/05/2016
#include <NIDAQmxWaveScanProcs>
#include <NIDAQmxWaveFormGenProcs>
#include <NIDAQmxPulseTrainGenerator>

////////// Windows //////////

Window StartGame() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(307,80,1343,495) as "StartGame"
	ModifyPanel cbRGB=(65534,65534,65534)
	SetDrawLayer UserBack
	SetDrawEnv fillpat= 0
	DrawRect 10,9,585,405
	SetDrawEnv fillfgc= (32768,54528,65280)
	SetDrawEnv save
	SetDrawEnv fsize= 16
	DrawText 390,93,"Highscores"
	SetDrawEnv fsize= 20
	DrawText 81,50,"Durrant Group"
	SetDrawEnv fsize= 18
	DrawText 113,86,"Flap PV"
	DrawText 18,393,"Created by Scot Wheeler"
	SetDrawEnv fsize= 18
	DrawText 364,54,"@durrant_group"
	SetDrawEnv fillpat= 0,fillfgc= (65535,65535,65535)
	DrawRect 594,10,918,162
	Button button0,pos={69,242},size={150,100},proc=startgameBut,title="START GAME"
	Button button0,font="Arial",fSize=18,fColor=(0,0,52224)
	Slider slider1,pos={44,158},size={200,56},font="Arial"
	Slider slider1,limits={1,3,1},variable= root:flappyvolt:difficulty_var,vert= 0,thumbColor= (0,0,39168)
	Slider slider1,userTicks={:flappyvolt:difficulty,:flappyvolt:difficultystr}
	ListBox highscore_names,pos={315,100},size={115,200},font="Arial"
	ListBox highscore_names,listWave=root:flappyvolt:highscore_names
	ListBox highscore_names_1,pos={440,100},size={83,198},font="Arial"
	ListBox highscore_names_1,listWave=root:flappyvolt:highscore_scores
	Button clearhigh,pos={373,312},size={120,30},proc=clearhighscores,title="Clear highscores"
	Button clearhigh,font="Arial",fColor=(0,0,52224)
	ValDisplay valdisp0,pos={198,378},size={130,16},title="Times Played :"
	ValDisplay valdisp0,font="Arial",frame=0,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdisp0,value= #"root:flappyvolt:timesplayed"
	PopupMenu levelsel,pos={99,114},size={90,21},bodyWidth=50,title="LEVEL"
	PopupMenu levelsel,font="Arial"
	PopupMenu levelsel,mode=1,popvalue="1",value= #"root:flappyvolt:levelsstr"
	Button newlevel,pos={373,351},size={120,22},proc=createlevel,title="Create New Level"
	Button newlevel,font="Arial",fSize=10,fColor=(0,0,52224)
	Button newlevel1,pos={373,378},size={120,22},proc=editlevelpanbut,title="Edit Level"
	Button newlevel1,font="Arial",fSize=10,fColor=(0,0,52224)
	ValDisplay valdisp1,pos={606,90},size={300,19},title="Voltage:",font="Arial"
	ValDisplay valdisp1,fSize=16,format="%0.2f V",frame=0
	ValDisplay valdisp1,limits={0,3,0},barmisc={0,70},mode= 3,highColor= (10496,60672,1792),lowColor= (65280,0,0)
	ValDisplay valdisp1,value= #"root:flappyvolt:cellvoltage"
	ValDisplay valdisp1,barBackColor= (65535,65535,65535)
	Button backcontrol,pos={696,23},size={120,40},proc=startbackbut,title="START DISPLAY"
	Button backcontrol,font="Arial",fSize=14,fColor=(0,0,65280)
	ValDisplay valdisp2,pos={606,125},size={300,19},title="Current:",font="Arial"
	ValDisplay valdisp2,fSize=16,format="%0.2f mA",frame=0
	ValDisplay valdisp2,limits={0,1,0},barmisc={0,70},mode= 3,highColor= (10496,60672,1792),lowColor= (65280,0,0)
	ValDisplay valdisp2,value= #"root:flappyvolt:cellcurrent"
	ValDisplay valdisp2,barBackColor= (65535,65535,65535)
	Button resetbut,pos={496,378},size={80,20},proc=reset,title="RESET"
	Button resetbut,help={"Resets start panel only"},font="Arial",fSize=12
	Button resetbut,fColor=(65280,0,0)
	CheckBox autosave,pos={500,351},size={72,15},proc=autosavebut,title="Auto Save"
	CheckBox autosave,font="Arial",value= 0
	ToolsGrid snap=1
EndMacro


Window FlapPVhand() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(375,141,665,346) as "FlapPV"
	ModifyPanel cbRGB=(65534,65534,65534)
	SetDrawLayer UserBack
	SetDrawEnv fsize= 18
	DrawText 118,65,"SETUP"
	SetDrawEnv fsize= 16
	DrawText 60,95,"Place hand over solar cell"
	ValDisplay valdisp0,pos={136,120},size={50,25},font="Arial",fSize=20,frame=0
	ValDisplay valdisp0,fStyle=1,limits={0,0,0},barmisc={0,1000}
	ValDisplay valdisp0,value= #"root:flappyvolt:setuptime"
EndMacro

Window updatelevel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel/K=1 /W=(1053,93,1365,336) as "updatelevel"
	PopupMenu levelsel,pos={45,24},size={90,21},bodyWidth=50,title="LEVEL"
	PopupMenu levelsel,font="Arial"
	PopupMenu levelsel,mode=2,popvalue="2",value= #"root:flappyvolt:levelsstr"
	PopupMenu levelsel1,pos={45,52},size={129,21},bodyWidth=89,title="LEVEL"
	PopupMenu levelsel1,font="Arial"
	PopupMenu levelsel1,mode=2,popvalue="Bottom",value= #"\"Top;Bottom\""
	SetVariable setvar0,pos={46,87},size={89,16},bodyWidth=50,title="Edit left"
	SetVariable setvar0,format="%1.2f s"
	SetVariable setvar0,limits={0,60,1},value= root:flappyvolt:editleft
	SetVariable setvar1,pos={40,133},size={95,16},bodyWidth=50,title="Edit right"
	SetVariable setvar1,format="%1.2f s"
	SetVariable setvar1,limits={0,60,1},value= root:flappyvolt:editright
	SetVariable setvar2,pos={155,87},size={121,16},bodyWidth=50,title="Magnitude left"
	SetVariable setvar2,format="%1.2f"
	SetVariable setvar2,limits={-20,20,1},value= root:flappyvolt:editleftmag
	SetVariable setvar3,pos={149,136},size={127,16},bodyWidth=50,title="Magnitude right"
	SetVariable setvar3,format="%1.2f"
	SetVariable setvar3,limits={-20,20,1},value= root:flappyvolt:editrightmag
	Button editlevbut,pos={127,176},size={80,30},proc=editlevel,title="Update"
	Button editlevbut,font="Arial"
EndMacro


////////// Button Controls //////////
Function reset(str):ButtonControl //just resets the window after an abort
	string str
	variable i=0
	DoWindow/F StartGame
	if (V_Flag==1)
		Killwindow StartGame
	endif
	do
		DoWindow/F $("StartGame"+num2str(i))
		if (V_Flag==1)
			Killwindow $("StartGame"+num2str(i))
		endif
		
	while(V_Flag==1)

	execute "StartGame()"
End


Function startgameBut(str):ButtonControl
	string str
	variable level
	controlinfo/W=StartGame levelsel
	level=V_Value 
	string execstr="playgame("+num2str(level)+")"
	execute/Q execstr
End

Function editlevelpanbut(str):ButtonControl
	string str
	string password="Durrant"
	string userpassword
	Prompt userpassword, "Enter Password"
	DoPrompt "New Level", userpassword
	if (cmpstr(userpassword, password)==0)
		DoWindow/F updatelevel
		if(V_Flag==0)
			execute "updatelevel()"
		endif
	else
		abort "Password incorrect"
	endif
	
End

Function editlevel(str):ButtonControl
	string str
	NVAR editleft
	NVAR editright
	NVAR editleftmag
	NVAR editrightmag
	variable level
	controlinfo/W=updatelevel levelsel
	level=V_Value 
	string wavenam="level"+num2str(level)
	controlinfo/W=updatelevel levelsel1
	if (V_Value==1)
		wavenam+="T"
	endif
	wave wav=$(wavenam)
	
	wav[x2pnt(wav,editleft),x2pnt(wav,editright)]=((editrightmag-editleftmag)/(editright-editleft))*(pnt2x(wav,p)-editleft)+editleftmag
	
End

Function clearhighscores(str):ButtonControl
	string str
	string password="Durrant"
	string userpassword
	Prompt userpassword, "Enter Password"
	DoPrompt "Clear Variables", userpassword
	if (cmpstr(userpassword, password)==0)
		wave/T highscore_names=highscore_names
		wave/T highscore_scores=highscore_scores
		wave highscore_times=highscore_times
		highscore_names=""
		highscore_scores=""
		highscore_times=0
	else
		abort "Password incorrect"
	endif

End

Function createlevel(str):ButtonControl
	string str
	variable newlevelnum
	string wavenam
	string password="Durrant"
	string userpassword
	Prompt userpassword, "Enter Password"
	DoPrompt "New Level", userpassword
	if (cmpstr(userpassword, password)==0)
		do
			newlevelnum+=1
			wavenam="level"+num2str(newlevelnum)
		while(waveexists($(wavenam)))
		string wavenamT=wavenam+"T"
		Make/O/N=60001 $(wavenam), $(wavenamT)
		wave wav=$(wavenam)
		wave wavT=$(wavenamT)
		setscale/I x, 0, 60, wav, wavT
	else
		abort "Password incorrect"
	endif
	
End

////////// Game functions //////////

function getaxislim(timenow, totaltimes, axmax)
	variable timenow, totaltimes, &axmax
	variable axmin
	NVAR difficulty=difficulty_var
	axmin=timenow-(5/(difficulty^1.5))
	
	
	axmax=timenow+(5/(difficulty^1.5))
	
	if (axmin<0)
		axmin=0
	endif
	if (axmax>totaltimes)
		axmax=totaltimes
	endif
	
	return axmin
end

function gettime(starttime)
	variable starttime //in ticks
	variable timenow
	timenow=(ticks-starttime)/60 //in seconds
	return timenow
end

function getvoltage()
	variable volt, i
	volt=0
	for(i=0;i<4;i+=1)
	//volt+=5
		volt+=fDAQmx_readChan("Dev1",0, -2,2, 1) 
	endfor
	volt/=4
	volt=abs(volt)
return volt
end

function getcurrent()
	variable volt, current, i
	variable Rmeas=10
	volt=0
	for(i=0;i<4;i+=1)
	
		volt+=(fDAQmx_readChan("Dev1",3, -1,1, 0))
	endfor
	volt/=4
	current=(abs(volt)/Rmeas)*1000
return current
end

function setupgame()
	NVAR Vmin=Vmin
	NVAR Vmax=Vmax
	NVAR setuptime=setuptime
	variable test
	string buttonstr
	Vmin=0
	Vmax=0
	setuptime=3
	do
		Vmax+=getvoltage()
		sleep/S 1
		setuptime-=1
		doupdate	
	while(setuptime>0)
	Vmax/=3
	
//	DoWindow/K FlapPVhand

//	execute "FlapPVhand()"
//	DoWindow/F StartGame
//	SetDrawLayer UserBack
//	SetDrawEnv fsize= 16
//	DrawText 150,375,"Place hand over solar cell"
//	ValDisplay setuptime,pos={150,385},size={50,25},font="Arial",fSize=20,frame=0
//	ValDisplay setuptime,fStyle=1,limits={0,0,0},barmisc={0,1000}
//	ValDisplay setuptime,value= #"root:flappyvolt:setuptime"

	setuptime=3
	
	Button button0, win=StartGame, title="Place Hand \r Over \r Solar Cell", fColor=(0,52224,0)
	DoUpdate
	
	do
		test=getvoltage()
		sleep/S 0.5
	while (test>=(Vmax-(Vmax*0.1)))
	
	buttonstr="Get Ready...\r"+num2str(setuptime)
	Button button0, win=StartGame, title=buttonstr, fColor=(0,52224,0)
	
	do
		Vmin+=getvoltage()
		sleep/S 1
		setuptime-=1
		buttonstr="Get Ready...\r"+num2str(setuptime)
		Button button0, win=StartGame, title=buttonstr, fColor=(0,52224,0)
		doupdate		
	while(setuptime>0)
	DoWindow/K FlapPVhand
	Vmin/=3
	Vmax-=Vmin
	
end


Function setupgraph(level,levelT)
wave level, levelT
wave player=player
wave timewav=timewav
wave ten=ten
variable axmin, axmax
axmin=getaxislim(0, 60, axmax)
// setup the game window
	DoWindow/K flappysolar
	Display/K=1/N=flappysolar
	PauseUpdate 
	Appendtograph/W=flappysolar/C=(0,0,0) level/TN=level
	Appendtograph/W=flappysolar/C=(0,0,0) levelT/TN=levelT
	Appendtograph/W=flappysolar/C=(0,0,0) ten/TN=ten
	Appendtograph/W=flappysolar/C=(0,0,65280) player vs timewav 
	ModifyGraph mode(player)=3,marker(player)=60,msize(player)=8
	ModifyGraph mode(level)=7,hbFill(level)=58
	ModifyGraph mode(levelT)=7, toMode(levelT)=1,hbFill(levelT)=58
	ModifyGraph standoff=0
	SetAxis bottom axmin, axmax
	Setaxis left 0, 10
	ModifyGraph tick=3
	ModifyGraph  noLabel=1
	Label left "Solar Cell Voltage"
	ResumeUpdate
	movewindow 2,2,2,2
End

Function updatehighscore(timenow, level)
	variable timenow, level
	variable score
	string newname
	wave highscore_times=highscore_times
	wave/T highscore_scores=highscore_scores
	wave/T highscore_names=highscore_names
	NVAR difficulty=difficulty_var
	score=round(10*(timenow*difficulty*level))/10
	
	if (score>highscore_times[9])// check if it's in the top 10?
		Prompt newname, "Congratulations you got a high score! Enter name"
		DoPrompt "NewHighScore", newname
		If (V_Flag==1)
			return 1
		endif
		highscore_times[9]=score //update the bottom place as new time
		highscore_scores[]=num2str(highscore_times[p])
		
		highscore_names[9]=newname
		sort/R highscore_times, highscore_times, highscore_scores, highscore_names 
	else
		print "This was not a high score"
	endif
	
	return 1
	
End

/////////// Main game ///////////

function playgame(level)
	variable level
	setdatafolder root:flappyvolt // just in case the folder has been changed
	StopBackgroundTask()
	variable starttime, totaltimet, totaltimes, len, axmin, axmax, timenow, returned
	NVAR Vmin=Vmin
	NVAR Vmax=Vmax
	NVAR timesplayed=timesplayed
	string levelstr="level"+num2str(level)
	string levelstrT="level"+num2str(level)+"T"
	wave levelwaveT=$levelstrT
	wave levelwave=$levelstr
	wave player=player
	wave timewav=timewav
	setupgame()
	setupgraph(levelwave, levelwaveT)
	
	// get the time of the level
	wavestats/Q levelwave
	len=V_npnts 
	totaltimes=pnt2x(levelwave, (len-1)) //in seconds
	print "Level time: "+num2str(totaltimes)+"s"
	totaltimet=totaltimes*60 // in ticks
	sleep/S 1
	
	// start
	starttime=ticks //in ticks
	do //the game
		player[0]=(((getvoltage()-Vmin)/Vmax)*10)
		timenow=gettime(starttime)
		axmin=getaxislim(timenow, totaltimes, axmax)
		timewav=timenow
		SetAxis bottom axmin,axmax
		DoUpdate
		if (player[0]<levelwave(timenow) || player[0]>levelwaveT(timenow))
			TextBox/C/N=text0/F=0/A=MC "\\Z16GAME OVER"
			DoUpdate
			returned=updatehighscore(timenow, level)
			break
		endif
	
	while((timenow)<(totaltimes-0.1))
	
	if (returned==0)
		TextBox/C/N=text0/F=0/A=MC "\\Z16LEVEL COMPLETE"
		DoUpdate
		returned=updatehighscore(60, level)
	endif
	timesplayed+=1
	print "Goodbye"
	killwindow flappysolar
	Button button0, win=StartGame, title="START GAME", fColor=(0,0,52224)
	StartBackgroundTask()
//	killwindow StartGame
//	execute "StartGame()"
//	MoveWindow 2,2,2,2
end
