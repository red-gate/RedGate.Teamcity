function Get-TeamcityBuildConfigAgentRequirements
{
    [CmdletBinding()]
  param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [string] $Id
    )

    process {

    (Invoke-RestMethod "$TeamcityServer/app/rest/buildTypes/id:$Id/agent-requirements" -Headers $Headers -UseBasicParsing).'agent-requirements'.'agent-requirement'

    }

}
