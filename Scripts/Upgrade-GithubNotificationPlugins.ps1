[Cmdletbinding()]
param(
    [string] $BuildType,
    [string] $ApiToken
)

# Assume that RedGate.Teamcity was imported in the parent scope.

$ErrorActionPreference = 'Stop'
$VerbosePreference = 'Continue'


$features = (Get-TeamcityBuildConfig  $BuildType).features.feature
$toRemove = $features | where type -eq 'teamcity.github.status' | select -first 1

if($toRemove) {

    if(!($features | where type -eq 'commit-status-publisher')) {
        # Add the new commit-status-publisher build feature
        New-TeamcityGithubBuildStatusFeature -BuildTypeId $BuildType -Token $ApiToken -verbose
    }

    # Remove the old notification feature
    Remove-TeamcityBuildFeature -BuildTypeId $BuildType -FeatureId $toRemove.id -verbose
} else {
    Write-Verbose "Build $BuildType does not use teamcity.github.status features"
}
