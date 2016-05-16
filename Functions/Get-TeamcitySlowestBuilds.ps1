function Get-TeamcitySlowestBuilds
{
	[CmdletBinding()]
	param(
		[datetime] $Since = (Get-Date).AddDays(-7),
		[int] $Count = 100
	)


	$result = Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/?since=$($Since.Year)$($Since.Month.ToString('00'))$($Since.Day.ToString('00'))&count=$Count" -Credential $Credential -UseBasicParsing
	$builds = ([xml] $result.Content).builds.build | Select id, buildTypeId, status


	$i = 0
	$builds | ForEach {

		$i++
		$local:ProgressPreference = 'Continue'
		Write-Progress -Activity "Querying Teamcity..." -PercentComplete ($i / $Count * 100)
		$local:ProgressPreference = 'SilentlyContinue'

		[pscustomobject] @{
			Id = $_.Id
			BuildTypeId = $_.buildTypeId
			BuildDuration =  [system.timespan]::FromMilliseconds([int](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/id:$($_.Id)/statistics/BuildDuration" -Credential $Credential -UseBasicParsing).Content)
			Status = $_.status
		}

	}
}
