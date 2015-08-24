function Get-TeamcityBuildConfig
{
	[CmdletBinding()]
  param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[string] $Id
	)

	process {

			([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/buildTypes/id:$Id" -Credential $Credential).Content).buildType

	}
	
}
