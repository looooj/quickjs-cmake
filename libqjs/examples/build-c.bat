@echo off

%~d0
cd %~p0
call cmakepath
set cdir=%~p0
set gen="0"
set build="0"
set cfg="Debug"
set target=
set arg=
set x86_x64=-DCMAKE_GENERATOR_PLATFORM=Win32
set x86_x64=-DCMAKE_GENERATOR_PLATFORM=x64

:checkArg
if "x%1" == "x" goto checkArgEnd
set arg="%1"
set isTarget="1"
shift
if %arg% == "x64" set x86_x64=-DCMAKE_GENERATOR_PLATFORM=x64
if %arg% == "x86" set x86_x64=-DCMAKE_GENERATOR_PLATFORM=Win32
if %arg% == "x64" set isTarget="0"
if %arg% == "x86" set isTarget="0"
if %arg% == "g" set isTarget="0"
if %arg% == "mg" set isTarget="0"
if %arg% == "b" set isTarget="0"
if %arg% == "r" set isTarget="0"
if %isTarget% == "1" goto setTarget

if %arg% == "g" set gen="1"
if %arg% == "mg" set gen="mg" 
if %arg% == "b" set build="1"
if %arg% == "r" set cfg="Release"
goto checkArg

:setTarget
set target=%arg%
goto checkArg
:checkArgEnd

:genMingw
if %gen% == "0" goto build
if %gen% == "1" goto gen

echo "need setup mingw env..."
rd  /s /q cmake-tmp  > NUL 2>&1
md cmake-tmp > NUL 2>&1
del cmake-tmp\*.* /s /q > NUL 2>&1
cd cmake-tmp 
rem call mingpath
cmake  -G "MinGW Makefiles" ..
cd %cdir%

goto build

:gen
if %gen% == "0" goto build
echo "gen ..."
rd  /s /q cmake-tmp > NUL 2>&1
md cmake-tmp > NUL 2>&1 
del cmake-tmp\*.* /s /q > NUL 2>&1
cd cmake-tmp
cmake %x86_x64% .. 
cd %cdir%

:build
if  %build% == "0" goto end
if "%target%x" == "x" goto buildAll
cd %cdir%
md cmake-tmp
cd cmake-tmp
cmake --build . --config %cfg% --target %target%
cd %cdir%
goto end

:buildAll
cd %cdir%
md cmake-tmp
cd cmake-tmp
cmake --build . --config %cfg% 
cd %cdir%
goto end

:end
cd %cdir%






