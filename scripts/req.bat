echo off
cd /d "%~dp0.."
call .\env\Scripts\activate

python -m pip install pip -U
python -m pip install -r requirements.txt
python -m pip freeze > requirements.txt

pause
exit /b
