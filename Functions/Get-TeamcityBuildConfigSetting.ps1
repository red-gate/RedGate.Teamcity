function Get-TeamcityBuildConfigSetting
{
	[CmdletBinding()]
  param(
		[Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[string] $Id,

		[Parameter(Mandatory=$true)]
		[ValidateSet(
			'allowExternalStatus',
			'allowPersonalBuildTriggering',
			'artifactRules',
			'buildNumberCounter',
			'buildNumberPattern',
			'checkoutDirectory',
			'checkoutMode',
			'cleanBuild',
			'enableHangingBuildsDetection',
			'executionTimeoutMin',
			'maximumNumberOfBuilds',
			'shouldFailBuildIfTestsFailed',
			'shouldFailBuildOnAnyErrorMessage',
			'shouldFailBuildOnBadExitCode',
			'shouldFailBuildOnOOMEOrCrash',
			'showDependenciesChanges',
			'vcsLabelingBranchFilter'
			)]
		[string] $SettingName
	)

	process {

			(Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/buildTypes/id:$Id/settings/$SettingName" -Credential $Credential).Content

	}

}
