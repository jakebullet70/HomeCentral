B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic/JakeBullet
#Region VERSIONS 
' V. 1.0 	Dec/21/2023
#End Region
'Static code module
Sub Process_Globals
End Sub

Public Sub Init
End Sub


Public Sub LogWrite(txt As String, msgType As Int)
	
	#if debug
	Log("TODO - LogWrite" & txt)
	#else
	Log(txt)
	#end if
	
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
Public Sub LogWrite4(txt As String, msgType As Int)
	LogWrite(txt,msgType)
	'LogColor(txt,Colors.red)
End Sub
Public Sub LogException(LastEx As Exception,logAlways As Boolean)
	
	#if debug
	Log("TODO - LogException" & LastEx)
	#else
	Log(LastEx)
	#end if
		
'	'Dim cse As CallSubExtended
'	'cse.AsyncCallSubX(Null,"g.LogException2",Array As Object(LastEx,logAlways,""),2)
'	LogException2(LastEx,logAlways,"")
End Sub

Public Sub LogException3(LastEx As Exception,logAlways As Boolean,extraString As String)

	#if debug
	Log("TODO - LogException3" & LastEx)
	#else
	Log(LastEx)
	#end if
	
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


