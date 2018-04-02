for ($i=0; $i -lt $args.length; $i++)
{
    $servico = "name='$($args[$i])'"
    Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter $servico | findstr.exe IDProcess > "$($args[$i]).csv"
    echo "Hora(min);IO(MBps);RAM(MB);CPU(%)" > "$($args[$i]).csv"
}
echo "Hora(min);IO(MBps);RAM(MB);CPU(%)" > Maquina.csv
do
{
    for ($i=0; $i -lt $args.length; $i++)
    {
        $servico = "name='$($args[$i])'"
	    $minutos =  $((new-timespan -hour (get-date).hour).totalminutes + (get-date).minute)
	    $ProcessProp = Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter $servico
	    $io = $ProcessProp.IODataBytesPersec/1024
	    $io = [Math]::Round(($ProcessProp.IODataBytesPersec / 1mb),2)
	    $ram = [Math]::Round(($ProcessProp.workingSetPrivate / 1mb),2)
	    $cpu = $ProcessProp.PercentProcessorTime
	    Write-Output "$($minutos);$($io);$($ram);$($cpu)" >> "$($args[$i]).csv"
    }

	#Maquina
	$minutos =  $((new-timespan -hour (get-date).hour).totalminutes + (get-date).minute)
	$ProcessProp = Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='_Total'"
	$ProcessIdle = Get-WmiObject -Class Win32_PerfFormattedData_PerfProc_Process -Filter "name='Idle'"
	$io = $ProcessProp.IODataBytesPersec/1024
	$io = [Math]::Round(($ProcessProp.IODataBytesPersec / 1mb),2)
	$ram = [Math]::Round(($ProcessProp.workingSetPrivate / 1mb),2)
	$cpu = ($ProcessProp.PercentProcessorTime - $ProcessIdle.PercentProcessorTime)
	Write-Output "$($minutos);$($io);$($ram);$($cpu)" >> Maquina.csv
	start-sleep -Seconds 120
}
until($infinity)
