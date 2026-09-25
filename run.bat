@echo off
REM ================================================================
REM run.bat - venvでx_collector.pyを実行する
REM
REM 使い方:
REM   run.bat                       当日0:00～8:00(JST)を収集→翻訳→メール送信
REM   run.bat --from 8:00 --to 18:00  時間帯を指定
REM   run.bat --window 8            旧方式（実行時刻から8時間遡る）
REM   run.bat --collect-only        収集のみ
REM   run.bat --no-mail             翻訳まで・送信なし
REM   run.bat --test-llm            Groqへの疎通確認
REM   run.bat --selftest            オフライン自己テスト
REM
REM 翻訳はGroq(クラウド)を使うので、Docker/Ollamaは不要。
REM このファイルはプロジェクトルートに置く（src\ config\ data\ web\ と同じ階層）。
REM ================================================================
setlocal
cd /d "%~dp0"

REM ---- 設定（ここだけ編集）----------------------------------------------
set VENV_DIR=env
set PY_MAIN=src\x_collector.py
REM ------------------------------------------------------------------------

REM ---- venv 有効化（無ければシステムのpythonで続行。落とさない）----------
if exist "%VENV_DIR%\Scripts\activate.bat" (
    call "%VENV_DIR%\Scripts\activate.bat"
) else (
    echo [WARN] 仮想環境 %VENV_DIR% が見つかりません。システムのpythonで実行します。
)

echo [*] x_collector.py 実行中...
python %PY_MAIN% %*
set _pyresult=%errorlevel%

if %_pyresult% NEQ 0 (
    echo [FAIL] x_collector.py がエラー終了しました（exit code %_pyresult%）
    pause
    exit /b %_pyresult%
)
echo [OK] 完了

pause
exit /b
