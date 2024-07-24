@echo off
setlocal enabledelayedexpansion

:menu
echo =============================================
echo *           Don't Starve Together           *
echo =============================================
echo                ��ѡ��һ��ѡ��:
echo           1.��������------����
echo           2.��������------���ϡ���Ѩ
echo           3.���ͻ���------����
echo           4.���ͻ���------���ϡ���Ѩ
echo           5. �˳�
echo =============================================
set /p choice=���������ѡ��1/2/3/4/5��:

if "%choice%"=="1" (
    echo --^> ��ѡ����ѡ�� 1������ת����������
    call:host_get_IPv6
    call:host_forward_overworld
    echo --^> ��� IPv6 ��ַ���£��뷢�͸���ĺ��ѣ�
    echo --^> !hostIPv6!
    goto end
) else if "%choice%"=="2" (
    echo --^> ��ѡ����ѡ�� 2������ת���������缰��Ѩ
    call:host_get_IPv6
    call:host_forward_overworld
    call:host_forward_cave
    echo --^> ��� IPv6 ��ַ���£��뷢�͸���ĺ��ѣ�
    echo --^> !hostIPv6!
    goto end
) else if "%choice%"=="3" (
    echo --^> ��ѡ����ѡ�� 3���������ӵ�������
    call:local_get_IPv6
    call:local_connect_overworld
    exit
) else if "%choice%"=="4" (
    echo --^> ��ѡ����ѡ�� 4���������ӵ������缰��Ѩ
    call:local_get_IPv6
    call:local_connect_overworld
    call:local_connect_cave
    exit
) else if "%choice%"=="5" (
    echo --^> ��ѡ����ѡ�� 5�������˳�����
    goto end
) else (
    echo ��Чѡ�����������롣
    goto menu
)
:: ************************************
:: fun:�����Զ���ȡ IPv6 ��ַ
:host_get_IPv6
for /f "tokens=16" %%i in ('ipconfig ^| findstr /r /c:"IPv6 ��ַ"') do (
    set hostIPv6=%%i
    @REM ���������find��ѯֻ��һ�н�������������װ�����������ж����������ip��ַ����һ�����Ǳ���IP��
    @REM ��ʹ��goto��֤forִֻ��һ�ξ�����ѭ������ֹ���� hostIPv6 ��ֵ������
    goto out
)
:out
goto:EOF

:: ************************************
:: fun:ת��������
:host_forward_overworld
@REM ���������� Port
set overworldHostPort=10999
set overworldMapPort=10999
@REM -l���ص�ip��ַ -rĿ���ip��ַ -u��ʾ����udp���� -t��ʾ����tcp����
start "" cmd /c "tinymapper.exe -l[%hostIPv6%]:%overworldHostPort% -r127.0.0.1:%overworldMapPort% -u"
goto:EOF

:: ************************************
:: fun:ת����Ѩ����
:host_forward_cave
@REM ���ö�Ѩ Port
set caveHostPort=10998
set caveMapPort=10998
start "" cmd /c "tinymapper.exe -l[%hostIPv6%]:%caveHostPort% -r127.0.0.1:%caveMapPort% -u"
goto:EOF

:: ************************************
:: fun:�ͻ���ȡ IPv6 ��ַ
:local_get_IPv6
:inputLoop
set /p hostIPv6=���������� IPv6 ��ַ: 

@REM ����û��Ƿ�û���������ݣ�����ǣ���Ҫ���û���������
if "%hostIPv6%"=="" (
    echo ��û�������ַ����������Ч��IPv6��ַ
    goto inputLoop
)
goto:EOF

:: ************************************
:: fun:�ͻ�����������
:local_connect_overworld
@REM ���������� Port
set overworldHostPort=10999
set overworldLocalPort=10999
@REM -l���ص�ip��ַ -rĿ���ip��ַ -u��ʾ����udp���� -t��ʾ����tcp����
start "" cmd /c "tinymapper.exe -l127.0.0.1:%overworldLocalPort% -r[%hostIPv6%]:%overworldHostPort% -u"
goto:EOF

:: ************************************
:: fun:�ͻ����Ӷ�Ѩ����
:local_connect_cave
@REM ���������� Port
set caveHostPort=10998
set caveLocalPort=10998
@REM -l���ص�ip��ַ -rĿ���ip��ַ -u��ʾ����udp���� -t��ʾ����tcp����
start "" cmd /c "tinymapper.exe -l127.0.0.1:%caveLocalPort% -r[%hostIPv6%]:%caveHostPort% -u"
goto:EOF

:end
echo �����������������رոô���
endlocal
pause
