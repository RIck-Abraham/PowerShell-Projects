#adjusted by seagull, april 2022 :: build 2
New-ItemProperty -Path HKLM:\SOFTWARE\CentraStage\ -Name $env:CustomUDF -PropertyType String -Value (((Get-WmiObject -ComputerName $env:COMPUTERNAME -Class Win32_UserAccount -Filter "LocalAccount=True" | % {$_.Name+","}) -as [string]) -replace(',$',''))