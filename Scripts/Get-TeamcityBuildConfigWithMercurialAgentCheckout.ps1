[Cmdletbinding()]
param()

#Assume that RedGate.Teamcity was imported in the parent scope.

$mercurialVcs = @(Get-TeamcityVcsRootsPerVcsType -VcsType Mercurial)

# Get all the build configs
 Get-TeamcityBuildconfigs | Get-TeamcityBuildConfig | ForEach {

  # check the config has 'checkout on agent' set
  $checkoutOnAgent = $_.settings.property | ? { $_.name -eq 'checkoutMode' -and $_.value -eq 'ON_AGENT' }

  if(!$checkoutOnAgent) {
    Write-Verbose "Build config $($_.id) does not have checkout on agent"
    return
  }

  # check it is a config linked to Mercurial
  $hasMercurialVcsRoot = $_.'vcs-root-entries'.'vcs-root-entry'.'vcs-root'.id | ForEach { $mercurialVcs -contains $_ }

  if(!$hasMercurialVcsRoot) {
    Write-Verbose "Build config $($_.id) does not have a Mercurial VCS"
    return
  }

  # We got one! Output it
  $_
}
