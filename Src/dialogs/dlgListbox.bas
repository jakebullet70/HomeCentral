B4A=true
Group=Dialogs
ModulesStructureVersion=1
Type=Class
Version=11.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
' V. 1.1 		jan/13/2024
'				Cleanup / refactor
' V. 1.0 	Aug/13/2022
'				1st run!
#End Region

Sub Class_Globals
	
	Private mpage As B4XMainPage = B4XPages.MainPage 'ignore
	Private xui As XUI
	Private mTitle As Object
	Private mCallback As Object
	Private mEventName As String
	Private mTag As Object = Null 'ignore
	
	Private mDialog As B4XDialog
	
	Public IsMenu As Boolean = False
	
End Sub


Public Sub setTag(v As Object)
	mTag = v
End Sub

Public Sub Initialize( title As Object, Callback As Object, EventName As String,dlg As B4XDialog) As Object
	
	mTitle = title
	mCallback = Callback
	mEventName = EventName
	mDialog = dlg
	Return Me
	
End Sub


Public Sub Show(height As Float, width As Float, data As Map)
	
	'--- init
	mDialog.Initialize(mpage.Root)
	Dim ListTemplate As B4XListTemplate : ListTemplate.Initialize
	Dim dlgHelper As sadB4XDialogHelper
	dlgHelper.Initialize(mDialog)
	
	'--- make it pretty
	ListTemplate.CustomListView1.DefaultTextBackgroundColor = clrTheme.Background

	'--- setup control
	ListTemplate.Resize(width, height)
	ListTemplate.CustomListView1.AsView.width = width
	ListTemplate.CustomListView1.AsView.Height = height
	ListTemplate.CustomListView1.PressedColor = clrTheme.BackgroundHeader
	ListTemplate.CustomListView1.DefaultTextColor = clrTheme.txtNormal
	ListTemplate.options = objHelpers.Map2List(data,True)
	
	
	Dim l As B4XView = ListTemplate.CustomListView1.DesignerLabel
	l.Font = xui.CreateDefaultFont(NumberFormat2(30 / guiHelpers.gFscale,1,0,0,False))
	
	dlgHelper.ThemeDialogForm( mTitle)
	Dim rs As ResumableSub = mDialog.ShowTemplate(ListTemplate, "", "",IIf(IsMenu,"CLOSE","CANCEL"))
	dlgHelper.ThemeDialogBtnsResize
	
	'--- display dialog
	Wait For(rs) complete(i As Int)
	If i = xui.DialogResponse_Positive Then
		CallSub3(mCallback,mEventName,GetTagFromMap(ListTemplate.SelectedItem,data),mTag)
	Else
		CallSub3(mCallback,mEventName,"","")
	End If
	
	mpage.tmrTimerCallSub.CallSubDelayedPlus(Main,"Dim_ActionBar_Off",300)
	
	
End Sub


Private Sub GetTagFromMap(item As String,d As Map) As String
	'---  item is a string built with csbuilder, needs to
	'--- found this way
	For xx = 0 To d.Size - 1
		If d.GetKeyAt(xx).As(String).Contains(item) Then
			Return d.GetValueAt(xx)
		End If
	Next
	Return ""
End Sub




