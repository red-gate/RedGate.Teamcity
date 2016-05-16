function Get-TeamcityVcsRoots
{
	[CmdletBinding()]
    param(
        [string] $Locator = ''
    )


    if( $Locator -and !$Locator.StartsWith('?locator=') ) {
        $Locator = "?locator=$Locator"
    }

    ([xml] (Invoke-WebRequest "$TeamcityServer/httpAuth/app/rest/vcs-roots$Locator" -Credential $Credential -UseBasicParsing).Content).'vcs-roots'.'vcs-root' | ForEach {
        [pscustomobject] @{
            Id = $_.id
            Name = $_.name
        }
    }
}
