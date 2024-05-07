REM 환경을 활성화합니다.
call .venv\Scripts\activate.bat

REM waitress-serve를 사용하여 Flask 앱을 실행합니다.
waitress-serve --listen=*:15000 app:app