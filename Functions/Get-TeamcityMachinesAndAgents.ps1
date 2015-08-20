function Get-TeamcityMachinesAndAgents
{
	[CmdletBinding()]
	param(
	)

	$agents = Get-TeamcityBuildAgents -Credential $Credential

	$i = 0
	$agents | ForEach {
		
		$i++
		$local:ProgressPreference = 'Continue'
		Write-Progress -Activity "Querying Teamcity..." -PercentComplete ($i / $agents.count * 100)
		$local:ProgressPreference = 'SilentlyContinue'

		$agentDetails = ([xml](Invoke-WebRequest "$TeamcityServer$($_.href)" -Credential $Credential).Content).agent
		$machineName = $agentDetails.properties.property | where name -eq 'env.COMPUTERNAME' | select -ExpandProperty value
		$pool = $agentDetails.pool.name

		[PsCustomObject] @{
			Name = $agentDetails.name.ToUpper()
			Machine = $machineName
			Pool = $pool.ToUpper()
		}

	}

}
