Get-ADUser -Filter * -Properties Department, Title | Select-Object Name, SamAccountName, Department, Title
Get-ADUser -Filter {Enabled -eq $false} | Select-Object Name, SamAccountName
Search-ADAccount -LockedOut
Get-ADUser -Filter * -Properties whenCreated | Sort-Object whenCreated -Descending | Select-Object -First 5 Name, whenCreated