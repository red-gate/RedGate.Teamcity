$ErrorActionPreference = 'Stop'

"$PSScriptRoot\Functions\" |
    Resolve-Path |
    Get-ChildItem -Filter *.ps1 -Recurse |
    ForEach { . $_.FullName }

# Global variables that are only available to the module functions
if( !$Env:TeamcityServer ) {
  $Env:TeamcityServer = Read-Host -Prompt (@"
Enter your Teamcity Server Url. (like this: http://buildserver).
It will be saved as an environment variable named "TeamcityServer".
If you want to skip this prompt, set the environment variable before importing this module

"@)
}

$TeamcityServer = $Env:TeamcityServer

if($global:TeamcityCredentials) {
    $Credential = $global:TeamcityCredentials
} else {
    $Credential = Get-Credential $env:username -Message "Enter your Credential to access $TeamcityServer"
}


Export-ModuleMember `
    -Function `
        Enable-TeamcityAgent,
        Get-TeamcityAgentPools,
        Get-TeamcityArchivedBuildConfigs,
        Get-TeamcityBuildAgentDetails,
        Get-TeamcityBuildAgents,
        Get-TeamcityBuildAgentService,
        Get-TeamcityBuildConfig,
        Get-TeamcityBuildConfigParameters,
        Get-TeamcityBuildConfigSetting,
        Get-TeamcityBuildConfigSettings,
        Get-TeamcityBuildConfigs,
        Get-TeamcityBuildConfigAgentRequirements,
        Get-TeamcityBuildConfigsLinkedToSpecificAgent,
        Get-TeamcityBuildConfigsWithRequirement,
        Get-TeamcityBuildDetails,
        Get-TeamcityBuilds,
        Get-TeamcityHangingBuilds,
        Get-TeamcitySlowestBuilds,
        Get-TeamcityMachinesAndAgents,
        Get-TeamcityProjects,
        Get-TeamcityVcsRoot,
        Get-TeamcityVcsRoots,
        Remove-TeamcityBuild,
        Remove-TeamcityArtifactsOfBuildConfig,
        Get-TeamcityVcsRootsPerVcsType,
        Set-TeamcityVcsRootProperty
