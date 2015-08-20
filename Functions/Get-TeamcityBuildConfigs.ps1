function Get-TeamcityBuildConfigs
{
	[CmdletBinding()]
  param()

	([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/buildTypes" -Credential $Credential).Content).buildTypes.buildType

}
