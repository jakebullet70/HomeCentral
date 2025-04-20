B4J=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
' Author:  sadLogic/JakeBullet and AI...
' Stupid AI, took over an hour with me telling it what was wrong like 10 times
' and it writing new code for me to test just to tell it it was wrong again.
'
#Region VERSIONS 
' V. 1.0 	Apr/2025
'
' Adds a highlight bar to a Java listview control
'
#End Region


Sub Class_Globals
	Public selectedIndex As Int = -1
	Private lv As ListView
End Sub

Public Sub Initialize(lst As ListView)	
	lv = lst
	Private jo = lst As JavaObject
	Private cdw As ColorDrawable
	cdw.Initialize(clrTheme.Background, clrTheme.txtNormal)
	jo.RunMethod("setSelector", Array(cdw))
End Sub


Public Sub ProgrammaticallyClickAndHighlight(index As Int)
	lv.SetSelection(index)
	Sleep(200) ' Wait for scroll to complete
	ClickListViewItem(index)
End Sub
'
Sub ClickListViewItem(index As Int)
	Dim joLV As JavaObject = lv
	Dim firstVisible As Int = joLV.RunMethod("getFirstVisiblePosition", Null)
	Dim relativeIndex As Int = index - firstVisible
    
	If relativeIndex < 0 Or relativeIndex >= joLV.RunMethod("getChildCount", Null) Then
		'Log("Item is not currently visible.")
		Return
	End If

	Dim itemView As JavaObject = joLV.RunMethod("getChildAt", Array(relativeIndex))
	If itemView.IsInitialized Then
		' Make sure the ID is passed as a Long
		Dim itemId As Long = index
		'Dim clicked As Boolean = joLV.RunMethod("performItemClick", Array(itemView, index, itemId))
		joLV.RunMethod("performItemClick", Array(itemView, index, itemId))
		'Log("Click performed: " & clicked)
	End If
End Sub

Public Sub ItemClick (Position As Int, Value As Object)
   
	' Remove highlight from previously selected item
	If selectedIndex <> -1 Then
		Dim joLV As JavaObject = lv
		Dim firstVisible As Int = joLV.RunMethod("getFirstVisiblePosition", Null)
		Dim oldRelativeIndex As Int = selectedIndex - firstVisible
		If oldRelativeIndex >= 0 And oldRelativeIndex < joLV.RunMethod("getChildCount", Null) Then
			Dim oldView As JavaObject = joLV.RunMethod("getChildAt", Array(oldRelativeIndex))
			oldView.RunMethod("setBackgroundColor", Array(Colors.Transparent))
		End If
	End If

	' Highlight the new selected item
	Dim joLV As JavaObject = lv
	Dim firstVisible As Int = joLV.RunMethod("getFirstVisiblePosition", Null)
	Dim relativeIndex As Int = Position - firstVisible
	If relativeIndex >= 0 And relativeIndex < joLV.RunMethod("getChildCount", Null) Then
		Dim newView As JavaObject = joLV.RunMethod("getChildAt", Array(relativeIndex))
		newView.RunMethod("setBackgroundColor", Array(clrTheme.Background))
	End If

	selectedIndex = Position
	'ToastMessageShow("Clicked: rec ID:" & Value, False)
End Sub
