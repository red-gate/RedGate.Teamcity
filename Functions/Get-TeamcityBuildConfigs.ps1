<#
.SYNOPSIS
Retrieve a list of build configuration from a Teamcity server.
#>
function Get-TeamcityBuildConfigs
{
    [CmdletBinding()]
    param(
        # Optional, a '<buildTypeLocator>' as defined in https://confluence.jetbrains.com/display/TCD9/REST+API#RESTAPI-BuildConfigurationLocator
        # to filter the list of build configs returned.
        # Example: -Locator '?project=project1'
        # Example: -Locator '?paused=true'
        [string] $Locator
    )

    if( $Locator -and !$Locator.StartsWith('?') ) {
        throw "Invalid Locator: '$Locator'. -Locator is expected to start with '?'"
    }

    ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/buildTypes/$Locator" -Credential $Credential).Content).buildTypes.buildType

}
