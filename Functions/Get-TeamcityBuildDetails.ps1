function Get-TeamcityBuildDetails
{
	[CmdletBinding()]
  param(
		[Parameter(ValueFromPipelineByPropertyName=$true)]
		[int] $Id
	)

	process {

		([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/builds/id:$Id" -Credential $Credential -UseBasicParsing).Content).build

	}

}
