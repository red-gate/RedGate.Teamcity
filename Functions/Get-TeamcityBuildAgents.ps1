function Get-TeamcityBuildAgents
{
	[CmdletBinding()]
  param(
		# Name / wildcard pattern of the agent name
		[string] $NamePattern,

		# (Optional) Additional locator. (defaults to 'locator=authorized:any')
		[string] $Locator = 'locator=authorized:any'
	)

  $allAgents = ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/agents?$Locator" -Credential $Credential -UseBasicParsing).Content).agents.agent |
			select id, name, href

	if( $NamePattern ) {
		$allAgents | where name -like $NamePattern
	} else {
		$allAgents
	}

}
