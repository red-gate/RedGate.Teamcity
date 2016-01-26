<#
.SYNOPSIS
Retrieve a list of archived build configuration from a Teamcity server.
.DESCRIPTION
Archived build config are build that belong to a project that is archived.
#>
function Get-TeamcityArchivedBuildConfigs {
    [CmdletBinding()]
    param()

    Get-TeamcityProjects -Archived 'true' | ForEach {
        Get-TeamcityBuildConfigs -parentProjectId $_.id
    }

}
