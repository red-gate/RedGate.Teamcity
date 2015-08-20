function Get-TeamcityBuildAgentDetails
{
	[CmdletBinding()]
    param(
        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string] $id
    )

		process {

			([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agents/id:$Id" -Credential $Credential).Content).agent

		}
		
}
