@echo off
:ServerCredent
set /p ServerName=Enter the sql server instance name: 
set /p User=Enter the user: 
set /p Passwd=Enter the Password: 
set /p DB=Enter the Database Name:  
sqlcmd.exe -S "%ServerName%" -U "%User%" -P %Passwd% -d "%DB%" -h-1 -Q "SET NOCOUNT ON; SELECT top 1  BuildVersion FROM znodeMultifront Order by MultifrontId DESC" -o output.txt
set /p recCount= < output.txt
del output.txt
IF  []==%recCount% (
echo server credential not valid... 
goto :ServerCredent 
)
echo Connected Sucessfully...
set mypath=%cd%
IF  90340==%recCount% (
goto :Execute4 
)
:FileFolder
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'Please select folder having upgrade sql files...',0,0).self.path""

for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
setlocal enabledelayedexpansion
IF  902114==%recCount% (
goto :Execute3
)
IF  90246==%recCount% (
goto :Execute2
)
IF  90175==%recCount% (
 goto :Execute1
)
 :Execute1
IF NOT EXIST "%folder%\UpgradeScriptFrom901To902.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom901To902.sql"
 goto :FileFolder
)
set "folder1=%folder%\UpgradeScriptFrom901To902.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder1%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute2
IF NOT EXIST "%folder%\UpgradeScriptFrom902To903.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom902To903.sql"
 goto :FileFolder
)
set "folder2=%folder%\UpgradeScriptFrom902To903.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder2%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute3
IF NOT EXIST "%folder%\UpgradeScriptFrom903To904.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom903To904.sql"
 goto :FileFolder
)
set "folder3=%folder%\UpgradeScriptFrom903To904.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder3%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute4
IF NOT EXIST "%folder%\UpgradeScriptFrom904To9051.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom904To9051.sql"
 goto :FileFolder
)
set "folder3=%folder%\UpgradeScriptFrom904To9051.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder3%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute5
IF NOT EXIST "%folder%\UpgradeScriptFrom9051To906.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom9051To906.sql"
 goto :FileFolder
)
set "folder3=%folder%\UpgradeScriptFrom9051To906.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder3%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute6
IF NOT EXIST "%folder%\UpgradeScriptFrom906To910.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom906To910.sql"
 goto :FileFolder
)
set "folder3=%folder%\UpgradeScriptFrom906To910.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder3%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute7
IF NOT EXIST "%folder%\UpgradeScriptFrom910To911.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom910To911.sql"
 goto :FileFolder
)
set "folder3=%folder%\UpgradeScriptFrom910To911.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder3%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute8
IF NOT EXIST "%folder%\UpgradeScriptFrom911To920.sql" (
 echo You chose %folder%
 echo folder not contain upgrade file "UpgradeScriptFrom911To920.sql"
 goto :FileFolder
)
set "folder3=%folder%\UpgradeScriptFrom911To920.sql"
sqlcmd.exe -S "%ServerName%" -U "%User%" -P !Passwd! -d "%DB%" -h-1 -i "%folder3%" -o output.txt 
for /f %%i in ("output.txt") do set size=%%~zi
if %size% gtr 0 (
Start notepad "output.txt"
)
pause
del output.txt
:Execute9
echo Your database is up-to-date.
pause
endlocal
goto :EOF

