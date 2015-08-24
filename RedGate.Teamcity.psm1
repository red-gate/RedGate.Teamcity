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
$Credential = Get-Credential $env:username -Message "Enter your Credential to access $TeamcityServer"

Export-ModuleMember `
	-Function `
        Get-TeamcityBuildAgentDetails,
        Get-TeamcityBuildAgents,
        Get-TeamcityBuildConfig,
        Get-TeamcityBuildConfigs,
        Get-TeamcityBuildConfigAgentRequirements,
        Get-TeamcityBuildConfigsLinkedToSpecificAgent,
        Get-TeamcityHangingBuilds,
		    Get-TeamcitySlowestBuilds,
        Get-TeamcityMachinesAndAgents,
        Get-TeamcityVcsRoot,
        Get-TeamcityVcsRoots,
        Remove-TeamcityBuild,
        Get-TeamcityVcsRootsPerVcsType,
        Set-TeamcityVcsRootProperty
