<#
.SYNOPSIS
Retrieve a list of projects from a Teamcity server.
#>
function Get-TeamcityProjects
{
    [CmdletBinding()]
    param(
        # If set to 'true', only retrieves projects that are archived
        # If set to 'false'm only retrieves projects that are not archived
        # Default: If set to $null, retrieves all projects regardless of their archived status
        [ValidateSet($null, 'true', 'false')]
        [string] $Archived = $null
    )

    $projects = ([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/projects" -Credential $Credential -UseBasicParsing).Content).projects.project

    if($Archived) {
        if( $Archived -eq 'true') {
            $projects | where archived -eq $Archived
        } else {
            $projects | where archived -eq $null
        }
    } else {
        $projects
    }

}
