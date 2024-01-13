B4A=true
Group=MiscClasses
ModulesStructureVersion=1
Type=Class
Version=5.5
@EndOfDesignText@
' Author:  sadLogic

Sub Class_Globals
	Private Const mModule As String = "guiMsgs" 'ignore
	'--- just seldom used strings in a class
	Dim Msg As StringBuilder 'ignore
	Dim xui As XUI
End Sub

Public Sub Initialize
End Sub



Public Sub BuildMainSetup() As Map
	
	Dim cs As CSBuilder 
	Dim m As Map : m.Initialize
	
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE30B)). _
				 Typeface(Typeface.DEFAULT).Append("   General Settings").PopAll,"gn")				 
	
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE859)). _
				 Typeface(Typeface.DEFAULT).Append("   Home Page Settings").PopAll,"hm")

	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE8C1)). _
				 Typeface(Typeface.DEFAULT).Append("   Weather Settings").PopAll,"wth")				 
	
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE8C1)). _
				 Typeface(Typeface.DEFAULT).Append("   Timers Settings").PopAll,"tm")				 
	
	Return m
	
End Sub



