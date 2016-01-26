<#
.SYNOPSIS
    Delete artifacts of a Teamcity build config

.DESCRIPTION
    Find all the artifacts of a given build config
    and ruthlessly delete them.
#>
Function Remove-TeamcityArtifactsOfBuildConfig
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    Param
    (
        # The path to where the Teamcity artifacts are stored.
        # something like '<your-teamcity-data-dir>\system\artifacts'
        $TeamcityArtifactDirectory = $env:TeamcityArtifactDirectory,

        # The Name of the build configuration.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        # The Id of the parent project of the build configuration
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $ProjectId
    )
    Begin
    {
        $local:ErrorActionPreference = 'Stop'

        if(!$TeamcityArtifactDirectory) {
            throw '-TeamcityArtifactDirectory was not specified and $env:TeamcityArtifactDirectory is not set.'
        }
        $TeamcityArtifactDirectory = Resolve-Path $TeamcityArtifactDirectory
    }
    Process
    {
        if(!$ProjectId) { throw 'Missing ProjectId'}
        if(!$Name) { throw 'Missing Name'}

        Join-Path $TeamcityArtifactDirectory "$ProjectId\$Name" |
            Resolve-Path -ErrorAction SilentlyContinue |
            Get-ChildItem |
            Remove-Item -Force -Recurse -Verbose

    }
    End
    {
    }
}
