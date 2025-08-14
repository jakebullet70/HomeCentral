B4A=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=5.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.0	July 2025
'			Code from original eHome of 2015
#End Region

Sub Class_Globals
	Private xui As XUI
	Public oSQL As SQL
End Sub

Public Sub Initialize
	oSQL = B4XPages.MainPage.sql
	
'	Try
'		oSQL.ExecNonQuery($"DROP TABLE user_menus"$)
'	Catch
'		Log(LastException)
'	End Try
	oSQL.ExecNonQuery($"CREATE TABLE IF NOT EXISTS "user_menus" (
		"id" INTEGER,
		"short_desc" TEXT,
		"package_name" TEXT, 
		"num" TEXT, 
		PRIMARY KEY("id" AUTOINCREMENT));"$)
	
'	Dim count As Int = oSQL.ExecQuerySingleResult($"SELECT COUNT(*) FROM user_menus"$)
'	If count = 0 Then
'		oSQL.ExecNonQuery($"CREATE INDEX "ndx_desc_userapps" ON "user_menus" ("description");"$)
'		'--- this will update older installs or just seed the table
'		'Dim s As String =
'		Main.kvs.Remove(gblConst.INI_WEB_HOME)
'		targets_insert_new("Home Page", _
'				Main.kvs.GetDefault(gblConst.INI_WEB_HOME,"http://sadlogic.com"),True)
'	End If
	#if debug
	Log("created userApps setup table")
	#End If
	
End Sub




Public Sub GenericIntentCall(strIntent As String) As Boolean
	Try
		Dim in As Intent
		Dim pm As PackageManager
		in = pm.GetApplicationIntent(strIntent)
		If in.IsInitialized Then
			StartActivity(in)
		End If
		'In.Flags = 268435456 'FLAG_ACTIVITY_NEW_TASK):
		'StartActivity(In)
		Return True
	Catch
		Log("failed to call - pm.GetApplicationIntent-" & strIntent)
	End Try
	Return False
	
End Sub



'======================================================================================
Public Sub Run_AndroidSettings
	Dim i As Intent
	i.Initialize("", "")
	i.SetComponent("com.android.settings/.Settings")
	StartActivity(i)
End Sub


#Region USER_MENU_CRAP

Private Sub UserMenu(num As Int, caption As String, longClick As Boolean)
	
	Select Case True
		'Case caption.Length = 0 AND longClick = False
		'--- un-assigned key and blank
		'--- do nothing
	
		Case caption.Length <> 0 And longClick = False
			'--- assigened key
			UserMenuProcessKey(num)
		
		Case longClick = True
			'--- bring up the user menu key tool thingy
		'	Dim o9 As popUserMenuEdit
		'	o9.Initialize(act, g.Int2Str(num),caption)
			
	End Select

End Sub


Private Sub UserMenuProcessKey(num As Int)

	'Try
		
	Dim rs As Cursor = oSQL.ExecQuery2( _
			"SELECT package_name FROM user_menus WHERE num = ?", _
			Array As String(num))
		
	If rs.RowCount = 0 Then
		'--- this should never be blank
		Log("UserMenuProcessKey: no entry found in table!" & num)
		Return
	End If
		
	rs.Position = 0
	LogColor("Pack name: " & rs.GetString("package_name"),Colors.Magenta)
	Dim pm As PackageManager
	Dim it As Intent = pm.GetApplicationIntent(rs.GetString("package_name"))
	If it.IsInitialized Then StartActivity(it)
	'Catch
	'	g.LogException(LastException,False)
	'End Try

End Sub


Private Sub Add3rdPartyApp2Menu(num As Int) As String 'ignore
	Try

		Dim cur As Cursor = oSQL.ExecQuery2( _
				"SELECT * FROM user_menus WHERE short_desc <> ? AND num = ?", _
				Array As String("",num))
					
		If cur.RowCount = 0 Then
			Return ""
		End If
		cur.Position = 0
		Return cur.GetString("short_desc")
		
	Catch
		Log(LastException)
	End Try
	

End Sub



#End Region



'================= Code from old ehome to add / remove external apps from table -------
'================= Code from old ehome to add / remove external apps from table -------
'================= Code from old ehome to add / remove external apps from table -------
'================= Code from old ehome to add / remove external apps from table -------
'================= Code from old ehome to add / remove external apps from table -------
'================= Code from old ehome to add / remove external apps from table -------


