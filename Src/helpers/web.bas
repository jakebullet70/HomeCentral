﻿B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' July/2025
'    Support code for web snapin
'
#End Region
'Static code module
Sub Process_Globals
	'Private XUI As XUI
	Private oSQL As SQL	
	Private inited As Boolean = False
End Sub

'------------------------------------------------------------------------------------
'------------------------------------------------------------------------------------


Public Sub InitSql
	
	If inited Then Return
	inited = True
	
	oSQL = B4XPages.MainPage.sql
'	Try
'		oSQL.ExecNonQuery($"DROP TABLE web_targets"$)
'	Catch
'		Log(LastException)
'	End Try
	oSQL.ExecNonQuery($"CREATE TABLE IF NOT EXISTS "web_targets" (
		"id" INTEGER,
		"description" TEXT,
		"addr" TEXT, 
		"home_page" TEXT, 
		PRIMARY KEY("id" AUTOINCREMENT));"$)
	'Log(oSQL.ExecQuerySingleResult($"SELECT COUNT(*) FROM timers"$))
	Dim count As Int = oSQL.ExecQuerySingleResult($"SELECT COUNT(*) FROM web_targets"$)
	If count = 0 Then
		oSQL.ExecNonQuery($"CREATE INDEX "ndx_desc_web" ON "web_targets" ("description");"$)
		'--- this will update older installs or just seed the table
		'Dim s As String = 
		Main.kvs.Remove(gblConst.INI_WEB_HOME)
		targets_insert_new("Home Page", _
				Main.kvs.GetDefault(gblConst.INI_WEB_HOME,"http://sadlogic.com"),True)
	End If
	#if debug
	Log("created web setup table")
	#End If
End Sub



'Public Sub targets_is_home_page(id As Int) As Boolean
'	Return IIf( _
'		oSQL.ExecQuerySingleResult("SELECT home_page FROM web_targets WHERE id=" & id)="1", _
'		True,False)
'End Sub


Public Sub targets_clear_home_page
	'--- its a small table, not like there will be a performance issue
	oSQL.ExecNonQuery($"UPDATE web_targets SET home_page = "";"$)
End Sub


Public Sub targets_set_home_page(id As Int)
	oSQL.ExecNonQuery($"UPDATE web_targets SET home_page = "1" WHERE id="$ & id)
End Sub


Public Sub targets_insert_new(desc As String, address As String,home_page As Boolean)
	oSQL.ExecNonQuery2($"INSERT INTO web_targets 
						("description","addr",home_page) VALUES (?,?,?);"$, _
						Array As String(desc,address,IIf(home_page,"1","")))
End Sub


Public Sub targets_update(desc As String, address As String, recid As Int)
	oSQL.ExecNonQuery2($"UPDATE "web_targets" SET description = ?,addr = ? WHERE id = ?;"$, _
						Array As String(desc,address,recid))
End Sub


Public Sub targets_delete(id As String)
	oSQL.ExecNonQuery("DELETE FROM web_targets WHERE id=" & id)
End Sub


Public Sub targets_get_all() As Cursor
	Return oSQL.ExecQuery("SELECT * FROM web_targets ORDER BY description")
End Sub




