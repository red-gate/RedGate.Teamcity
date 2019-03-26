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

    (Invoke-RestMethod "$TeamcityServer/httpAuth/app/rest/builds/$Locator" -Credential $Credential -UseBasicParsing).builds.build |
        select *

}
