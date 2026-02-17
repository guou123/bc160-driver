@echo off
setlocal enabledelayedexpansion
%1 %2
ver|find "5.">nul&&goto :search_graphicscard
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :search_graphicscard","","runas",1)(window.close)&goto :eof

:search_graphicscard
:: 设置注册表项的路径
set reg_path=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}
echo.
echo 请使用管理员身份运行脚本
:: 查找设备名称
echo.
echo 正在搜索当前电脑已安装的显卡以及显卡的序号...
echo.
echo 若出现同一张显卡对应多个序号的情况，代表驱动没有完全卸载
echo.
echo 遇到上述情况建议请使用DDU对所有显卡驱动重新进行清理，直到剩下一个
echo.
echo 这里默认最多显示7个
echo.
for /f "tokens=*" %%a in ('reg query "%reg_path%"') do (
    set "line=%%a"
    set "last_four_chars=!line:~-4!"
    if "!last_four_chars!"=="0000" (
        set "reg_key=!reg_path!\0000"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0001" (
       set "reg_key=!reg_path!\0001"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0002" (
       set "reg_key=!reg_path!\0002"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0003" (
       set "reg_key=!reg_path!\0003"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0004" (
       set "reg_key=!reg_path!\0004"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0005" (
       set "reg_key=!reg_path!\0005"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0006" (
       set "reg_key=!reg_path!\0006"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    ) else if "!last_four_chars!"=="0007" (
       set "reg_key=!reg_path!\0007"
        for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
                set "driver_desc=%%c"
                echo !line:~-1!：!driver_desc!
        )
    )
)

echo.
echo 若亮机卡为AMD独显，请将NVIDIA设置为节能，AMD设置为高性能，然后在图形设置中强制调用
echo.
echo 若亮机卡为NVIDIA独显，请将亮机卡设置为节能，计算卡设置为高性能，系统即可自动调用
echo.
:: 询问用户选择
echo 请将哪一张显卡设置为节能显卡(亮机卡/仅作为输出画面的显卡)？输入序号后回车确认。
set /p powersave_num=请输入: 
echo.
echo 请将哪一张显卡设置为高性能显卡(游戏渲染调用的显卡)？输入序号后回车确认。
set /p highperformance_num=请输入: 
echo.
:: 设置节能显卡
    set "powersave_reg=%reg_path%\000%powersave_num%"
    reg add "!powersave_reg!" /v "EnableMsHybrid" /t REG_DWORD /d 00000006 /f
    reg add "!powersave_reg!" /v "GridLicensedFeatures" /t REG_DWORD /d 00000007 /f
	set "reg_key=!reg_path!\000%powersave_num%"
    for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
	set "driver_desc=%%c")
    echo 已将 !driver_desc! 设置为节能显卡。
	echo.

:: 设置高性能显卡
    set "highperformance_reg=%reg_path%\000%highperformance_num%"
    reg add "!highperformance_reg!" /v "EnableMsHybrid" /t REG_DWORD /d 00000001 /f
    reg add "!highperformance_reg!" /v "GridLicensedFeatures" /t REG_DWORD /d 00000007 /f
    reg add "!highperformance_reg!" /v "AdapterType" /t REG_DWORD /d 00000001 /f
	set "reg_key=!reg_path!\000%highperformance_num%"
    for /f "tokens=2,*" %%b in ('reg query "!reg_key!" /v DriverDesc 2^>nul ^| findstr /i "DriverDesc"') do (
	set "driver_desc=%%c")
    echo 已将 !driver_desc! 显卡设置为高性能显卡。
	echo.
pause




:recovery_set
cls
echo.
echo 若设置正确，在设备管理器内禁用并启用显卡或者重启系统后即可生效
echo.
echo 若设置有误，输入N还原默认"显卡调用"设定
echo.
SET /P RECOVERY_SET="输入Y或者直接回车为跳过本步骤，输入N还原设定：  "
IF /I "%RECOVERY_SET%" EQU "N" GOTO :recovery_mshybrid
IF /I "%RECOVERY_SET%" EQU "Y" GOTO :eof

REM --Cheking for input
cls
goto :eof


:recovery_mshybrid
echo 正在还原设定
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0003 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0004 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0005 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0006 /v EnableMsHybrid /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0007 /v EnableMsHybrid /f

reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0003 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0004 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0005 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0006 /v AdapterType /f
reg delete HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0007 /v AdapterType /f
:eof
endlocal
pause



