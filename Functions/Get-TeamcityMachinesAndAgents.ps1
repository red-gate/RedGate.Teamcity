function Get-TeamcityMachinesAndAgents
{
	[CmdletBinding()]
	param(
		[string] $AgentNamePattern = '*'
	)

	Get-TeamcityBuildAgents -NamePattern $AgentNamePattern | Get-TeamcityBuildAgentDetails		

}
