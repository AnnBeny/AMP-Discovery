@echo off
REM Spustí RUN.sh ve WSL a načte login shell (PATH z .bashrc)
wsl bash --noprofile --norc -c 'bash "/mnt/c/Users/User/kamila/WORKFLOWS/AMP/src/RUN_wsl.sh"'
pause