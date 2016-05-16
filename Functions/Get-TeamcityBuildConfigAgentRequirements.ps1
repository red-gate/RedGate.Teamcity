function Get-TeamcityBuildConfigAgentRequirements
{
	[CmdletBinding()]
  param(
		[Parameter(ValueFromPipelineByPropertyName=$true)]
		[string] $Id
	)

	process {

	([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/buildTypes/id:$Id/agent-requirements" -Credential $Credential -UseBasicParsing).Content).'agent-requirements'.'agent-requirement'

	}

}
