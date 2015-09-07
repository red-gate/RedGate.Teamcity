function Get-TeamcityBuildConfigsWithRequirement
{
  [CmdletBinding()]
	param(
    [string] $Name,
    [string] $Value
	)

<#
The list of requirements type we currently have defined in Teamcity as of Aug 2015.
does-not-contain, exists, equals, starts-with, contains, does-not-equal, matches, not-exists, any, no-less-than, does-not-match
#>

  process {

    $interestingRequirementTypes = @('equals', 'starts-with', 'contains', 'matches', 'exists', 'any')

    $buildConfigs = Get-TeamcityBuildConfigs | select id, name

    Foreach ($buildConfig in $buildConfigs)
    {
        # find the agent requirements for this build config
        $requirements = $buildConfig |
          Get-TeamcityBuildConfigAgentRequirements |
          where { $interestingRequirementTypes -contains $_.type -and $_.id -eq $Name }

        $computerNames = @($requirements.properties.property |
                              where name -eq 'property-value' |
                              select -ExpandProperty value |
                              where { !$Value -or $_ -like $Value } )

        if($computerNames) {
          # This build config is linked to a specific (set of) agent(s)
          # Output it.
          [pscustomobject] @{
            Id = $buildConfig.id
            Name = $buildConfig.name
            AgentNames = $computerNames
          }

        }
    }

  }

}
