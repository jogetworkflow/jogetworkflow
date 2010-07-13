@ECHO OFF
:Start
ECHO. 
ECHO ***************************************************************
ECHO ***************************************************************
ECHO *** This will download the latest version of Joget and      ***
ECHO *** update. Please stop Apache Tomcat before proceeding.    ***
ECHO *** Do you really want to run this Y or N?                  ***
ECHO *** If you would like to just download the version without  ***
ECHO *** updating, use D                                         ***
ECHO ***************************************************************
ECHO ***************************************************************
ECHO.

set /p answer=Enter Y or N or D: 
if /i {%answer%}=={n} goto :EOF
if /i {%answer%}=={d} goto :Download
if /i {%answer%}=={y} goto :Update
goto :Start

:Download

ECHO Downloading Joget

call apache-ant-1.7.1\bin\ant download

ECHO.
ECHO ======= Download Complete =========
ECHO.
goto End


:Update

ECHO Updating Joget

call apache-ant-1.7.1\bin\ant update

ECHO.
ECHO ======= Update Complete =========
ECHO.
goto End

:End
PAUSE

