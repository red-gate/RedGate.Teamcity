function Get-TeamcityProjects
{
	[CmdletBinding()]
  param()

	([xml](Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/projects" -Credential $Credential).Content).projects.project

}
