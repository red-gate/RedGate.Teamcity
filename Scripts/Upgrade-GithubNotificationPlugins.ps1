[Cmdletbinding()]
param(
    [string] $BuildTypeId,
    [string] $ApiToken
)

# Assume that RedGate.Teamcity was imported in the parent scope.

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'


$buildConfig = Get-TeamcityBuildConfig  $BuildTypeId

if($buildConfig.'vcs-root-entries'.count -ne '1') {
    Write-Warning "No VCS root (or more than 1 VCS root) for build config $BuildTypeID. Cannot use this script... Sorry!"
    return
}

$VcsRootId = $buildConfig.'vcs-root-entries'.'vcs-root-entry'.'vcs-root'.id
$toRemove = $buildConfig.features.feature | where type -eq 'teamcity.github.status' | select -first 1

if($toRemove) {

    if(!($buildConfig.features.feature | where type -eq 'commit-status-publisher')) {
        # Add the new commit-status-publisher build feature
        New-TeamcityGithubBuildStatusFeature -BuildTypeId $BuildTypeId -Token $ApiToken -VcsRootId $VcsRootId -verbose
    }

    # Remove the old notification feature
    Remove-TeamcityBuildFeature -BuildTypeId $BuildTypeId -FeatureId $toRemove.id -verbose
} else {
    Write-Verbose "Build $BuildTypeId does not use teamcity.github.status features"
}
