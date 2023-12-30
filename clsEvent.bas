B4A=true
Group=Default Group\Generic code
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
#Region Module Attributes
	#ExcludeFromDebugger: False
	#ExcludeFromLibrary: true
#End Region


'Class module
Sub Class_Globals
	Private subscriptions As List
	Private callbacks As List
End Sub

'Initializes the event. Must be called.
Public Sub Initialize()
	subscriptions.Initialize
	callbacks.Initialize
End Sub

'Stores the infromation to create a callback (by using CallSub)
'If the target and callback combination already exist, the existing callback will be replaced with the one provided.
'
'target: The object hosting the sub to call
'callback: The string of the sub to call when this event is raised
Public Sub Subscribe(target As Object, callback As String)
	Dim index As Int = subscriptions.IndexOf(target)
	Dim addItem As Boolean
	
	addItem = index = -1
	
	If (addItem = False) Then
		If (callbacks.Get(index) <> callback) Then
			subscriptions.RemoveAt(index)
			callbacks.RemoveAt(index)
			addItem = True
		End If
	End If
	
	If (addItem) Then
		subscriptions.add(target)
		callbacks.add(callback)
	End If
End Sub

'Removes the object from the subscription list.
'
'target: The object that should be unsubscribed from the event.
Public Sub Unsubscribe(target As Object)
	Dim index As Int = subscriptions.IndexOf(target)
	If (index <> -1) Then
		subscriptions.RemoveAt(index)
		callbacks.RemoveAt(index)
	End If
End Sub

'Calls each subscriber of this event.
Public Sub Raise()
	For Each deleg As Object In subscriptions
		Dim callbackIndex As Int = subscriptions.IndexOf(deleg)
	
		CallSubDelayed(deleg, callbacks.Get(callbackIndex))
	Next 
End Sub

'Calls each subscriber of this event, providing the supplied argument.
'
'arg1: The first argument to provide to each subscriber. 
Public Sub Raise2(arg1 As Object)
	For Each deleg As Object In subscriptions
		Dim callbackIndex As Int = subscriptions.IndexOf(deleg)
	
		CallSubDelayed2(deleg, callbacks.Get(callbackIndex), arg1)
	Next 
End Sub

'Calls each subscriber of this event, providing the supplied argument.
'
'arg1: The first argument to provide to each subscriber. 
'arg2: The second argument to provide to each subscriber. 
Public Sub Raise3(arg1 As Object, arg2 As Object)
	For Each deleg As Object In subscriptions
		Dim callbackIndex As Int = subscriptions.IndexOf(deleg)
	
		CallSubDelayed3(deleg, callbacks.Get(callbackIndex), arg1, arg2)
	Next 
End Sub