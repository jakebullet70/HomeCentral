B4A=true
Group=B4XcustomClasses
ModulesStructureVersion=1
Type=Class
Version=5.5
@EndOfDesignText@
' Author:  B4X / Tweaked by sadLogic
#Region VERSIONS 
' V. 1.4	Apr/22/2025
'			Added GoingDown flag to the destroy method.
' V. 1.3	Jan/23/2024
'			Added destroy method, really should not be needed but hey, nuke the obj it just to be sure.  :)
' V. 1.2	Jan/08/2024
'			Added ExistsRemoveAdd_DelayedPlus2, ExistsRemoveAdd_DelayedPlus methods
' V. 1.1	Aug/20/2023
'			Added Exists and ExistsRemove methods
' V. 1.0 From https://www.b4x.com/android/forum/threads/b4x-callsubplus-callsub-with-explicit-delay.60877/#content
#End Region

'Class module
Sub Class_Globals
	Private RunDelayed As Map, GoingDown As Boolean = False
	Type RunDelayedData (Module As Object, SubName As String, Arg() As Object, Delayed As Boolean)
End Sub

Public Sub Initialize
	RunDelayed.Initialize
End Sub

Public Sub Destroy
	'--- remove any timers if they are there
	GoingDown = True
	RunDelayed.Clear
End Sub


'------------------------------ Added  ----------------------------------------------------
Public Sub ExistsRemoveAdd_DelayedPlus(Module As Object, SubName As String,Delay As Int)
	
	If GoingDown Then Return
	ExistsRemove(Module, SubName)
	CallSubDelayedPlus(Module,SubName,Delay)
	
End Sub

Public Sub ExistsRemoveAdd_DelayedPlus2(Module As Object, SubName As String,Delay As Int, Arg() As Object)
	
	If GoingDown Then Return
	ExistsRemove(Module, SubName)
	CallSubDelayedPlus2(Module,SubName,Delay,Arg)
	
End Sub

Public Sub ExistsRemove(Module As Object, SubName As String) 
	
	If GoingDown Then Return
	Dim t As Timer = Exists(Module,SubName) 
	If t <> Null Then 
		t.Enabled = False
		RunDelayed.Remove(t)
	End If
	
End Sub
Public Sub Exists(Module As Object, SubName As String) As Timer
	
	If GoingDown Then Return
	If RunDelayed.IsInitialized <> False Then 
		For Each t As Timer In RunDelayed.Keys
			Dim dt As RunDelayedData = RunDelayed.Get(t)
			If dt.SubName = SubName And dt.Module = Module Then
				'Log("tmr already here")
				Return t
			End If
		Next
	End If
	Return Null
	
End Sub
'-------------------------------------------------------------------------------------------


'Similar to CallSubDelayed. This method allows you to set the delay (in milliseconds).
'Note that the sub name must include an underscore if compiled with obfuscation enabled.
Public Sub CallSubDelayedPlus(Module As Object, SubName As String, Delay As Int)
	If GoingDown Then Return
	CallSubDelayedPlus2(Module, SubName, Delay, Null)	
End Sub

'Similar to CallSubDelayed. This method allows you to set the delay (in milliseconds).
'Note that the sub name must include an underscore if compiled with obfuscation enabled.
'The target sub should have one parameter with a type of Object().
Public Sub CallSubDelayedPlus2(Module As Object, SubName As String, Delay As Int, Arg() As Object)
	If GoingDown Then Return
	PlusImpl(Module, SubName, Delay, Arg, True)
End Sub

'Similar to CallSub. This method allows you to set the delay (in milliseconds).
'Note that the sub name must include an underscore if compiled with obfuscation enabled.
Public Sub CallSubPlus(Module As Object, SubName As String, Delay As Int)
	If GoingDown Then Return
	CallSubPlus2(Module, SubName, Delay, Null)	
End Sub

'Similar to CallSub. This method allows you to set the delay (in milliseconds).
'Note that the sub name must include an underscore if compiled with obfuscation enabled.
'The target sub should have one parameter with a type of Object().
Public Sub CallSubPlus2(Module As Object, SubName As String, Delay As Int, Arg() As Object)
	If GoingDown Then Return
	PlusImpl(Module, SubName, Delay, Arg, False)
End Sub

Private Sub PlusImpl(Module As Object, SubName As String, Delay As Int, Arg() As Object, delayed As Boolean)
	'If RunDelayed.IsInitialized = False Then RunDelayed.Initialize
	If GoingDown Then Return
	Dim tmr As Timer
	tmr.Initialize("tmr", Delay)
	Dim rdd As RunDelayedData
	rdd.Module = Module
	rdd.SubName = SubName
	rdd.Arg = Arg
	rdd.delayed = delayed
	RunDelayed.Put(tmr, rdd)
	tmr.Enabled = True
	
	#if debug
	WhatEvents("Added")
	#End If
	
End Sub

Private Sub tmr_Tick
	If GoingDown Then Return
	Dim t As Timer = Sender
	t.Enabled = False
	Dim rdd As RunDelayedData = RunDelayed.Get(t)
	RunDelayed.Remove(t)
	
	#if debug
	Log("calSubDelayed subs fired! --> " & rdd.SubName)
	#End If
	
	If rdd.Delayed Then
		If rdd.Arg = Null Then
			CallSubDelayed(rdd.Module, rdd.SubName)
		Else
			CallSubDelayed2(rdd.Module, rdd.SubName, rdd.Arg)
		End If
	Else
		If rdd.Arg = Null Then
			CallSub(rdd.Module, rdd.SubName)
		Else
			CallSub2(rdd.Module, rdd.SubName, rdd.Arg)
		End If
	End If
	
	#if debug
	WhatEvents("left in queue")
	#End If
		
End Sub

#if debug
Private Sub WhatEvents(what As String)
	If GoingDown Then Return
	Log("------------------ " & what)
	For Each t As Timer In RunDelayed.Keys
		Dim dt As RunDelayedData = RunDelayed.Get(t)
		Log("calSubDelayed subs still alive --> " & dt.SubName)
	Next
	Log("------------------------------------")
End Sub
#End If

