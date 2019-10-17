<#
.SYNOPSIS
Get a list of Teamcity build configs matching a specific 'agent requirement'
.EXAMPLE
Get-TeamcityBuildConfigsWithRequirement -Name env.ComputerName -Value 'old-computer-name'
Find all the build configs that are set to only run on a machine called 'old-computer-name'
#>
function Get-TeamcityBuildConfigsWithRequirement
{
  [CmdletBinding()]
	param(
        # The name of the agent requirement.
        # examples are: 'env.Computername', 'MSBuildTools4.0_x86_Path'
        [Parameter(Mandatory=$true)]
        [string] $Name,
        # The value of the agent requirement condition. (can be empty. In that case, the value is not checked)
        # Can contain wildcards (*)
        [string] $Value,
        # If specified, also return build configs that belong to archived projects.
        [switch] $IncludeArchivedProjects
	)

<#
The list of requirements type we currently have defined in Teamcity as of Aug 2015.
does-not-contain, exists, equals, starts-with, contains, does-not-equal, matches, not-exists, any, no-less-than, does-not-match
#>

  process {

    $interestingRequirementTypes = @('equals', 'starts-with', 'ends-with', 'contains', 'matches', 'exists', 'any')

    if($IncludeArchivedProjects.IsPresent) {
        $archivedProjects = @()
    } else {
        $archivedProjects = @(Get-TeamcityProjects -Archived 'true' | Select -ExpandProperty Id)
    }

    $buildConfigs = @(Get-TeamcityBuildConfigs | where { $archivedProjects -notcontains $_.projectid } | select id, name, weburl)

    Foreach ($buildConfig in $buildConfigs)
    {
        # find the agent requirements for this build config
        $requirements = $buildConfig |
          Get-TeamcityBuildConfigAgentRequirements |
          where { $interestingRequirementTypes -contains $_.type  } |
          where { $_.properties.property | where { $_.name -eq 'property-name' -and $_.value -like $Name } }

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
