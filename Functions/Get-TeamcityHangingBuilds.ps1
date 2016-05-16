function Get-TeamcityHangingBuilds
{
	[CmdletBinding()]
	param()


	$result = Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/?locator=running:true" -Credential $Credential -UseBasicParsing -Verbose:$false
	$builds = ([xml] $result.Content).builds.build | Select id, buildTypeId, status

	$hangingBuilds = @()
	$suspectBuilds = @()

	$builds | ForEach {

		$runningInfo = ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/id:$($_.Id)" -Credential $Credential -UseBasicParsing -Verbose:$false).Content).build.'running-info' |
			Select elapsedSeconds, estimatedTotalSeconds, probablyHanging

		if( $runningInfo.probablyHanging -eq 'true') {

			Write-Verbose "Teamcity says that build id $($_.id) is probably hanging"

			# Add a OvertimeBy property to the object we're going to return
			$_ | Add-Member -MemberType NoteProperty -Name OvertimeBy -Value ([timespan]::FromSeconds([int]$runningInfo.elapsedSeconds - [int]$runningInfo.estimatedTotalSeconds)) | Out-Null

			$hangingBuilds += $_

		} elseif( [int]$runningInfo.elapsedSeconds -gt ([int]$runningInfo.estimatedTotalSeconds*2) ) {

			Write-Verbose "We suspect that build id $($_.id) is probably hanging (even though Teamcity doesn't see it). Because it has been running for at least twice the amount of time that was predicted by Teamcity"

			# Add a OvertimeBy property to the object we're going to return
			$_ | Add-Member -MemberType NoteProperty -Name OvertimeBy -Value ([timespan]::FromSeconds([int]$runningInfo.elapsedSeconds - [int]$runningInfo.estimatedTotalSeconds)) | Out-Null

			$suspectBuilds += $_

		} else {

			Write-Verbose "Not hanging or suspect build: $_.id. elapsedSeconds: $runningInfo.elapsedSeconds, estimatedTotalSeconds: $runningInfo.estimatedTotalSeconds"

		}

	}

	[pscustomobject] @{
		HangingBuilds = $hangingBuilds
		suspectBuilds = $suspectBuilds
	}
}
