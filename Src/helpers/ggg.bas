B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/Jakebullet
#Region VERSIONS 
' V. 1.0 	June/7/2022
#End Region
'Static code module

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Private xui As XUI
'	
'	Public oMQTTparser As clsMQTTsuport
'	Public pictureFont As Typeface
	
	Public isInitalized As Boolean = False
	
	Public bIsInetConected As Boolean = False
'	Dim bIsInetConectedOld As Boolean = False
	
'	Public  oMySQL As clsMySQL
'	Public picsFromExternalMedia As Boolean = False
'	
'	Public currScreenBeforeScrnSaver As Int
'	
'	Public oSSocket As ServerSocket
'	
'	Public debugMode As Boolean
'	Public phw As PhoneWakeState
'	Public ph As Phone
	'
'	Private startTime As Long
'	Public oSQL As SQL
'	'Public oSMTP As SMTP
'	
'	'Private mp As MediaPlayer
'	
'	'--- font size crap
'	Private su As StringUtils
'	
'	Private m_oWifiLock As Object
'	
'	'--- log types
	Dim ID_LOG_ERR, ID_LOG_WARNING, ID_LOG_MSG As Int
	ID_LOG_ERR = 0 : ID_LOG_WARNING = 1 : ID_LOG_MSG = 2
'	
'	Public Locale As AHLocale
'	
'	Private currentUser As clsUserRecord
	Public WeatherData As clsWeatherData
	Public OnConnectedEventWeather As clsEvent
	Public OnDisconnectedEventWeather As clsEvent
'	Public OnSelectedUserChanged As clsEvent
'	Public oGenericEvents As clsGenericEvents
'	Public oInetEvents As clsEvent
'	
'	Public ehome_clrTheme As String 
'	Public oSQL_Settings As SQL
	'
'	
'	Type User (id As Int, email As String, fname As String, lname As String, phone As String, age As Int, color As Int, role As String, emg_contact As String, chores As Boolean, profimg_path As String, shopping As Boolean)
End Sub



'
'
'#Region INTERNAL
'
'
'
'Public Sub getIP() As String
'	Dim server As ServerSocket 'ignore 
'	Return server.GetMyWifiIP'ignore
'End Sub
'
'public Sub ReReadInternalPics
'	Dim filesInMedia As ReadFilesInDir
'	 Dim fTypes As List : fTypes.Initialize
'	 fTypes.Add("png") : fTypes.Add("jpg")  
'	 filesInMedia.Initialize(c.SHARED0PATH ,"pictures",fTypes)
'End Sub
'
'
'Public Sub Initialize()
'
'
'	Dim oDbUpdater As DbUpdater : oDbUpdater.Initialize	
'	Dim isFirstRun As Boolean = oDbUpdater.go
'	
'	'c.CLR_TXT_BRIGHT = LoadColor("holo_blue_dark")
'	
'	OnConnectedEventWeather.Initialize
'	OnDisconnectedEventWeather.Initialize
'	OnSelectedUserChanged.Initialize
'	oGenericEvents.Initialize
'	currentUser.Initialize
'	oInetEvents.Initialize
'	
'	'--- color theme
'	ehome_clrTheme = INIRead2(c.INI_CONST_SETUP_COLORS,"Theme_color","FC")
'	
'	'--- who am I?
'	c.familyID = INIRead(c.INI_CONST_MAIN,"FAMILY_EH_ID")
'	c.DEVICE0ID = INIRead(c.INI_CONST_MAIN,"DEVICE0ID")
'	debugLog3(c.familyID)
'	debugLog3(c.DEVICE0ID)
'	
'	startTime = DateTime.Now
'	c.GetAllGlobalVars
'	Locale.Initialize
'
'	
'	'--- wifi wake lock (creates object - use AcquireLockWifi / ReleaseLockWifi to invoke)
'	Dim R As Reflector
'	R.Target = R.GetContext
'	R.Target = R.RunMethod2("getSystemService", "wifi", "java.lang.String")
'	m_oWifiLock = R.RunMethod4("createWifiLock", Array As Object(1, "locktag"), _
'	 						Array As String("java.lang.int", "java.lang.String"))
'
'	ProcessSecretInfo
'	
'	'oMySQL.Initialize()
'	If isFirstRun Then
'		
'		ReReadInternalPics
'		
'	End If
'	
'	If c.isMQTTon Then
'		CallSubDelayed(Starter,"Start_MQTT")
'	End If
'	
'	isInitalized = True
'
'	oDbUpdater.CreateHaTableIfNeeded
'
'End Sub
'
'#End Region
'
'
'
'
'Public Sub StrikeThroughCreate(str As String) As RichString
'	Dim rStr As RichString 
'	rStr.Initialize(str) 
'	rStr.StrikeThrough(0,rStr.Length)
'	rStr.Color(Colors.LightGray,0,rStr.Length)
'	Return rStr
'End Sub
'
'Public Sub StrikeThroughRemove(str As String) As RichString
'	Dim rStr As RichString 
'	rStr.Initialize(str) 
'	'rStr.StrikeThrough(0,rStr.Length)
'	'rStr.Color(Colors.LightGray,0,rStr.Length)
'	Return rStr
'End Sub
'
'
'
'#Region DEBUG_MODE
'Public Sub debugModeSet() As Boolean
'  debugMode = IsDebuggerAttatch
'  Return debugMode
'End Sub
Public Sub debugLog(s As String)
	#If Debug
	Log(s)
	#End If
