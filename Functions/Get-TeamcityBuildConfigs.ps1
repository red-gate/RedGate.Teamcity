<#
.SYNOPSIS
Retrieve a list of build configuration from a Teamcity server.
#>
function Get-TeamcityBuildConfigs
{
    [CmdletBinding()]
    param(
        # Optional, the id of the project that the returned build configs belong to
        [string] $ParentProjectId
    )

    if($ParentProjectId) {
        $Url = "$TeamcityServer/httpAuth/app/rest/projects/id:$ParentProjectId/buildTypes/"
    } else {
        $Url = "$TeamcityServer/httpAuth/app/rest/buildTypes/"
    }

    ([xml](Invoke-WebRequest $Url -Credential $Credential).Content).buildTypes.buildType |
        Select Id,
            Name,
            Paused,
            ProjectName,
            ProjectId,
            Href,
            WebUrl
}
