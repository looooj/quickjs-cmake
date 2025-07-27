
%~d0
cd %~p0
setlocal
call cmakepath
set cdir=%~p0
set xarch=%1
set xsource_version=%2
set xbuild_type=%3%
set xgen=%4%

if "t%xsource_version%" == "t" set xsource_version=2023-12-09
if "t%xbuild_type%" == "t" set xbuild_type=Release

rd  /s /q cmake-tmp  > NUL 2>&1
md cmake-tmp > NUL 2>&1
del cmake-tmp\*.* /s /q > NUL 2>&1
cd cmake-tmp 
call cmake-mingw%xarch%-var.bat
cmake -DCMAKE_FIND_ROOT_PATH=%_MINGW_PATH_% ^
-DCMAKE_MAKE_PROGRAM=%_MINGW_MAKE_% ^
-DQJS_SOURCE_VERSION=%xsource_version% ^
-DCMAKE_BUILD_TYPE=%xbuild_type% ^
-G "MinGW Makefiles" ..



if not "t%xgen%" == "t" goto xend
rem goto xend

cd %cdir%
md cmake-tmp
cd cmake-tmp
cmake --build . --target qjs_copy_lib 
cd %cdir%
md dist
md dist\%xsource_version%
md dist\%xsource_version%\include
copy ..\quickjs-%xsource_version%\*.h dist\%xsource_version%\include


:xend


