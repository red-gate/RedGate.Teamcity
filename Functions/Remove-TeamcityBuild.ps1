function Remove-TeamcityBuild
{
	[CmdletBinding()]
	param(
		[Parameter(Mandatory=$true)]
		[string] $Id,

		[string] $Comment = 'Canceled using Teamcity REST API, RedGate.Teamcity/Remove-TeamcityBuild'
	)


	$request = "<buildCancelRequest comment='$Comment' readdIntoQueue='true' />"

	$result = Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/id:$Id" -Credential $Credential -Method Post -Body $request -ContentType 'application/xml'

	"$($result.StatusCode) - $($result.StatusDescription)"
}
