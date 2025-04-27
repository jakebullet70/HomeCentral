ECHO OFF
ECHO -------- start builds -----------------
c:
cd C:\dev\b4x\src\HomeCentral\b4a

del *.apk 
del HomeCentral_java_src*.7z 

ECHO ------------- FOSS ------------------
"C:\Program Files\Anywhere Software\B4A\B4ABuilder.exe" -task=build -Optimize=true -Output=HomeCentral
copy Objects\*.apk 
..\7z a -t7z -r HomeCentral_java_src_foss.7z "Objects\src\*.*"

ECHO ------------ copy to root ------------
copy *.apk ..\*.*
copy *.7z ..\*.*

del *.apk 
del HomeCentral_java_src*.7z 

ECHO -------------- end --------------------
pause
