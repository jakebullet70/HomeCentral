﻿B4J=true
Group=Helpers
ModulesStructureVersion=1
Type=StaticCode
Version=9.5
@EndOfDesignText@
' Author:  sadLogic
#Region VERSIONS 
'V.	1.1	Apr/5/2023
'				Added copyObject method				
' V. 	1.0 	Jun/7/2022
#End Region
'Static code module
Sub Process_Globals
	Private Const mModule As String = "objHelper" 'ignore
End Sub


'--- uses B4XSerializator
Public Sub Map2Disk2(folder As String, filename As String,m As Map)
	Dim ser As B4XSerializator '--- in the RandomAccessFile jar
	File.WriteBytes(folder, filename, ser.ConvertObjectToBytes(m))
End Sub
'--- uses B4XSerializator
Public Sub MapFromDisk2(folder As String, filename As String) As Map
	Dim ser As B4XSerializator '--- in the RandomAccessFile jar
	Return ser.ConvertBytesToObject(File.ReadBytes(folder, filename))
End Sub


'--- uses B4XSerializator
Public Sub List2Disk(folder As String, filename As String,lst As List)
	Dim ser As B4XSerializator '--- in the RandomAccessFile jar
	File.WriteBytes(folder, filename, ser.ConvertObjectToBytes(lst))
End Sub
'--- uses B4XSerializator
Public Sub ListFromDisk(folder As String, filename As String) As List
	Dim ser As B4XSerializator '--- in the RandomAccessFile jar
	Return ser.ConvertBytesToObject(File.ReadBytes(folder, filename))
End Sub


Public Sub List2StrArray(lst As List) As String()
	
	Dim ret(lst.Size) As String
	For index=0 To lst.Size - 1
		ret(index) = lst.Get(index)
	Next
	Return ret
	
End Sub

Public Sub Map2Json(m As Map) As String
	
	Dim gen As JSONGenerator
	gen.Initialize(m)
	Return gen.ToString
	
End Sub

public Sub List2Json(lst As List) As String
	
	Dim gen As JSONGenerator
	gen.Initialize2(lst)
	Return gen.ToString
	
End Sub

'Convert a map into a list
'if KeyList = True, then return a list of keys, otherwise a list of values
public Sub Map2List(myMap As Map, KeyList As Boolean) As List
	Dim lst As List : lst.Initialize
	If KeyList Then
		For Each item As Object In myMap.Keys
			lst.Add(item)
		Next
	Else
		For Each item As Object In myMap.Values
			lst.Add(item)
		Next
	End If
	Return lst
End Sub


Public Sub CopyObject(SourceObject As Object) As Object 'ignore
	'--- Note that not all types are supported. Supported types are: primitives, strings, lists, maps, arrays of objects or bytes, 
	'--- custom types and any combination of those (a map that holds arrays of custom types).
	'https://www.b4x.com/android/forum/threads/copying-an-object-not-just-a-reference.12816/#post-412984
	Dim s As B4XSerializator
	Return s.ConvertBytesToObject(s.ConvertObjectToBytes(SourceObject))
End Sub

Public Sub CopyMap(original As Map) As Map 'ignore
	Return CopyObject(original)
End Sub


Public Sub ConcatMaps(maps() As Map) As Map 'ignore
	Dim retMap As Map : retMap.Initialize
	For Each m As Map In maps
		For Each k As Object In m.Keys
			retMap.Put(k, m.Get(k))
		Next
	Next
	Return retMap
End Sub






