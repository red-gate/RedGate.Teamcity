<#
.SYNOPSIS
    Remove a build feature from a build configuration

.EXAMPLE
    Remove-BuildFeature -BuildTypeId 'bt11' -FeatureId 'BUILD_EXT_007'
#>
Function Remove-TeamcityBuildFeature
{
    [CmdletBinding()]
    Param
    (
        # The id of the build configuration
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
        [string] $BuildTypeId,

        # The id of the feature to remove
        [Parameter(Mandatory, Position=1)]
        [string] $FeatureId
    )
    Process
    {
        Invoke-RestMethod `
            -Uri "$TeamcityServer/httpAuth/app/rest/buildTypes/id:$BuildTypeId/features/$FeatureId" `
            -Credential $Credential `
            -Method Delete
    }
}
