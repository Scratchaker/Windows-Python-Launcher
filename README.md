# Windows Python Launcher

**Customizable Windows batch script to launch Python projects and files.**  
*Ideal for testing and distributing python projects without compiling.*
---
## Features

- Detects installed Python version and optionally uses the `py` launcher.
- Auto-detects and runs initial Python files (`run.py`, `main.py`, `app.py`).
- Optional virtual environment creation (`venv`) before running scripts.
- Automatically installs `requirements.txt` if present (It will only be installed on `venv` creation if enabled)
- Optionally passes command-line arguments to the Python script.
- Can launch the command prompt minimized with a custom title.

## Configuration

Edit the batch script to customize the behavior:

- `pythonversion` - Python version to use with the launcher. Will be ignored if pythondir is not py or py.exe
- `pythondir` - Path or command for Python executable (Useful when using portable python versions).  
- `windowname` - Title of the command prompt window.  
- `initialfiles` - List of initial files to run if no argument is provided. (Follow the example structure to add filenames).  
- `usevenv` - Create and use a virtual environment (1 = enabled, 0 = disabled).  
- `venvname` - Name of the virtual environment.  
- `installrequirementsfile` - Install `requirements.txt` in venv (1 = enabled, 0 = disabled).  
- `requirementsfile` - Path to the requirements file.  
- `minimizedcmd` - Start command prompt minimized (1 = yes, 0 = no).  
- `autoclosecmd` - Close the command prompt window when the python file execution has ended (1 = yes, 0 = no).  
- `passarguments` - Pass arguments to the Python script  (1 = yes, 0 = no) (drag and drop will be disabled!).  
- `alertifpynotinstalled` - Alert and open the python download page if no python version is installed (1 = yes, 0 = no).

## Usage

- Run the batch file directly. It will detect Python, create a venv if configured, install requirements, and execute the appropriate Python file.
- Copy the file to your project folder and add custom initial file names at `initialfiles` if neccesary. Runing this script will start your python project
- To run a specific Python file, **drag and drop** it onto the batch script (if `passarguments=0`).
