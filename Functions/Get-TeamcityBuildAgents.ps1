function Get-TeamcityBuildAgents
{
	[CmdletBinding()]
  param(
		# Name / wildcard pattern of the agent name
		[string] $NamePattern
	)

  $allAgents = ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agents" -Credential $Credential).Content).agents.agent |
			select id, name, href

	if( $NamePattern ) {
		$allAgents | where name -like $NamePattern
	} else {
		$allAgents
	}

}
