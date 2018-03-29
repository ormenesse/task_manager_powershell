echo "####################################" > CylanceSvc.csv
echo "#       Análise  CylanceSvc        #" >> CylanceSvc.csv
echo "####################################" >> CylanceSvc.csv
echo "####################################" > CyOptics.csv
echo "#        Análise  CyOptics         #" >> CyOptics.csv
echo "####################################" >> CyOptics.csv
echo "####################################" > Maquina.csv
echo "#         Análise  Máquina         #" >> Maquina.csv
echo "####################################" >> Maquina.csv
Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='CylanceSvc'" | findstr.exe IDProcess >> CylanceSvc.csv
echo "Hora(min);IO(MBps);RAM(MB);CPU(%)" >> CylanceSvc.csv
Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='CylanceOptics'" | findstr.exe IDProcess >> CyOptics.csv
echo "Hora(min);IO(MBps);RAM(MB);CPU(%)" >> CyOptics.csv
echo "Hora(min);IO(MBps);RAM(MB);CPU(%)" >> Maquina.csv

do
{
	#CylanceSvc.exe
	$minutos =  $((new-timespan -hour (get-date).hour).totalminutes + (get-date).minute)
	$ProcessProp = Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='CylanceSvc'"
	$io = $ProcessProp.IODataBytesPersec/1024
	$io = [Math]::Round(($ProcessProp.IODataBytesPersec / 1mb),2)
	$ram = [Math]::Round(($ProcessProp.workingSetPrivate / 1mb),2)
	$cpu = $ProcessProp.PercentProcessorTime
	Write-Output "$($minutos);$($io);$($ram);$($cpu)" >> CylanceSvc.csv
	#CyOptics.exe
	$minutos =  $((new-timespan -hour (get-date).hour).totalminutes + (get-date).minute)
	$ProcessProp = Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='CyOptics'"
	$io = $ProcessProp.IODataBytesPersec/1024
	$io = [Math]::Round(($ProcessProp.IODataBytesPersec / 1mb),2)
	$ram = [Math]::Round(($ProcessProp.workingSetPrivate / 1mb),2)
	$cpu = $ProcessProp.PercentProcessorTime
	Write-Output "$($minutos);$($io);$($ram);$($cpu)" >> CyOptics.csv
	#Maquina
	$minutos =  $((new-timespan -hour (get-date).hour).totalminutes + (get-date).minute)
	$ProcessProp = Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='_Total'"
	$io = $ProcessProp.IODataBytesPersec/1024
	$io = [Math]::Round(($ProcessProp.IODataBytesPersec / 1mb),2)
	$ram = [Math]::Round(($ProcessProp.workingSetPrivate / 1mb),2)
	$cpu = $ProcessProp.PercentProcessorTime
	Write-Output "$($minutos);$($io);$($ram);$($cpu)" >> Maquina.csv
	start-sleep -Seconds 120
}
until($infinity)