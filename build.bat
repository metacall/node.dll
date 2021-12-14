@echo on

rem NodeJS Version
set NODEJS_VERSION=%1

rem Use all the cores when building
set CL=/MP

set loc=%cd%

echo Checking Compiler and Build System

rem Install NASM
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-win64.zip', './nasm.zip')" || goto :error
powershell -Command "$global:ProgressPreference = 'SilentlyContinue'; Expand-Archive" -Path "nasm.zip" -DestinationPath . || goto :error
set PATH=%PATH%;%loc%\nasm-2.15.05;%loc%\nasm-2.15.05\rdoff
del nasm.zip

echo Downloading Dependencies

powershell -Command "(New-Object Net.WebClient).DownloadFile('https://nodejs.org/download/release/v%NODEJS_VERSION%/node-v%NODEJS_VERSION%.tar.gz', './node_src.tar.gz')" || goto :error
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/metacall/core/66fcaac300611d1c4210023e7b260296586a42e0/cmake/NodeJSGYPPatch.py', './NodeJSGYPPatch.py')" || goto :error

echo Building NodeJS as Shared Library

rem Build NodeJS (DLL)
cmake -E tar xzf node_src.tar.gz || goto :error
cd %loc%\node-v%NODEJS_VERSION% || goto :error
python %loc%\NodeJSGYPPatch.py %loc%\node-v%NODEJS_VERSION%\node.gyp || goto :error
call .\vcbuild.bat dll

echo NodeJS Built Successfully

powershell -Command "Compress-Archive" -Path %loc%\node-v%NODEJS_VERSION%\out\Release\libnode.lib, %loc%\node-v%NODEJS_VERSION%\out\Release\libnode.dll -DestinationPath %loc%\node-shared-v%NODEJS_VERSION%-x64.zip || goto :error

echo Tarball Compressed Successfully

rem Delete unnecesary data
rmdir /S /Q %loc%\node-v%NODEJS_VERSION%
rmdir /S /Q %loc%\nasm-2.15.05

exit 0

rem Handle error
:error
echo Failed with error #%errorlevel%
exit /b %errorlevel%
