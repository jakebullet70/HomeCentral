B4A=true
Group=MiscClasses\EventController
ModulesStructureVersion=1
Type=Class
Version=7.3
@EndOfDesignText@
'Class module
Sub Class_Globals
	Private eg As Map
End Sub

'Initializes the event. Must be called.
Public Sub Initialize()
	eg.Initialize
End Sub

'Stores the infromation to create a callback (by using CallSub)
'If the target and callback combination already exist, the existing callback will be replaced with the one provided.
'
'target: The object hosting the sub to call
'callback: The string of the sub to call when this event is raised
Public Sub Subscribe(eventName As String, CallBackObj As Object, callbackSub As String)
	
	'--- create callback obj
	Dim oo As clsEvent : oo.Initialize
	oo.Subscribe(CallBackObj,callbackSub)
	'--- will replace it if it exists
	Log("getHashCode-->"&GetHashCode(CallBackObj))
	eg.Put(eventName & "_" & GetHashCode(CallBackObj).As(String) ,oo )

End Sub


'Removes the object from the subscription list.
'
'target: The object that should be unsubscribed from the event.
Public Sub Unsubscribe(eventName As String,CallBackObj As Object)
	Dim hc As Int = GetHashCode(CallBackObj).As(String)
	If eg.ContainsKey(eventName & "_" & hc) Then
		eg.Remove(eventName & "_" & hc)
	End If
End Sub

'Calls each subscriber of this event.
Public Sub Raise(eventName As String)
	For Each en As String In eg.Keys
		If en.StartsWith(eventName & "_") Then
			Dim ov As clsEvent
			ov = eg.Get(en)
			ov.Raise
		End If
	Next
End Sub

'Calls each subscriber of this event, providing the supplied argument.
'
'arg1: The first argument to provide to each subscriber. 
Public Sub Raise2(eventName As String,arg1 As Object)
	For Each en As String In eg.Keys
		If en.StartsWith(eventName & "_") Then
			Dim ov As clsEvent
			ov = eg.Get(en)
			ov.Raise2(arg1)
			'Log(Regex.Split("_",en)(1))
		End If
	Next
End Sub

'Calls each subscriber of this event, providing the supplied argument.
'
'arg1: The first argument to provide to each subscriber. 
'arg2: The second argument to provide to each subscriber. 
Public Sub Raise3(eventName As String,arg1 As Object, arg2 As Object)
	For Each en As String In eg.Keys
		If en.StartsWith(eventName & "_") Then
			Dim ov As clsEvent
			ov = eg.Get(en)
			ov.Raise3(arg1,arg2)
		End If
	Next
End Sub


Private Sub GetHashCode(o As Object) As Int
	Dim jo2 As JavaObject = o
	Return jo2.RunMethod("hashCode", Null)
End Sub