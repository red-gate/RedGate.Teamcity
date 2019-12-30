function Get-TeamcityBuilds
{
    [CmdletBinding()]
    param(
        # Use 'running:true' to get running builds
        # Use 'agentName:agent1' to get builds running on agent1
        [string] $Locator = ''
    )

    if($Locator) {
        $Locator = "?locator=${Locator}"
    }

    (Invoke-RestMethod "$TeamcityServer/app/rest/builds/$Locator" -Headers $Headers -UseBasicParsing).builds.build |
        select *

}
