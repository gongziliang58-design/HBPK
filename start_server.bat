@echo off

REM 检查Python是否安装
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo 未找到Python。请先安装Python，然后再尝试运行此脚本。
    echo 或者您可以使用其他方法启动HTTP服务器，如README.md中所述。
    pause
    exit /b 1
)

REM 启动Python HTTP服务器
echo 正在启动HTTP服务器...
echo 请在浏览器中访问 http://localhost:8000
echo 按Ctrl+C可停止服务器
python -m http.server 8000

pause