function Get-TeamcityBuildConfigsWithRequirement
{
  [CmdletBinding()]
	param(
    [Parameter(Mandatory=$true)]
    [string] $Name,
    [string] $Value
	)

<#
The list of requirements type we currently have defined in Teamcity as of Aug 2015.
does-not-contain, exists, equals, starts-with, contains, does-not-equal, matches, not-exists, any, no-less-than, does-not-match
#>

  process {

    $interestingRequirementTypes = @('equals', 'starts-with', 'contains', 'matches', 'exists', 'any')

    $buildConfigs = @(Get-TeamcityBuildConfigs | select id, name, weburl)

    Foreach ($buildConfig in $buildConfigs)
    {
        # find the agent requirements for this build config
        $requirements = $buildConfig |
          Get-TeamcityBuildConfigAgentRequirements |
          where { $interestingRequirementTypes -contains $_.type -and $_.id -eq $Name }

        if( $Value ) {
          # Additional filtering if $Value was passed in
          $requirements = @($requirements.properties.property |
            where name -eq 'property-value' |
            select -ExpandProperty value |
            where { $_ -like $Value } )
        }

        if($requirements) {
          # This build config has the requirement we are looking for
          # Output it.
          [pscustomobject] @{
            Id = $buildConfig.id
            Name = $buildConfig.name
            Link = $buildConfig.weburl
            Requirements = $requirements
          }

        }
    }

  }

}
