: ; # polyglot wrapper — runs as CMD on Windows, bash on Unix
: ; exec bash "${0%.*}" "$@" 2>/dev/null || exec bash "$0" "$@"
@echo off
setlocal enabledelayedexpansion

:: Windows: find bash and run the hook
set "SCRIPT_DIR=%~dp0"
set "HOOK=%~1"

:: Try Git for Windows bash locations
for %%G in (
  "C:\Program Files\Git\bin\bash.exe"
  "C:\Program Files (x86)\Git\bin\bash.exe"
) do (
  if exist %%G (
    %%G "%SCRIPT_DIR%%HOOK%" %*
    exit /b %ERRORLEVEL%
  )
)

:: Try PATH
where bash >nul 2>&1
if %ERRORLEVEL% equ 0 (
  bash "%SCRIPT_DIR%%HOOK%" %*
  exit /b %ERRORLEVEL%
)

echo [software-forge] Could not find bash. Install Git for Windows or add bash to PATH.
exit /b 1
