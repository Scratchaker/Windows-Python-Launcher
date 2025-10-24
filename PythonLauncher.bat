@echo off
setlocal enabledelayedexpansion



:::------------------------------------Configuration------------------------------------:::

::Set the python version to use. Will be ignored if pythondir is not py or py.exe.
set pythonversion=3.11
::Used to configure the python exe to use. Useful when using portable python versions. Use %cd%\path\to\python.exe to use relative directories.
set pythondir=py

::Used to define the title of the cmd that will execute the python file.
set windowname=Python

::This script can auto detect what initial files to run edit this list to add custom initial files or change the order(if two files exist the first will be runed).
set initialfiles="run.py" "main.py" "app.py"

::Set if a venv will be created before runing the python file.
set usevenv=1
::Used to define the name of the venv that will be created and used.
set venvname=pyvenv
::Set if a requirements.txt file will be installed when creating the venv. Packages will not be installed or updated if the venv alredy exists.
set installrequirementsfile=1
::Used to define the requirements file that will be installed.
set requirementsfile=requirements.txt

::Toggle if the cmd that runs the python file should start minimized.
set minimizedcmd=0
::Toggle if the cmd window should be closed when the python file execution has ended.
set autoclosecmd=0
::Used to toggle if the arguments passed to this file will be passed to the python file. Will disable running a python file when dragging it over this file if enabled.
set passarguments=0

::Set if the user will be alerted and taken to the python download page if python is not installed. Program will abort if python is not installed when set to 0.
set alertifpynotinstalled=1

:::-----------------------------------------Code----------------------------------------:::



rem Check if python is installed.
%pythondir% -V
if %ERRORLEVEL% neq 0 (
    rem Python is NOT installed.
	set "ispyinstalled=0"
	cls
	if "!alertifpynotinstalled!"=="1" (
		echo No python version was found!
		echo Opening download page.
		start https://www.python.org/downloads/
	) else (
		exit
	)
	pause >nul
	exit
) else (
	set "ispyinstalled=1"
)
cls
rem Decide what type of cli launcher is being used.
if exist "%pythondir%" (
    for %%A in ("%pythondir%") do (
        set "fileName=%%~nxA"
    )

    if /I "!fileName!"=="py" (
        echo File is py
        set "usepylancher=1"
    ) else if /I "!fileName!"=="py.exe" (
        echo File is py.exe
        set "usepylancher=1"
    ) else (
        echo File name is different: %pythondir%
        set "usepylancher=0"
    )
) else (
    if "!ispyinstalled!"=="1" (
        echo File does not exist, but Python is installed.
		
		if /I "!fileName!"=="py" (
			echo File is py
			set "usepylancher=1"
		) else if /I "!fileName!"=="py.exe" (
			echo File is py.exe
			set "usepylancher=1"
		) else (
			echo File name is different: %pythondir%
			set "usepylancher=0"
		)
    ) else (
		if "!alertifpynotinstalled!"=="1" (
			echo File does not exist.
			set "usepylancher=0"
		) else (
			exit
		)
    )
)
cls


rem Define what to do.
if "!minimizedcmd!"=="1" (
    set "min=/min"
	if "!autoclosecmd!"=="1" (
		set "minexit=& exit"
	) else (
		set "minexit="
	)
) else (
    set "min="
	if "!autoclosecmd!"=="1" (
		set "minexit=& exit"
	) else (
		set "minexit="
	)
)

if "!usevenv!"=="1" (
    set "venvcmd=%cd%\%venvname%\Scripts\activate"
) else (
    set "venvcmd=cls"
)

if "!usepylancher!"=="1" (
    set "pycmd=-%pythonversion%"
) else (
    set "pycmd="
)


if !passarguments!==1 (
	rem Run a flie with arguments.
	set foundFile=
	for %%f in (%initialfiles%) do (
		if exist %%~f (
			set foundFile=%%~f
			set "command=start %min% "%windowname%" cmd /k ^"call !venvcmd! ^& %pythondir% %pycmd% !foundFile! %* %minexit%^""
			goto :runFile
		)
    )
	set command=start %min% "%windowname%" cmd /k "!venvcmd! & %pythondir% %pycmd%"
	goto :runFile
) else (
    if "%~1"=="" (
		rem No argument provided.
		rem Check if any initial file exists.
		set foundFile=
		for %%f in (%initialfiles%) do (
			if exist %%~f (
				set foundFile=%%~f
				set command=start %min% "%windowname%" cmd /k "!venvcmd! & %pythondir% %pycmd% !foundFile! %minexit%"
				goto :runFile
			)
        )
		set command=start %min% "%windowname%" cmd /k "!venvcmd! & %pythondir% %pycmd%"
		goto :runFile
	) else (
		rem An argument has been provided. Run that file.
		set command=start %min% "%windowname%" cmd /k "!venvcmd! & %pythondir% %pycmd% %1 %minexit%"
		goto :runFile
	)
)

:runFile
rem Run command.
call :createvenv
%command%
goto :eof

:createvenv
rem Create a virtual environment.
if "!usevenv!"=="1" (
    if not exist "%venvname%" (
		echo Creating Virtual environment...
		%pythondir% %pycmd% -m venv "%venvname%"
		
		if "!installrequirementsfile!"=="1" (
			if exist "%requirementsfile%" (
				%cd%\%venvname%\Scripts\activate
				%pythondir% %pycmd% -m pip install -r %requirementsfile%
			) else (
				echo No requirements to install
			)
		) else (
			echo No requirements to install
		)
	)

) else (
    echo VENV is disabled
)
goto :eof
