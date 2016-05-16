function Get-TeamcityBuildConfigSettings
{
	[CmdletBinding()]
  param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[string] $Id
	)

	process {

			([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/buildTypes/id:$Id/settings" -Credential $Credential -UseBasicParsing).Content).properties.property

	}

}
