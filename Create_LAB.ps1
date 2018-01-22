<#
.Synopsis

	Create a LAB environment with PowerShell

.DESCRIPTION

With this Script are you able to create a LAB info your Active Directory. 
OU, Users and Groups are created with this script.

.EXAMPLE

	.\create_lab.ps1

.NOTES

	AUTHORS
	Whitehathacker.info
#>

get-executionpolicy -Scope CurrentUser
Import-Module activedirectory

###### Define a domain variable ######
$domain = Read-Host "Please enter the domain name"
$TLD = "int"

###### Create OU in whitehat (Root OU) ######

New-ADOrganizationalUnit -Name LAB -Path "DC=$domain,DC=$TLD"

###### Create OU Devices & Server in LAB ######

New-ADOrganizationalUnit -Name Devices -Path "OU=LAB,DC=$domain,DC=$TLD"

New-ADOrganizationalUnit -Name Server -Path "OU=Devices,OU=LAB,DC=$domain,DC=$TLD"
New-ADOrganizationalUnit -Name Computers -Path "OU=Devices,OU=LAB,DC=$domain,DC=$TLD"

###### Create OU Users in LAB ######

New-ADOrganizationalUnit -Name Users -Path "OU=LAB,DC=$domain,DC=$TLD"

New-ADOrganizationalUnit -Name Admins -Path "OU=Users,OU=LAB,DC=$domain,DC=$TLD"
New-ADOrganizationalUnit -Name PowerUsers -Path "OU=Users,OU=LAB,DC=$domain,DC=$TLD"
New-ADOrganizationalUnit -Name Standard -Path "OU=Users,OU=LAB,DC=$domain,DC=$TLD"

###### Create OU Groups on LAB ######

New-ADOrganizationalUnit -Name Groups -Path "OU=LAB,DC=$domain,DC=$TLD"
New-ADOrganizationalUnit -Name Security -Path "OU=Groups,OU=LAB,DC=$domain,DC=$TLD"
New-ADOrganizationalUnit -Name Distribution -Path "OU=Groups,OU=LAB,DC=$domain,DC=$TLD"

###### Create Users into OU Users in LAB ######

$Pass='L0ndon2018$'
$Password=ConvertTo-SecureString -AsPlainText -Force -String $Pass

New-ADUser -SamAccountName "joker" -UserPrincipalName "joker@$domain.$TLD" -GivenName "joker" -Name "joker " -DisplayName "joker" -City "Gotham City" -AccountPassword $Password -Enabled $true -Path "OU=Standard,OU=Users,OU=LAB,DC=$domain,DC=$TLD" 
New-ADUser -SamAccountName "joker_adm" -UserPrincipalName "joker_adm@$domain.$TLD" -GivenName "joker"  -Name "joker ADM" -DisplayName "joker ADM" -City "Gotham City" -AccountPassword $Password -Enabled $true -Path "OU=Admins,OU=Users,OU=LAB,DC=$domain,DC=$TLD"

###### Create new Admin Groups on LAB ######

New-ADGroup -Name "gs-lab-adm" -SamAccountName gs-lab-adm -GroupScope Global -GroupCategory Security -Description "Global Security Groups for Administrator" -PassThru -Path "OU=Security,OU=Groups,OU=LAB,DC=$domain,DC=$TLD"

###### Adding Users to Groups on LAB #####

Add-ADGroupMember -Identity gs-lab-adm -Members joker_adm
Add-ADGroupMember -Identity "Domain Admins" -Members "gs-lab-adm"

###############################################
#                                             #
#               END of Script                 #
#                                             #
###############################################
