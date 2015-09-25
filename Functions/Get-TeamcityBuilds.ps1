function Get-TeamcityBuilds
{
	[CmdletBinding()]
  param(
		[switch] $Running
	)

	$locator = ''
	if( $Running.IsPresent ) {
			$locator = "?locator=running:true"
	}

	([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/$locator" -Credential $Credential).Content).builds.build

}
