@echo off
setlocal enabledelayedexpansion

:menu
echo =============================================
echo *           Don't Starve Together           *
echo =============================================
echo                请选择一个选项:
echo           1.（主机）------地上
echo           2.（主机）------地上、洞穴
echo           3.（客机）------地上
echo           4.（客机）------地上、洞穴
echo           5. 退出
echo =============================================
set /p choice=请输入你的选择（1/2/3/4/5）:

if "%choice%"=="1" (
    echo --^> 你选择了选项 1，即将转发地上世界
    call:host_get_IPv6
    call:host_forward_overworld
    echo --^> 你的 IPv6 地址如下，请发送给你的好友：
    echo --^> !hostIPv6!
    goto end
) else if "%choice%"=="2" (
    echo --^> 你选择了选项 2，即将转发地上世界及洞穴
    call:host_get_IPv6
    call:host_forward_overworld
    call:host_forward_cave
    echo --^> 你的 IPv6 地址如下，请发送给你的好友：
    echo --^> !hostIPv6!
    goto end
) else if "%choice%"=="3" (
    echo --^> 你选择了选项 3，即将连接地上世界
    call:local_get_IPv6
    call:local_connect_overworld
    exit
) else if "%choice%"=="4" (
    echo --^> 你选择了选项 4，即将连接地上世界及洞穴
    call:local_get_IPv6
    call:local_connect_overworld
    call:local_connect_cave
    exit
) else if "%choice%"=="5" (
    echo --^> 你选择了选项 5，即将退出程序
    goto end
) else (
    echo 无效选择，请重新输入。
    goto menu
)
:: ************************************
:: fun:主机自动获取 IPv6 地址
:host_get_IPv6
for /f "tokens=16" %%i in ('ipconfig ^| findstr /r /c:"IPv6 地址"') do (
    set hostIPv6=%%i
    @REM 正常情况下find查询只有一行结果，如果主机安装了虚拟机则会有多个适配器有ip地址。第一个才是本机IP，
    @REM 故使用goto保证for只执行一次就跳出循环，防止后续 hostIPv6 的值被覆盖
    goto out
)
:out
goto:EOF

:: ************************************
:: fun:转发主世界
:host_forward_overworld
@REM 设置主世界 Port
set overworldHostPort=10999
set overworldMapPort=10999
@REM -l本地的ip地址 -r目标的ip地址 -u表示这是udp连接 -t表示这是tcp连接
start "" cmd /c "tinymapper.exe -l[%hostIPv6%]:%overworldHostPort% -r127.0.0.1:%overworldMapPort% -u"
goto:EOF

:: ************************************
:: fun:转发洞穴世界
:host_forward_cave
@REM 设置洞穴 Port
set caveHostPort=10998
set caveMapPort=10998
start "" cmd /c "tinymapper.exe -l[%hostIPv6%]:%caveHostPort% -r127.0.0.1:%caveMapPort% -u"
goto:EOF

:: ************************************
:: fun:客机获取 IPv6 地址
:local_get_IPv6
:inputLoop
set /p hostIPv6=输入主机的 IPv6 地址: 

@REM 检查用户是否没有输入内容，如果是，则要求用户重新输入
if "%hostIPv6%"=="" (
    echo 你没有输入地址，请输入有效的IPv6地址
    goto inputLoop
)
goto:EOF

:: ************************************
:: fun:客机连接主世界
:local_connect_overworld
@REM 设置主世界 Port
set overworldHostPort=10999
set overworldLocalPort=10999
@REM -l本地的ip地址 -r目标的ip地址 -u表示这是udp连接 -t表示这是tcp连接
start "" cmd /c "tinymapper.exe -l127.0.0.1:%overworldLocalPort% -r[%hostIPv6%]:%overworldHostPort% -u"
goto:EOF

:: ************************************
:: fun:客机连接洞穴世界
:local_connect_cave
@REM 设置主世界 Port
set caveHostPort=10998
set caveLocalPort=10998
@REM -l本地的ip地址 -r目标的ip地址 -u表示这是udp连接 -t表示这是tcp连接
start "" cmd /c "tinymapper.exe -l127.0.0.1:%caveLocalPort% -r[%hostIPv6%]:%caveHostPort% -u"
goto:EOF

:end
echo 程序结束，按任意键关闭该窗口
endlocal
pause
