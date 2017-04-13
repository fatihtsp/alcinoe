@echo off

setlocal

REM -----------------------------------------------------
REM
REM Update the path below according to your system
REM Please notice that we use the SDK of Marshmallow (23)
REM instead of the default lollipop (22) used by Delphi
REM Berlin. This because we want the text selection
REM like https://developer.android.com/about/versions/marshmallow/android-6.0-changes.html#behavior-text-selection
REM Please install the SDK build tools and the SDK Platform 
REM of Marshmallow (23) using C:\Users\Public\Documents\Embarcadero\Studio\18.0\PlatformSDKs\android-sdk-windows\SDK Manager.exe
REM
REM -----------------------------------------------------

if x%ANDROID% == x set ANDROID="C:\Users\Public\Documents\Embarcadero\Studio\18.0\PlatformSDKs\android-sdk-windows"
set ANDROID_PLATFORM=%ANDROID%\platforms\android-23
set JDK_PATH="C:\Program Files\Java\jdk1.7.0_25\bin"
set CONFIRM=%1
if x%CONFIRM% == x set CONFIRM=on

SET FileName=lib\jar\bolts\*.jar
del %FileName% /s
if exist %FileName% goto ERROR

SET FileName=source\output
IF EXIST %FileName% rmdir /s /q %FileName%
IF EXIST %FileName% goto ERROR

echo Compiling the Java Sources
mkdir source\output 2> nul
%JDK_PATH%\javac -Xlint:deprecation -cp^
 %ANDROID_PLATFORM%\android.jar;^
lib\jar\facebook\facebook-android-sdk.jar;^
 -d source\output^
 bolts-tasks\src\main\java\bolts\*.java^
 bolts-applinks\src\main\java\bolts\*.java
IF ERRORLEVEL 1 goto ERROR

echo Creating jar containing the new classes
%JDK_PATH%\jar cf bolts.jar -C source\output bolts
IF ERRORLEVEL 1 goto ERROR

SET FileName=source\output
IF EXIST %FileName% rmdir /s /q %FileName%
IF EXIST %FileName% goto ERROR

echo Jar created successfully
if x%CONFIRM% == xon PAUSE 
goto EXIT

:ERROR
pause

:EXIT

endlocal