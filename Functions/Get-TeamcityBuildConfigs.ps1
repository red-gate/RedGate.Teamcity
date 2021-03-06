<#
.SYNOPSIS
Retrieve a list of build configuration from a Teamcity server.
#>
function Get-TeamcityBuildConfigs
{
    [CmdletBinding()]
    param(
        # Optional, the id of the project that the returned build configs belong to
        [string] $ParentProjectId,

        # Optional, Include build configuration templates
        [switch] $IncludeTemplates
    )

    if($ParentProjectId) {
        $Urls = @("$TeamcityServer/app/rest/projects/id:$ParentProjectId/buildTypes/")
        if($IncludeTemplates.IsPresent) {
            $Urls += "$TeamcityServer/app/rest/projects/id:$ParentProjectId/templates/"
        }
    } else {
        $Urls = @("$TeamcityServer/app/rest/buildTypes/")
        if($IncludeTemplates.IsPresent) {
            $Urls += "$TeamcityServer/app/rest/buildTypes?locator=templateFlag:true"
        }
    }

    $Urls | foreach {
        (Invoke-RestMethod $_ -Headers $Headers -UseBasicParsing).buildTypes.buildType |
            Select Id,
                Name,
                Paused,
                ProjectName,
                ProjectId,
                Href,
                WebUrl
    }
}
