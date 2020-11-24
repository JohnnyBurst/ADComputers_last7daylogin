$cutoff = (Get-Date).AddDays(-7)

$filter = "LastLogonDate -gt '$cutoff' -and (OperatingSystem -eq 'Windows 7 Professional' -or OperatingSystem -eq 'Windows XP Professional')"

Get-ADComputer -Filter $filter -Properties lastlogondate, description | select-object Name, DistinguishedName, LastLogonDate, Description,
    @{n='LastBootUpTime';e={
        $booted = Get-WMIObject Win32_OperatingSystem -computername $_.name
        $booted.ConvertToDateTime($booted.LastBootUpTime)
    }} | Sort Name | Export-Csv .\currentmachines.csv -NTI
