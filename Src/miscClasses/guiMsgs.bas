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
	
	'm.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE88A)). _
	'			 Typeface(Typeface.DEFAULT).Append("   Home Page Settings").PopAll,"hm")

	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xEB46)). _
				 Typeface(Typeface.DEFAULT).Append("   Weather Settings").PopAll,"wth")				 
	
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE425)). _
				 Typeface(Typeface.DEFAULT).Append("   Timers Settings").PopAll,"tm")				 
	
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.FONTAWESOME).VerticalAlign(6dip).Append(Chr(0xF03E)). _
				 Typeface(Typeface.DEFAULT).Append("   Picture Album Settings").PopAll,"pic")				 

	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE894)). _
				 Typeface(Typeface.DEFAULT).Append("   Web Page Settings").PopAll,"wb")				 
	
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE859)). _
				 Typeface(Typeface.DEFAULT).Append("   Android Settings").PopAll,"as")				 
				 
	m.Put(cs.Initialize.Append(" ").Typeface(Typeface.MATERIALICONS).VerticalAlign(6dip).Append(Chr(0xE05E)). _
				 Typeface(Typeface.DEFAULT).Append("   Check For Update").PopAll,"up")				 
				 
	Return m
	
End Sub


Public Sub BuildKitchenTimerPresets() As Map
	Dim cursor As Cursor = kt.timers_get_all
	Dim m As Map : m.Initialize
	For i = 0 To cursor.RowCount - 1
		cursor.Position = i
		m.Put(cursor.GetString("time") & "-" & cursor.GetString("description"),cursor.GetString("id"))
	Next
	Return m
End Sub