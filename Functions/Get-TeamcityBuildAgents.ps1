function Get-TeamcityBuildAgents
{
    [CmdletBinding()]
  param(
        # Name / wildcard pattern of the agent name
        [string] $NamePattern,

        # (Optional) Additional locator. (defaults to 'locator=authorized:any')
        [string] $Locator = 'locator=authorized:any'
    )

  $allAgents = (Invoke-RestMethod "$TeamcityServer/app/rest/agents?$Locator" -Headers $Headers -UseBasicParsing).agents.agent |
            select id, name, href

    if( $NamePattern ) {
        $allAgents | where name -like $NamePattern
    } else {
        $allAgents
    }

}