End Sub
''--- logs in color
'Public Sub debugLog2(s As String)
'	#If Debug
'	debugLogColor(s,Colors.Green)
'	#End If
'End Sub
'Public Sub debugLogColor(s As String, color As Int)
'	#If Debug
'	LogColor(s,color)
'	#End If
'End Sub
'Public Sub IsDebuggerAttatch() As Boolean
'	Dim R As Reflector
'  	Return( R.GetStaticField("anywheresoftware.b4a.BA", "debugMode") )
'End Sub
'Public Sub debugToast(msg As String, longDuration As Boolean)
'	#If Debug
'    ToastMessageShowX(msg,longDuration)
'	#End If
'End Sub
'
'
'public Sub DebugLogSuccess(s As String)
'	#If Debug
'	debugLogColor("***************",Colors.Green)
'	debugLogColor(s,Colors.Green)
'	debugLogColor("***************",Colors.Green)
'	#End If
'End Sub
'
'public Sub DebugLogFailure(s As String)
'	#If Debug
'	debugLogColor("***************",Colors.red)
'	debugLogColor(s,Colors.Red)
'	debugLogColor("***************",Colors.red)
'	#End If
'End Sub
'
'
''---
''--- Logs in color and with ************
''---
'Public Sub debugLog3(s As String)
'	#If Debug
'	debugLogColor("***************",Colors.Green)
'	debugLogColor(s,Colors.Green)
'	debugLogColor("***************",Colors.Green)
'	#End If
'End Sub
'#End Region
'
'
'
'
''Public Sub GetTargetDir() As String
''
''	Return c.SHARED0PATH
'''	Dim targetDir As String
'''    If File.ExternalWritable Then 
'''		targetDir = File.DirDefaultExternal 
'''	Else 
'''		targetDir = File.DirInternal
'''	End If
'''	Return targetDir
''End Sub
'
'
'
'#Region GET_RELEASE_WI_FI_LOCKS
''---
''---
''---
'Public Sub AcquireLockWifi
'   Dim R As Reflector
'   R.Target = m_oWifiLock
'   R.RunMethod("acquire")
'End Sub
'
'
''---
''---
''---
'Public Sub ReleaseLockWifi
'	Try
'		Dim R As Reflector
'	   R.Target = m_oWifiLock
'	   R.RunMethod("release")	
'	Catch
'		LogException3(LastException,True,"ReleaseLockWifi")
'	End Try
'   
'End Sub
'
'#End Region
'
'
'#Region INI
'Public Sub INIRead2(section As String, key As String,defualt As String) As String
'	Dim ret As String = INIRead(section,key)
'	If ret.Length = 0 Or ret = Null Then ret = defualt
'	Return ret
'End Sub
'Public Sub INIRead(section As String, key As String) As String
'	Dim ret As Object
'	ret = oSQL_Settings.ExecQuerySingleResult2("SELECT value FROM ini WHERE section = ? and key = ?", Array As String(section,key))
'	debugLog("Section: " & section & "   Key: " & key & "   Value: " & ret)
'	If ret = Null Then 
'		Return ""
'	Else
'		Return ret
'	End If
'End Sub
'Public Sub INIWrite(section As String, key As String, value As String)
'	oSQL_Settings.ExecNonQuery2("DELETE FROM ini WHERE section = ? and key = ?",Array As String(section,key))
'	oSQL_Settings.ExecNonQuery2("INSERT INTO ini (section,key,value) VALUES (?,?,?)",Array As String(section,key,value))
'End Sub
'#End Region
'
'#Region LOG CRAP
'
'
'
'Public Sub LogClearOldAll()
'	oSQL.ExecNonQuery("DELETE FROM logs")
'	LogWrite("Cleared log table",ID_LOG_MSG)
'End Sub
'
'
'Public Sub LogClearOld(optionalMSG As String)
'	Dim ttl As Int = db.Table_CountRows(oSQL,"logs")
'	LogWrite("Checking logs: " & ttl ,ID_LOG_MSG)
'	Dim clearNum As Int = 500
'	
'	If ttl > clearNum Then
'		ToastMessageShowX("Clearing logs... Recs:" & ttl,True) '--- 
'		
'		Dim ret As Int = oSQL.ExecQuerySingleResult("SELECT max(id) FROM logs")
'		
'		Dim half As Int = (ret - (clearNum / 2))
'		oSQL.ExecNonQuery(("DELETE FROM logs where id < " & half ))
'		Dim nowTTL As Int = db.Table_CountRows(oSQL,"logs")
'		
'		LogWrite(optionalMSG &  " - Cleared some of log table - TTL:" & ttl & "  New TTL:" & nowTTL,ID_LOG_MSG)
'		
''		Log("***********************")
''		Log("Count : " &  ttl)
''		Log("MAX ID: " &  ret)
''		Log("Half  : " &  half)
''		Log("Count : " &  nowTTL)
''		Log("***********************")
'
'	End If
'End Sub
'
''--- log message to DB
Public Sub LogWrite(txt As String, msgType As Int)
	
	Log("TODO - " & txt)
	
'	Try
'		If msgType = ID_LOG_ERR Then oSQL.EndTransaction '---- clear ANY transaction
'	Catch
'	End Try 'ignore
''	If oSQL.IsInitialized = False Then
''		Msgbox(txt,"")
''	End If
'	Dim ssql As String =  $"INSERT INTO logs (info,type,date_time) VALUES ('${txt}','${msgType}','${DateTime.now}')"$
'	oSQL.ExecNonQuery(ssql)
'	'oSQL.ExecQueryAsync("",ssql,Null)
'	'oSQL.ExecNonQuery2(ssql,Array As Object(txt,msgType,DateTime.Now))
'	debugLog2("** Log write: " & txt)
End Sub
'
'' 
''Sub SQLQ_QueryComplete(success As Boolean, cur As Cursor)
''	'--- do not delete
''End Sub
'
''--- logs and shows a toast message in debug
'Public Sub LogWrite2(txt As String, msgType As Int)
'	LogWrite(txt,msgType)
'	If IsDebuggerAttatch Then ToastMessageShowX(txt,True)
'End Sub
'
''--- logs and shows a toast message in release
'Public Sub LogWrite3(txt As String, msgType As Int)
'	LogWrite(txt,msgType)
'	ToastMessageShowX(txt,True)
''End Sub
'
'--- logs to the DB and logs to Android
Public Sub LogWrite4(txt As String, msgType As Int)
	LogWrite(txt,msgType)
	'LogColor(txt,Colors.red)
End Sub
'
'Public Sub GetLogIn_HTML() As String
'
'	Try
'			
'		Dim s As String = "SELECT Id as 'Id',Info as 'Info', " & _
'					"Case Type WHEN 0 Then 'Error' WHEN 1 Then 'Warning' Else 'MSG' End as 'Type', " & _
'					"datetime(date_time / 1000,'unixepoch','localtime') As 'Date' FROM logs ORDER BY id DESC"
'
'		Return (db.ExecuteHtml(oSQL, s, Null, 0, False))
'		
'	Catch
'		Return "GetLogIn_HTML  " & LastException.Message
'	End Try
'
'End Sub
'
'Public Sub GetIniIn_HTML() As String
'	Try
'		Return (db.ExecuteHtml(oSQL_Settings, "SELECT * from ini order by section", Null, 0, False))	
'	Catch
'		Return "GetIniIn_HTML  " & LastException.Message
'	End Try
'	
'End Sub
'
'Public Sub GetProfilesIn_HTML() As String
'	Try
'		Return (db.ExecuteHtml(oSQL_Settings, "SELECT * from profiles", Null, 0, False))	
'	Catch
'		Return "GetProfilesIn_HTML  " & LastException.Message
'	End Try
'	
'End Sub
'
'
'#End Region
'
'#Region MISC FUNCTIONS
'
'
''Public Sub ParseColor(clr As Int) As Int()
''	Dim res(4) As Int
''	res(0) = Bit.UnsignedShiftRight(Bit.And(clr, 0xff000000), 24) ' alfa
''	res(1) = Bit.UnsignedShiftRight(Bit.And(clr, 0xff0000), 16)   ' R
''	res(2) = Bit.UnsignedShiftRight(Bit.And(clr, 0xff00), 8)      ' G
''	res(3) = Bit.And(clr, 0xff)  
''	Return res
''End Sub
'
''
''Sub Str2Double(S As String) As Double
''	Return S
''End Sub
'Sub Str2Int(S As String) As Int
'	Return S
'End Sub
'Sub Int2Str(I As Int) As String
'	Return I
'End Sub
'Sub int2bool(I As Int) As Boolean  'ignore
'	If I = 0 Then Return False Else Return True
'End Sub
'Sub bool2int(b As Boolean) As Int  'ignore
'	If b Then Return 1 Else Return 0
'End Sub
'Sub bool2Str(b As Boolean) As Int  'ignore
'	If b Then Return "1" Else Return "0"
'End Sub
'
''Sub iif(boolCondition As Object, returnTrue As Object, returnFalse As Object) As Object
''	If boolCondition = True Then
''		Return returnTrue
''	Else
''		Return returnFalse
''	End If
''End Sub 
'
'
'#End Region
'
'
'
'Public Sub CleanTime(s As String) As String
'	
'	If Regex.Split(":",s)(1).Length = 1 Then
'		s = s & "0"
'	End If
'	If fn.CountChar(s,":") = 1 And s.length = 5 Then
'		s = s & ":00"
'		Return s
'	End If
'	If fn.CountChar(s,":") = 2 And s.Length = 8 Then
'		Return s
'	End If
'	Return ""
'End Sub
'
'
'
'
'Public Sub PopupVolume_MUSIC
'	Dim currVol As Int = ph.GetVolume(ph.VOLUME_MUSIC)
'	ph.SetVolume(ph.VOLUME_MUSIC,currVol, True)
'End Sub
'
'
'#Region SCREEN ON/OFF DIMMED
'
'
'Public Sub ScreenFullOn
'	
'	Try
'		
'		Log("Public Sub ScreenFullOn")
'		If IsPaused(Main) Then StartActivity(Main)
'		Dim n As Float = 1.0
'		ph.SetScreenBrightness(n)
'		phw.ReleaseKeepAlive
'		phw.KeepAlive(True) '--- keep the screen-cpu on
'		
'		'phw.ReleaseKeepAlive
'		'DoEvents
'		'If IsPaused(Main) Then StartActivity(Main)
'		
'	Catch
'		LogException2(LastException,True,"ScreenFullOn")
'	End Try
'	
'End Sub
'Public Sub DimTheScrnBySettingBrightness
'	debugLog("Public Sub DimTheScrnBySettingBrightness")
'	Dim f As Float = c.SCRN_DIM_PCT1
'	ph.SetScreenBrightness(f)
'End Sub
'
'#End Region
'
'
'
'Public Sub ToastMessageShowX(msg As String, longDuration As Boolean)
'	ToastMessageShow(msg,longDuration)
'	'CallSub3(Main,"CallNewToast",msg,longDuration)
'End Sub
'
'
'
'#Region SIZE ADJUSTS AND SCREEN CRAP
'Public Sub SizeFontAdjust() As Float
'	Dim I As Int = GetDeviceLayoutValues.Width
'	If I > 760 And I < 900 Then
'		Return 1
'	Else If I > 901 And I < 1099 Then
'		Return 1.20
'	Else If I > 1200 Then
'		Return 1.45
'	Else
'		LogWrite("Scrn Size Err 001:" & I,ID_LOG_ERR)
'		Return 1
'	End If
'	
'End Sub
'
'
'
'
'Public Sub SizesTabsHeight() As Int
'	Dim I As Int = GetDeviceLayoutValues.Width
'	If I = 800 Then
'		Return 48dip
'	Else If I = 1024 Then
'		Return 52dip
'	Else If I > 1200 Then
'		Return 64dip
'	Else
'		LogWrite("Scrn Size Err 003:" & I,ID_LOG_ERR)
'		Return 48dip
'	End If
'	
'End Sub
'
''Sub setTextHeight(txt As String,lbl As Label)
''  Dim dt1 As Float
''  Dim limit = 0.5 As Float
''  Dim h As Int
''
''Try
''  lbl.Text = txt
''  lbl.TextSize = 72
''  dt1 = lbl.TextSize
''  h = su.MeasureMultilineTextHeight(lbl, txt)
''  Do While dt1 > limit OR h > lbl.Height
''    dt1 = dt1 / 2
''    h = su.MeasureMultilineTextHeight(lbl, txt)
''    If h > lbl.Height Then
''      lbl.TextSize = lbl.TextSize - dt1
''    Else
''      lbl.TextSize = lbl.TextSize + dt1
''    End If
''  Loop
''  
''  Catch
''  	'Log(LastException.Message)
''	LogException(LastException,True)
''  End Try
''End Sub
''
'
''--- returns true if the size is too large
''--- called from setText
'public Sub CheckSize(size As Float, MultipleLines As Boolean, mLbl As Label) As Boolean
'	#if release
'	Try
'	#end if
'	
'		Dim cvs As Canvas ,  bmp As Bitmap
'		bmp.InitializeMutable(1%x,1%y)
'		cvs.Initialize2(bmp)
'		mLbl.TextSize = size
'		If MultipleLines Then
'			Return su.MeasureMultilineTextHeight(mLbl, mLbl.Text) > mLbl.Height
'		Else
'			Return cvs.MeasureStringWidth(mLbl.Text, mLbl.Typeface, size) > mLbl.Width Or su.MeasureMultilineTextHeight(mLbl, mLbl.Text) > mLbl.Height
'		End If
'		
'	#if release	
'	Catch
'		LogException(LastException,True)
'	End Try
'	#end if
'	Return True '--- just return true if error
'		
'End Sub
''
'''Public Sub setText(value As String, mLbl As Label)
'''	mLbl.Text = value
'''	Dim multipleLines As Boolean = mLbl.Text.Contains(CRLF)
'''	Dim size As Float
'''	For size = 2 To 80
'''		If CheckSize(size, multipleLines,mLbl) Then Exit
'''	Next
'''	size = size - 0.5
'''	If CheckSize(size, multipleLines,mLbl) Then size = size - 0.5
'''	Dim offset As Int = 3
'''	mLbl.TextSize = (size+offset)
'''	debugLog("size:"& mLbl.TextSize)
'''End Sub
''
'
'Public Sub setText(value As String, mLbl As Label)
'	Dim HighValue As Float  = 2
'	Dim LowValue As Float = 1
'	Dim CurrentValue As Float
'
'	mLbl.Text = value
'	Dim multipleLines As Boolean = mLbl.Text.Contains(CRLF)
'	'need to set actual start values so find Gross Start/Stop values
'	'first is linear Growth with some arbitrary 'large' value 'going with 30
'	'this can be fine tuned based on size of the display that you are aiming for/have available vs size of your CustomViews
'
'	Do While Not(CheckSize(HighValue, multipleLines,mLbl))
'		LowValue = HighValue
'		HighValue = HighValue + 30
'	Loop
'
'	CurrentValue = (HighValue + LowValue)/2
'	'
'	'initial sizes set, now for binary approach
'	'
'	'adjust this to taste.  I like it at 1, and I think it looks very nice... can go a little larger for even faster times
'	'smaller for closer hit to actual optimum, but sacrificing a little speed
'	'
'	Dim ToleranceValue As Float = .5
'	'ToleranceValue = 1
'
'	Dim currentResult As Boolean
'	Do While (CurrentValue - LowValue) > ToleranceValue Or (HighValue - CurrentValue) > ToleranceValue 
'		
'		currentResult = CheckSize(CurrentValue, multipleLines,mLbl)
'		
'		If currentResult Then 'this means currentvalue is too large
'			HighValue = CurrentValue
'		Else 'currentValue is too small
'			LowValue = CurrentValue
'		End If
'		CurrentValue = (HighValue + LowValue) / 2
'	Loop
'	Dim offset As Int = 0
'	mLbl.TextSize = ((CurrentValue - ToleranceValue) + offset)
'	'debugLog("size:"& mLbl.TextSize)
'End Sub
'
'#End Region
'
'
'
''Public Sub HasPhoneFeature() As Boolean
''	Return HasFeature("android.hardware.telephony")
''End Sub
''Private Sub HasFeature(Feature As String) As Boolean
''	Dim R As Reflector
''	R.Target = R.GetContext
''	R.Target = R.RunMethod("getPackageManager")
''	Return R.RunMethod2("hasSystemFeature", Feature, "java.lang.String")
''End Sub
'
''
''Public Sub ReturnAppVersionName() As String
''	Dim pm As PackageManager 
''	#if not(KE)
''	Return pm.GetVersionName("com.sadLogic.FamilyCentral")
''	#else
''	Return pm.GetVersionName("com.sadLogic.KitchenEssentials")
''	#end if
''End Sub
'
''=====================================================================================
''=====================================================================================
''=====================================================================================
''=====================================================================================
''=====================================================================================
''=====================================================================================
''=====================================================================================
'
'
'
'
'
'
'''Dim DoAction As Intent
'''DoAction.Initialize("android.settings.LOCATION_SOURCE_SETTINGS", "")
'''StartActivity(DoAction)
'''
'''
'''Action Details(Activity action)	
'''ACCESSIBILITY_SETTINGS = Show settings For accessibility modules.	
'''ADD_ACCOUNT = Show add account screen For creating a new account.	
'''AIRPLANE_MODE_SETTINGS = Show settings To allow entering/exiting airplane mode.	
'''APN_SETTINGS = Show settings To allow configuration of APNs.	
'''APPLICATION_DETAILS_SETTINGS = Show screen of details about a particular application.	
'''APPLICATION_DEVELOPMENT_SETTINGS = Show settings To allow configuration of application development-related settings.	
'''APPLICATION_SETTINGS = Show settings To allow configuration of application-related settings.	
'''BLUETOOTH_SETTINGS = Show settings To allow configuration of Bluetooth.	
'''DATA_ROAMING_SETTINGS = Show settings For selection of 2G/3G.	
'''DATE_SETTINGS = Show settings To allow configuration of date AND time.	
'''DEVICE_INFO_SETTINGS = Show general device information settings (serial number, software version, Phone number, etc.).	
'''DISPLAY_SETTINGS = Show settings To allow configuration of display.	
'''INPUT_METHOD_SETTINGS = Show settings To configure input methods, In particular allowing the user To enable input methods.	
'''INPUT_METHOD_SUBTYPE_SETTINGS = Show settings To enable/disable input method subtypes.	
'''INTERNAL_STORAGE_SETTINGS = Show settings For internal storage.	
'''LOCALE_SETTINGS = Show settings To allow configuration of Locale.	
'''LOCATION_SOURCE_SETTINGS = Show settings To allow configuration of current location sources.	
'''MANAGE_ALL_APPLICATIONS_SETTINGS = Show settings To manage all applications.	
'''MANAGE_APPLICATIONS_SETTINGS = Show settings To manage installed applications.	
'''MEMORY_CARD_SETTINGS = Show settings For memory card storage.	
'''NETWORK_OPERATOR_SETTINGS = Show settings For selecting the network operator.	
'''NFCSHARING_SETTINGS = Show NFC Sharing settings.	
'''NFC_SETTINGS = Show NFC settings.	
'''PRIVACY_SETTINGS = Show settings To allow configuration of privacy options.	
'''QUICK_LAUNCH_SETTINGS = Show settings To allow configuration of quick launch shortcuts.	
'''SEARCH_SETTINGS = Show settings For global search.	
'''SECURITY_SETTINGS = Show settings To allow configuration of security AND location privacy.	
'''SETTINGS = Show system settings.	
'''SOUND_SETTINGS = Show settings To allow configuration of sound AND volume.	
'''SYNC_SETTINGS = Show settings To allow configuration of sync settings.	
'''USER_DICTIONARY_SETTINGS = Show settings To manage the user input dictionary.	
'''WIFI_IP_SETTINGS = Show settings To allow configuration of a static IP address For Wi-Fi.	
'''WIFI_SETTINGS = Show settings To allow configuration of Wi-Fi.	
'''WIRELESS_SETTINGS = Show settings To allow configuration of wireless Controls such As Wi-Fi, Bluetooth AND Mobile networks.	
'''EXTRA_AUTHORITIES = Limit available options In launched activity based on the given authority.
'
'
''
''Public Sub CreatShortcut
''
''manafest
''AddApplicationText(<activity android:name="anywheresoftware.b4a.objects.preferenceactivity"/>)
''
''
''	Dim PrefMgr As PreferenceManager
''    If PrefMgr.GetBoolean("shortcutinstalled") Then
''        Return
''    End If
''    
''    Dim shortcutIntent As Intent
''    shortcutIntent.Initialize("", "")
''    shortcutIntent.SetComponent("my.app/.main") ' Put the app package name here
''    
''    Dim In As Intent
''    In.Initialize("", "")
''    In.PutExtra("android.intent.extra.shortcut.INTENT", shortcutIntent)
''    In.PutExtra("android.intent.extra.shortcut.NAME", "My ShortCut") ' Put you're application name here
''        In.PutExtra("android.intent.extra.shortcut.ICON", LoadBitmap(File.DirAssets, "app_icon_1.png")) ' If you have the icon file in the assets, you just need any bitmap here. Best is 72x72 pixels because launchers do not scale. You might want to experiment a little bit with size
''    
''    In.Action = "com.android.launcher.action.INSTALL_SHORTCUT"
''    
''    Dim p As Phone
''    p.SendBroadcastIntent(In)
''    'DoEventsNow
''    PrefMgr.SetBoolean("shortcutinstalled", True)
''
''
''End Sub
'
'
'#Region User Management
'
''Gets all of the users from the DB
'Public Sub GetUsers(excludeEmergencyContacts As Boolean) As List ' returning users list
'	
'	' Load all users from DB
'	Dim UsersList As List : UsersList.Initialize
'	Dim curs As Cursor = oSQL_Settings.ExecQuery("SELECT * FROM profiles")
'	
'	For i = 0 To curs.RowCount - 1
'		
'		curs.Position = i
'		
'		Dim User As User
'		User.role = curs.GetString("role")
'		
'		If(excludeEmergencyContacts = True And User.role.ToLowerCase.Trim <> "user") Then '-- if role is emerg contact we skip
'			Continue
'		End If
'		
'		User.id = curs.GetInt("id")
'		User.email = curs.GetString("email")
'		User.fname = curs.GetString("fname")
'		User.lname = curs.GetString("lname")
'		User.age = curs.GetInt("age")
'		User.color = curs.GetInt("color")
'		User.chores = int2bool(curs.GetString("chores"))
'		User.emg_contact = curs.GetString("emg_contact")
'		User.phone = curs.GetString("phone")
'		User.profimg_path = curs.GetString("profimg_path")
'		User.shopping = int2bool(curs.GetString("shopping"))
'		
'		UsersList.Add(User)
'		
'	Next
'	
'	Return UsersList
'	' Return array of users
'	
'	'To iterate trough list , use following code:
'	'for each user as User in g.GetUsers(?) ...
'	
'End Sub
'
'Public Sub getCurrentUser As clsUserRecord
'	Return currentUser
'End Sub
'
'Public Sub setCurrentUser(newUser As clsUserRecord)
'	currentUser = newUser
'	
'	OnSelectedUserChanged.Raise
'End Sub
'
'#End Region
'
'
''=========================== NOT GLOBAL STUFF ===========================================
''=========================== NOT GLOBAL STUFF ===========================================
''=========================== NOT GLOBAL STUFF ===========================================
''=========================== NOT GLOBAL STUFF ===========================================
'
''=========================== DELETE FOR NEW PROJECT ===========================================
'
'
'
'
'#region Side_MENU_HELPER_METHODS
'
'Public Sub SetSideMenuParams(lv As ListView) As ListView
'	'--- build the menus
'
'	lv.Clear
'	
'	Dim icon As Bitmap : icon.Initialize(File.DirAssets,"menu_finger01.png")
'	lv.SingleLineLayout.Label.SetBackgroundImage(icon)
'	
'	If GetDeviceLayoutValues.Height <= 700 Then 
'		lv.SingleLineLayout.ItemHeight = 48dip
'	Else
'		lv.SingleLineLayout.ItemHeight = 58dip
'	End If
'	
'	lv.Color = Colors.Transparent
'	lv.SingleLineLayout.Label.Gravity = Bit.Or(Gravity.CENTER_HORIZONTAL,Gravity.CENTER_VERTICAL)
'	lv.SingleLineLayout.Label.SetLayout(0dip,0dip,lv.Width,lv.SingleLineLayout.ItemHeight)
'	lv.SingleLineLayout.Label.TextSize = 18
'	
'	Return lv
'End Sub
'
'Public Sub MenuGetBlankItemsNeeded(menuListView As CustomListView) As Int
'	Dim maxHeight As Int = menuListView.AsView().Height
'	Dim currentHeight As Int = 0
'	
'	For i = 0 To menuListView.Count - 1
'		If (menuListView.GetValue(i) = "---") Then
'			currentHeight = currentHeight + 10dip
'		Else
'			currentHeight = currentHeight + 60dip
'		End If
'	Next
'
'	If (currentHeight < maxHeight) Then
'		Return  (maxHeight / 60dip) - (currentHeight / 60dip)
'	End If
'
'	Return 0
'End Sub
'
'
'Public Sub MenuFillWithBlankItems(menuListView As CustomListView) As Int
'
'	Dim newItemCount As Int = MenuGetBlankItemsNeeded(menuListView)
'
'	For item = 0 To newItemCount - 1
'		MenuCreateItem(menuListView, "", "")
'	Next
'		
'	Return newItemCount
'
'End Sub
'
'Public Sub MenuCreateItem(menuListView As CustomListView, text As String, value As String) As Panel
'	
'	Dim icon As Bitmap : icon.Initialize(File.DirAssets,"menu_finger01.png")
'	Dim itemHeight As Int = 60dip
'	Dim panelHost As Panel
'	Dim lbl As Label
'	
'	lbl.Initialize("")
'	lbl.Gravity = Bit.Or(Gravity.CENTER_VERTICAL, Gravity.CENTER_HORIZONTAL)
'	lbl.TextColor = GetColorTheme(ehome_clrTheme,"themeColorText")
'	
'	panelHost.Initialize("")
'	panelHost.SetBackgroundImage(icon)
'	panelHost.AddView(lbl, 10, 0, menuListView.AsView.Width - 20, itemHeight)
'	
'	menuListView.Add(panelHost, itemHeight, value)
'	setText(text, lbl)
'	
'	If (lbl.TextSize > 18) Then
'		lbl.TextSize = 18
'	End If
'	
'	Return panelHost
'
'End Sub
'
'Public Sub MenuCreateItemAt(menuListView As CustomListView, text As String, value As String, index As Int)
'	
'	Dim icon As Bitmap : icon.Initialize(File.DirAssets,"menu_finger01.png")
'	Dim itemHeight As Int = 60dip
'	Dim panelHost As Panel
'	Dim lbl As Label
'	
'	lbl.Initialize("")
'	lbl.Gravity = Bit.Or(Gravity.CENTER_VERTICAL, Gravity.CENTER_HORIZONTAL)
'	lbl.TextColor = Colors.ARGB(255,232,142,66)
'	
'	panelHost.Initialize("")
'	panelHost.SetBackgroundImage(icon)
'	panelHost.AddView(lbl, 10, 0, menuListView.AsView.Width - 20, itemHeight)
'	
'	menuListView.InsertAt(index, panelHost, itemHeight, value)
'	setText(text, lbl)
'	
'	If (lbl.TextSize > 18) Then
'		lbl.TextSize = 18
'	End If
'
'End Sub
'
'Public Sub MenuCreateItemSeparator(menuListView As CustomListView)
'	
'	Dim icon As Bitmap : icon.Initialize(File.DirAssets,"dividerH.png")
'	Dim itemHeight As Int = 7dip
'	Dim panelHost As Panel
'	Dim childPanel As Panel
'	
'	panelHost.Initialize("")
'	childPanel.Initialize("")
'	childPanel.SetBackgroundImage(icon)
'	panelHost.AddView(childPanel, 5, 0, menuListView.AsView.Width - 10, itemHeight)
'	
'	menuListView.Add(panelHost, itemHeight, "---")
'
'End Sub
'
'#end region
'
'
'Public Sub ShowWebHelp(act As Activity, pagePart As String)
'	
'	Dim title As String = pagePart
'	
'	pagePart = pagePart.ToLowerCase
'	pagePart = pagePart.Replace(" ", "-")
'	pagePart = pagePart & ".html"
'	'Dim site As String = "http://jakebullet70.github.io/sadLogic/help/" &  pagePart
'	Dim site As String = "http://sadconsole.com"
'	'site = "file:///" & File.DirAssets & "/Help/help/home.html"
'	debugLog( site)
'	Dim webView As puWebView
'	webView.Initialize(act,  site, "", False, "How to: " & title, True)
'	'webView.Initialize(act, "", WebViewAssetFile("Help/help/home.html"), False, "How to: " & title, True)
'	'Sleep(500)
'End Sub
'
'
''Sub WebViewAssetFile (FileName As String) As String
''   #if B4J
''     Return File.GetUri(File.DirAssets, FileName)
''   #Else If B4A
''	Dim jo As JavaObject
''	jo.InitializeStatic("anywheresoftware.b4a.objects.streams.File")
''	If jo.GetField("virtualAssetsFolder") = Null Then
''		Return "file:///android_asset/" & FileName.ToLowerCase
''	Else
''		Return "file://" & File.Combine(jo.GetField("virtualAssetsFolder"), _
''       jo.RunMethod("getUnpackedVirtualAssetFile", Array As Object(FileName)))
''	End If
''   #Else If B4i
''     Return $"file://${File.Combine(File.DirAssets, FileName)}"$
''   #End If
''End Sub
''	
''Public Sub GetScreenBrightnessHigh() As Float '--- not being used at this moment
''	Return 1
''End Sub
''Public Sub GetScreenBrightnessLow() As Float '--- not being used at this moment
''	Return .01
''End Sub
'	
'Public Sub GetScreenSaverOn() As Boolean
'
'	If c.SNAPIN_MENU_PFRAME_ACTIVE = True Then
'		Return (True And (fn.ConvertStr2Bool(INIRead(c.INI_CONST_SETUP,"SCREEN_SAVER_PVIEWER"))))
'	End If
'	Return False
'
'End Sub
'
'
'
'Public Sub GetIsItTimeForTheScreenSaver() As Boolean
'
'	'--- these are now returened in 24hr format 
'
'	Dim now As Long = DateTime.now
'	Dim start_Time As Float
'	Dim endTime, nowTime As Float
'	
''	INIWrite(c.INI_CONST_SETUP,"SCREEN_SAVER_TIME_START","7:30")
''	INIWrite(c.INI_CONST_SETUP,"SCREEN_SAVER_TIME_END","20:00")
''	start_Time = 7.30
''	endTime = 20.00
'	
'	Dim t1, t2 As String
'	t1 =  INIRead(c.INI_CONST_SETUP,"SCREEN_SAVER_TIME_START")
'	t2 = INIRead(c.INI_CONST_SETUP,"SCREEN_SAVER_TIME_END")
'	
'	start_Time = t1.Replace(":",".")
'	endTime     =  t2.Replace(":",".")
'	
'	nowTime   = DateTime.GetHour(now) & "." & fn.PadLeft(DateTime.GetMinute(now),"0",2)
'	
'	If (start_Time = 00.00 And endTime = 00.00)          Then Return True
'	If (nowTime >= start_Time And nowTime < endTime) Then Return True
'	
'	Return False
'
'End Sub
''		
'
'
'Public Sub IsVoiceOn_KTimers() As Boolean
'	Try
'		Return fn.ConvertStr2Bool(INIRead(c.INI_CONST_SETUP,"KTIMERS_SPEECH_ON"))
'	Catch
'		Return False
'	End Try
'End Sub
''Public Sub IsVoiceOn_Shopping() As Boolean
''	Try
''		Return ConvertStr2Bool(INIRead(c.INI_CONST_SETUP,"SHOPPING_SPEECH_ON"))
''	Catch
''		Return False
''	End Try
''End Sub
'Public Sub IsVoiceOn_Announce() As Boolean
'	Try
'		Return fn.ConvertStr2Bool(INIRead(c.INI_CONST_SETUP,"VOICE_ALARMS_ON"))
'	Catch
'		Return False
'	End Try
'End Sub
'
'
'Public Sub IsCalendarReadOn() As Boolean
'
'	Return False '--- for now
''	
''	Try
''		Dim R As String = INIRead2(c.INI_CONST_SETUP,"CAL_READ_NUM","-1")
''		If R = "-1" Or R = "" Then 
''			Return False
''		End If
''		Return True
''	Catch
''		Return False
''	End Try
'End Sub
'
'
'
'Public Sub LogException2(LastEx As Exception,logAlways As Boolean,extraString As String)
'
'	Dim Ex As ExceptionEx = LastEx
'	If logAlways Then 
'		LogWrite(extraString & " : " &  LastException.Message & CRLF & Ex.StackTrace, ID_LOG_ERR)
'		Return
'	End If
'
'	If debugMode Then 
'	'	Ex.Throw 
'	Else 
'		LogWrite(extraString & " : " &  LastException.Message & CRLF & Ex.StackTrace, ID_LOG_ERR)
'	End If	
'	
'End Sub
'
'--- logs to log file and logs to Android
Public Sub LogException3(LastEx As Exception,logAlways As Boolean,extraString As String)
	Log("TODO - LogException3")
	
'	Dim Ex As ExceptionEx = LastEx
'	Log(Ex.StackTrace)
'	If logAlways Then
'		LogWrite(extraString & " : " &  LastException.Message & CRLF & Ex.StackTrace, ID_LOG_ERR)
'		Log(extraString & " : " &  LastException.Message & CRLF & Ex.StackTrace)
'		Return
'	End If
'	
'	If debugMode Then
'		'	Ex.Throw
'	Else
'		LogWrite(extraString & " : " &  LastException.Message & CRLF & Ex.StackTrace, ID_LOG_ERR)
'	End If
	
End Sub
'
'
'
Public Sub LogException(LastEx As Exception,logAlways As Boolean)
	
	Log("TODO - LogException")
	
'	'Dim cse As CallSubExtended
'	'cse.AsyncCallSubX(Null,"g.LogException2",Array As Object(LastEx,logAlways,""),2)
'	LogException2(LastEx,logAlways,"")
End Sub
'
'
'
'
'
'
'Public Sub CreateCallback(Target As Object, Method As String) As clsSimpleCallback
'	Dim callback As clsSimpleCallback
'	callback.Initialize
'	callback.Target = Target
'	callback.CallbackSub = Method
'	Return callback
'End Sub
'
'
'
'
'#Region DATA FOR SHOWING PROGRAM INFO
'
'
'private Sub GetCpuType() As String
'	Dim cpu As CPUFeatures
'	If cpu.IsARM Then
'		Return "ARM"	
'	End If
'	If cpu.IsARM64 Then
'		Return "ARM 64"
'	End If
'	If cpu.IsARMv7a Then
'		Return "ARM 7a"
'	End If
'	If cpu.IsMIPS Then
'		Return "MIPS"
'	End If
'	If cpu.IsMIPS64 Then
'		Return "MIPS 64"
'	End If
'	If cpu.IsX86 Then
'		Return "X86 32"
'	End If
'	If cpu.IsX8664 Then
'		Return "X86 64"
'	End If
'	Return "Uknown"
'End Sub
'
'
'Private Sub Get_Info() As Map
'
'	Try
'		
'		Dim p As Phone, mb As Int
'		Dim m As Map : m .Initialize
'		Dim os As OperatingSystem : os.Initialize("")
'		Dim cpu As CPUFeatures
'		'Dim ca As Cache
'		'ca.Initialize(2,2*1024*1024,"")
'		
'		
'		m.Put("------ PROGRAM ------","---------------")
'		m.Put("App",Application.LabelName)
'		m.Put("Installed",INIRead(c.INI_CONST_MAIN,"INSTALLED"))
'		m.Put("Uptime",fn.UpTime(startTime))
'		m.Put("Name",INIRead(c.INI_CONST_SETUP,"INFO_MY_NAME"))
'		m.Put("Prg version",fn.ReturnAppVersionName("com.sadLogic.KitchenEssentials")) 'g.INIRead(c.INI_CONST_MAIN,"PRG_VERSION"))
'		m.Put("DB version",INIRead(c.INI_CONST_MAIN,"DB_VERSION"))
'		m.Put("ID",INIRead(c.INI_CONST_MAIN,"DEVICE0ID"))
'		
'		m.Put("------ COMPUTER ------","---------------")
'		m.Put("Model",p.Model)
'		m.Put("Manufacture",p.Manufacturer)
'		mb = ((os.AvailableInternalMemorySize / 1024) / 1024)
'		m.Put("Avail Internal mem",mb & "mb")
'		mb  = ((os.AvailableExternalMemorySize / 1024) / 1024)
'		m.Put("Avail External mem",mb & "mb")
'		'm.Put("Free mem", ca.FreeMemory)
'		'm.Put("Free disk space",ca.DiskFree)	
'		m.Put("CPU count",cpu.GetCPUCount)
'		m.Put("CPU type",GetCpuType)
'		'm.Put("Email Address",fn.GetEmailAddr())
'		
'		m.Put("------ NETWORK ------","---------------")
'		'Dim server As ServerSocket ': server.Initialize(9905,"d")
'		'server.GetMyWifiIP)
'		m.Put("IP Address",getIP)
'		
'		Dim mac As String = "..." : Dim ssid As String = "..."
'		Dim o As MLwifi, strength As String
'		mac = o.MACAddress
'		ssid = o.SSID
'		strength = o.WifiStrength
'		
'
'		m.Put("MAC Address",mac)
'		m.Put("SSID",ssid)
'		m.Put("Link Strength",strength)
'		m.Put("Inet Connected",o.isOnLine)
'		
''
''		m.Put("------ VARS ------","---------------")
''		'm.Put("FMT_HEADER_DATE",c.FMT_HEADER_DATE)
''		'm.Put("FMT_HEADER_TIME",c.FMT_HEADER_TIME)
''		m.Put("FMT_SNAPIN_CLOCK",c.FMT_SNAPIN_CLOCK)
''		m.Put("FMT_SNAPIN_DATE",c.FMT_SNAPIN_DATE)
''		
''		'm.Put("WEB_RECIPE_TARGET",c.WEB_RECIPE_TARGET)
''		'm.Put("WEB_HA_TARGET",c.WEB_HA_TARGET)
''		m.Put("IGNORE_CLOSE",c.IGNORE_CLOSE)
''		m.Put("KIOSK_MODE",c.KIOSK_MODE)
''		m.Put("SCRN_SLEEP_TIME",c.SCRN_SLEEP_TIME)
''		
''		m.Put("SCREEN_SAVER_PVIEWER",INIRead(c.INI_CONST_SETUP,"SCREEN_SAVER_PVIEWER"))
''		m.Put("SCREEN_SAVER_TIME_START",INIRead(c.INI_CONST_SETUP,"SCREEN_SAVER_TIME_START"))
''		m.Put("SCREEN_SAVER_TIME_END",INIRead(c.INI_CONST_SETUP,"SCREEN_SAVER_TIME_END"))
'
'
'	Catch
'		LogException2(LastException,True,"Get_Info")
'	End Try
'	
'	Return m
'	
'End Sub
'
'
'
'Public Sub GetInfoStr2Display_HTML() As String
'	Dim HtmlCSS As String 
'	
'	Try
'			
'		HtmlCSS = "table {width: 100%;border: 1px solid #cef;text-align: left; }" _
'			& " th { font-weight: bold;	background-color: #acf;	border-bottom: 1px solid #cef; }" _ 
'			& "td,th {	padding: 4px 5px; }" _
'			& ".odd {background-color: #def; } .odd td {border-bottom: 1px solid #cef; }" _
'			& "a { text-decoration:none; color: #000;}"
'		
'			
'		Dim m As Map = Get_Info
'			
'		Dim sb As StringBuilder		
'		sb.Initialize
'		sb.Append("<html><body>").Append(CRLF)
'		sb.Append("<style type='text/css'>").Append(HtmlCSS).Append("</style>").Append(CRLF)
'		sb.Append("<table><tr>").Append(CRLF)
'		
'		sb.Append("<th>").Append("Key").Append("</th>")
'		sb.Append("<th>").Append("Value").Append("</th>")
'		
'		sb.Append("</tr>").Append(CRLF)
'		For row = 0 To m.Size - 1
'			
'			If row Mod 2 = 0 Then
'				sb.Append("<tr>")
'			Else
'				sb.Append("<tr class='odd'>")
'			End If
'		
'			sb.Append("<td>")
'			sb.Append(m.GetKeyAt(row))
'			sb.Append("</td>")
'			sb.Append("<td>")
'			sb.Append(m.GetValueAt(row))
'			sb.Append("</td>")
'		
'			sb.Append("</tr>").Append(CRLF)
'		Next
'		sb.Append("</table></body></html>")
'		Return sb.ToString
'		
'		
'	Catch
'		Dim s9 As String = "GetInfoStr2Display_HTML "
'		LogException2(LastException,True,s9)		
'		Return s9 & LastException.Message
'	End Try
'	
'	
'End Sub
'#End Region
'
'
'
'Public Sub ConvertB4aDateToMySQL(d As Long) As String
'	Return dt.FormatDateTime("yyyy-MM-dd hh:mm:ss",d)
'End Sub
'
'Sub GetLstItemPressedCD (border_r As Int) As ColorDrawable
'	Dim pressed_cd As ColorDrawable
'	pressed_cd.Initialize(GetColorTheme(ehome_clrTheme,"lstItemPressed"),border_r)
'	Return pressed_cd
'End Sub
'
'
'public Sub RemoveBgPanelOnPopups(tagName As String, act As Activity)
'
'	Dim xx As Int = 0
'	For Each pnl As View In act.GetAllViewsRecursive
'		Try
'			If pnl.Tag = tagName Then
'				act.RemoveViewAt(xx)
'				debugLog("Removed view:" & pnl.Tag)
'				Exit 
'			End If
'		Catch 
'		End Try 'ignore
'		xx = xx + 1
'	Next
'
'End Sub
'
'
'
'public Sub ProcessSecretInfo()
'
'	'--- reads ping targets from encrypted file
'	debugLog("ProcessSecretInfo")
'	
''	Dim raf1 As RandomAccessFile
''	raf1.Initialize(c.SHARED0PATH,c.PINGoTARGETSoFILE,True)
''	c.PingTargets = raf1.ReadEncryptedObject(c.PASSWORD,raf1.CurrentPosition)
'	'c.PingTargets = raf1.Readb4xObject(raf1.CurrentPosition)
'	
'	'--- read PW - login info form encrypted map file
'	Log(c.PASSWORD)
'	Dim raf0 As RandomAccessFile
'	raf0.Initialize(c.SHARED0PATH,c.BIN0FILE,True)
'	c.PasswordLoginMapping = raf0.ReadEncryptedObject(c.PASSWORD,raf0.CurrentPosition)
''	c.PasswordLoginMapping = raf0.Readb4xObject(raf0.CurrentPosition)
'	'c.PasswordLoginMapping = File.ReadMap(c.SHARED0PATH,c.BIN0FILE)
'	
'	
'End Sub
'
'
'
'public Sub MyCurrencyFormat(MyNumber As Double) As String
'  Dim AHL As AHLocale   'need the AHlocale library
'  AHL.InitializeUS
'  Dim MyCur As String =AHL.CurrencySymbol
'  Dim MyFrac As Int =AHL.CurrencyFractionDigits
'  Return MyCur & NumberFormat2(MyNumber,1,MyFrac,MyFrac,True)
'End Sub
'
'
'Sub EnableDisableScreenPopups(pnl As Panel,disable As Boolean)
'
'	'--- called for popups to freeze the background screen
'	If disable Then
'		pnl.SetVisibleAnimated(250,True)
'		pnl.BringToFront
'	Else
'		pnl.SetVisibleAnimated(150,False)
'		pnl.SendToBack
'	End If
'End Sub
'
'
'Sub KeepScreenOn(IsEnabled As Boolean)
'    'Prevents the screen from sleeping when the current Activity is in the foreground
'    Dim r As Reflector
'    r.Target = r.GetActivity
'    r.Target = r.RunMethod("getWindow")
'    Dim FLAG_KEEP_SCREEN_ON As Int = 128
'    If IsEnabled Then
'        r.RunMethod2("addFlags", FLAG_KEEP_SCREEN_ON, "java.lang.int")
'    Else
'        r.RunMethod2("clearFlags", FLAG_KEEP_SCREEN_ON, "java.lang.int")
'    End If
'End Sub
'
'
'
public Sub GetWeatherKey() As String
	Return   cnst.OpenWeatherAPI  'c.PasswordLoginMapping.Get(c.weatherKey1)
	'(c.pppWeatherKey1)
	'Weather key is registered to thraka.accounts@outlook.com
End Sub
'
'
'
'
''========================================================================
'' Removes old file(s) from a folder if older then X amount days
'' Param - folder, the folder to search
'' Param - fileSpec, file spec to search for
'' Param - numOfDays, if file is older then X days then delete
'public Sub RemoveOldFiles(folder As String, fileSpec As String, numOfDays As Int) As Boolean
'	
'	Dim lstFolder As List
'	lstFolder.Initialize
'	
'	Try
'		
'		lstFolder = fn.WildCardFilesList2(folder,"*.elog",False,False)
'		For Each filename As String In lstFolder
'			If File.IsDirectory(folder, filename) Then
'				Continue
'			End If
'			
'			Dim p As Period = DateUtils.PeriodBetween(File.LastModified(folder,filename),DateTime.Now)
'			LogColor("RemoveOldFiles: days: " & p.Days,Colors.Blue)
'			If p.Days >= numOfDays Then
'				File.Delete(folder,filename)	
'			End If
'		Next
'		
'	Catch
'		Log(LastException)
'		Return False
'	End Try
'	Return True
'	
'End Sub
'
''========================================================================
'
'
'
'Public Sub Check_Lic() As String
'	
'	Try
'		'--- DUMMY!!  Do not remove
'		Dim caseMe As String = c.p3.SubString(3)
'		Dim l1 As String = c.P1 & fn.GUID
'		Dim l2 As String = c.P2
'		Dim h1,h2,h3 As Int
'		h1 = 99863822
'		h2 = c.N3
'		h3 = c.N1 + h1 + 6994
'		c.N2 = 73325488 - h3
'		
'		caseMe = caseMe & c.p2
'		
'		h1 = c.n2 * c.N1 + 995 - c.n1
'		h2 = c.dummyReverse(88,h2,12 & c.P4)
'		Select Case caseMe.Trim
'			Case "ujkjell863u9666"
'				c.n1 = h3 - c.n2 + 5928
'			Case "y3hoo56ggt" : 
'				C.n2 = h3 - 5998 + c.n1
'			Case "7hp@77uu4" : 
'				c.N3 = h1 - h2 + 75409
'			Case Else
'				c.N2 = h2 + h1 - 46171
'		End Select
'		l1 = l1 & l2.SubString2(1,2)
'		Dim ret As String = c.dummyReverse(16051981554 - c.n3,h2,l2 & c.P1)
'	Catch
'		Log(LastException)
'		Return 0
'	End Try
'	
'	Return ret
'End Sub
'
'
'
'
'public Sub SendOldErrFiles(folder As String, fileSpec As String) 
'
'	Dim what As String = "Checking 4 err files - "
'	Log(what & "start")	
'	If c.ProcessThisErrFile <> "" Then 
'		'---  a file still needs to be sent
'		Log(what & $"ProcessThisErrFile <> """$)
'		Return
'	End If
'	
'	Dim lstFolder As List
'	lstFolder.Initialize
'	
'	Try
'		
'		lstFolder = fn.WildCardFilesList2(folder,"*.elog",False,False)
'		For Each filename As String In lstFolder
'			If File.IsDirectory(folder, filename) Then
'				Continue
'			End If
'			
'			Log(what & filename)
'			#if release 
'			
'				c.ProcessThisErrFile = filename
'				Dim oEmailClass As clsEmailSender
'				oEmailClass.errorCrashEmail = True
'				oEmailClass.Initialize(c.NEWoDEVoEMAIL,fn.Array2List(Array As String(c.NEWoDEVoEMAIL)) , _
'								File.GetText(c.SHARED0PATH,c.ProcessThisErrFile), _
'								$"eHome Crash-Error Log: ${DateUtils.TicksToString(DateTime.Now)}"$, Null,"")
'				Exit 
'				
'			#else
'			
'					fn.SafeKill(c.SHARED0PATH,filename)
'			#end if
'			
'		Next
'		Log(what & "end")
'		
'	Catch
'		Log(LastException)
'	End Try
'	Return 
'	
'End Sub
'
'
'public Sub StopScheduleServices
'	
'	'CancelScheduledService(svrKiosk)    : StopService(svrKiosk)
'	'CancelScheduledService(svrAnnounce) : StopService(svrAnnounce)
'	CancelScheduledService(svrMain)     : StopService(svrMain)
'	CancelScheduledService(svrKTimers)  : StopService(svrKTimers)
''	CancelScheduledService(svrCheckWeb) : StopService(svrCheckWeb)
'	'CancelScheduledService(newinst2) : StopService(newinst2)
'	CancelScheduledService(svrHealth) : StopService(svrHealth)
'	CancelScheduledService(HttpUtils2Service) : StopService(HttpUtils2Service) '--- used by weather
'	StopService(SvcOverlayInfo)
'	
'End Sub
'
'
'public Sub NeedNewVersion(newVer As Int) As Boolean
'	Dim o_pUtils As PackageUtils
'	Dim o_pInfo As PackageInfo = o_pUtils.GetPackageInfo(o_pUtils.GetMyPackageName,2)
'	If o_pInfo.VersionCode >= newVer Then
'		Return False
'	Else
'		Return True		
'	End If
'End Sub
'
'
'public Sub getMypackageName() As String
'	Dim o_pUtils As PackageUtils
'	Return o_pUtils.GetMyPackageName
'End Sub
'
'
'
'
'public Sub Init_snapin_menu2(myMenu As AnimatedSlidingMenu)
'	'myMenu.Initialize(Activity, Me, "All Apps", "appsMenu", "R",  0dip, 300dip, g.GetColorTheme(g.ehome_clrTheme,""), Null)
'	
'	Dim clrTheme As Int = GetColorTheme(ehome_clrTheme,"")
'	Dim mnuIndex As Int	= 3
'	
'	
'	myMenu.AddItem(Null,"Home",Colors.White,clrTheme, 1 ,c.SNAPIN_MENU_HOME_NDX)
'	
'	myMenu.AddItem(Null,"Weather",Colors.White,clrTheme,2,c.SNAPIN_MENU_WEATHER_NDX)
'	If c.SNAPIN_MENU_SHOPPING_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_SHOPPING,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_SHOPPING_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_CHORES_ACTIVE Then
'		 myMenu.AddItem(Null,c.SNAPIN_MENU_CHORES,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_CHORES_NDX)
'		 mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_RECIPIES_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_RECIPIES,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_RECIPIES_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_TIMERS_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_TIMERS,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_TIMERS_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_CONVERSIONS_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_CONVERSIONS,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_CONVERSIONS_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_BUDGET_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_BUDGET,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_BUDGET_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_RADIO_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_RADIO,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_RADIO_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_MSGS_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_MSGS,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_MSGS_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_PFRAME_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_PFRAME,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_PFRAME_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	If c.SNAPIN_MENU_HA_ACTIVE Then 
'		myMenu.AddItem(Null,c.SNAPIN_MENU_HA,Colors.White,clrTheme,mnuIndex,c.SNAPIN_MENU_HA_NDX)
'		mnuIndex = mnuIndex + 1
'	End If
'	
'End Sub
'
'
'public Sub SetShadow(btn As View,OnOrOff As Boolean)
'	'dim l as snapinMappings.Get(btn)
'	Dim pnl As Panel = btn
'	Dim lbl As Label, v As View
'	For i = 0 To pnl.NumberOfViews - 1
'		v = pnl.GetView(i)
'		If v Is Label Then 
'			lbl = v
'			Dim x As Int
'			If OnOrOff Then x = 3 Else x = 0 
'			fn.SetTextShadow(lbl,x,3,3,Colors.DarkGray)
'		End If
'	Next
'End Sub
'
'
'
'
'
'public Sub RemoveOldErrFiles(folder As String, fileSpec As String) 
'	'--- can be removed in a few versions after  2.15.10
'	'--- can be removed in a few versions after  2.15.10
'	Dim lstFolder As List
'	lstFolder.Initialize
'	Log("RemoveOldErrFiles")
'	Try
'		lstFolder = fn.WildCardFilesList2(folder,"*.elog", False,False)
'		For Each filename As String In lstFolder
'			If File.IsDirectory(folder, filename) Then
'				Continue
'			End If
'			Log("Removing file.")
'			fn.SafeKill(c.SHARED0PATH,filename)
'		Next
'	Catch
'		Log(LastException)
'	End Try
'	Return 
'	
'End Sub
'
'
'public Sub ConvertLinuxLineEndings2Windows(s As String) As String
'	Return s.Replace(Chr(10),Chr(13) & Chr(10))
'End Sub
'
'Sub PINgenerate() As String
'	Dim s As StringBuilder : s.Initialize
'	s.Append(Chr(Rnd(97,123))).Append(Chr(Rnd(97,123))).Append(Chr(Rnd(97,123))).Append(Chr(Rnd(97,123))).Append(Chr(Rnd(97,123)))
'	Return s.ToString
'End Sub
'
'
'#region Colors_Theme
'
'
'public Sub PanelBgColor() As Int
'	Return Colors.ARGB(128,0,0,0)
'End Sub
'
''Themes the current panel and its children
'Public Sub ThemePanel(panelView As Panel, recursive As Boolean)
'	
'	For Each v As View In panelView.GetAllviewsRecursive		
'		
'		If (v Is CheckBox) Then
'			
'			Dim check As CheckBox = v
'			
'
'			fn.SetCBDrawable(check, GetColorTheme(ehome_clrTheme,"darkText"), 1, GetColorTheme(ehome_clrTheme,"other"), Chr(8730), Colors.LightGray, 20dip, 2dip)
'			check.TextColor = GetColorTheme(ehome_clrTheme, "darkText")
'		
'		
'		Else If(v Is Button) Then
'			Dim btn As Button = v
'			SetColorList(btn, GetColorTheme(ehome_clrTheme, "btnNormal"), _
'		    				  GetColorTheme(ehome_clrTheme, "btnPressed"), _
'		    				  GetColorTheme(ehome_clrTheme, "btnNormal"), _
'							  GetColorTheme(ehome_clrTheme ,"btnDisabled"), 9dip)
'							  
'			btn.TextColor = GetColorTheme(ehome_clrTheme, "highlightText")
'		
'		Else If (v Is ListView) Then
'			Dim lst As ListView = v
'			lst.SingleLineLayout.Label.TextColor = GetColorTheme(ehome_clrTheme,"darkText")
'		
'		Else If (v Is EditText) Then
'
'			SetColorList(v, Null, Null, Null, Null, 2dip)
'			
'		Else If (v Is Label) Then
'		
'			'Dim lbl As Label = v
'			'With light theme do we need this?
'			'lbl.TextColor = GetColorTheme(ehome_clrTheme,"darkText")
'		
'		Else If (v Is Spinner) Then
'			'--- not working
'			'Dim spin As Spinner = v
''			'With light theme do we need this?
''			spin.TextColor = GetColorTheme(ehome_clrTheme,"darkText")
''			spin.DropdownTextColor = GetColorTheme(ehome_clrTheme,"darkText")
'			
'		Else If (v Is Panel And recursive) Then
'			ThemePanel(v, True)
'		
'		End If	
'	Next
'
'End Sub
'
'
''Sets up the colors of the buttons
'Public Sub SetColorList(V As View, DefaultColor As Object, PressedColor As Object, _
'    DisabledColor As Object, FocusedColor As Object, brd_r As Int)    
'    
'    ' Receives 5 states' colors. They can be a Boolean or a String in order to disable that state
'    If(V Is Button) Then
'	    Dim sd As StateListDrawable
'	    sd.Initialize 
'	    If DisabledColor Is Int Then
'			Dim cd As ColorDrawable 
'			cd.Initialize(DisabledColor,brd_r) 
'			sd.AddState(sd.State_Disabled, cd)
'		End If
'	    If PressedColor Is Int Then
'			Dim cd As ColorDrawable 
'			cd.Initialize(PressedColor,brd_r)
'			sd.AddState(sd.State_Pressed, cd)
'		End If
'	    If FocusedColor Is Int Then
'			Dim cd As ColorDrawable 
'			cd.Initialize(FocusedColor,brd_r)
'			sd.AddState(sd.State_Focused, cd)
'		End If
'	    If DefaultColor Is Int Then ' must be the last one
'			Dim cd As ColorDrawable 
'			cd.Initialize(DefaultColor,brd_r)
'			sd.AddCatchAllState(cd)
'	    End If
'		V.Background = sd
'	Else If(V Is EditText Or V Is Label) Then
'		Dim sd As StateListDrawable
'	    sd.Initialize 
'		
'	    If DisabledColor Is Int Then
'			Dim cd As ColorDrawable 
'			cd.Initialize2(DisabledColor,brd_r,2dip,GetColorTheme(ehome_clrTheme,"darkText"))
'			sd.AddState(sd.State_Disabled, cd)
'		End If
'		If FocusedColor Is Int Then
'			Dim cd As ColorDrawable 
'			cd.Initialize2(FocusedColor,brd_r,2dip,GetColorTheme(ehome_clrTheme,"other"))
'			sd.AddState(sd.State_Focused, cd)
'		End If
'	    If DefaultColor Is Int Then ' must be the last one
'			Dim cd As ColorDrawable 
'			cd.Initialize2(DefaultColor,brd_r,2dip,GetColorTheme(ehome_clrTheme,"other"))
'			sd.AddCatchAllState(cd)
'	    End If
'		V.Background = sd
'	End If
'End Sub
'
''GET THEME'
'
'Sub GetColorTheme(theme As String,key As String) As Int
'	
'	Dim color As Int 
'	
'	Select Case theme.ToLowerCase	
'		Case "blue"
'			Select Case key		
'				Case "press"
'					color = Colors.ARGB(120, 118, 100, 255)	
'				Case "darkText"
'					color = Colors.Gray
'				Case "themeColorText"
'					color = Colors.ARGB(255, 118, 167, 255)
'				Case "btnNormal"
'					color = Colors.ARGB(240, 118, 167, 255)
'				Case "btnPressed"
'					color = Colors.ARGB(200, 118, 167, 255)
'				Case "btnDisabled"
'					color = Colors.ARGB(100, 118, 167, 255)
'				Case "highlightText"
'					color = Colors.ARGB(255,255,255,255)
'				Case "lstItemPressed"
'					color = Colors.ARGB(100,118, 167, 255)
'				Case Else
'					color = Colors.ARGB(234.5, 118, 167, 255)			
'			End Select						
'		Case "silver"
'			Select Case key		
'				Case "press"
'					color = Colors.LightGray	
'				Case "darkText"
'					color = Colors.Gray
'				Case "themeColorText"
'					color = Colors.ARGB(255, 138, 137, 137)
'				Case "btnNormal"
'					color = Colors.ARGB(240, 138, 137, 137)
'				Case "btnPressed"
'					color = Colors.ARGB(200, 138, 137, 137)
'				Case "btnDisabled"
'					color = Colors.ARGB(100, 138, 137, 137)
'				Case "highlightText"
'					color = Colors.ARGB(255,255,255,255)
'				Case "lstItemPressed"
'					color = Colors.ARGB(100,138, 137, 137)
'				Case Else
'					color = Colors.ARGB(234.5, 138, 137, 137)			
'			End Select						
'		Case Else ' Default FC color theme
'			Select Case key			
'				Case "press"
'					color = Colors.ARGB(120, 232, 75, 66)	
'				Case "darkText"
'					color = Colors.Gray
'				Case "themeColorText"
'					color = Colors.ARGB(255, 232, 142, 66)
'				Case "btnNormal"
'					color = Colors.ARGB(240, 232, 142, 66)
'				Case "btnPressed"
'					color = Colors.ARGB(200, 232, 142, 66)
'				Case "btnDisabled"
'					color = Colors.ARGB(100, 232, 142, 66)
'				Case "highlightText"
'					color = Colors.ARGB(255,255,255,255)
'				Case "lstItemPressed"
'					color = Colors.ARGB(100,232,142,66)
'				Case Else
'					color = Colors.ARGB(234.5, 232, 142, 66)			
'			End Select
'	End Select
'	
'	Return color
'	
'End Sub
'
'
'#end region
'
''--- adds the values of a map to a list
' Sub Map2List(TheMap As Map) As List
'	
'	Try
'		Dim retList As List : retList.Initialize
'		For x = 0 To TheMap.Size - 1
'			retList.Add(TheMap.GetValueAt(x))
'		Next
'		
'		Return retList
'	Catch
'		Return Null
'	End Try
'
'End Sub
'
'
''--- adds the keys of a map to a list
' Sub Map2List2(TheMap As Map) As List
'	
'	Try
'		Dim retList As List : retList.Initialize
'		For x = 0 To TheMap.Size - 1
'			retList.Add(TheMap.GetkeyAt(x))
'		Next
'		
'		Return retList
'	Catch
'		Return Null
'	End Try
'
'End Sub
'
''--- close ALL activities!!!!
''--- NEEDS TESTING
'Sub CloseActivities 'ignore
'	Dim jo As JavaObject
'	jo.InitializeContext
'	jo.RunMethod("finishAffinity", Null)
'End Sub
'
'
'Sub RenameFile(SrcDir As String, SrcFilename As String, DestDir As String, DestFilename As String) As Boolean
'    Dim R As Reflector, NewObj As Object, New As String , Old As String 
'   If SrcFilename=Null Or DestFilename=Null Or SrcDir=Null Or DestDir=Null Then Return False
'   If File.Exists(SrcDir,SrcFilename) And Not(File.Exists(DestDir,DestFilename)) Then    
'      New=File.Combine(DestDir,DestFilename)
'      Old=File.Combine(SrcDir,SrcFilename)
'      If Not(New = Old) Then
'          NewObj=R.CreateObject2("java.io.File",Array As Object(New),Array As String("java.lang.String"))
'          R.Target=R.CreateObject2("java.io.File",Array As Object(Old),Array As String("java.lang.String"))
'          Return R.RunMethod4("renameTo",Array As Object(NewObj),Array As String("java.io.File"))
'      End If
'   End If
'   Return False
'End Sub
'
'
'Sub Log2Db_HealthMessage(s As String)
'	#if release
'	LogWrite("Health: " & s,ID_LOG_MSG)
'	#else
'	LogColor("******************************************",Colors.green)
'	LogWrite4("Health: " & s,ID_LOG_MSG)
'	LogColor("******************************************",Colors.green)
'	#end if
'End Sub
'
'
'
'
'
'
'
'
'
'
'
'
'
'