'
'Private Sub GetDataFromINI
'	
'	Dim rs As Cursor = g.oSQL.ExecQuery2( _
'		"SELECT * FROM user_menus WHERE num = ?", _
'		Array As String(currBtnNum))
'		
'	If rs.RowCount = 0 Then
'		'--- this should never be blank
'		g.LogWrite("popUserMenuEdit:GetData: no Data found for " & currBtnNum ,g.ID_LOG_MSG)
'		Return
'	End If
'		
'	rs.Position = 0
'	txtShort.Text = rs.GetString("short_desc")
'	lblSelectedPRG.Tag  = rs.GetString("Package_name")
'	lblSelectedPRG.Text = pm.GetApplicationLabel(lblSelectedPRG.Tag)
'	
'End Sub
'
'Private Sub LoadInstalledApps
'	Dim args(1) As Object
'	Dim Obj1, Obj2, Obj3 As Reflector
'	Dim size, i, flags As Int
'	Dim Types(1), name,packName As String
'	Dim icon As BitmapDrawable
'	Obj1.Target = Obj1.GetContext
'	Obj1.Target = Obj1.RunMethod("getPackageManager") ' PackageManager
'	Obj2.Target = Obj1.RunMethod2("getInstalledPackages", 0, "java.lang.int") ' List<PackageInfo>
'	size = Obj2.RunMethod("size")
'	For i = 0 To size -1
'	
'		Obj3.Target = Obj2.RunMethod2("get", i, "java.lang.int") ' PackageInfo
'		packName = Obj3.GetField("packageName")
'		
'		Obj3.Target = Obj3.GetField("applicationInfo") ' ApplicationInfo
'		flags = Obj3.GetField("flags")
'		
'		flags = Obj3.GetField("flags")
'		
'		If Bit.And(flags, 1)  = 0 Then
'			'app is not in the system image
'			args(0) = Obj3.Target
'			Types(0) = "android.content.pm.ApplicationInfo"
'			name = Obj1.RunMethod4("getApplicationLabel", args, Types)
'			icon = Obj1.RunMethod4("getApplicationIcon", args, Types)
'			lv.AddTwoLinesAndBitmap2(name,"",icon.Bitmap,packName)
'		End If
'	Next
'End Sub
'
'
'Private Sub lv_ItemClick (Position As Int, Value As Object)
'
'	CallSubDelayed(svrMain,"ResetScrn_SleepCounter")
'	Dim i As String = Value
'	lblSelectedPRG.tag = i
'	lblSelectedPRG.Text = pm.GetApplicationLabel(i)
'	txtShort.Text = ""
'	oKB.ShowKeyboard(txtShort)
'	txtShort.RequestFocus
'	
'End Sub
'
'Sub btnSave_Click
'	
'	
'	If txtShort.Text = "" Then
'		g.ToastMessageShowX("Please enter a short description.",True)
'		Return
'	End If
'	
'	If lblSelectedPRG.Tag = "" Then
'		g.ToastMessageShowX("Please select a program.",True)
'		Return
'	End If
'	
'	
'	g.oSQL.ExecNonQuery2( _
'			"UPDATE user_menus SET short_desc=?,package_name=? WHERE num=?", _
'			Array As String(txtShort.Text,lblSelectedPRG.Tag,currBtnNum))
'	
'	'Dim writeME As String = txtShort.Text & userMenuParseChars & lblSelectedPRG.Tag
'	'g.INIWrite(c.INI_CONST_MENUKEYS,currBtnNum,writeME)
'	CallSub(Main,"ReInitMenuInHomeScrn")
'	Close
'	
'End Sub
'
'Sub btnClear_Click
'
'	dg.AskYesNo(act,"Question","Clear this key mapping?",act.Height / 5,Me,"ClearItemsOk_clicked","")
'
'End Sub
'
'Sub ClearItemsOk_clicked
'	
'	g.oSQL.ExecNonQuery2( _
'		"UPDATE user_menus SET short_desc='',package_name='' WHERE num=?", _
'		Array As String(currBtnNum))
'	
'	CallSub(Main,"ReInitMenuInHomeScrn")
'	Close
'	
'End Sub
'	

