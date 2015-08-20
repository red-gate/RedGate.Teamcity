function Set-TeamcityVcsRootProperty
{
	[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $VcsRootId,
        [Parameter(Mandatory=$true)]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [string] $Value,
        [switch] $Quiet
    )

    if( -not $SomeSwitch.IsPresent ) {
        $local:VerbosePreference = 'Continue'
    }
    
    Write-Verbose "VCS Root Id: $VcsRootId. Updating property '$Name' to '$Value'"

    $result = Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/vcs-roots/id:$VcsRootId/properties/$Name" -Method Put -Body $Value -Credential $Credential -verbose:$false

    Write-Verbose "$($result.StatusCode) - $($result.StatusDescription)"
}