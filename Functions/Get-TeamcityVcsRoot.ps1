function Get-TeamcityVcsRoot
{
	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $Id
    )


    $result = ([xml] (Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/vcs-roots/id:$Id" -Credential $Credential -UseBasicParsing).Content).'vcs-root' 

    $vcsRoot = [pscustomobject] @{
        Id = $result.id
        Name = $result.name
        VcsName = $result.vcsName

        Project = [pscustomobject] @{
            Id = $result.project.id
            Name = $result.project.name
        }

        Properties = @(
                $result.properties.property | ForEach {
                    [pscustomobject] @{
                        Name = $_.name
                        Value = $_.value
                    }
            }
        )
    }

    $vcsRoot
}
