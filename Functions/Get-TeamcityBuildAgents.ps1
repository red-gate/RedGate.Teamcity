function Get-TeamcityBuildAgents
{
	[CmdletBinding()]
    param()

    ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agents" -Credential $Credential).Content).agents.agent

}